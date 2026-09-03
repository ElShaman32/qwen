import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/services/sync_service.dart';
import 'historial_tasa_dao.dart';

/// Período seleccionado para ver histórico de tasas.
enum PeriodoHistorialTasa {
  sieteDias,
  treintaDias,
  noventaDias,
  todo,
}

final periodoHistorialTasaProvider = StateProvider<PeriodoHistorialTasa>(
    (ref) => PeriodoHistorialTasa.treintaDias);

/// Lista usada por el gráfico, en orden ascendente.
final historialTasasGraficoProvider =
    FutureProvider<List<HistorialTasaData>>((ref) {
  ref.watch(syncRefreshProvider);

  final periodo = ref.watch(periodoHistorialTasaProvider);
  final dao = ref.watch(historialTasaDaoProvider);

  switch (periodo) {
    case PeriodoHistorialTasa.sieteDias:
      return dao.recientes(dias: 7);
    case PeriodoHistorialTasa.treintaDias:
      return dao.recientes(dias: 30);
    case PeriodoHistorialTasa.noventaDias:
      return dao.recientes(dias: 90);
    case PeriodoHistorialTasa.todo:
      return dao.todo();
  }
});

/// Lista usada por la tabla, más recientes primero.
final historialTasasTablaProvider =
    FutureProvider<List<HistorialTasaData>>((ref) {
  ref.watch(syncRefreshProvider);

  final periodo = ref.watch(periodoHistorialTasaProvider);
  final dao = ref.watch(historialTasaDaoProvider);

  switch (periodo) {
    case PeriodoHistorialTasa.sieteDias:
      return dao.tabla(dias: 7);
    case PeriodoHistorialTasa.treintaDias:
      return dao.tabla(dias: 30);
    case PeriodoHistorialTasa.noventaDias:
      return dao.tabla(dias: 90);
    case PeriodoHistorialTasa.todo:
      return dao.tabla();
  }
});
