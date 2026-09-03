import 'package:shared_preferences/shared_preferences.dart';
import '../data/frase_repository.dart';

/// Servicio que decide si mostrar la frase del día.
/// Regla: primera apertura del día DESPUÉS de las 7:00 AM.
class FraseDiaService {
  static const String _keyUltimaFrase = 'ultima_frase_mostrada_epoch';
  static const int _horaActivacion = 7; // 7:00 AM

  final FraseRepository _repo;

  FraseDiaService(this._repo);

  /// Retorna una frase si debe mostrarse, null si no.
  /// Debe llamarse una sola vez por arranque.
  Future<Frase?> obtenerFraseSiCorresponde() async {
    final prefs = await SharedPreferences.getInstance();
    final ahora = DateTime.now();

    // Si aún no son las 7am, no mostrar nada
    if (ahora.hour < _horaActivacion) return null;

    final ultimaEpoch = prefs.getInt(_keyUltimaFrase) ?? 0;
    final ultima = DateTime.fromMillisecondsSinceEpoch(ultimaEpoch);

    // Si ya se mostró hoy, no repetir
    if (_esMismoDia(ultima, ahora)) return null;

    // Marcar como mostrada ANTES de descargar (evita doble disparo)
    await prefs.setInt(_keyUltimaFrase, ahora.millisecondsSinceEpoch);

    return _repo.obtenerFraseDelDia();
  }

  bool _esMismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
