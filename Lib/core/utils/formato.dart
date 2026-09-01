import 'package:intl/intl.dart';

/// Utilidades de formato venezolano centralizadas.
/// PROHIBIDO usar toStringAsFixed() directamente en la UI.
/// Todo monto, fecha o porcentaje DEBE pasar por aquí.
class Formato {
  Formato._();

  // Formateadores cacheados para rendimiento
  static final _bsFormat = NumberFormat('#,##0.00', 'es_VE');
  static final _usdFormat = NumberFormat('#,##0.00', 'en_US');
  static final _numeroFormat = NumberFormat('#,##0.##', 'es_VE');
  static final _porcentajeFormat = NumberFormat('#%', 'es_VE');
  static final _fechaFormat = DateFormat('dd/MM/yyyy', 'es_VE');
  static final _fechaHoraFormat = DateFormat('dd/MM/yyyy hh:mm a', 'es_VE');

  /// Bs 1.234,56
  static String bs(double monto) => 'Bs ${_bsFormat.format(monto)}';

  /// $1,234.56
  static String usd(double monto) => '\$${_usdFormat.format(monto)}';

  /// 1.234,56 (sin símbolo)
  static String numero(double valor, {int decimales = 2}) {
    if (decimales == 2) return _numeroFormat.format(valor);
    return NumberFormat('#,##0.${"#" * decimales}', 'es_VE').format(valor);
  }

  /// 16%
  static String porcentaje(double tasa) => _porcentajeFormat.format(tasa);

  /// dd/mm/yyyy
  static String fecha(DateTime dt) => _fechaFormat.format(dt);

  /// dd/mm/yyyy hh:mm AM/PM
  static String fechaHora(DateTime dt) => _fechaHoraFormat.format(dt);

  /// Peso para productos a granel: "0.250 kg"
  static String peso(double cantidad, String unidad) {
    final fmt = NumberFormat('#,##0.###', 'es_VE');
    return '${fmt.format(cantidad)} $unidad';
  }

  /// Teléfono venezolano: 0412-1234567
  static String telefono(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11) {
      return '${digits.substring(0, 4)}-${digits.substring(4)}';
    }
    return raw; // Retornar original si no tiene formato esperado
  }

  /// Cédula: V-12.345.678 o E-87.654.321
  static String cedula(String raw) {
    final cleaned = raw.trim().toUpperCase();
    final match = RegExp(r'^([VEJGCP])[-.\s]?(\d+)$').firstMatch(cleaned);
    if (match != null) {
      final letra = match.group(1)!;
      final nums = match.group(2)!;
      final fmt = NumberFormat('#,##0', 'es_VE');
      return '$letra-${fmt.format(int.tryParse(nums) ?? 0)}';
    }
    return raw;
  }
}
