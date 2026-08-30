import 'package:flutter/services.dart';

/// Capitaliza la primera letra de cada palabra (nombres y apellidos).
/// El resto va en minúscula automáticamente.
class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    var capitalizar = true;
    for (final char in text.split('')) {
      if (char == ' ') {
        capitalizar = true;
        buffer.write(char);
      } else if (capitalizar) {
        buffer.write(char.toUpperCase());
        capitalizar = false;
      } else {
        buffer.write(char.toLowerCase());
      }
    }

    final formatted = buffer.toString();
    // La longitud no cambia, la selección se mantiene
    return newValue.copyWith(text: formatted, selection: newValue.selection);
  }
}

/// Formatea cédula venezolana automáticamente:
/// - Si el usuario NO escribe J/G/E, asume V- y coloca puntos de miles.
/// - Si escribe J, G o E (jurídico/extranjero), deja la entrada manual.
class CedulaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final first = text[0].toUpperCase();

    // Jurídico o extranjero: entrada manual, sin formato
    if (first == 'J' || first == 'G' || first == 'E') {
      return newValue;
    }

    // Extraer dígitos (después de posible prefijo V)
    final resto = (first == 'V') ? text.substring(1) : text;
    var digits = resto.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 10) digits = digits.substring(0, 10);

    final formatted = 'V-${_conPuntos(digits)}';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Agrupa de derecha a izquierda con puntos: 4334567 -> 4.334.567
  String _conPuntos(String digits) {
    if (digits.length <= 3) return digits;
    final reversed = digits.split('').reversed.join('');
    final parts = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      final end = i + 3 > reversed.length ? reversed.length : i + 3;
      parts.add(reversed.substring(i, end));
    }
    return parts.join('.').split('').reversed.join('');
  }
}
