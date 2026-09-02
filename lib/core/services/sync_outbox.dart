import 'dart:convert';

import '../database/app_database.dart';
import 'dart:async';

/// Aviso de que hay operaciones nuevas en la cola.
/// El SyncScheduler lo escucha para hacer flush inmediato.
final StreamController<void> syncOutboxEvents = StreamController.broadcast();

/// Patrón Transactional Outbox.
///
/// Se llama DENTRO de la transacción Drift de la escritura de negocio,
/// así la operación de sync queda garantizada atómicamente:
/// si la venta/caja/producto se guardó, su subida a Firestore queda en cola.
///
/// Uso desde cualquier DAO (dentro de su _db.transaction):
///   await encolarSync(_db, coleccion: 'ventas', docId: uuid, payload: {...});
Future<void> encolarSync(
  AppDatabase db, {
  required String coleccion,
  required String docId,
  required Map<String, dynamic> payload,
  String operacion = 'set',
}) async {
  await db.into(db.syncQueue).insert(SyncQueueCompanion.insert(
        coleccion: coleccion,
        docId: docId,
        operacion: operacion,
        payload: jsonEncode(payload),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
  if (!syncOutboxEvents.isClosed) syncOutboxEvents.add(null);
}

/// Payload completo de producto (lo usa el admin en CRUD de inventario).
Map<String, dynamic> payloadProducto(ProductoData p) => {
      'nombre': p.nombre,
      'codigo': p.codigo,
      'categoria': p.categoria,
      'precioUsd': p.precioUsd,
      'costoUsd': p.costoUsd,
      'precioMayor': p.precioMayor,
      'stock': p.stock,
      'exentoIva': p.exentoIva,
      'esGranel': p.esGranel,
      'unidadMedida': p.unidadMedida,
      'fechaVencimiento': p.fechaVencimiento,
      'stockMinimo': p.stockMinimo,
      'activo': p.activo,
      'fechaActualizacion': p.fechaActualizacion,
    };

/// Payload completo de cliente (saldo es fuente de verdad remota).
Map<String, dynamic> payloadCliente(ClienteData c) => {
      'nombre': c.nombre,
      'cedula': c.cedula,
      'telefono': c.telefono,
      'saldoPendienteUsd': c.saldoPendienteUsd,
      'limiteCreditoUsd': c.limiteCreditoUsd,
      'activo': c.activo,
      'fechaActualizacion': c.fechaActualizacion,
    };
