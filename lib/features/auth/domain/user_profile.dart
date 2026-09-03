/// Perfil del usuario actual (leído de usuarios/{uid} del Firebase del cliente)
class UserProfile {
  final String uid;
  final String correo;
  final String nombre;
  final String rol; // 'admin' | 'cajero'
  final bool activo;

  const UserProfile({
    required this.uid,
    required this.correo,
    required this.nombre,
    required this.rol,
    required this.activo,
  });

  bool get esAdmin => rol == 'admin';
  bool get esCajero => rol == 'cajero';

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      correo: data['correo'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      rol: data['rol'] as String? ?? 'cajero',
      activo: data['activo'] as bool? ?? false,
    );
  }
}