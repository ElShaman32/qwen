/// Validaciones centralizadas de formularios.
/// Todo formulario de auth DEBE usar estas funciones.
abstract class Validaciones {
  /// Valida correo electrónico (formato básico).
  static String? correo(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ingresa el correo';
    if (!value.contains('@') || !value.contains('.')) {
      return 'Correo inválido';
    }
    return null;
  }

  /// Valida contraseña para CREAR cuenta (registro admin / cambio de clave).
  /// Política: 8+ chars, 1 letra, 1 número. Sin símbolos obligatorios.
  static String? passwordCreacion(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa una contraseña';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!value.contains(RegExp(r'[a-zA-Z]'))) return 'Debe tener al menos una letra';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Debe tener al menos un número';
    return null;
  }

  /// Valida contraseña para INICIAR SESIÓN (solo que no esté vacía).
  /// No aplicamos política aquí: el usuario ya tiene su clave creada.
  static String? passwordLogin(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
    return null;
  }

  /// Mide fuerza de contraseña (para mostrar indicador visual opcional).
  static bool esPasswordFuerte(String value) {
    return value.length >= 10 &&
        value.contains(RegExp(r'[A-Z]')) &&
        value.contains(RegExp(r'[0-9]')) &&
        value.contains(RegExp(r'[^a-zA-Z0-9]'));
  }
}