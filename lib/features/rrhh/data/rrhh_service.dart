import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_cuaderno_de_mario/core/services/client_firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../core/services/client_firebase.dart';
import '../../auditoria/data/auditoria_service.dart';
import '../../auditoria/domain/auditoria_acciones.dart';

/// Usuario de la app (leído de usuarios/ del Firestore del cliente).
class UsuarioApp {
  final String uid;
  final String correo;
  final String nombre;
  final String rol;
  final bool activo;

  const UsuarioApp({
    required this.uid,
    required this.correo,
    required this.nombre,
    required this.rol,
    required this.activo,
  });

  bool get esAdmin => rol == 'admin';

  factory UsuarioApp.fromFirestore(String uid, Map<String, dynamic> data) =>
      UsuarioApp(
        uid: uid,
        correo: data['correo'] as String? ?? '',
        nombre: data['nombre'] as String? ?? '',
        rol: data['rol'] as String? ?? 'cajero',
        activo: data['activo'] as bool? ?? false,
      );
}

/// Lista en vivo de usuarios del cliente.
final usuariosProvider = StreamProvider<List<UsuarioApp>>((ref) {
  final clientFb = ref.watch(clientFirebaseProvider);
  if (!clientFb.isInitialized) return Stream.value(const []);

  return clientFb.firestore.collection('usuarios').snapshots().map(
        (snap) => snap.docs
            .map((d) => UsuarioApp.fromFirestore(d.id, d.data()))
            .toList(),
      );
});

/// Gestión de equipo: crear cajeros sin cerrar la sesión del admin,
/// activar/desactivar y cambiar roles.
class RrhhService {
  RrhhService(this._ref);

  final Ref _ref;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Crea el usuario en Auth (app secundaria) + documento en usuarios/.
  /// Retorna null si OK, o el mensaje de error.
  Future<String?> crearCajero({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    FirebaseApp? secundaria;
    User? nuevoUsuario;

    try {
      // App secundaria: crea el usuario SIN tocar la sesión del admin
      final clientApp = Firebase.apps.firstWhere((a) => a.name != '[DEFAULT]');
      secundaria = await Firebase.initializeApp(
        name: 'rrhh_${DateTime.now().millisecondsSinceEpoch}',
        options: clientApp.options,
      );

      final auth = FirebaseAuth.instanceFor(app: secundaria);
      final cred = await auth.createUserWithEmailAndPassword(
        email: correo.trim().toLowerCase(),
        password: password,
      );

      nuevoUsuario = cred.user;
      final uid = nuevoUsuario!.uid;

      // Perfil escrito con la sesión del admin
      final clientFb = ClientFirebase();
      await clientFb.firestore.collection('usuarios').doc(uid).set({
        'correo': correo.trim().toLowerCase(),
        'nombre': nombre.trim(),
        'rol': 'cajero',
        'activo': true,
        'fechaCreacion': FieldValue.serverTimestamp(),
      });

      // Éxito: cerrar sesión secundaria y liberar la app
      await auth.signOut();
      await secundaria.delete();
      secundaria = null;

      _logger.i('👥 Cajero creado: $correo');

      // Movimiento crítico: registrar creación de usuario
      await _ref.read(auditoriaServiceProvider).registrar(
            AccionesAuditoria.usuarioModificado,
            detalles: 'Usuario creado: $nombre ($correo), rol: cajero',
          );

      return null;
    } on FirebaseAuthException catch (e) {
      _logger.e('❌ FirebaseAuthException creando cajero: ${e.code}');
      switch (e.code) {
        case 'email-already-in-use':
          return 'Ese correo ya está registrado';
        case 'weak-password':
          return 'Contraseña débil (mínimo 8 caracteres, letra y número)';
        case 'invalid-email':
          return 'Correo inválido';
        default:
          return 'Error de autenticación: ${e.code}';
      }
    } catch (e) {
      // Usuario huérfano: Auth se creó pero el perfil falló -> limpiar
      _logger.e('❌ Error creando perfil del cajero: $e');
      try {
        await nuevoUsuario?.delete();
        _logger.w('🧹 Usuario de Auth eliminado por limpieza');
      } catch (_) {}
      return 'Error al crear el cajero. Intenta de nuevo.';
    } finally {
      if (secundaria != null) {
        try {
          await secundaria.delete();
        } catch (_) {}
      }
    }
  }

  Future<void> setActivo(String uid, bool activo,
      {String nombreUsuario = ''}) async {
    final clientFb = ClientFirebase();
    await clientFb.firestore
        .collection('usuarios')
        .doc(uid)
        .update({'activo': activo});

    // Movimiento crítico: registrar cambio de estado
    await _ref.read(auditoriaServiceProvider).registrar(
          AccionesAuditoria.usuarioModificado,
          detalles:
              '${nombreUsuario.isEmpty ? uid : nombreUsuario}: cuenta ${activo ? 'activada' : 'desactivada'}',
        );
  }

  Future<void> setRol(String uid, String rol,
      {String nombreUsuario = ''}) async {
    final clientFb = ClientFirebase();
    await clientFb.firestore.collection('usuarios').doc(uid).update({
      'rol': rol,
    });

    // Movimiento crítico: registrar cambio de rol
    await _ref.read(auditoriaServiceProvider).registrar(
          AccionesAuditoria.usuarioModificado,
          detalles:
              '${nombreUsuario.isEmpty ? uid : nombreUsuario}: rol cambiado a $rol',
        );
  }
}

final rrhhServiceProvider = Provider<RrhhService>((ref) => RrhhService(ref));
