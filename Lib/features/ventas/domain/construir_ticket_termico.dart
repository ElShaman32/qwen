import 'dart:convert';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import 'ticket_termico.dart';
import 'venta_models.dart';

/// Convierte una venta en bytes ESC/POS para impresora térmica.
/// SIN emojis (las térmicas no los renderizan, Decisiones.md).
List<int> construirTicketTermico(VentaData venta, AppConfigState config) {
  final t = TicketTermico(ancho: 48);
  final items = (jsonDecode(venta.itemsJson) as List)
      .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
      .toList();
  final pagos = (jsonDecode(venta.pagosJson) as List)
      .map((e) => Pago.fromJson(e as Map<String, dynamic>))
      .toList();

  final fecha = DateTime.fromMillisecondsSinceEpoch(venta.fecha);
  final hora =
      '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';

  t.iniciar();

  // Encabezado del negocio
  t.encabezadoNegocio(
    nombre: config.nombreEfectivo,
    slogan: config.sloganEfectivo,
    rif: config.rif,
    direccion: config.direccion,
    telefono: config.telefono,
  );

  // Info de venta
  t.titulo('TICKET DE VENTA');
  t.par('Fecha:', Formato.fecha(fecha));
  t.par('Hora:', hora);
  t.par('Venta #', venta.numeroVenta.toString());
  t.par('Cajero:', venta.usuarioNombre);
  t.separador();

  // Items
  for (final item in items) {
    final cant = item.esGranel
        ? '${Formato.numero(item.cantidad, decimales: 2)} ${item.unidadMedida ?? 'kg'}'
        : '${item.cantidad.toInt()} und';
    final detalle = '$cant x ${Formato.usd(item.precioUnitarioUsd)}';
    t.item(
      nombre: item.productoNombre,
      detalle: detalle,
      total: Formato.usd(item.subtotalUsd),
    );
  }

  t.separador();

  // Totales
  t.totalDestacado('TOTAL USD:', Formato.usd(venta.totalUsd));
  t.par('Tasa:', Formato.numero(venta.tasaUsada, decimales: 2));
  t.totalDestacado('TOTAL Bs:', Formato.bs(venta.totalBs));

  // Desglose exento/gravado si aplica
  if (venta.exentoBs > 0) {
    t.par('Exento:', Formato.bs(venta.exentoBs));
    t.par('Gravado:', Formato.bs(venta.totalBs - venta.exentoBs));
  }

  t.separador();

  // Pagos
  t.titulo('PAGOS');
  for (final pago in pagos) {
    final monto = pago.simbolo == 'Bs'
        ? Formato.bs(pago.montoBs)
        : Formato.usd(pago.montoUsd);
    t.par('${pago.metodoNombre}:', monto);

    // Tercera moneda
    if (pago.montoTercera != null && pago.terceraSimbolo != null) {
      t.par(
        '  ${Formato.numero(pago.montoTercera!, decimales: 2)} ${pago.terceraSimbolo}',
        Formato.usd(pago.montoUsd),
      );
    }

    // Detalle de pago (correo, número, etc.)
    if (pago.detallePago != null && pago.detallePago!.isNotEmpty) {
      t.linea('  ${pago.detallePago}');
    }

    // Vuelto inteligente
    if (pago.vueltoUsd != null && pago.vueltoUsd! > 0) {
      t.par('  Vuelto \$:', Formato.usd(pago.vueltoUsd!));
    }
    if (pago.vueltoBs != null && pago.vueltoBs! > 0) {
      t.par('  Vuelto Bs:', Formato.bs(pago.vueltoBs!));
    }
  }

  t.separador();

  // Impuestos (desglose fiscal)
  t.titulo('IMPUESTOS INCLUIDOS');
  final baseImponible = venta.totalBs - venta.ivaBs;
  t.par('Base imponible:', Formato.bs(baseImponible));
  t.par('IVA (16%):', Formato.bs(venta.ivaBs));
  if (venta.igtfBs > 0) {
    t.par('IGTF (3%):', Formato.bs(venta.igtfBs));
  }

  t.separador();

  // Pie
  t.linea('');
  t.linea('Gracias por su compra!');
  if (config.sloganEfectivo.isNotEmpty) {
    t.linea(config.sloganEfectivo);
  }
  t.linea('');
  t.linea('Tecnologia de SiReBAi');

  // Corte de papel
  t.corte();

  return t.bytes();
}
