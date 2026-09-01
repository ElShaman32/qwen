import 'dart:io';

import 'package:excel_plus/excel_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';

/// Exporta el histórico de tasas a Excel.
class HistorialTasaExport {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final Ref _ref;

  HistorialTasaExport(this._ref);

  /// Genera el Excel y retorna la ruta local.
  Future<String> exportar({
    required List<HistorialTasaData> tasas,
    required String etiquetaPeriodo,
  }) async {
    try {
      final config = _ref.read(appConfigProvider);

      final excel = Excel.createExcel();
      final sh = excel['Sheet1'];

      void fila(String a, String b) {
        sh.appendRow([TextCellValue(a), TextCellValue(b)]);
      }

      // Encabezado
      fila('Histórico de tasas', config.nombreEfectivo);
      fila('Período', etiquetaPeriodo);
      fila('Generado', Formato.fechaHora(DateTime.now()));
      if (config.rif.isNotEmpty) fila('RIF', config.rif);
      fila('Tasa actual',
          '${Formato.numero(config.tasaEfectiva, decimales: 2)} Bs por \$');
      sh.appendRow([]);

      // Estadísticas del período
      if (tasas.isNotEmpty) {
        final valores = tasas.map((t) => t.tasa).toList();
        final min = valores.reduce((a, b) => a < b ? a : b);
        final max = valores.reduce((a, b) => a > b ? a : b);
        final promedio = valores.reduce((a, b) => a + b) / valores.length;

        fila('Registros', '${tasas.length}');
        fila('Tasa mínima', '${Formato.numero(min, decimales: 2)} Bs');
        fila('Tasa máxima', '${Formato.numero(max, decimales: 2)} Bs');
        fila('Tasa promedio', '${Formato.numero(promedio, decimales: 2)} Bs');
        sh.appendRow([]);
      }

      // Tabla de detalle
      sh.appendRow([
        TextCellValue('Fecha'),
        TextCellValue('Hora'),
        TextCellValue('Tasa (Bs por \$)'),
        TextCellValue('Fuente'),
      ]);

      for (final tasa in tasas) {
        final fecha = tasa.fecha;
        sh.appendRow([
          TextCellValue(Formato.fecha(fecha)),
          TextCellValue(
              '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}'),
          TextCellValue(Formato.numero(tasa.tasa, decimales: 2)),
          TextCellValue(_etiquetaFuente(tasa.fuente)),
        ]);
      }

      // Guardar
      final bytes = excel.save();
      if (bytes == null) throw Exception('No se pudo generar el Excel');

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/historial_tasas_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes);

      _logger.i('📊 Histórico de tasas exportado: ${file.path}');
      return file.path;
    } catch (e, stack) {
      _logger.e('Error exportando histórico de tasas',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  String _etiquetaFuente(String fuente) {
    switch (fuente) {
      case 'bcv_api':
        return 'BCV manual';
      case 'bcv_api_auto':
        return 'BCV automática';
      case 'manual':
        return 'Manual';
      default:
        return fuente.replaceAll('_', ' ');
    }
  }
}

final historialTasaExportProvider =
    Provider<HistorialTasaExport>((ref) => HistorialTasaExport(ref));
