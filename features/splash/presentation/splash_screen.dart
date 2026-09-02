import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/client_firebase.dart';

/// Pantalla de inicio visual con sonido de caja registradora.
/// Controla su propia navegación después de una duración mínima.
/// SIEMPRE muestra marca "El Cuaderno de Mario" + "SiReBAi".
///
/// Lógica mínima: el router maneja TODO el flujo de protección
/// (onboarding, login, demo vencido, etc.). El splash solo decide
/// entre "ir al home" o "ir a activación".
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Duración mínima del splash para que se vea el logo y suene la caja.
  static const _duracionMinima = Duration(milliseconds: 2200);

  @override
  void initState() {
    super.initState();
    _iniciarFlujo();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Orquesta el arranque: sonido → espera mínima → navegación.
  Future<void> _iniciarFlujo() async {
    await _reproducirSonidoCaja();
    await Future.delayed(_duracionMinima);

    if (!mounted) return;
    _navegarSiguiente();
  }

  Future<void> _reproducirSonidoCaja() async {
    try {
      await _audioPlayer.play(
        AssetSource('sonidos/caja_registradora.mp3'),
      );
    } catch (e) {
      debugPrint('🔇 No se pudo reproducir el sonido de caja: $e');
    }
  }

  /// Navegación mínima: home si hay sesión/demo, activación si no.
  /// El router se encarga de TODO lo demás (onboarding, login, protección).
  void _navegarSiguiente() {
    final config = ref.read(appConfigProvider);
    final clientFb = ClientFirebase();

    // Kill switch → quedarse en splash (router también lo bloquea)
    if (config.isKillSwitchActive) return;

    // Decidir entre home o activación
    final haySesion =
        clientFb.isInitialized && clientFb.auth.currentUser != null;
    final demoActivo = config.isDemoMode && !config.demoVencido;

    if (haySesion || demoActivo) {
      // Ir al home. El router interceptará si:
      // - No aceptó términos → manda a onboarding
      // - Demo vencido → manda a activación
      context.go(AppRoutes.home);
    } else {
      // Ir a activación. El router interceptará si:
      // - No aceptó términos → manda a onboarding
      context.go(AppRoutes.activacion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(theme),
            const SizedBox(height: 24),
            Text(
              'El Cuaderno de Mario',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Cuentas Claras, Negocio Próspero',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            if (config.isKillSwitchActive)
              _buildKillSwitchMessage(theme)
            else
              CircularProgressIndicator(color: theme.colorScheme.primary),
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
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/Cuaderno.png',
        width: 120,
        height: 120,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.storefront,
            size: 64,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget _buildKillSwitchMessage(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.lock_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Suscripción vencida',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onErrorContainer,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Han pasado más de 7 días sin conexión.\n'
            'Conecta a internet para verificar tu suscripción.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
