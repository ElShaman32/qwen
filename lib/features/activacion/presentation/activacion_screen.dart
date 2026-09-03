import 'package:el_cuaderno_de_mario/core/services/demo_data_seeder.dart';
import 'package:el_cuaderno_de_mario/core/services/demo_mode_service.dart';
import 'package:el_cuaderno_de_mario/core/services/subscription_service.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_scheduler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/client_firebase.dart';
import '../../../core/services/negocio_service.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/validaciones.dart';
import '../../../core/widgets/marca_logo.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';

/// Pantalla de activación (hub central) - 3 opciones para el usuario.
/// SIEMPRE muestra marca "El Cuaderno de Mario" + "SiReBAi" (pre-login).
///
/// Opciones:
/// 1. "Ya tengo cuenta" → diálogo con correo+contraseña
/// 2. "Registrar mi bodega" → formulario de lead
/// 3. "Probar gratis 24h" → modo demo
class ActivacionScreen extends ConsumerStatefulWidget {
  const ActivacionScreen({super.key});

  @override
  ConsumerState<ActivacionScreen> createState() => _ActivacionScreenState();
}

class _ActivacionScreenState extends ConsumerState<ActivacionScreen> {
  final Logger _logger = Logger();
  bool _iniciandoDemo = false;

  /// Abre diálogo con formulario de login (correo+contraseña del negocio)
  void _abrirLoginDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const _LoginFormDialog(),
    );
  }

  /// Navega al formulario de lead (registro de bodega)
  void _irARegistro() {
    _logger.i('📝 Navegando a lead form desde activación');
    context.go(AppRoutes.leadForm);
  }

  /// Inicia el modo demo (24h) y navega al Dashboard
  Future<void> _iniciarModoDemo() async {
    if (_iniciandoDemo) return;

    setState(() => _iniciandoDemo = true);

    try {
      final demoService = DemoModeService();
      final enDemo = await demoService.estaEnModoDemo();

      if (enDemo) {
        _logger.w('⚠️ Ya estaba en modo demo');
      } else {
        // 1. Marcar inicio de demo en SharedPreferences
        await demoService.iniciarDemo();

        // 2. Sembrar datos de ejemplo en Drift
        final db = ref.read(databaseProvider);
        await DemoDataSeeder().sembrarDatosDemo(db);

        // 3. Activar modo demo en AppConfigState + Drift
        final ahora = DateTime.now().millisecondsSinceEpoch;
        await ref.read(appConfigProvider.notifier).activarModoDemo(ahora);

        _logger.i('✅ Modo demo iniciado correctamente');
      }

      if (!mounted) return;

      // 4. Navegar al Dashboard
      context.go(AppRoutes.home);
    } catch (e, stack) {
      _logger.e('❌ Error iniciando modo demo', error: e, stackTrace: stack);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar el modo prueba. Intenta de nuevo.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _iniciandoDemo = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.watch(appConfigProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final esPantallaGrande = constraints.maxWidth > 600;
            final padding = esPantallaGrande ? 48.0 : 24.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── HEADER: Logo + Marca ────────────────────────
                      const MarcaLogo(size: 100),
                      const SizedBox(height: 16),
                      Text(
                        'El Cuaderno de Mario',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cuentas Claras, Negocio Próspero',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // ── TÍTULO DE LA PANTALLA ──────────────────────
                      Text(
                        '¿Cómo quieres comenzar?',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // ── OPCIÓN 1: Ya tengo cuenta ──────────────────
                      _OpcionCard(
                        icon: Icons.login,
                        titulo: 'Ya tengo cuenta',
                        descripcion:
                            'Mi bodega ya está registrada y tengo mis credenciales',
                        color: theme.colorScheme.primary,
                        esGrande: esPantallaGrande,
                        onTap: _abrirLoginDialog,
                      ),
                      const SizedBox(height: 16),

                      // ── OPCIÓN 2: Registrar mi bodega ──────────────
                      _OpcionCard(
                        icon: Icons.store_outlined,
                        titulo: 'Registrar mi bodega',
                        descripcion:
                            'Quiero registrar mi bodega para que me contacten',
                        color: theme.colorScheme.tertiary,
                        esGrande: esPantallaGrande,
                        onTap: _irARegistro,
                      ),
                      const SizedBox(height: 16),

                      // ── OPCIÓN 3: Probar gratis 24h ────────────────
                      _OpcionCard(
                        icon: Icons.rocket_launch_outlined,
                        titulo: 'Probar gratis 24 horas',
                        descripcion:
                            'Descubre todas las funciones sin registrarte',
                        color: theme.colorScheme.secondary,
                        esGrande: esPantallaGrande,
                        onTap: _iniciarModoDemo,
                        cargando: _iniciandoDemo,
                        destacado: true,
                      ),
                      const SizedBox(height: 40),

                      // ── FOOTER SIREBAI ─────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.support_agent,
                            size: 16,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Soporte: SiReBAi',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Tarjeta reutilizable para cada opción del hub de activación
class _OpcionCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final Color color;
  final bool esGrande;
  final VoidCallback onTap;
  final bool cargando;
  final bool destacado;

  const _OpcionCard({
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.color,
    required this.esGrande,
    required this.onTap,
    this.cargando = false,
    this.destacado = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: destacado
          ? color.withValues(alpha: 0.08)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: cargando ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(esGrande ? 24 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: destacado
                  ? color.withValues(alpha: 0.4)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: destacado ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icono circular
              Container(
                width: esGrande ? 56 : 48,
                height: esGrande ? 56 : 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: esGrande ? 28 : 24),
              ),
              const SizedBox(width: 16),

              // Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcion,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Indicador de carga o flecha
              if (cargando)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// DIÁLOGO: Formulario de Login (correo+contraseña del negocio)
/// Es la versión original de la pantalla, encapsulada en diálogo.
/// ─────────────────────────────────────────────────────────────
class _LoginFormDialog extends ConsumerStatefulWidget {
  const _LoginFormDialog();

  @override
  ConsumerState<_LoginFormDialog> createState() => _LoginFormDialogState();
}

class _LoginFormDialogState extends ConsumerState<_LoginFormDialog> {
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

      // Limpiar modo demo si estaba activo
      await ref.read(appConfigProvider.notifier).desactivarModoDemo();

      // Guardar estado de suscripción del Maestro
      await ref.read(appConfigProvider.notifier).updateSubscription(
            plan: negocio.plan,
            activa: negocio.activa,
            fechaVencimientoEpoch: negocio.fechaVencimientoEpoch,
          );
      // Guardar credenciales para re-verificación periódica
      await ref.read(subscriptionServiceProvider).guardarCredencialesNegocio(
            correo: _correoController.text,
            password: _passwordController.text,
          );
      // Sincronizar configuración
      await ref.read(appConfigProvider.notifier).syncFromRemote();

      // Activar sincronización automática (inventario, clientes, ventas, etc.)
      ref.read(syncSchedulerProvider);

      // Verificar si hay admin
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
        // Cerrar diálogo y navegar a login
        if (mounted) Navigator.of(context).pop();
        if (mounted) context.go(AppRoutes.login);
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

    await ref.read(sessionServiceProvider).guardarCredencialesCliente(
          nombreApp: nombreApp,
          opciones: opciones,
        );
  }

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

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header del diálogo
                Row(
                  children: [
                    Icon(
                      Icons.login,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Iniciar sesión',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa el correo y contraseña de tu negocio',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

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
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
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
                    _isLoading ? 'Verificando...' : '¡Dale! Verificar',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
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
                  const SizedBox(height: 20),
                  _buildNoExisteMessage(theme),
                ],

                if (_estadoActual == EstadoNegocio.inactivo) ...[
                  const SizedBox(height: 20),
                  _buildInactivoMessage(theme),
                ],

                if (_estadoActual == EstadoNegocio.activoSinAdmin &&
                    _negocioEncontrado != null) ...[
                  const SizedBox(height: 20),
                  _buildRegistroAdminPrompt(theme, _negocioEncontrado!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoExisteMessage(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.business_outlined,
              size: 32, color: theme.colorScheme.error),
          const SizedBox(height: 8),
          Text(
            'Credenciales inválidas o negocio no registrado',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Verifica tus datos o contacta a SiReBAi',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.pause_circle_outline,
              size: 32, color: theme.colorScheme.tertiary),
          const SizedBox(height: 8),
          Text(
            'Suscripción vencida',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Tu negocio "${_negocioEncontrado?.nombre}" está pausado',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.person_add_outlined,
              size: 32, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            '¡Negocio verificado!',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${negocio.nombre}\n${negocio.rif}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'No hay admin registrado. Créalo para comenzar.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(
                AppRoutes.registroAdmin,
                extra: {'negocio': negocio},
              );
            },
            icon: const Icon(Icons.app_registration),
            label: const Text('Registrar Administrador'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }
}
