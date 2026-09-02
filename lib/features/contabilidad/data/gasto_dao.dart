import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

/// DAO de gastos manuales. Registra gastos y encola sync.
class GastoDao {
  final AppDatabase _db;

  GastoDao(this._db);

  /// Inserta un nuevo gasto.
  Future<int> insertar({
    required String categoria,
    required String descripcion,
    required double montoUsd,
    required double tasa,
    required int fecha,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final gastoUuid = const Uuid().v4();

    final id = await _db.into(_db.gasto).insert(
          GastoCompanion.insert(
            uuid: gastoUuid,
            categoria: categoria,
            descripcion: descripcion,
            montoUsd: montoUsd,
            tasa: tasa,
            fecha: fecha,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: ahora,
            fechaActualizacion: ahora,
          ),
        );

    // Outbox: encolar gasto para sync
    await encolarSync(_db, coleccion: 'gastos', docId: gastoUuid, payload: {
      'categoria': categoria,
      'descripcion': descripcion,
      'montoUsd': montoUsd,
      'tasa': tasa,
      'fecha': fecha,
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'fechaCreacion': ahora,
      'fechaActualizacion': ahora,
    });

    return id;
  }

  /// Gastos en un rango de fechas, más recientes primero.
  Future<List<GastoData>> enRango(int inicio, int fin) {
    return (_db.select(_db.gasto)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerOrEqualValue(fin))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Suma de gastos manuales en un rango de fechas.
  Future<double> sumaEnRango(int inicio, int fin) async {
    final sumExpr = _db.gasto.montoUsd.sum();
    final row = await (_db.selectOnly(_db.gasto)
          ..addColumns([sumExpr])
          ..where(_db.gasto.fecha.isBiggerOrEqualValue(inicio) &
              _db.gasto.fecha.isSmallerOrEqualValue(fin)))
        .getSingle();
    return row.read(sumExpr) ?? 0.0;
  }

  /// Todos los gastos para exportar.
  Future<List<GastoData>> todos() {
    return (_db.select(_db.gasto)
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }
}

final gastoDaoProvider = Provider<GastoDao>((ref) {
  return GastoDao(ref.watch(databaseProvider));
});
