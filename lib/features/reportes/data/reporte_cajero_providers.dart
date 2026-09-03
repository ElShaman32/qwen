import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/sync_service.dart';
import 'reportes_service.dart';

/// Provider para reporte de ventas por cajero.
/// Usa el mismo periodo que los reportes: 0=hoy, 1=7 días, 2=mes.
final reportePorCajeroProvider =
    FutureProvider.family<List<ResumenCajero>, int>((ref, periodo) {
  ref.watch(syncRefreshProvider);
  final svc = ref.watch(reportesServiceProvider);
  switch (periodo) {
    case 1:
      return svc.resumenPorCajero(ReportesService.inicioDeDias(7));
    case 2:
      return svc.resumenPorCajero(ReportesService.inicioDeMes());
    default:
      return svc.resumenPorCajero(ReportesService.inicioDeHoy());
  }
});
