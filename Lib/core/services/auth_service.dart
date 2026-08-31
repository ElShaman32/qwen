import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'client_firebase.dart';

/// Servicio de autenticación (logout).
/// El login se maneja en LoginScreen/RegistroAdminScreen.
class AuthService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Cierra la sesión del usuario actual.
  /// NO disposea ClientFirebase (el negocio sigue activado en el dispositivo).
  Future<void> logout() async {
    try {
      final clientFb = ClientFirebase();
      if (clientFb.isInitialized) {
        await clientFb.auth.signOut();
        _logger.i('👋 Sesión cerrada correctamente');
      }
    } catch (e) {
      _logger.e('❌ Error cerrando sesión: $e');
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());