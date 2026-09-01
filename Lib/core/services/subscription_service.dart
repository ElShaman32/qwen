import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../config/app_config_notifier.dart';
import '../constants/app_constants.dart';
import 'negocio_service.dart';

/// Gestiona la re-verificación periódica de la suscripción contra el Maestro.
///
/// Recibe [Ref] en el constructor para resolver dependencias internamente.
/// Así los widgets llaman verificarSuscripcion() sin pasar ref.
class SubscriptionService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static const _storage = FlutterSecureStorage();
  static const _keyCorreo = 'negocio_correo';
  static const _keyPassword = 'negocio_password';

  final Ref _ref;
  Timer? _timer;

  SubscriptionService(this._ref);

  // ── Credenciales del negocio (Maestro) ──────────────────────

  /// Guarda las credenciales del negocio tras activación exitosa.
  Future<void> guardarCredencialesNegocio({
    required String correo,
    required String password,
  }) async {
    try {
      await _storage.write(key: _keyCorreo, value: correo.trim().toLowerCase());
      await _storage.write(key: _keyPassword, value: password);
      _logger.i('🔐 Credenciales del negocio guardadas en secure storage');
    } catch (e) {
      _logger.e('❌ Error guardando credenciales del negocio: $e');
    }
  }

  /// Carga las credenciales del negocio. Retorna null si no existen.
  /// Record NOMBRADO para acceder con .correo y .password
  Future<({String correo, String password})?>
      cargarCredencialesNegocio() async {
    try {
      final correo = await _storage.read(key: _keyCorreo);
      final password = await _storage.read(key: _keyPassword);
      if (correo == null || password == null) return null;
      return (correo: correo, password: password);
    } catch (e) {
      _logger.e('❌ Error cargando credenciales del negocio: $e');
      return null;
    }
  }

  /// Limpia las credenciales del negocio.
  Future<void> limpiarCredencialesNegocio() async {
    await _storage.delete(key: _keyCorreo);
    await _storage.delete(key: _keyPassword);
  }

  // ── Verificación de suscripción ────────────────────────────

  /// Re-autentica contra el Maestro y actualiza el estado de suscripción.
  /// Silencioso: si falla, solo loguea y no bloquea la app.
  Future<void> verificarSuscripcion() async {
    try {
      final creds = await cargarCredencialesNegocio();
      if (creds == null) {
        _logger.w('⚠️ No hay credenciales del negocio, saltando verificación');
        return;
      }

      final negocioService = _ref.read(negocioServiceProvider);
      final negocio = await negocioService.buscarPorCorreo(
        correoNegocio: creds.correo,
        contrasena: creds.password,
      );

      if (negocio == null) {
        _logger
            .w('⚠️ No se pudo verificar suscripción (credenciales inválidas)');
        return;
      }

      await _ref.read(appConfigProvider.notifier).updateSubscription(
            plan: negocio.plan,
            activa: negocio.activa,
            fechaVencimientoEpoch: negocio.fechaVencimientoEpoch,
          );

      _logger.i(
          '✅ Suscripción re-verificada: plan=${negocio.plan} activa=${negocio.activa}');
    } catch (e) {
      _logger.e('❌ Error en verificación de suscripción: $e');
      // No bloquear la app. Continuar con el estado cacheado.
    }
  }

  // ── Timer periódico ─────────────────────────────────────────

  /// Inicia el timer de re-verificación periódica.
  void iniciarTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(hours: AppConstants.reverificacionHoras),
      (_) => verificarSuscripcion(),
    );
    _logger.i(
        '⏱️ Timer de re-verificación iniciado (${AppConstants.reverificacionHoras}h)');
  }

  /// Detiene el timer.
  void detenerTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Provider global del SubscriptionService.
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  final service = SubscriptionService(ref);

  // Verificar al activar el provider (arranque de la app)
  Future.microtask(() => service.verificarSuscripcion());

  // Iniciar timer periódico
  service.iniciarTimer();

  ref.onDispose(() => service.detenerTimer());

  return service;
});
