import 'dart:convert';
import '../../../core/database/app_database.dart';
import '../../ventas/domain/venta_models.dart';

/// Resultado del arqueo teórico del turno.
class ResumenCaja {
  final double esperadoBs;
  final double esperadoUsd;
  final Map<String, double> porMetodo;
  final double totalVendidoUsd;
  final int numVentas;

  const ResumenCaja({
    required this.esperadoBs,
    required this.esperadoUsd,
    required this.porMetodo,
    required this.totalVendidoUsd,
    required this.numVentas,
  });
}

/// Calcula cuánto efectivo DEBERÍA haber en el cajón.
/// Maneja vuelto inteligente: el $ que entra es recibido - vueltoUsd,
/// y el Bs que sale es el vueltoBs entregado.
abstract class CajaCalculos {
  static double _red2(double x) => (x * 100).round() / 100;

  static ResumenCaja calcular({
    required AperturaCajaData apertura,
    required List<VentaData> ventas,
    required List<RetiroCajaData> retiros,
  }) {
    double bs = apertura.montoInicialBs;
    double usd = apertura.montoInicialUsd;
    final porMetodo = <String, double>{};
    double totalVendido = 0;

    for (final v in ventas) {
      totalVendido += v.totalUsd;

      final pagos = (jsonDecode(v.pagosJson) as List)
          .map((e) => Pago.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final p in pagos) {
        porMetodo[p.metodoNombre] =
            _red2((porMetodo[p.metodoNombre] ?? 0) + p.montoUsd);

        if (p.metodoId == 'efectivo_usd') {
          // $ que realmente queda en el cajón
          final efectoUsd = p.recibido != null
              ? p.recibido! - (p.vueltoUsd ?? 0)
              : p.montoUsd;
          usd += efectoUsd;
          // Bs que salieron como vuelto mixto
          bs -= (p.vueltoBs ?? 0);
        } else if (p.metodoId == 'efectivo_bs') {
          bs += p.montoBs;
        }
        // fiado / digitales: no entra efectivo al cajón
      }
    }

    for (final r in retiros) {
      bs -= r.montoBs;
    }

    return ResumenCaja(
      esperadoBs: _red2(bs),
      esperadoUsd: _red2(usd),
      porMetodo: porMetodo,
      totalVendidoUsd: _red2(totalVendido),
      numVentas: ventas.length,
    );
  }
}
