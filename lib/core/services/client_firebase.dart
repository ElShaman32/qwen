import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Servicio singleton para manejar la instancia del Firebase del CLIENTE.
/// PROHIBIDO usar FirebaseFirestore.instance o FirebaseAuth.instance en el resto del código.
class ClientFirebase {
  ClientFirebase._();
  static final ClientFirebase _instance = ClientFirebase._();
  factory ClientFirebase() => _instance;

  FirebaseApp? _clientApp;
  bool _isInitialized = false;

  /// Inicializa el segundo Firebase con las credenciales del cliente.
  /// Debe llamarse DESPUÉS de obtener las credenciales del Firebase Maestro.
  Future<void> initialize({
    required String name,
    required FirebaseOptions options,
  }) async {
    if (_isInitialized) return;

    try {
      // Verificar si ya existe una app con este nombre (hot reload / reactivación)
      final existingApps = Firebase.apps;
      final existingApp = existingApps.where((app) => app.name == name).firstOrNull;

      if (existingApp != null) {
        _clientApp = existingApp;
      } else {
        _clientApp = await Firebase.initializeApp(
          name: name,
          options: options,
        );
      }

      _isInitialized = true;
      debugPrint('✅ [ClientFirebase] Inicializado correctamente: $name');
    } catch (e) {
      debugPrint('❌ [ClientFirebase] Error al inicializar: $e');
      rethrow;
    }
  }

  /// Instancia de Firestore del cliente.
  FirebaseFirestore get firestore {
    _ensureInitialized();
    return FirebaseFirestore.instanceFor(app: _clientApp!);
  }

  /// Instancia de Auth del cliente.
  FirebaseAuth get auth {
    _ensureInitialized();
    return FirebaseAuth.instanceFor(app: _clientApp!);
  }

  /// Verifica si el servicio está listo para usarse.
  bool get isInitialized => _isInitialized;

  void _ensureInitialized() {
    if (!_isInitialized || _clientApp == null) {
      throw StateError(
        'ClientFirebase no ha sido inicializado. '
        'Llama a ClientFirebase().initialize() primero.',
      );
    }
  }

  /// Limpia la instancia (útil para logout o cambio de negocio).
  Future<void> dispose() async {
    if (_clientApp != null) {
      await _clientApp!.delete();
      _clientApp = null;
      _isInitialized = false;
      debugPrint('🗑️ [ClientFirebase] Instancia eliminada.');
    }
  }
}