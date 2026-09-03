import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_scheduler.dart';
import 'package:el_cuaderno_de_mario/core/utils/validaciones.dart';
import 'package:el_cuaderno_de_mario/features/ventas/data/metodos_pago_provider.dart'
    show MetodoPago;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/client_firebase.dart';
import '../../../core/services/negocio_service.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';

/// Pantalla de registro del primer administrador.
/// Solo accesible cuando el negocio existe, está activo y NO tiene admin.
class RegistroAdminScreen extends ConsumerStatefulWidget {
  final NegocioInfo negocio;

  const RegistroAdminScreen({super.key, required this.negocio});

  @override
  ConsumerState<RegistroAdminScreen> createState() =>
      _RegistroAdminScreenState();
}

class _RegistroAdminScreenState extends ConsumerState<RegistroAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  bool _isLoading = false;
  String? _errorMessage;
  bool _aceptaAdvertencia = false;

  @override
  void initState() {
    super.initState();
    // Pre-llenar correo con el del negocio si coincide
    _correoController.text = widget.negocio.correoNegocio;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrarAdmin() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_aceptaAdvertencia) {
      setState(
          () => _errorMessage = 'Debes aceptar la advertencia para continuar');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final clientFb = ClientFirebase();

      final cred = await clientFb.auth.createUserWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _passwordController.text,
      );
      final uid = cred.user!.uid;
      await cred.user!.updateDisplayName(_nombreController.text.trim());

      // Escrituras en Firestore. Si fallan, eliminamos el usuario huerfano (Bug #3)
      try {
        await clientFb.firestore.collection('usuarios').doc(uid).set({
          'correo': _correoController.text.trim().toLowerCase(),
          'nombre': _nombreController.text.trim(),
          'rol': 'admin',
          'activo': true,
          'fechaCreacion': FieldValue.serverTimestamp(),
        });

        await clientFb.firestore
            .collection('configuracion')
            .doc('generales')
            .set({
          'app_nombre': widget.negocio.nombre,
          'app_slogan': '',
          'logo_url': '',
          'color_primario': '#1a5c2a',
          'color_secundario': '#ffd700',
          'rif': widget.negocio.rif,
          'direccion': '',
          'telefono': '',
          'tasa_bcv': 780.0,
          'usarTasaBCV': true,
          'tasaManual': 0,
          'iva_rate': 0.16,
          'igtf_rate': 0.03,
        });

        await clientFb.firestore
            .collection('metodos_pago')
            .doc(MetodoPago.terceraDefault.id)
            .set(MetodoPago.terceraDefault.toSeedMap());
        // 5. Seed de métodos de pago venezolanos
        for (final metodo in MetodoPago.defaults) {
          await clientFb.firestore
              .collection('metodos_pago')
              .doc(metodo.id)
              .set(metodo.toSeedMap());
        }
      } catch (firestoreError) {
        _logger.e(
            '❌ Error creando docs Firestore, limpiando usuario huerfano: $firestoreError');
        try {
          await cred.user?.delete();
          _logger.w('🗑️ Usuario huerfano eliminado de Auth');
        } catch (deleteError) {
          _logger.e('❌ No se pudo eliminar usuario huerfano: $deleteError');
        }
        rethrow;
      }

      ref.read(appConfigProvider.notifier).setPlan(widget.negocio.plan);
      await ref.read(appConfigProvider.notifier).syncFromRemote();

      // Activar sincronización automática (inventario, clientes, ventas, etc.)
      ref.read(syncSchedulerProvider);

      if (!mounted) return;
      // 4. Navegar al dashboard (ya hay sesión activa)
      context.go(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      String mensaje;
      switch (e.code) {
        case 'email-already-in-use':
          mensaje = 'Este correo ya está registrado. Intenta iniciar sesión.';
          break;
        case 'weak-password':
          mensaje = 'La contraseña debe tener mínimo 6 caracteres.';
          break;
        case 'invalid-email':
          mensaje = 'El formato del correo no es válido.';
          break;
        default:
          mensaje = 'Error al registrar: ${e.message}';
      }
      setState(() {
        _errorMessage = mensaje;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inesperado. Contacta a SiReBAi si persiste.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Administrador')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Datos del negocio verificado
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.verified_user,
                              color: theme.colorScheme.primary, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            widget.negocio.nombre,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.negocio.rif,
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ADVERTENCIA CRÍTICA
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                theme.colorScheme.error.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: theme.colorScheme.error, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '⚠️ IMPORTANTE: La cuenta que crees aquí será el ADMINISTRADOR PRINCIPAL de ${widget.negocio.nombre}. '
                              'Tendrá acceso total a ventas, inventario, configuración y datos financieros. '
                              'Usa un correo seguro y una contraseña fuerte.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Checkbox de aceptación
                    Row(
                      children: [
                        Checkbox(
                          value: _aceptaAdvertencia,
                          onChanged: (v) =>
                              setState(() => _aceptaAdvertencia = v ?? false),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                                () => _aceptaAdvertencia = !_aceptaAdvertencia),
                            child: Text(
                              'Entiendo y acepto que esta cuenta será la administradora principal',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Campos del formulario
                    TextFormField(
                      controller: _nombreController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Ingresa tu nombre';
                        }
                        if (v.trim().length < 2) {
                          return 'El nombre es muy corto';
                        }
                        if (v.trim().length > 80) {
                          return 'El nombre es muy largo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validaciones.correo,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                        helperText: 'Mínimo 8 caracteres',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Ingresa una contraseña';
                        }
                        if (v.length < 8) {
                          return 'Mínimo 8 caracteres';
                        }
                        if (!v.contains(RegExp(r'[a-zA-Z]'))) {
                          return 'Debe tener al menos una letra';
                        }
                        if (!v.contains(RegExp(r'[0-9]'))) {
                          return 'Debe tener al menos un número';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) => v != _passwordController.text
                          ? 'Las contraseñas no coinciden'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Error message
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Botón registrar
                    FilledButton.icon(
                      onPressed: (_isLoading || !_aceptaAdvertencia)
                          ? null
                          : _registrarAdmin,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.app_registration),
                      label: Text(_isLoading
                          ? 'Registrando...'
                          : '¡Listo! Registrar Admin'),
                      style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52)),
                    ),
                    const SizedBox(height: 16),

                    // Botón cancelar / volver
                    OutlinedButton(
                      onPressed: _isLoading ? null : () => context.pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(height: 32),

                    // Footer SiReBAi
                    Center(
                      child: SirebaiWhatsappButton(
                        mensaje:
                            'Hola SiReBAi, tengo problemas registrando el admin de ${widget.negocio.nombre}',
                        child: const Text('¿Problemas? Contacta a SiReBAi',
                            style: TextStyle(fontSize: 12)),
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
}
