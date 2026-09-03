import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class DemoModeService {
  static const Duration demoDuration = Duration(hours: 24);
  static const String _demoStartKey = 'demo_start_timestamp';
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  Future<void> iniciarDemo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ahora = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_demoStartKey, ahora);
      _logger.i('✅ Modo demo iniciado: $ahora');
    } catch (e) {
      _logger.e('❌ Error al iniciar modo demo: $e');
    }
  }

  Future<bool> estaEnModoDemo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final inicio = prefs.getInt(_demoStartKey);
      return inicio != null && inicio > 0;
    } catch (e) {
      _logger.e('❌ Error al verificar modo demo: $e');
      return false;
    }
  }

  Future<Duration> tiempoRestante() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final inicio = prefs.getInt(_demoStartKey);
      if (inicio == null || inicio == 0) return Duration.zero;

      final ahora = DateTime.now().millisecondsSinceEpoch;
      final transcurrido = Duration(milliseconds: ahora - inicio);
      final restante = demoDuration - transcurrido;

      return restante.isNegative ? Duration.zero : restante;
    } catch (e) {
      _logger.e('❌ Error al calcular tiempo restante: $e');
      return Duration.zero;
    }
  }

  Future<void> finalizarDemo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_demoStartKey);
      _logger.i('🧹 Modo demo finalizado y limpiado');
    } catch (e) {
      _logger.e('❌ Error al finalizar modo demo: $e');
    }
  }

  Future<bool> demoVencido() async {
    final restante = await tiempoRestante();
    return restante == Duration.zero;
  }
}
