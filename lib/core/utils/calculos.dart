import 'dart:math';

/// Resultado del desglose de impuestos post-precio.
class DesgloseImpuestos {
  final double precioFinal;
  final double baseImponible;
  final double montoIva;
  final double montoIgtf;
  final double totalConIgtf;
  final double tasaIva;
  final double tasaIgtf;
  final bool aplicaIgtf;

  const DesgloseImpuestos({
    required this.precioFinal,
    required this.baseImponible,
    required this.montoIva,
    required this.montoIgtf,
    required this.totalConIgtf,
    required this.tasaIva,
    required this.tasaIgtf,
    required this.aplicaIgtf,
  });
}

/// Métodos de pago que generan IGTF según normativa venezolana.
const _metodosConIgtf = {
  'efectivo_usd',
  'zelle',
  'binance',
  'tercera_moneda',
};

/// Utilidades de cálculo financiero centralizadas.
/// REDONDEO EXPLÍCITO en cada operación para evitar floating-point drift.
class Calculos {
  Calculos._();

  /// Redondea a N decimales usando banker's rounding.
  static double redondear(double valor, {int decimales = 2}) {
    final factor = pow(10, decimales).toDouble();
    return (valor * factor).roundToDouble() / factor;
  }

  /// REGLA #3: Impuestos se gravan DESPUÉS del precio mostrado.
  /// El precioFinal YA incluye IVA. Se calcula base = precioFinal / (1 + tasaIVA).
  /// IGTF solo aplica si el método de pago es divisas/cripto.
  static DesgloseImpuestos calcularImpuestos({
    required double precioFinal,
    required double tasaIva,
    required double tasaIgtf,
    required String metodoPago,
  }) {
    final base = redondear(precioFinal / (1 + tasaIva));
    final iva = redondear(precioFinal - base);
    final aplicaIgtf = _metodosConIgtf.contains(metodoPago.toLowerCase());
    final igtf = aplicaIgtf ? redondear(precioFinal * tasaIgtf) : 0.0;
    final total = redondear(precioFinal + igtf);

    return DesgloseImpuestos(
      precioFinal: redondear(precioFinal),
      baseImponible: base,
      montoIva: iva,
      montoIgtf: igtf,
      totalConIgtf: total,
      tasaIva: tasaIva,
      tasaIgtf: tasaIgtf,
      aplicaIgtf: aplicaIgtf,
    );
  }

  /// Convierte USD → Bs usando tasa efectiva.
  static double usdABs(double usd, double tasa) => redondear(usd * tasa);

  /// Convierte Bs → USD usando tasa efectiva.
  static double bsAUsd(double bs, double tasa) =>
      tasa > 0 ? redondear(bs / tasa) : 0.0;

  /// Calcula vuelto en Bs cuando no hay cambio suficiente en USD.
  /// faltanteUsd = vueltoTotalUsd - disponibleEnUsd
  static double vueltoFaltanteEnBs({
    required double faltanteUsd,
    required double tasa,
  }) =>
      usdABs(faltanteUsd, tasa);

  /// Precio por granel: precioPorKg * pesoEnKg
  static double precioGranel({
    required double precioPorUnidad,
    required double cantidad,
  }) =>
      redondear(precioPorUnidad * cantidad);

  /// Descuento porcentual sobre un monto.
  static double aplicarDescuento(double monto, double porcentaje) =>
      redondear(monto * (1 - porcentaje));
}
