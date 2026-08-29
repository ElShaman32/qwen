import 'package:el_cuaderno_de_mario/core/services/subscription_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/client_firebase.dart';
import '../../../core/services/negocio_service.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/validaciones.dart';
import '../../../core/widgets/marca_logo.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';

/// Pantalla de activación (primera vez) - OPCIÓN A.
/// Pide correo del negocio + contraseña del negocio y autentica contra el Maestro.
class ActivacionScreen extends ConsumerStatefulWidget {
  const ActivacionScreen({super.key});

  @override
  ConsumerState<ActivacionScreen> createState() => _ActivacionScreenState();
}

class _ActivacionScreenState extends ConsumerState<ActivacionScreen> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  NegocioInfo? _negocioEncontrado;
  EstadoNegocio? _estadoActual;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verificarNegocio() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _negocioEncontrado = null;
      _estadoActual = null;
    });

    try {
      final servicio = ref.read(negocioServiceProvider);
      final negocio = await servicio.buscarPorCorreo(
        correoNegocio: _correoController.text,
        contrasena: _passwordController.text,
      );

      if (!mounted) return;

      // Credenciales inválidas o negocio no existe
      if (negocio == null) {
        setState(() {
          _estadoActual = EstadoNegocio.noExiste;
          _isLoading = false;
        });
        return;
      }

      // Negocio existe pero está inactivo (kill switch)
      if (!negocio.activa) {
        setState(() {
          _negocioEncontrado = negocio;
          _estadoActual = EstadoNegocio.inactivo;
          _isLoading = false;
        });
        return;
      }

      // Negocio existe y está activo -> inicializar Firebase del cliente
      await _inicializarFirebaseCliente(negocio);

      // Guardar plan en el estado de configuración
      // Guardar estado de suscripción del Maestro (plan, activa, vencimiento)
      await ref.read(appConfigProvider.notifier).updateSubscription(
            plan: negocio.plan,
            activa: negocio.activa,
            fechaVencimientoEpoch: negocio.fechaVencimientoEpoch,
          );
      // Guardar credenciales del negocio para re-verificación periódica
      await ref.read(subscriptionServiceProvider).guardarCredencialesNegocio(
            correo: _correoController.text,
            password: _passwordController.text,
          );
      // Sincronizar configuración DESPUÉS de inicializar ClientFirebase
      await ref.read(appConfigProvider.notifier).syncFromRemote();

      // Verificar si hay admin (existe configuracion/generales?)
      final hayAdmin = await _verificarAdminExiste();

      if (!mounted) return;

      setState(() {
        _negocioEncontrado = negocio;
        _estadoActual = hayAdmin
            ? EstadoNegocio.activoConAdmin
            : EstadoNegocio.activoSinAdmin;
        _isLoading = false;
      });

      if (hayAdmin) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Error de conexión. Verifica tu internet e intenta de nuevo.';
        _isLoading = false;
      });
    }
  }

  Future<void> _inicializarFirebaseCliente(NegocioInfo negocio) async {
    final nombreApp = 'client_${negocio.rif.replaceAll('-', '')}';
    final opciones = FirebaseOptions(
      apiKey: negocio.credencialesFirebase['api_key'] as String,
      appId: negocio.credencialesFirebase['app_id'] as String,
      projectId: negocio.credencialesFirebase['project_id'] as String,
      messagingSenderId:
          negocio.credencialesFirebase['messaging_sender_id'] as String,
      storageBucket: negocio.credencialesFirebase['storage_bucket'] as String?,
    );

    await ClientFirebase().initialize(name: nombreApp, options: opciones);

    // Persistir para restaurar la sesión en próximos arranques
    await ref.read(sessionServiceProvider).guardarCredencialesCliente(
          nombreApp: nombreApp,
          opciones: opciones,
        );
  }

  /// Verifica si hay admin revisando si existe configuracion/generales.
  /// El admin crea ese documento al registrarse; su existencia indica admin.
  Future<bool> _verificarAdminExiste() async {
    try {
      final clientFb = ClientFirebase();
      final doc = await clientFb.firestore
          .collection('configuracion')
          .doc('generales')
          .get();
      return doc.exists;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MarcaLogo(size: 100),
                    const SizedBox(height: 24),

                    Text(
                      'El Cuaderno de Mario',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Activa tu negocio',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Correo del negocio
                    TextFormField(
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Correo del negocio',
                        hintText: 'admin@tubodega.com',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validaciones.correo,
                    ),
                    const SizedBox(height: 16),

                    // Contraseña del negocio
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Contraseña del negocio',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: Validaciones.passwordLogin,
                      onFieldSubmitted: (_) => _verificarNegocio(),
                    ),
                    const SizedBox(height: 24),

                    // Botón verificar
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _verificarNegocio,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                          _isLoading ? 'Verificando...' : '¡Dale! Verificar'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    if (_estadoActual == EstadoNegocio.noExiste) ...[
                      const SizedBox(height: 24),
                      _buildNoExisteDialog(theme),
                    ],

                    if (_estadoActual == EstadoNegocio.inactivo) ...[
                      const SizedBox(height: 24),
                      _buildInactivoMessage(theme),
                    ],

                    if (_estadoActual == EstadoNegocio.activoSinAdmin &&
                        _negocioEncontrado != null) ...[
                      const SizedBox(height: 24),
                      _buildRegistroAdminPrompt(theme, _negocioEncontrado!),
                    ],

                    const SizedBox(height: 48),
                    Text(
                      'Soporte: SiReBAi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoExisteDialog(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.business_outlined,
              size: 40, color: theme.colorScheme.error),
          const SizedBox(height: 12),
          Text(
            'Credenciales inválidas o negocio no registrado',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Verifica tu correo y contraseña, o contacta a SiReBAi',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const SirebaiWhatsappButton(
            mensaje:
                'Hola SiReBAi, quiero registrar mi negocio en El Cuaderno de Mario.',
          ),
        ],
      ),
    );
  }

  Widget _buildInactivoMessage(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.pause_circle_outline,
              size: 40, color: theme.colorScheme.tertiary),
          const SizedBox(height: 12),
          Text(
            'Suscripción vencida',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tu negocio "${_negocioEncontrado?.nombre}" tiene la suscripción pausada.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SirebaiWhatsappButton(
            mensaje:
                'Hola SiReBAi, mi negocio "${_negocioEncontrado?.nombre}" aparece como inactivo.',
          ),
        ],
      ),
    );
  }

  Widget _buildRegistroAdminPrompt(ThemeData theme, NegocioInfo negocio) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.person_add_outlined,
              size: 40, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            '¡Negocio verificado!',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${negocio.nombre}\n${negocio.rif}',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'No se encontró un administrador registrado.\nCrea la cuenta admin para comenzar.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go(
              AppRoutes.registroAdmin,
              extra: {'negocio': negocio},
            ),
            icon: const Icon(Icons.app_registration),
            label: const Text('Registrar Administrador'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
