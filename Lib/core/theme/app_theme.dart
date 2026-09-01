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

      // AppBar consistente con branding
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // Botones con bordes redondeados modernos
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // Cards con estilo limpio
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
      ),

      // Inputs con bordes suaves
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // BottomNavigationBar adaptativo
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSecondaryContainer);
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
