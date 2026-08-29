import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../core/services/client_firebase.dart';

/// Escritura de configuración en el Firestore del cliente.
class ConfigService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Actualiza campos de configuracion/generales.
  Future<void> guardarCampos(Map<String, dynamic> campos) async {
    final clientFb = ClientFirebase();
    await clientFb.firestore
        .collection('configuracion')
        .doc('generales')
        .update(campos);
    _logger.i('💾 Config actualizada: ${campos.keys.join(', ')}');
  }

  /// Guarda (merge) un método de pago en metodos_pago/{id}.
  Future<void> guardarMetodo(String id, Map<String, dynamic> campos) async {
    final clientFb = ClientFirebase();
    await clientFb.firestore
        .collection('metodos_pago')
        .doc(id)
        .set(campos, SetOptions(merge: true));
    _logger.i('💳 Método de pago actualizado: $id');
  }

  /// Registra el cambio de tasa en historial_tasas/ (Firestore del cliente).
  Future<void> registrarHistorialTasa(double tasa, String fuente) async {
    try {
      final clientFb = ClientFirebase();
      await clientFb.firestore.collection('historial_tasas').add({
        'tasa': tasa,
        'fuente': fuente, // 'bcv_api' | 'manual'
        'fecha': FieldValue.serverTimestamp(),
      });
      _logger.i('📈 Histórico de tasa registrado: $tasa ($fuente)');
    } catch (e) {
      // No bloquear si falla el histórico
      _logger.e('❌ Error guardando histórico de tasa: $e');
    }
  }
}

final configServiceProvider = Provider<ConfigService>((ref) => ConfigService());
