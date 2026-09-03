import 'package:flutter/material.dart';
import '../config/app_config_notifier.dart';

/// Generador de temas Material 3 dinámicos basados en la configuración whitelabel.
/// Los colores primario/secundario se leen del AppConfigState.
abstract class AppTheme {
  /// Genera ThemeData completo desde la configuración actual.
  /// Se llama cada vez que appConfigProvider cambia (hot reload de branding).
  static ThemeData fromConfig(AppConfigState config) {
    final primaryColor = _parseColor(
        config.colorPrimario, const Color.fromARGB(255, 80, 11, 112));
    final secondaryColor =
        _parseColor(config.colorSecundario, const Color.fromARGB(255, 0, 0, 0));

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Tipografía venezolana legible
      fontFamily: 'Roboto', // Cambiar a fuente custom si se desea

      // ✅ NUEVO: Sombras sutiles para profundidad
      shadowColor: Colors.black.withValues(alpha: 0.1),

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        surfaceTintColor: Colors.transparent, // ✅ Evita overlay raro
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // ✅ NUEVO: Padding mejorado
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // ✅ MEJORADO: Cards con sombras sutiles
      cardTheme: CardThemeData(
        elevation: 2, // ✅ Antes era 0
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
      ),

      // ✅ MEJORADO: Inputs con iconos y mejor feedback
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // ✅ NUEVO: Iconos de prefix con color sutil
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ✅ NUEVO: ListTile mejorado
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.secondaryContainer,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSecondaryContainer,
            );
          }
          return TextStyle(color: colorScheme.onSurfaceVariant);
        }),
      ),
    );
  }

  /// Parsea hex string (#RRGGBB) a Color con fallback seguro.
  static Color _parseColor(String hex, Color fallback) {
    try {
      final cleanHex = hex.replaceAll('#', '');
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      }
      if (cleanHex.length == 8) {
        return Color(int.parse(cleanHex, radix: 16));
      }
      return fallback;
    } catch (_) {
      return fallback;
    }
  }
}
