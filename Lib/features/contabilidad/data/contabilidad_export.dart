import 'dart:io';

import 'package:excel_plus/excel_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/utils/formato.dart';
import '../domain/contabilidad_models.dart';
import 'contabilidad_service.dart';
import 'gasto_dao.dart';
import '../../caja/data/caja_dao.dart';
import '../../clientes/data/cliente_dao.dart';
import '../../inventario/data/producto_dao.dart';
import '../../merma/data/merma_dao.dart';
import '../../ventas/data/venta_dao.dart';

/// Exporta el cuaderno contable a Excel (estado de resultados + situación
/// financiera + detalle de gastos). Gate: puedePersonalizar.
class ContabilidadExport {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final Ref _ref;

  ContabilidadExport(this._ref);

  /// Genera el archivo Excel y retorna la ruta local.
  Future<String> exportar({required PeriodoContable periodo}) async {
    try {
      final config = _ref.read(appConfigProvider);
      final servicio = _ref.read(contabilidadServiceProvider);
      final ventaDao = _ref.read(ventaDaoProvider);
      final gastoDao = _ref.read(gastoDaoProvider);
      final mermaDao = _ref.read(mermaDaoProvider);
      final cajaDao = _ref.read(cajaDaoProvider);
      final clienteDao = _ref.read(clienteDaoProvider);
      final productoDao = _ref.read(productoDaoProvider);

      // Calcular datos
      final resultados = await servicio.estadoResultados(
        periodo: periodo,
        ventaDao: ventaDao,
        gastoDao: gastoDao,
        mermaDao: mermaDao,
      );
      final situacion = await servicio.situacionFinanciera(
        cajaDao: cajaDao,
        clienteDao: clienteDao,
        productoDao: productoDao,
        config: config,
      );
      final (inicio, fin) = servicio.rangoPeriodo(periodo);
      final gastos = await gastoDao.enRango(inicio, fin);

      // Crear Excel
      final excel = Excel.createExcel();
      final hoja = excel['Sheet1'];

      // Título
      hoja
        ..cell(CellIndex.indexByString('A1')).value =
            TextCellValue('CUADERNO CONTABLE - ${config.nombreEfectivo}')
        ..cell(CellIndex.indexByString('A2')).value =
            TextCellValue('Período: ${_etiquetaPeriodo(periodo)}')
        ..cell(CellIndex.indexByString('A3')).value =
            TextCellValue('Generado: ${Formato.fechaHora(DateTime.now())}');

      // Estado de Resultados
      int fila = 5;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('ESTADO DE RESULTADOS');
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Concepto');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue('Monto (USD)');
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Ingresos (${resultados.numVentas} ventas)');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(resultados.ingresosUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Gastos manuales (${resultados.numGastos})');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(-resultados.gastosManualesUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Gastos de merma');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(-resultados.gastosMermaUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('UTILIDAD NETA');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(resultados.utilidadNetaUsd));
      fila += 2;

      // Situación Financiera
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('SITUACIÓN FINANCIERA');
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('ACTIVOS');
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Efectivo en caja');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(situacion.efectivoCajaUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Cuentas por cobrar (fiados)');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(situacion.cuentasPorCobrarUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Inventario (a costo)');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(situacion.inventarioCostoUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('TOTAL ACTIVOS');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(situacion.activosTotalesUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('PASIVOS');
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Deudas a proveedores');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(situacion.pasivosUsd));
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('PATRIMONIO');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue(Formato.usd(situacion.patrimonioUsd));
      fila += 2;

      // Detalle de gastos manuales
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('DETALLE DE GASTOS MANUALES');
      fila++;
      hoja.cell(CellIndex.indexByString('A$fila')).value =
          TextCellValue('Fecha');
      hoja.cell(CellIndex.indexByString('B$fila')).value =
          TextCellValue('Categoría');
      hoja.cell(CellIndex.indexByString('C$fila')).value =
          TextCellValue('Descripción');
      hoja.cell(CellIndex.indexByString('D$fila')).value =
          TextCellValue('Monto (USD)');
      fila++;

      for (final gasto in gastos) {
        final fecha = DateTime.fromMillisecondsSinceEpoch(gasto.fecha);
        hoja.cell(CellIndex.indexByString('A$fila')).value =
            TextCellValue(Formato.fecha(fecha));
        hoja.cell(CellIndex.indexByString('B$fila')).value =
            TextCellValue(CategoriasGasto.etiqueta(gasto.categoria));
        hoja.cell(CellIndex.indexByString('C$fila')).value =
            TextCellValue(gasto.descripcion);
        hoja.cell(CellIndex.indexByString('D$fila')).value =
            TextCellValue(Formato.usd(gasto.montoUsd));
        fila++;
      }

      // Guardar archivo (excel_plus: save() retorna bytes, se escriben con File)
      final dir = await getApplicationDocumentsDirectory();
      final nombreArchivo =
          'contabilidad_${_etiquetaPeriodoArchivo(periodo)}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final ruta = '${dir.path}/$nombreArchivo';

      final bytes = excel.save();
      await File(ruta).writeAsBytes(bytes!);

      _logger.i('📊 Contabilidad exportada: $ruta');
      return ruta;
    } catch (e, stack) {
      _logger.e('Error exportando contabilidad', error: e, stackTrace: stack);
      rethrow;
    }
  }

  String _etiquetaPeriodo(PeriodoContable periodo) {
    switch (periodo) {
      case PeriodoContable.hoy:
        return 'Hoy';
      case PeriodoContable.sieteDias:
        return 'Últimos 7 días';
      case PeriodoContable.mes:
        return 'Mes actual';
    }
  }

  String _etiquetaPeriodoArchivo(PeriodoContable periodo) {
    switch (periodo) {
      case PeriodoContable.hoy:
        return 'hoy';
      case PeriodoContable.sieteDias:
        return '7dias';
      case PeriodoContable.mes:
        return 'mes';
    }
  }
}

final contabilidadExportProvider =
    Provider<ContabilidadExport>((ref) => ContabilidadExport(ref));
