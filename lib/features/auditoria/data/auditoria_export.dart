import 'dart:io';
import 'dart:typed_data';

import 'package:excel_plus/excel_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../domain/auditoria_acciones.dart';
import 'auditoria_dao.dart';

/// Exporta el log de auditoría a un archivo Excel (.xlsx).
///
/// Estrategia:
/// 1. Lee todos los logs del DAO
/// 2. Genera el archivo en memoria con excel_plus
/// 3. Lo guarda en el directorio de documentos de la app
/// 4. Registra la exportación en el propio log de auditoría
/// 5. Lo comparte con share_plus (Android/iOS) o muestra la ruta (Windows)
class AuditoriaExport {
  AuditoriaExport(this._ref);

  final Ref _ref;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Exporta y retorna la ruta del archivo generado.
  /// Lanza excepción si algo falla (el llamador la maneja).
  Future<String> exportar() async {
    // 1. Leer todos los logs
    final logs = await _ref.read(auditoriaDaoProvider).listarParaExportar();

    // 2. Crear el libro de Excel
    final excel = Excel.createExcel();
    final hoja = excel['Sheet1'];

    // 3. Encabezados (TextCellValue obligatorio en excel_plus 2.x)
    final encabezados = ['Fecha', 'Usuario', 'Acción', 'Detalles'];
    for (var col = 0; col < encabezados.length; col++) {
      hoja
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(encabezados[col]);
    }

    // 4. Filas de datos
    for (var i = 0; i < logs.length; i++) {
      final log = logs[i];
      final fila = i + 1; // +1 porque la fila 0 es el encabezado
      final fecha = DateTime.fromMillisecondsSinceEpoch(log.fecha);

      hoja
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: fila))
          .value = TextCellValue(Formato.fechaHora(fecha));
      hoja
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: fila))
          .value = TextCellValue(log.usuarioNombre);
      hoja
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: fila))
          .value = TextCellValue(_accionLegible(log.accion));
      hoja
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: fila))
          .value = TextCellValue(log.detalles ?? '');
    }

    // 5. Guardar a bytes (save() NO recibe argumentos en excel_plus 2.x)
    final bytes = excel.save();
    if (bytes == null || bytes.isEmpty) {
      throw Exception('No se pudo generar el archivo Excel');
    }

    // 6. Guardar el archivo en disco
    final ruta = await _guardarArchivo(bytes);

    // 7. Registrar la exportación en el log de auditoría (meta-auditoría)
    await _ref.read(auditoriaDaoProvider).insertar(
          usuarioId: _usuarioId(),
          usuarioNombre: _usuarioNombre(),
          accion: AccionesAuditoria.auditoriaExportada,
          detalles: '${logs.length} registros exportados',
        );

    _logger.i('📊 Auditoría exportada: $ruta');
    return ruta;
  }

  /// Convierte el código snake_case en algo legible.
  String _accionLegible(String accion) {
    const etiquetas = {
      'login': 'Inicio de sesión',
      'logout': 'Cierre de sesión',
      'venta_anulada': 'Venta anulada',
      'caja_apertura': 'Apertura de caja',
      'caja_cierre': 'Cierre de caja',
      'caja_retiro': 'Retiro de caja',
      'producto_creado': 'Producto creado',
      'producto_actualizado': 'Producto actualizado',
      'producto_eliminado': 'Producto eliminado',
      'cliente_creado': 'Cliente creado',
      'fiado_registrado': 'Fiado registrado',
      'abono_registrado': 'Abono registrado',
      'tasa_actualizada': 'Tasa actualizada',
      'config_actualizada': 'Configuración actualizada',
      'usuario_creado': 'Usuario creado',
      'usuario_rol_cambiado': 'Rol cambiado',
      'usuario_estado_cambiado': 'Estado de usuario cambiado',
      'auditoria_exportada': 'Auditoría exportada',
    };
    return etiquetas[accion] ?? accion;
  }

  /// Guarda los bytes en el directorio de documentos y retorna la ruta.
  Future<String> _guardarArchivo(List<int> bytes) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final nombreArchivo = 'auditoria_$timestamp.xlsx';

    Directory directorio;
    try {
      directorio = await getApplicationDocumentsDirectory();
    } catch (e) {
      _logger.e('Error obteniendo directorio de documentos', error: e);
      rethrow;
    }

    final archivo = File(p.join(directorio.path, nombreArchivo));
    await archivo.writeAsBytes(Uint8List.fromList(bytes));
    return archivo.path;
  }

  String _usuarioId() {
    final user = _ref.read(currentUserProvider).value;
    return user?.uid ?? '';
  }

  String _usuarioNombre() {
    final user = _ref.read(currentUserProvider).value;
    return user?.nombre ?? 'Desconocido';
  }
}

final auditoriaExportProvider = Provider<AuditoriaExport>((ref) {
  return AuditoriaExport(ref);
});
