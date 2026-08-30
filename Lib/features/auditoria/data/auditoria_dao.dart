import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

/// DAO de auditoría: inserta logs y lista con búsqueda.
/// Copia patrón de MermaDao (constructor AppDatabase, provider con databaseProvider).
class AuditoriaDao {
  final AppDatabase _db;

  AuditoriaDao(this._db);

  /// Inserta un log de auditoría.
  Future<void> insertar({
    required String usuarioId,
    required String usuarioNombre,
    required String accion,
    String? detalles,
  }) {
    return _db.into(_db.auditoriaLog).insert(AuditoriaLogCompanion.insert(
          uuid: const Uuid().v4(),
          usuarioId: usuarioId,
          usuarioNombre: usuarioNombre,
          accion: accion,
          detalles: Value(detalles),
          fecha: DateTime.now().millisecondsSinceEpoch,
        ));
  }

  /// Lista en vivo de logs, ordenada por fecha descendente, con búsqueda.
  Stream<List<AuditoriaLogData>> observar({String busqueda = ''}) {
    final q = _db.select(_db.auditoriaLog)
      ..orderBy(
          [(t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)]);

    final texto = busqueda.trim();
    if (texto.isNotEmpty) {
      final patron = '%$texto%';
      q.where((t) =>
          t.accion.like(patron) |
          t.usuarioNombre.like(patron) |
          t.detalles.like(patron));
    }

    return q.watch();
  }

  /// Todos los logs para exportar a Excel.
  Future<List<AuditoriaLogData>> listarParaExportar() {
    return (_db.select(_db.auditoriaLog)
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Podar: mantener máximo 5000 registros (retención local).
  Future<void> podar({int maximo = 5000}) async {
    final countExpr = _db.auditoriaLog.id.count();
    final countRow = await (_db.selectOnly(_db.auditoriaLog)
          ..addColumns([countExpr]))
        .getSingle();
    final total = countRow.read(countExpr) ?? 0;

    if (total <= maximo) return;

    // Obtener el timestamp del registro número [maximo] (más reciente primero).
    final filaCorte = await (_db.select(_db.auditoriaLog)
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ])
          ..limit(1, offset: maximo - 1))
        .getSingle();

    // Borrar todos los anteriores a ese timestamp.
    await (_db.delete(_db.auditoriaLog)
          ..where((t) => t.fecha.isSmallerThanValue(filaCorte.fecha)))
        .go();
  }
}

final auditoriaDaoProvider = Provider<AuditoriaDao>((ref) {
  return AuditoriaDao(ref.watch(databaseProvider));
});
