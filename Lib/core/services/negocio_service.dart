import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Estado del negocio tras la verificación en el Maestro.
enum EstadoNegocio {
  noExiste,
  inactivo,
  activoSinAdmin,
  activoConAdmin,
}

/// Datos del negocio obtenidos del Firebase Maestro.
class NegocioInfo {
  final String nombre;
  final String rif;
  final String plan;
  final bool activa;
  final String correoNegocio;
  final Map<String, dynamic> credencialesFirebase;
  final int fechaVencimientoEpoch;

  const NegocioInfo({
    required this.nombre,
    required this.rif,
    required this.plan,
    required this.activa,
    required this.correoNegocio,
    required this.credencialesFirebase,
    required this.fechaVencimientoEpoch,
  });
}

final negocioServiceProvider = Provider<NegocioService>((ref) {
  return NegocioService(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

/// Servicio para consultar negocios en Firebase MAESTRO.
///
/// EXCEPCIÓN DOCUMENTADA: usa FirebaseFirestore.instance y
/// FirebaseAuth.instance porque opera sobre el Firebase Maestro (default app).
/// La prohibición de .instance aplica SOLO al Firebase del Cliente.
class NegocioService {
  final FirebaseFirestore _firestoreMaestro;
  final FirebaseAuth _authMaestro;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  NegocioService(this._firestoreMaestro, this._authMaestro);

  /// Autentica contra el Maestro con correo+contraseña del negocio y busca
  /// el documento por ID (el ID es el correo).
  ///
  /// Retorna null si las credenciales son inválidas o el negocio no existe.
  Future<NegocioInfo?> buscarPorCorreo({
    required String correoNegocio,
    required String contrasena,
  }) async {
    final correoNormalizado = correoNegocio.trim().toLowerCase();

    try {
      // 1. Autenticar contra el Maestro (excepción documentada)
      final cred = await _authMaestro.signInWithEmailAndPassword(
        email: correoNormalizado,
        password: contrasena,
      );
      final uid = cred.user!.uid;

      // 2. Get directo por ID (el ID es el correo)
      final doc = await _firestoreMaestro
          .collection('negocios')
          .doc(correoNormalizado)
          .get();

      if (!doc.exists) {
        await _authMaestro.signOut();
        _logger.i('🔍 Documento de negocio no encontrado: $correoNormalizado');
        return null;
      }

      final data = doc.data()!;

      // 3. Verificar que auth_uid coincida (defensa en profundidad)
      final authUid = data['auth_uid'] as String?;
      if (authUid != uid) {
        await _authMaestro.signOut();
        _logger.w('⚠️ auth_uid no coincide para $correoNormalizado');
        return null;
      }

      // 4. Leer credenciales de la subcolección
      //    🔴 IMPORTANTE: esto DEBE ser ANTES del signOut
      final credDoc =
          await doc.reference.collection('credenciales').doc('firebase').get();

      final credenciales =
          credDoc.exists ? credDoc.data()! : <String, dynamic>{};

      // 5. 🔴 Sign out AHORA, después de leer TODO lo necesario
      await _authMaestro.signOut();

      // Parsear fecha_vencimiento (Timestamp -> epoch ms)
      int fechaVencimientoEpoch = 0;
      final fechaRaw = data['fecha_vencimiento'];
      if (fechaRaw is Timestamp) {
        fechaVencimientoEpoch = fechaRaw.millisecondsSinceEpoch;
      }

      return NegocioInfo(
        nombre: data['nombre'] as String? ?? '',
        rif: data['rif'] as String? ?? '',
        plan: data['plan'] as String? ?? 'cuaderno',
        activa: data['activa'] as bool? ?? false,
        correoNegocio: data['correo_negocio'] as String? ?? correoNormalizado,
        credencialesFirebase: credenciales,
        fechaVencimientoEpoch: fechaVencimientoEpoch,
      );
    } on FirebaseAuthException catch (e) {
      await _authMaestro.signOut();
      if (e.code == 'invalid-credential' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        _logger.i('🔍 Credenciales inválidas para: $correoNormalizado');
        return null;
      }
      _logger.e('❌ FirebaseAuthException buscando negocio: ${e.code}');
      rethrow;
    } catch (e) {
      await _authMaestro.signOut();
      _logger.e('❌ Error buscando negocio: $e');
      rethrow;
    }
  }
}
