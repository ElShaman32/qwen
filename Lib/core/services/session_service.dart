import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Credenciales del Firebase del cliente, persistidas para restaurar sesion.
class CredencialesCliente {
  final String nombreApp;
  final FirebaseOptions opciones;
  const CredencialesCliente({required this.nombreApp, required this.opciones});
}

/// Persiste las credenciales del Firebase del cliente para que, al reiniciar
/// la app, podamos re-inicializar ClientFirebase y Firebase Auth restaure la sesion.
/// Sin esto, la sesion se pierde en cada arranque.
class SessionService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static const _keyNombreApp = 'client_app_name';
  static const _keyOpciones = 'client_firebase_options';

  /// Guarda las credenciales despues de una activacion exitosa.
  Future<void> guardarCredencialesCliente({
    required String nombreApp,
    required FirebaseOptions opciones,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final opcionesJson = jsonEncode({
        'apiKey': opciones.apiKey,
        'appId': opciones.appId,
        'projectId': opciones.projectId,
        'messagingSenderId': opciones.messagingSenderId,
        'storageBucket': opciones.storageBucket,
      });
      await prefs.setString(_keyNombreApp, nombreApp);
      await prefs.setString(_keyOpciones, opcionesJson);
      _logger.i('💾 Credenciales del cliente persistidas');
    } catch (e) {
      _logger.e('❌ Error persistiendo credenciales del cliente: $e');
    }
  }

  /// Restaura las credenciales guardadas. Retorna null si no hay sesion previa.
  Future<CredencialesCliente?> cargarCredencialesCliente() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nombreApp = prefs.getString(_keyNombreApp);
      final opcionesJson = prefs.getString(_keyOpciones);
      if (nombreApp == null || opcionesJson == null) return null;

      final map = jsonDecode(opcionesJson) as Map<String, dynamic>;
      final opciones = FirebaseOptions(
        apiKey: map['apiKey'] as String,
        appId: map['appId'] as String,
        projectId: map['projectId'] as String,
        messagingSenderId: map['messagingSenderId'] as String,
        storageBucket: map['storageBucket'] as String?,
      );
      return CredencialesCliente(nombreApp: nombreApp, opciones: opciones);
    } catch (e) {
      _logger.e('❌ Error cargando credenciales del cliente: $e');
      return null;
    }
  }

  /// Limpia credenciales (logout o cambio de negocio).
  Future<void> limpiarCredencialesCliente() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNombreApp);
    await prefs.remove(_keyOpciones);
  }
}

final sessionServiceProvider = Provider<SessionService>((ref) => SessionService());