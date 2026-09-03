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

/// Resumen de ventas agrupado por cajero.
class ResumenCajero {
  final String usuarioId;
  final String nombre;
  final int numVentas;
  final double totalUsd;
  final double gananciaUsd;

  const ResumenCajero({
    required this.usuarioId,
    required this.nombre,
    required this.numVentas,
    required this.totalUsd,
    required this.gananciaUsd,
  });

  double get ticketPromedio => numVentas == 0 ? 0 : (totalUsd / numVentas);
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

  /// Ventas no anuladas desde [inicio], ajustadas por notas de crédito.
  Future<List<VentaData>> _ventasDesde(int inicio) {
    return (_db.select(_db.venta)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicio) & t.anulada.equals(false)))
        .get();
  }

  /// Suma total de notas de crédito desde [inicio].
  Future<double> totalDevolucionesDesde(int inicio) async {
    final notas = await (_db.select(_db.notaCredito)
          ..where((t) => t.fecha.isBiggerOrEqualValue(inicio)))
        .get();
    return notas.fold<double>(0.0, (acc, n) => acc + n.montoUsd);
  }

  /// Suma del costo de los productos devueltos desde [inicio] (para ajustar ganancia).
  Future<double> costoDevolucionesDesde(int inicio) async {
    final notas = await (_db.select(_db.notaCredito)
          ..where((t) => t.fecha.isBiggerOrEqualValue(inicio)))
        .get();

    double costoTotal = 0;
    for (final nota in notas) {
      final items = (jsonDecode(nota.itemsJson) as List)
          .map((e) => _ItemNotaCredito.fromJson(e as Map<String, dynamic>))
          .toList();
      for (final item in items) {
        costoTotal += item.costoUnitarioUsd * item.cantidad;
      }
    }
    return costoTotal;
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

    // ═══════════════════════════════════════════════════════════
    // AJUSTE POR DEVOLUCIONES (notas de crédito)
    // ═══════════════════════════════════════════════════════════
    final devolucionesUsd = await totalDevolucionesDesde(inicio);
    final costoDevoluciones = await costoDevolucionesDesde(inicio);

    // Ajustar totales
    final totalUsdAjustado = red2(usd - devolucionesUsd);
    final tasaPromedio = ventas.isEmpty || usd == 0 ? 0 : bs / usd;
    final totalBsAjustado = red2(bs - (devolucionesUsd * tasaPromedio));

    // Ajustar ganancia: restar el costo de lo devuelto
    final gananciaAjustada = red2(ganancia - costoDevoluciones);

    return StatsResumen(
      totalUsd: totalUsdAjustado,
      totalBs: totalBsAjustado,
      gananciaUsd: gananciaAjustada,
      numVentas: ventas.length,
      ticketPromedio:
          ventas.isEmpty ? 0 : red2(totalUsdAjustado / ventas.length),
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

  /// Resumen de ventas agrupado por cajero desde [inicio].
  /// Retorna la lista ordenada por totalUsd descendente (top cajero primero).
  Future<List<ResumenCajero>> resumenPorCajero(int inicio) async {
    final ventas = await _ventasDesde(inicio);
    final agg = <String, ResumenCajero>{};

    for (final v in ventas) {
      final prev = agg[v.usuarioId];

      double gananciaVenta = 0;
      final items = (jsonDecode(v.itemsJson) as List)
          .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
          .toList();
      for (final i in items) {
        gananciaVenta += i.subtotalUsd - (i.costoUnitarioUsd * i.cantidad);
      }

      agg[v.usuarioId] = ResumenCajero(
        usuarioId: v.usuarioId,
        nombre: v.usuarioNombre.isEmpty ? 'Cajero' : v.usuarioNombre,
        numVentas: (prev?.numVentas ?? 0) + 1,
        totalUsd: red2((prev?.totalUsd ?? 0) + v.totalUsd),
        gananciaUsd: red2((prev?.gananciaUsd ?? 0) + gananciaVenta),
      );
    }

    final lista = agg.values.toList()
      ..sort((a, b) => b.totalUsd.compareTo(a.totalUsd));
    return lista;
  }

  /// Resumen diario de ventas y ganancia de los últimos [dias] días.
  /// Una sola query a Drift, agrupación en memoria. Offline-first.
  Future<List<ResumenDiario>> resumenUltimosDias(int dias) async {
    final ahora = DateTime.now();
    final hoyLimpio = DateTime(ahora.year, ahora.month, ahora.day);
    final inicio = hoyLimpio.subtract(Duration(days: dias - 1));
    final inicioMs = inicio.millisecondsSinceEpoch;

    // 1. Una sola query: todas las ventas no anuladas del rango
    final ventas = await (_db.select(_db.venta)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicioMs) & t.anulada.equals(false)))
        .get();

    // 2. Agrupar por día (clave = epoch del día limpio)
    final ventasPorDia = <int, double>{};
    final ganPorDia = <int, double>{};

    for (final v in ventas) {
      final diaVenta = DateTime.fromMillisecondsSinceEpoch(v.fecha);
      final diaLimpio = DateTime(diaVenta.year, diaVenta.month, diaVenta.day);
      final clave = diaLimpio.millisecondsSinceEpoch;

      ventasPorDia[clave] = (ventasPorDia[clave] ?? 0) + v.totalUsd;

      // Ganancia = suma de (subtotal - costo) por item
      final items = (jsonDecode(v.itemsJson) as List)
          .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
          .toList();
      double gan = 0;
      for (final i in items) {
        gan += i.subtotalUsd - (i.costoUnitarioUsd * i.cantidad);
      }
      ganPorDia[clave] = (ganPorDia[clave] ?? 0) + gan;
    }

    // 3. Construir la lista con los [dias] días (incluyendo los vacíos = 0)
    final resultado = <ResumenDiario>[];
    for (int i = 0; i < dias; i++) {
      final fechaDia = hoyLimpio.subtract(Duration(days: dias - 1 - i));
      final clave = fechaDia.millisecondsSinceEpoch;
      resultado.add(ResumenDiario(
        fecha: fechaDia,
        ventas: ventasPorDia[clave] ?? 0,
        ganancia: ganPorDia[clave] ?? 0,
      ));
    }

    return resultado;
  }

  /// Ventas no anuladas desde [inicio] (para exportación).
  Future<List<VentaData>> ventasDelPeriodo(int inicio) => _ventasDesde(inicio);
}

/// Item de una nota de crédito (para calcular costo devuelto).
class _ItemNotaCredito {
  final double cantidad;
  final double costoUnitarioUsd;

  const _ItemNotaCredito({
    required this.cantidad,
    required this.costoUnitarioUsd,
  });

  factory _ItemNotaCredito.fromJson(Map<String, dynamic> json) =>
      _ItemNotaCredito(
        cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0,
        costoUnitarioUsd: (json['costoUnitarioUsd'] as num?)?.toDouble() ?? 0,
      );
}

/// Resumen de un día específico (ventas y ganancia).
class ResumenDiario {
  final DateTime fecha;
  final double ventas;
  final double ganancia;

  const ResumenDiario({
    required this.fecha,
    required this.ventas,
    required this.ganancia,
  });
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
