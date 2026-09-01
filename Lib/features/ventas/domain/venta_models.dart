/// Item de una venta. Guarda precio AL MOMENTO de la venta (auditoría).
class ItemVenta {
  final int? productoId;
  final String productoNombre;
  final String? codigo;
  final double cantidad;
  final bool esGranel;
  final String? unidadMedida;
  final double precioUnitarioUsd;
  final double subtotalUsd;
  final double costoUnitarioUsd;
  final bool exentoIva;

  const ItemVenta({
    this.productoId,
    required this.productoNombre,
    this.codigo,
    required this.cantidad,
    this.esGranel = false,
    this.unidadMedida,
    required this.precioUnitarioUsd,
    required this.subtotalUsd,
    this.costoUnitarioUsd = 0,
    this.exentoIva = false,
  });

  Map<String, dynamic> toJson() => {
        'productoId': productoId,
        'productoNombre': productoNombre,
        'codigo': codigo,
        'cantidad': cantidad,
        'esGranel': esGranel,
        'unidadMedida': unidadMedida,
        'precioUnitarioUsd': precioUnitarioUsd,
        'subtotalUsd': subtotalUsd,
        'costoUnitarioUsd': costoUnitarioUsd,
        'exentoIva': exentoIva,
      };

  factory ItemVenta.fromJson(Map<String, dynamic> json) => ItemVenta(
        productoId: json['productoId'] as int?,
        productoNombre: json['productoNombre'] as String? ?? '',
        codigo: json['codigo'] as String?,
        cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0,
        esGranel: json['esGranel'] as bool? ?? false,
        unidadMedida: json['unidadMedida'] as String?,
        precioUnitarioUsd: (json['precioUnitarioUsd'] as num?)?.toDouble() ?? 0,
        subtotalUsd: (json['subtotalUsd'] as num?)?.toDouble() ?? 0,
        costoUnitarioUsd: (json['costoUnitarioUsd'] as num?)?.toDouble() ?? 0,
        exentoIva: json['exentoIva'] as bool? ?? false,
      );
}

/// Un pago dentro de una venta (soporta pagos mixtos y vuelto inteligente).
class Pago {
  final String metodoId;
  final String metodoNombre;
  final String simbolo;
  final bool esDivisa; // aplica IGTF
  final double montoUsd;
  final double montoBs;
  final double tasa;
  final String? detallePago;
  final double? montoTercera;
  final String? terceraSimbolo;

  /// Monto recibido en la moneda del método (efectivo).
  final double? recibido;

  /// Vuelto entregado en USD (vuelto inteligente: parte en $).
  final double? vueltoUsd;

  /// Vuelto entregado en Bs (vuelto inteligente: parte en Bs).
  final double? vueltoBs;

  const Pago({
    required this.metodoId,
    required this.metodoNombre,
    required this.simbolo,
    required this.esDivisa,
    required this.montoUsd,
    required this.montoBs,
    required this.tasa,
    this.detallePago,
    this.montoTercera,
    this.terceraSimbolo,
    this.recibido,
    this.vueltoUsd,
    this.vueltoBs,
  });

  Map<String, dynamic> toJson() => {
        'metodoId': metodoId,
        'metodoNombre': metodoNombre,
        'simbolo': simbolo,
        'esDivisa': esDivisa,
        'montoUsd': montoUsd,
        'montoBs': montoBs,
        'tasa': tasa,
        'detallePago': detallePago,
        'montoTercera': montoTercera,
        'terceraSimbolo': terceraSimbolo,
        'recibido': recibido,
        'vueltoUsd': vueltoUsd,
        'vueltoBs': vueltoBs,
      };

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        metodoId: json['metodoId'] as String? ?? '',
        metodoNombre: json['metodoNombre'] as String? ?? '',
        simbolo: json['simbolo'] as String? ?? '',
        esDivisa: json['esDivisa'] as bool? ?? false,
        montoUsd: (json['montoUsd'] as num?)?.toDouble() ?? 0,
        montoBs: (json['montoBs'] as num?)?.toDouble() ?? 0,
        tasa: (json['tasa'] as num?)?.toDouble() ?? 0,
        detallePago: json['detallePago'] as String?,
        montoTercera: (json['montoTercera'] as num?)?.toDouble(),
        terceraSimbolo: json['terceraSimbolo'] as String?,
        recibido: (json['recibido'] as num?)?.toDouble(),
        vueltoUsd: (json['vueltoUsd'] as num?)?.toDouble(),
        vueltoBs: (json['vueltoBs'] as num?)?.toDouble(),
      );
}
