import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

/// Servicio de impresión térmica Bluetooth.
/// Wrapper de print_bluetooth_thermal con manejo de estado y errores.
class PrinterService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Escanea dispositivos Bluetooth disponibles.
  /// Requiere permisos de Bluetooth y ubicación (Android).
  Future<List<BluetoothInfo>> escanearDispositivos() async {
    try {
      final devices = await PrintBluetoothThermal.pairedBluetooths;
      _logger.i('🔍 Encontrados ${devices.length} dispositivos Bluetooth');
      return devices;
    } catch (e, stack) {
      _logger.e('Error escaneando dispositivos', error: e, stackTrace: stack);
      return [];
    }
  }

  /// Conecta a una impresora por MAC address.
  Future<bool> conectar(String macAddress) async {
    try {
      final result = await PrintBluetoothThermal.connect(
        macPrinterAddress: macAddress,
      );
      if (result) {
        _logger.i('✅ Conectado a impresora: $macAddress');
      } else {
        _logger.w('⚠️ No se pudo conectar a: $macAddress');
      }
      return result;
    } catch (e, stack) {
      _logger.e('Error conectando impresora', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Desconecta la impresora actual.
  Future<void> desconectar() async {
    try {
      await PrintBluetoothThermal.disconnect;
      _logger.i('🔌 Impresora desconectada');
    } catch (e, stack) {
      _logger.e('Error desconectando', error: e, stackTrace: stack);
    }
  }

  /// Verifica si hay una impresora conectada.
  Future<bool> estaConectada() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (e) {
      return false;
    }
  }

  /// Imprime texto plano en la impresora conectada.
  /// [texto] debe estar en formato ESC/POS (comandos de impresora térmica).
  Future<bool> imprimirTexto(String texto) async {
    try {
      final conectado = await estaConectada();
      if (!conectado) {
        _logger.w('⚠️ No hay impresora conectada');
        return false;
      }

      final result = await PrintBluetoothThermal.writeBytes(texto.codeUnits);
      if (result) {
        _logger.i('🖨️ Ticket impreso (${texto.length} bytes)');
      }
      return result;
    } catch (e, stack) {
      _logger.e('Error imprimiendo', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Imprime bytes ESC/POS directamente (ticket ya formateado).
  Future<bool> imprimirBytes(List<int> bytes) async {
    try {
      final conectado = await estaConectada();
      if (!conectado) {
        _logger.w('⚠️ No hay impresora conectada');
        return false;
      }
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      if (result) {
        _logger.i('🖨️ Ticket impreso (${bytes.length} bytes)');
      }
      return result;
    } catch (e, stack) {
      _logger.e('Error imprimiendo', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Imprime y corta el papel (comando ESC/POS de corte).
  Future<void> cortarPapel() async {
    try {
      // Comando ESC/POS: corta el papel después de imprimir
      const cutCommand = '\n\n\n\n\x1D\x56\x00';
      await PrintBluetoothThermal.writeBytes(cutCommand.codeUnits);
    } catch (e) {
      _logger.w('Error cortando papel: $e');
    }
  }
}

final printerServiceProvider = Provider<PrinterService>((ref) {
  return PrinterService();
});

/// Estado de conexión de la impresora (para UI reactiva).
final printerConnectionProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(printerServiceProvider);
  return await service.estaConectada();
});
