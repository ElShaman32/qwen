import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

/// Repositorio para guardar leads del modo demo en Firebase Maestro.
/// Colección: leads/
class LeadRepository {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Guarda un lead en Firebase Maestro.
  /// Retorna true si se guardó exitosamente.
  Future<bool> guardarLead({
    required String nombreBodega,
    required String contacto,
    required String telefono,
    required String ciudad,
    String? planInteres,
    String? notas,
  }) async {
    try {
      final ahora = DateTime.now();
      await FirebaseFirestore.instance.collection('leads').add({
        'nombre_bodega': nombreBodega.trim(),
        'contacto': contacto.trim(),
        'telefono': telefono.trim(),
        'ciudad': ciudad.trim(),
        'plan_interes': planInteres?.trim() ?? '',
        'notas': notas?.trim() ?? '',
        'timestamp': Timestamp.fromDate(ahora),
        'fuente': 'demo_app',
        'version_app': '1.0.0', // TODO: obtener de package_info_plus
      });

      _logger.i('✅ Lead guardado en Firebase Maestro: $nombreBodega');
      return true;
    } catch (e, s) {
      _logger.e('❌ Error guardando lead: $e', stackTrace: s);
      return false;
    }
  }

  /// Genera un número de cola aleatorio (35-150) para dar sensación de demanda.
  int generarNumeroCola() {
    final random = 35 + (DateTime.now().millisecondsSinceEpoch % 116);
    return random;
  }
}
