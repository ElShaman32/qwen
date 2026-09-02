import 'dart:io';

import 'package:excel_plus/excel_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import 'reportes_service.dart';

/// Exportación de reportes a Excel y PDF (planes pagos).
/// Patrón verificado de auditoria_export.dart:
/// excel_plus (TextCellValue + save()) y SharePlus.instance.share.
class ReportesExport {
  /// Genera el Excel (hoja resumen + hoja detalle) y lo comparte.
  static Future<void> exportarExcel({
    required StatsResumen resumen,
    required List<TopProducto> top,
    required List<VentaData> ventas,
    required AppConfigState config,
    required String nombrePeriodo,
  }) async {
    final excel = Excel.createExcel();
    final sh = excel['Sheet1'];

    void fila(String a, String b) {
      sh.appendRow([TextCellValue(a), TextCellValue(b)]);
    }

    fila('Reporte de ventas', config.nombreEfectivo);
    fila('Período', nombrePeriodo);
    fila('Generado', Formato.fecha(DateTime.now()));
    if (config.rif.isNotEmpty) fila('RIF', config.rif);
    fila('Tasa (Bs por \$)', Formato.numero(config.tasaEfectiva, decimales: 2));
    sh.appendRow([]);
    fila('Número de ventas', resumen.numVentas.toString());
    fila('Total USD', Formato.usd(resumen.totalUsd));
    fila('Total Bs', Formato.bs(resumen.totalBs));
    fila('Ganancia USD', Formato.usd(resumen.gananciaUsd));
    fila('Ticket promedio', Formato.usd(resumen.ticketPromedio));
    fila('IVA recaudado', Formato.bs(resumen.ivaBs));
    fila('Exento', Formato.bs(resumen.exentoBs));
    sh.appendRow([]);
    fila('Por método de pago', '');
    resumen.porMetodo.forEach((metodo, monto) {
      fila(metodo, Formato.usd(monto));
    });
    sh.appendRow([]);
    fila('Top productos', '');
    for (final t in top) {
      fila(
        t.nombre,
        '${Formato.numero(t.cantidad, decimales: 2)} · ${Formato.usd(t.totalUsd)}',
      );
    }

    // Hoja de detalle de ventas
    final dv = excel['Ventas'];
    dv.appendRow([
      TextCellValue('#'),
      TextCellValue('Fecha'),
      TextCellValue('Cajero'),
      TextCellValue('Total USD'),
      TextCellValue('Total Bs'),
    ]);
    for (final v in ventas) {
      dv.appendRow([
        TextCellValue(v.numeroVenta.toString()),
        TextCellValue(
            Formato.fecha(DateTime.fromMillisecondsSinceEpoch(v.fecha))),
        TextCellValue(v.usuarioNombre),
        TextCellValue(Formato.usd(v.totalUsd)),
        TextCellValue(Formato.bs(v.totalBs)),
      ]);
    }

    // excel_plus devuelve los BYTES (nullable): los escribo en un temporal
    final bytes = excel.save();
    if (bytes == null) throw Exception('No se pudo generar el Excel');
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/reporte_ventas.xlsx');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  /// Genera el PDF y lo comparte.
  static Future<void> exportarPdf({
    required StatsResumen resumen,
    required List<TopProducto> top,
    required AppConfigState config,
    required String nombrePeriodo,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            config.nombreEfectivo,
            style: const pw.TextStyle(
                fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Reporte de ventas — $nombrePeriodo'),
          pw.Text('Generado: ${Formato.fecha(DateTime.now())}'),
          pw.Text(
              'Tasa: ${Formato.numero(config.tasaEfectiva, decimales: 2)} Bs por \$'),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            headers: ['Indicador', 'Valor'],
            data: [
              ['Número de ventas', resumen.numVentas.toString()],
              ['Total USD', Formato.usd(resumen.totalUsd)],
              ['Total Bs', Formato.bs(resumen.totalBs)],
              ['Ganancia USD', Formato.usd(resumen.gananciaUsd)],
              ['Ticket promedio', Formato.usd(resumen.ticketPromedio)],
              ['IVA recaudado', Formato.bs(resumen.ivaBs)],
              ['Exento', Formato.bs(resumen.exentoBs)],
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Text('Por método de pago',
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.TableHelper.fromTextArray(
            headers: ['Método', 'Monto USD'],
            data: [
              for (final e in resumen.porMetodo.entries)
                [e.key, Formato.usd(e.value)],
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Text('Top productos',
              style: const pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.TableHelper.fromTextArray(
            headers: ['Producto', 'Cantidad', 'Total USD'],
            data: [
              for (final t in top)
                [
                  t.nombre,
                  Formato.numero(t.cantidad, decimales: 2),
                  Formato.usd(t.totalUsd),
                ],
            ],
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/reporte_ventas.pdf');
    await file.writeAsBytes(await pdf.save());
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }
}
