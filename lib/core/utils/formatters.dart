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

    if (first == 'J' || first == 'G' || first == 'E') {
      return newValue;
    }

    final resto = (first == 'V') ? text.substring(1) : text;
    var digits = resto.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 10) digits = digits.substring(0, 10);

    final formatted = 'V-${_conPuntos(digits)}';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

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

/// Formatea teléfono venezolano: 04121234567 → 0412-1234567
/// Máximo 11 dígitos. Formato: 4 dígitos operador + 7 dígitos número.
/// Solo dígitos; cualquier otra tecla se ignora.
class TelefonoFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    var digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    String formatted;
    if (digits.length <= 4) {
      formatted = digits;
    } else {
      formatted = '${digits.substring(0, 4)}-${digits.substring(4)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatea montos en vivo al estilo venezolano: 1500 → 1.500
/// Acepta coma o punto como separador decimal.
/// Máximo 2 decimales. Preserva posición del cursor.
/// Úsalo en precios, costos, stock, límites de crédito, etc.
class MoneyInputFormatter extends TextInputFormatter {
  MoneyInputFormatter({this.decimales = 2, this.maxDigitosEnteros = 10});

  final int decimales;
  final int maxDigitosEnteros;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // Normalizar: aceptar tanto coma como punto como separador decimal
    var raw = newValue.text.replaceAll(',', '.');

    // Solo dígitos y un punto decimal
    raw = raw.replaceAll(RegExp(r'[^0-9\.]'), '');

    // Evitar múltiples puntos decimales: solo el primero cuenta
    final primerPunto = raw.indexOf('.');
    if (primerPunto != -1) {
      final entero = raw.substring(0, primerPunto);
      final fraccion = raw.substring(primerPunto + 1).replaceAll('.', '');
      raw =
          '$entero.${fraccion.substring(0, fraccion.length > decimales ? decimales : fraccion.length)}';
    }

    // Separar entero y fracción
    final partes = raw.split('.');
    var entero = partes[0].replaceAll(RegExp(r'^0+(?=\d)'), '');
    if (entero.isEmpty) entero = '0';
    if (entero.length > maxDigitosEnteros) {
      entero = entero.substring(0, maxDigitosEnteros);
    }

    final parteDecimal = partes.length > 1 ? partes[1] : '';

    // Formatear con puntos de miles (estilo venezolano)
    final enteroFormateado = _conPuntosMiles(entero);

    String formatted;
    if (newValue.text.contains(',') || newValue.text.endsWith('.')) {
      // Si el usuario escribió coma o punto, mostrar la parte decimal
      formatted =
          '$enteroFormateado${raw.contains('.') ? ',' : ''}$parteDecimal';
    } else if (raw.contains('.')) {
      formatted = '$enteroFormateado,$parteDecimal';
    } else {
      formatted = enteroFormateado;
    }

    // Calcular nueva posición del cursor preservando caracteres desde el final
    final charsDesdeFinOld = oldValue.text.length - oldValue.selection.end;
    final newOffset = formatted.length - charsDesdeFinOld;
    final offsetClamped = newOffset.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offsetClamped),
    );
  }

  String _conPuntosMiles(String digits) {
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
