import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

/// DAO del histórico de tasas.
///
/// La tabla ya existe en Drift:
/// - tasa: double
/// - fuente: manual | bcv_api | bcv_api_auto
/// - fecha: DateTime
class HistorialTasaDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final AppDatabase _db;

  HistorialTasaDao(this._db);

  /// Inserta una tasa localmente.
  Future<int> insertar({
    required double tasa,
    required String fuente,
    DateTime? fecha,
  }) async {
    try {
      return await _db.into(_db.historialTasa).insert(
            HistorialTasaCompanion.insert(
              tasa: tasa,
              fuente: Value(fuente),
              fecha: Value(fecha ?? DateTime.now()),
            ),
          );
    } catch (e, stack) {
      _logger.e(
        'Error insertando historial de tasa local',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Última tasa registrada.
  Future<HistorialTasaData?> ultima() {
    return (_db.select(_db.historialTasa)
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Tasas de los últimos [dias].
  Future<List<HistorialTasaData>> recientes({required int dias}) {
    final desde = DateTime.now().subtract(Duration(days: dias));

    return (_db.select(_db.historialTasa)
          ..where((t) => t.fecha.isBiggerOrEqualValue(desde))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Todo el histórico, ascendente por fecha.
  Future<List<HistorialTasaData>> todo() {
    return (_db.select(_db.historialTasa)
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Lista para tabla, más recientes primero.
  Future<List<HistorialTasaData>> tabla({int? dias}) {
    final query = _db.select(_db.historialTasa);

    if (dias != null) {
      final desde = DateTime.now().subtract(Duration(days: dias));
      query.where((t) => t.fecha.isBiggerOrEqualValue(desde));
    }

    query.orderBy([
      (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc),
    ]);

    return query.get();
  }
}

final historialTasaDaoProvider = Provider<HistorialTasaDao>((ref) {
  return HistorialTasaDao(ref.watch(databaseProvider));
});
