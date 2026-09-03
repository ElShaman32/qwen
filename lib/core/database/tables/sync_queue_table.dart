import 'package:drift/drift.dart';

/// Cola de operaciones pendientes de subir a Firestore (patrón outbox).
/// Cada fila se crea DENTRO de la misma transacción que la escritura
/// de negocio, y se borra cuando la subida a Firestore confirma éxito.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Colección destino: inventario, ventas, clientes, pagos_fiados,
  /// caja/aperturas, caja/cierres, caja/retiros, merma
  TextColumn get coleccion => text()();

  /// uuid del registro local (ID del documento en Firestore)
  TextColumn get docId => text()();

  /// set | update | delete
  TextColumn get operacion => text()();

  /// JSON con el payload a escribir en Firestore
  TextColumn get payload => text()();

  /// Epoch ms de cuándo se encoló (para procesar en orden)
  IntColumn get timestamp => integer()();

  /// Reintentos fallidos (para diagnóstico)
  IntColumn get intentos => integer().withDefault(const Constant(0))();
}
