import 'dart:convert';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import 'venta_models.dart';

/// Genera el ticket en texto plano con emojis (formato WhatsApp).
abstract class TicketGenerator {
  static String generar(VentaData venta, AppConfigState config) {
    final items = (jsonDecode(venta.itemsJson) as List)
        .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
        .toList();
    final pagos = (jsonDecode(venta.pagosJson) as List)
        .map((e) => Pago.fromJson(e as Map<String, dynamic>))
        .toList();

    final fecha = DateTime.fromMillisecondsSinceEpoch(venta.fecha);
    final hora =
        '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';

    final sb = StringBuffer();
    sb.writeln('🧾 *${config.nombreEfectivo.toUpperCase()}*');
    if (config.rif.isNotEmpty) sb.writeln(config.rif);
    if (config.direccion.isNotEmpty) sb.writeln(config.direccion);
    if (config.telefono.isNotEmpty) sb.writeln('Tel: ${config.telefono}');
    sb.writeln('📅 ${Formato.fecha(fecha)} $hora');
    sb.writeln('👤 ${venta.usuarioNombre}');
    sb.writeln('Venta #${venta.numeroVenta}');
    sb.writeln('━━━━━━━━━━━━━━');

    for (final item in items) {
      final cant = item.esGranel
          ? '${Formato.numero(item.cantidad, decimales: 2)} ${item.unidadMedida ?? 'kg'}'
          : '${item.cantidad.toInt()} und';
      sb.writeln('$cant  ${item.productoNombre}');
      sb.writeln('     ${Formato.usd(item.subtotalUsd)}');
    }

    sb.writeln('━━━━━━━━━━━━━━');
    sb.writeln('TOTAL: ${Formato.usd(venta.totalUsd)}');
    sb.writeln('Tasa: ${Formato.numero(venta.tasaUsada, decimales: 2)}');
    sb.writeln('TOTAL Bs: ${Formato.bs(venta.totalBs)}');
    if (venta.exentoBs > 0) {
      sb.writeln('Exento: ${Formato.bs(venta.exentoBs)}');
      sb.writeln('Gravado: ${Formato.bs(venta.totalBs - venta.exentoBs)}');
    }
    sb.writeln('━━━━━━━━━━━━━━');
    sb.writeln('💵 PAGOS:');
    for (final pago in pagos) {
      sb.writeln(
          '${pago.metodoNombre}: ${_monto(pago.simbolo, pago.montoUsd, pago.montoBs)}');
      if (pago.recibido != null) {
        sb.writeln(
            '   Recibido: ${_monto(pago.simbolo, pago.recibido!, pago.recibido!)}');
      }
      if (pago.montoTercera != null) {
        sb.writeln(
            '   ${Formato.numero(pago.montoTercera!, decimales: 2)} ${pago.terceraSimbolo ?? ''} = ${Formato.usd(pago.montoUsd)}');
      }

      if (pago.detallePago != null && pago.detallePago!.isNotEmpty) {
        sb.writeln('   ${pago.detallePago}');
      }

      if (pago.vueltoUsd != null) {
        sb.writeln('   Vuelto \$: ${Formato.usd(pago.vueltoUsd!)}');
      }
      if (pago.vueltoBs != null) {
        sb.writeln('   Vuelto Bs: ${Formato.bs(pago.vueltoBs!)}');
      }
    }
    sb.writeln('━━━━━━━━━━━━━━');
    sb.writeln('📋 Impuestos incluidos:');
    sb.writeln('Base: ${Formato.bs(venta.totalBs - venta.ivaBs)}');
    sb.writeln('IVA: ${Formato.bs(venta.ivaBs)}');
    if (venta.igtfBs > 0) sb.writeln('IGTF: ${Formato.bs(venta.igtfBs)}');
    sb.writeln('━━━━━━━━━━━━━━');
    sb.writeln('¡Gracias por su compra!');
    if (config.sloganEfectivo.isNotEmpty) {
      sb.writeln('_${config.sloganEfectivo}_');
    }
    sb.writeln('Tecnología de SiReBAi🇻🇪');
    return sb.toString();
  }

  static String _monto(String simbolo, double usd, double bs) =>
      simbolo == 'Bs' ? Formato.bs(bs) : Formato.usd(usd);
}
