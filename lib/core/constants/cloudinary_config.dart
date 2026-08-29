/// Configuración de Cloudinary del desarrollador (SiReBAi).
/// Hardcodeada en el build: NO es dato del cliente.
///
/// SEGURIDAD: estas credenciales son públicas por naturaleza
/// (cualquier APK se descompila). La seguridad real está en
/// las RESTRICCIONES del upload preset en Cloudinary Console.
abstract class CloudinaryConfig {
  // TODO: reemplazar con tu cloud_name real
  static const cloudName = 'lsvim8pb';

  // Upload preset configurado en Cloudinary Console con estas restricciones:
  // - Signing Mode: Unsigned (requerido para upload desde cliente)
  // - Incoming transformation: limitar a imágenes (jpg, png, webp)
  // - Max file size: 2 MB
  // - Max resolution: 2000x2000 px
  // - Folder: logos/
  static const uploadPreset = 'logo_negocio';

  /// URL base para uploads
  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Construye URL pública de una imagen por su public_id
  static String urlDe(String publicId) =>
      'https://res.cloudinary.com/$cloudName/image/upload/$publicId';
}
