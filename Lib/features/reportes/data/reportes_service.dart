import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/sync_service.dart';
import '../../ventas/domain/venta_models.dart';

/// Resumen de ventas de un período.
class StatsResumen {
  final double totalUsd;
  final double totalBs;
  final double gananciaUsd;
  final int numVentas;
  final double ticketPromedio;
  final double ivaBs;
  final double exentoBs;
  final Map<String, double> porMetodo;

  const StatsResumen({
    required this.totalUsd,
    required this.totalBs,
    required this.gananciaUsd,
    required this.numVentas,
    required this.ticketPromedio,
    required this.ivaBs,
    required this.exentoBs,
    required this.porMetodo,
  });
}

/// Producto más vendido agregado.
class TopProducto {
  final String nombre;
  final double cantidad;
  final double totalUsd;

  const TopProducto({
    required this.nombre,
    required this.cantidad,
    required this.totalUsd,
  });
}

/// Cálculos de reportes leyendo directamente de Drift (offline-first).
class ReportesService {
  final AppDatabase _db;

  ReportesService(this._db);

  static double red2(double x) => (x * 100).round() / 100;

  static int inicioDeHoy() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day).millisecondsSinceEpoch;
  }

  static int inicioDeDias(int dias) {
    final n = DateTime.now().subtract(Duration(days: dias - 1));
    return DateTime(n.year, n.month, n.day).millisecondsSinceEpoch;
  }

  static int inicioDeMes() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, 1).millisecondsSinceEpoch;
  }

  Future<List<VentaData>> _ventasDesde(int inicio) {
    return (_db.select(_db.venta)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicio) & t.anulada.equals(false)))
        .get();
  }

  /// Resumen agregado desde [inicio] hasta ahora.
  Future<StatsResumen> resumenDesde(int inicio) async {
    final ventas = await _ventasDesde(inicio);

    double usd = 0, bs = 0, iva = 0, exento = 0, ganancia = 0;
    final porMetodo = <String, double>{};

    for (final v in ventas) {
      usd += v.totalUsd;
      bs += v.totalBs;
      iva += v.ivaBs;
      exento += v.exentoBs;

      final pagos = (jsonDecode(v.pagosJson) as List)
          .map((e) => Pago.fromJson(e as Map<String, dynamic>))
          .toList();
      for (final p in pagos) {
        porMetodo[p.metodoNombre] =
            red2((porMetodo[p.metodoNombre] ?? 0) + p.montoUsd);
      }

      final items = (jsonDecode(v.itemsJson) as List)
          .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
          .toList();
      for (final i in items) {
        ganancia += i.subtotalUsd - (i.costoUnitarioUsd * i.cantidad);
      }
    }

    return StatsResumen(
      totalUsd: red2(usd),
      totalBs: red2(bs),
      gananciaUsd: red2(ganancia),
      numVentas: ventas.length,
      ticketPromedio: ventas.isEmpty ? 0 : red2(usd / ventas.length),
      ivaBs: red2(iva),
      exentoBs: red2(exento),
      porMetodo: porMetodo,
    );
  }

  /// Top productos por venta desde [inicio].
  Future<List<TopProducto>> topProductos(int inicio, {int limit = 5}) async {
    final ventas = await _ventasDesde(inicio);
    final agg = <String, TopProducto>{};

    for (final v in ventas) {
      final items = (jsonDecode(v.itemsJson) as List)
          .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final i in items) {
        final prev = agg[i.productoNombre];
        agg[i.productoNombre] = TopProducto(
          nombre: i.productoNombre,
          cantidad: (prev?.cantidad ?? 0) + i.cantidad,
          totalUsd: red2((prev?.totalUsd ?? 0) + i.subtotalUsd),
        );
      }
    }

    final lista = agg.values.toList()
      ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
    return lista.take(limit).toList();
  }
}

final reportesServiceProvider = Provider<ReportesService>(
    (ref) => ReportesService(ref.watch(databaseProvider)));

// ── Providers de período (0=hoy, 1=7 días, 2=mes) ─────────────
final resumenPeriodoProvider =
    FutureProvider.family<StatsResumen, int>((ref, periodo) {
  final svc = ref.watch(reportesServiceProvider);
  switch (periodo) {
    case 1:
      return svc.resumenDesde(ReportesService.inicioDeDias(7));
    case 2:
      return svc.resumenDesde(ReportesService.inicioDeMes());
    default:
      return svc.resumenDesde(ReportesService.inicioDeHoy());
  }
});

final topPeriodoProvider =
    FutureProvider.family<List<TopProducto>, int>((ref, periodo) {
  final svc = ref.watch(reportesServiceProvider);
  switch (periodo) {
    case 1:
      return svc.topProductos(ReportesService.inicioDeDias(7));
    case 2:
      return svc.topProductos(ReportesService.inicioDeMes());
    default:
      return svc.topProductos(ReportesService.inicioDeHoy());
  }
});

/// Para el Dashboard: resumen de hoy.
final resumenHoyProvider = FutureProvider<StatsResumen>((ref) {
  ref.watch(syncRefreshProvider);
  return ref
      .watch(reportesServiceProvider)
      .resumenDesde(ReportesService.inicioDeHoy());
});
