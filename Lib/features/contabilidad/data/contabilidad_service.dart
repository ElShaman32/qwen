import 'package:el_cuaderno_de_mario/features/proveedores/data/proveedor_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../caja/data/caja_dao.dart';
import '../../clientes/data/cliente_dao.dart';
import '../../inventario/data/producto_dao.dart';
import '../../merma/data/merma_dao.dart';
import '../../ventas/data/venta_dao.dart';
import '../domain/contabilidad_models.dart';
import 'gasto_dao.dart';

/// Servicio de cálculos contables. Lee de DAOs existentes y arma
/// el Estado de Resultados y la Situación Financiera.
///
/// Reglas (Decisiones.md):
/// - Ingresos = ventas no anuladas del período
/// - Gastos = manuales (tabla Gasto) + merma (suma costoUsd)
/// - Activos = caja + fiados + inventario (stock × costoUsd)
/// - Pasivos = 0 hasta que llegue el módulo Proveedores
class ContabilidadService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Rango de fechas (epoch ms) según el período.
  (int inicio, int fin) rangoPeriodo(PeriodoContable periodo) {
    final ahora = DateTime.now();
    final fin = ahora.millisecondsSinceEpoch;

    switch (periodo) {
      case PeriodoContable.hoy:
        final inicioDia =
            DateTime(ahora.year, ahora.month, ahora.day).millisecondsSinceEpoch;
        return (inicioDia, fin);
      case PeriodoContable.sieteDias:
        final inicio =
            ahora.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
        return (inicio, fin);
      case PeriodoContable.mes:
        final inicioMes =
            DateTime(ahora.year, ahora.month, 1).millisecondsSinceEpoch;
        return (inicioMes, fin);
    }
  }

  /// Estado de Resultados para un período.
  Future<EstadoResultados> estadoResultados({
    required PeriodoContable periodo,
    required VentaDao ventaDao,
    required GastoDao gastoDao,
    required MermaDao mermaDao,
    required ProveedorDao proveedorDao,
  }) async {
    try {
      final (inicio, fin) = rangoPeriodo(periodo);

      // Ingresos: ventas no anuladas del período
      final ventas = await ventaDao.ventasDesde(inicio);
      final ventasEnRango = ventas.where((v) => v.fecha <= fin).toList();
      final ingresos =
          ventasEnRango.fold<double>(0.0, (acc, v) => acc + v.totalUsd);

      // Gastos manuales
      final gastosManuales = await gastoDao.sumaEnRango(inicio, fin);
      final numGastos = (await gastoDao.enRango(inicio, fin)).length;

      // Gastos de merma (suma costoUsd)
      final mermas = await mermaDao.recientes(dias: _diasDelPeriodo(periodo));
      final mermasEnRango =
          mermas.where((m) => m.fecha >= inicio && m.fecha <= fin).toList();
      final gastosMerma =
          mermasEnRango.fold<double>(0.0, (acc, m) => acc + m.costoUsd);

      // Compras de mercancía del período (tabla Compra)
      final comprasMercancia =
          await proveedorDao.sumaComprasEnRango(inicio, fin);
      // Contar compras: usamos un método auxiliar (agregar abajo)
      final numCompras = await proveedorDao.cuentaComprasEnRango(inicio, fin);

      return EstadoResultados(
        ingresosUsd: ingresos,
        gastosManualesUsd: gastosManuales,
        gastosMermaUsd: gastosMerma,
        comprasMercanciaUsd: comprasMercancia,
        numVentas: ventasEnRango.length,
        numGastos: numGastos,
        numCompras: numCompras,
      );
    } catch (e, stack) {
      _logger.e('Error calculando estado de resultados',
          error: e, stackTrace: stack);
      return EstadoResultados.vacio;
    }
  }

  /// Situación Financiera (activos - pasivos).
  Future<SituacionFinanciera> situacionFinanciera({
    required CajaDao cajaDao,
    required ClienteDao clienteDao,
    required ProductoDao productoDao,
    required ProveedorDao proveedorDao,
    required AppConfigState config,
  }) async {
    try {
      final tasa = config.tasaEfectiva;

      // Efectivo en caja: si hay caja abierta, calcular esperado;
      // si no, usar el último cierre
      double efectivoBs = 0;
      final apertura = await cajaDao.aperturaActiva();
      if (apertura != null) {
        // Caja abierta: inicial + ventas en efectivo - retiros
        final ventas = await cajaDao.ventasDesde(apertura.fecha);
        final retiros = await cajaDao.retirosDe(apertura.id);
        final totalRetiros =
            retiros.fold<double>(0, (acc, r) => acc + r.montoBs);
        // Aproximación: inicial + total ventas en Bs - retiros
        efectivoBs = apertura.montoInicialBs +
            ventas.fold<double>(0, (acc, v) => acc + v.totalBs) -
            totalRetiros;
      } else {
        final ultimoCierre = await cajaDao.ultimoCierre();
        if (ultimoCierre != null) {
          efectivoBs = ultimoCierre.montoRealBs;
        }
      }
      final efectivoUsd = tasa > 0 ? efectivoBs / tasa : 0.0;

      // Cuentas por cobrar: suma saldoPendienteUsd de clientes
      final clientes = await clienteDao.obtenerTodos();
      final cuentasPorCobrar =
          clientes.fold<double>(0.0, (acc, c) => acc + c.saldoPendienteUsd);

      // Inventario a costo: stock × costoUsd
      final productos = await productoDao.obtenerTodos();
      final inventarioCosto =
          productos.fold<double>(0.0, (acc, p) => acc + (p.stock * p.costoUsd));

      // Pasivos: deudas a proveedores
      final pasivosProveedores = await proveedorDao.totalPasivosProveedores();

      return SituacionFinanciera(
        efectivoCajaUsd: efectivoUsd,
        cuentasPorCobrarUsd: cuentasPorCobrar,
        inventarioCostoUsd: inventarioCosto,
        pasivosUsd: pasivosProveedores,
      );
    } catch (e, stack) {
      _logger.e('Error calculando situación financiera',
          error: e, stackTrace: stack);
      return SituacionFinanciera.vacia;
    }
  }

  int _diasDelPeriodo(PeriodoContable periodo) {
    switch (periodo) {
      case PeriodoContable.hoy:
        return 1;
      case PeriodoContable.sieteDias:
        return 7;
      case PeriodoContable.mes:
        return 31;
    }
  }
}

final contabilidadServiceProvider =
    Provider<ContabilidadService>((ref) => ContabilidadService());
