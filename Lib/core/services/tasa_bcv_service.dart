import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Descarga la tasa BCV desde fuentes públicas con fallback.
/// Si una fuente falla, prueba la siguiente.
class TasaBcvService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static const _timeout = Duration(seconds: 8);

  /// Retorna la tasa o null si TODAS las fuentes fallan.
  Future<double?> obtenerTasaBCV() async {
    final fuentes = <String, Future<double?> Function()>{
      'dolarapi': _fuenteDolarApi,
      'pydolarve': _fuentePyDolarVe,
    };

    for (final entry in fuentes.entries) {
      try {
        final tasa = await entry.value();
        if (tasa != null && tasa > 0) {
          _logger.i('📡 Tasa BCV de ${entry.key}: $tasa');
          return tasa;
        }
      } catch (e) {
        _logger.w('⚠️ Fuente ${entry.key} falló: $e');
      }
    }
    _logger.e('❌ Ninguna fuente de tasa BCV respondió');
    return null;
  }

  Future<double?> _fuenteDolarApi() async {
    final r = await http
        .get(Uri.parse('https://ve.dolarapi.com/v1/dolares/oficial'))
        .timeout(_timeout);
    if (r.statusCode != 200) return null;
    final json = jsonDecode(r.body) as Map<String, dynamic>;
    return (json['promedio'] as num?)?.toDouble();
  }

  Future<double?> _fuentePyDolarVe() async {
    final r = await http
        .get(Uri.parse('https://pydolarve.org/api/v1/dollar?monitor=bcv'))
        .timeout(_timeout);
    if (r.statusCode != 200) return null;
    final json = jsonDecode(r.body) as Map<String, dynamic>;
    return (json['monitors']?['bcv']?['price'] as num?)?.toDouble();
  }
}

final tasaBcvServiceProvider =
    Provider<TasaBcvService>((ref) => TasaBcvService());
