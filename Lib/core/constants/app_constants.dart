/// Constantes globales de la app.
abstract class AppConstants {
  /// Intervalo de re-verificación de suscripción contra el Maestro.
  /// Cambiar este valor ajusta la frecuencia globalmente.
  /// Ej: 24 -> cada día, 12 -> cada medio día, 72 -> cada 3 días.
  static const int reverificacionHoras = 72;
}
