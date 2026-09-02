import 'package:el_cuaderno_de_mario/core/services/sync_scheduler.dart';
import 'package:el_cuaderno_de_mario/core/widgets/marca_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/client_firebase.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';

/// Pantalla de login para usos posteriores (admin/cajero).
/// Autentica contra Firebase del Cliente y redirige según rol.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final clientFb = ClientFirebase();

      // 1. Autenticar en Firebase Auth del Cliente
      final cred = await clientFb.auth.signInWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _passwordController.text,
      );

      final uid = cred.user!.uid;

      // 2. Obtener rol desde Firestore del Cliente
      final userDoc =
          await clientFb.firestore.collection('usuarios').doc(uid).get();

      if (!userDoc.exists || !mounted) {
        setState(() {
          _errorMessage =
              'Usuario no encontrado en el sistema. Contacta al administrador.';
          _isLoading = false;
        });
        await clientFb.auth.signOut();
        return;
      }

      final data = userDoc.data()!;
      final rol = data['rol'] as String? ?? '';
      final activo = data['activo'] as bool? ?? false;

      // 3. Validar que la cuenta esté activa
      if (!activo) {
        setState(() {
          _errorMessage =
              'Tu cuenta ha sido desactivada. Contacta al administrador.';
          _isLoading = false;
        });
        await clientFb.auth.signOut();
        return;
      }

      // 4. Desactivar modo demo si estaba activo (limpia datos demo de Drift)
      await ref.read(appConfigProvider.notifier).desactivarModoDemo();

      // 5. Sincronizar configuración DESPUÉS de login exitoso
      await ref.read(appConfigProvider.notifier).syncFromRemote();

      // 6. Activar sincronización automática (inventario, clientes, ventas, etc.)
      ref.read(syncSchedulerProvider);

      if (!mounted) return;

      // 7. Redirigir según rol
      if (rol == 'admin') {
        context.go(AppRoutes.home);
      } else if (rol == 'cajero') {
        context.go(AppRoutes.ventas);
      } else {
        setState(() {
          _errorMessage = 'Rol desconocido. Contacta al administrador.';
          _isLoading = false;
        });
        await clientFb.auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      String mensaje;
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          mensaje = 'Correo o contraseña incorrectos';
          break;
        case 'too-many-requests':
          mensaje =
              'Demasiados intentos. Espera unos minutos e intenta de nuevo.';
          break;
        case 'network-request-failed':
          mensaje = 'Sin conexión a internet. Verifica tu red.';
          break;
        default:
          mensaje = 'Error al iniciar sesión: ${e.message}';
      }
      setState(() {
        _errorMessage = mensaje;
        _isLoading = false;
      });
    } catch (e) {
      _logger.e('❌ Error inesperado en login: $e');
      setState(() {
        _errorMessage = 'Error inesperado. Intenta de nuevo.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = ref.watch(appConfigProvider);

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
                    // Logo dinámico whitelabel
                    const MarcaLogo(size: 120),
                    const SizedBox(height: 24),

                    Text(
                      config.appNombre.isNotEmpty
                          ? config.appNombre
                          : 'El Cuaderno de Mario',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (config.appSlogan.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        config.appSlogan,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: 40),

                    // Campo correo
                    TextFormField(
                      controller: _correoController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Ingresa tu correo';
                        }
                        if (!v.contains('@')) return 'Correo inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo contraseña
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
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
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Ingresa tu contraseña'
                          : null,
                      onFieldSubmitted: (_) => _iniciarSesion(),
                    ),
                    const SizedBox(height: 24),

                    // Error message
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                size: 20, color: theme.colorScheme.error),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style:
                                    TextStyle(color: theme.colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Botón ¡Dale! Ingresar
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _iniciarSesion,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login),
                      label: Text(
                          _isLoading ? 'Ingresando...' : '¡Dale! Ingresar'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Footer SiReBAi
                    Text(
                      'Soporte: SiReBAi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SirebaiWhatsappButton(
                      mensaje:
                          'Hola SiReBAi, tengo problemas para iniciar sesión en El Cuaderno de Mario',
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
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
