import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Datos de la impresora térmica seleccionada por el admin.
class PrinterConfig {
  final String macAddress;
  final String nombre;

  const PrinterConfig({
    required this.macAddress,
    required this.nombre,
  });

  Map<String, dynamic> toJson() => {
        'macAddress': macAddress,
        'nombre': nombre,
      };

  factory PrinterConfig.fromJson(Map<String, dynamic> json) => PrinterConfig(
        macAddress: json['macAddress'] as String,
        nombre: json['nombre'] as String,
      );
}

/// Servicio de persistencia para la impresora seleccionada.
/// Usa SharedPreferences (mismo patrón que SessionService).
class PrinterConfigService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static const _keyConfig = 'printer_config';

  /// Guarda la impresora seleccionada.
  Future<void> guardarImpresora(PrinterConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyConfig, config.toJson().toString());
      _logger
          .i('💾 Impresora guardada: ${config.nombre} (${config.macAddress})');
    } catch (e) {
      _logger.e('Error guardando impresora: $e');
    }
  }

  /// Carga la impresora guardada. Retorna null si no hay configuración.
  Future<PrinterConfig?> cargarImpresora() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyConfig);
      if (jsonStr == null) return null;

      // Parse simple (no usamos jsonDecode porque toJson() usa toString())
      final macMatch = RegExp(r"'macAddress': '([^']+)'").firstMatch(jsonStr);
      final nombreMatch = RegExp(r"'nombre': '([^']+)'").firstMatch(jsonStr);

      if (macMatch == null || nombreMatch == null) return null;

      return PrinterConfig(
        macAddress: macMatch.group(1)!,
        nombre: nombreMatch.group(1)!,
      );
    } catch (e) {
      _logger.e('Error cargando impresora: $e');
      return null;
    }
  }

  /// Limpia la configuración de impresora.
  Future<void> limpiarImpresora() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyConfig);
      _logger.i('🗑️ Configuración de impresora limpiada');
    } catch (e) {
      _logger.e('Error limpiando impresora: $e');
    }
  }
}

final printerConfigServiceProvider = Provider<PrinterConfigService>((ref) {
  return PrinterConfigService();
});

/// Provider reactivo de la impresora configurada.
final printerConfigProvider = FutureProvider<PrinterConfig?>((ref) async {
  final service = ref.watch(printerConfigServiceProvider);
  return await service.cargarImpresora();
});
