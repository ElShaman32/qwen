/// Período contable para filtrar los cálculos.
enum PeriodoContable { hoy, sieteDias, mes }

/// Resumen del Estado de Resultados para un período.
/// Resumen del Estado de Resultados para un período.
class EstadoResultados {
  final double ingresosUsd; // ventas no anuladas
  final double gastosManualesUsd; // tabla Gasto
  final double gastosMermaUsd; // suma costoUsd de merma
  final double comprasMercanciaUsd; // suma de tabla Compra del período
  final int numVentas;
  final int numGastos;
  final int numCompras;

  const EstadoResultados({
    required this.ingresosUsd,
    required this.gastosManualesUsd,
    required this.gastosMermaUsd,
    required this.comprasMercanciaUsd,
    required this.numVentas,
    required this.numGastos,
    required this.numCompras,
  });

  double get gastosTotalesUsd =>
      gastosManualesUsd + gastosMermaUsd + comprasMercanciaUsd;
  double get utilidadNetaUsd => ingresosUsd - gastosTotalesUsd;

  static const vacio = EstadoResultados(
    ingresosUsd: 0,
    gastosManualesUsd: 0,
    gastosMermaUsd: 0,
    comprasMercanciaUsd: 0,
    numVentas: 0,
    numGastos: 0,
    numCompras: 0,
  );
}

/// Situación Financiera (balance simple).
class SituacionFinanciera {
  final double efectivoCajaUsd; // efectivo en caja abierta (o último cierre)
  final double cuentasPorCobrarUsd; // suma saldoPendienteUsd de clientes
  final double inventarioCostoUsd; // stock × costoUsd
  final double pasivosUsd; // 0 hasta que llegue Proveedores

  const SituacionFinanciera({
    required this.efectivoCajaUsd,
    required this.cuentasPorCobrarUsd,
    required this.inventarioCostoUsd,
    required this.pasivosUsd,
  });

  double get activosTotalesUsd =>
      efectivoCajaUsd + cuentasPorCobrarUsd + inventarioCostoUsd;
  double get patrimonioUsd => activosTotalesUsd - pasivosUsd;

  static const vacia = SituacionFinanciera(
    efectivoCajaUsd: 0,
    cuentasPorCobrarUsd: 0,
    inventarioCostoUsd: 0,
    pasivosUsd: 0,
  );
}

/// Categorías de gastos manuales (Funcionalidades.md).
class CategoriasGasto {
  CategoriasGasto._();

  static const impuestos = 'impuestos';
  static const servicios = 'servicios';
  static const reparaciones = 'reparaciones';
  static const alquiler = 'alquiler';
  static const sueldos = 'sueldos';
  static const mercancia = 'mercancia';
  static const otros = 'otros';

  static const todas = [
    impuestos,
    servicios,
    reparaciones,
    alquiler,
    sueldos,
    mercancia,
    otros,
  ];

  /// Etiqueta legible para la UI (español, venezolanismos).
  static String etiqueta(String categoria) {
    switch (categoria) {
      case impuestos:
        return 'Impuestos';
      case servicios:
        return 'Servicios (luz, agua, internet)';
      case reparaciones:
        return 'Reparaciones';
      case alquiler:
        return 'Alquiler';
      case sueldos:
        return 'Sueldos';
      case mercancia:
        return 'Compra de mercancía';
      case otros:
      default:
        return 'Otros';
    }
  }

  /// Icono por categoría para la UI.
  static String emoji(String categoria) {
    switch (categoria) {
      case impuestos:
        return '🏛️';
      case servicios:
        return '💡';
      case reparaciones:
        return '🔧';
      case alquiler:
        return '🏠';
      case sueldos:
        return '👥';
      case mercancia:
        return '📦';
      case otros:
      default:
        return '📌';
    }
  }
}
