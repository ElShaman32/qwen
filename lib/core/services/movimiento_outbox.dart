import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

/// Registra un movimiento crítico en el log de auditoría.
/// Fire-and-forget: NUNCA lanza excepciones, solo loguea errores.
///
/// Uso desde DAOs (patrón similar a encolarSync):
/// await registrarMovimiento(
///   _db,
///   usuarioId: usuarioId,
///   usuarioNombre: usuarioNombre,
///   accion: AccionesAuditoria.ventaAnulada,
///   detalles: 'Venta #123, motivo: cliente arrepentido',
/// );
Future<void> registrarMovimiento(
  AppDatabase db, {
  required String usuarioId,
  required String usuarioNombre,
  required String accion,
  String? detalles,
}) async {
  try {
    await db.into(db.auditoriaLog).insert(
          AuditoriaLogCompanion.insert(
            uuid: const Uuid().v4(),
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            accion: accion,
            detalles: Value(detalles),
            fecha: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  } catch (e, stack) {
    // Fire-and-forget: loguear y continuar, NUNCA propagar
    _logger.e('Error registrando movimiento ($accion)',
        error: e, stackTrace: stack);
  }
}
