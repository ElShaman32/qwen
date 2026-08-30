import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper sobre SharedPreferences para claves de la app.
/// No usa Riverpod porque es utilitario y síncrono después del init.
class PreferencesService {
  static const _keyYaActivado = 'ya_activado';
  static const _keyCorreoUsuario = 'correo_usuario';
  static const _keyTimestampUltimaVerificacion =
      'timestamp_ultima_verificacion';

  PreferencesService._();

  static SharedPreferences? _prefs;

  /// Llamar UNA VEZ en main() antes de runApp().
  static Future<void> inicializar() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError(
          'PreferencesService no inicializado. Llama inicializar() en main().');
    }
    return _prefs!;
  }

  // --- Activación ---
  bool get yaActivado => _instance.getBool(_keyYaActivado) ?? false;
  Future<void> setYaActivado(bool value) =>
      _instance.setBool(_keyYaActivado, value);

  // --- Usuario ---
  String? get correoUsuario => _instance.getString(_keyCorreoUsuario);
  Future<void> setCorreoUsuario(String correo) =>
      _instance.setString(_keyCorreoUsuario, correo);
  Future<void> limpiarCorreoUsuario() => _instance.remove(_keyCorreoUsuario);

  // --- Kill switch ---
  int get timestampUltimaVerificacion =>
      _instance.getInt(_keyTimestampUltimaVerificacion) ?? 0;

  Future<void> setTimestampUltimaVerificacion(DateTime fecha) => _instance
      .setInt(_keyTimestampUltimaVerificacion, fecha.millisecondsSinceEpoch);

  /// True si pasaron más de 7 días sin verificar con el servidor.
  bool get debeBloquearPorOffline {
    final timestamp = timestampUltimaVerificacion;
    if (timestamp == 0) return false; // Primera vez, no bloquear
    final dias = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(timestamp))
        .inDays;
    return dias > 7;
  }

  /// Limpia todo (logout completo + desactivación).
  Future<void> limpiarTodo() async {
    await _instance.clear();
  }

  static PreferencesService get instance => PreferencesService._();
}
