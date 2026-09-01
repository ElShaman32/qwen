import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../auth/application/current_user_provider.dart';
import 'auditoria_dao.dart';

/// Log transversal de auditoría / Movimientos críticos.
///
/// Estrategia (Decisiones.md):
/// - Escritura SIEMPRE: sin gate de plan, fire-and-forget
/// - Lectura/UI: gate por plan (puedePersonalizar)
/// - Poda de retención (5000 registros) una vez por sesión
///
/// Uso desde cualquier feature:
/// await ref.read(auditoriaServiceProvider).registrar(
///   AccionesAuditoria.ventaAnulada,
///   detalles: 'Motivo: cliente arrepentido',
/// );
class AuditoriaService {
  AuditoriaService(this._ref);

  final Ref _ref;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  bool _podado = false;

  /// Registra una acción en el log de movimientos.
  /// SIEMPRE escribe (sin gate de plan). Nunca lanza excepciones.
  Future<void> registrar(String accion, {String? detalles}) async {
    try {
      // Leer usuario actual (puede ser null si la sesión murió)
      final userAsync = _ref.read(currentUserProvider);
      final user = userAsync.value;

      if (user == null) {
        _logger.w('⚠️ Movimiento sin usuario activo: $accion');
        return;
      }

      // Insertar en Drift vía DAO
      await _ref.read(auditoriaDaoProvider).insertar(
            usuarioId: user.uid,
            usuarioNombre: user.nombre,
            accion: accion,
            detalles: detalles,
          );

      // Poda de retención (solo la primera vez por sesión)
      if (!_podado) {
        _podado = true;
        await _ref.read(auditoriaDaoProvider).podar();
      }

      _logger.i('📝 Movimiento: $accion ($detalles)');
    } catch (e, stack) {
      // Fire-and-forget: loguear y continuar, NUNCA propagar
      _logger.e('Error registrando movimiento ($accion)',
          error: e, stackTrace: stack);
    }
  }
}

final auditoriaServiceProvider = Provider<AuditoriaService>((ref) {
  return AuditoriaService(ref);
});
