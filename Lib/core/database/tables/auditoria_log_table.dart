import 'package:drift/drift.dart';

/// Registro transversal de auditoría.
/// Quién hizo qué y cuándo. Solo admin puede leer; cualquier usuario escribe.
/// Gate por plan Todos los Juguetes en el servicio.
class AuditoriaLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();

  /// Snapshot del usuario que hizo la acción (por si se elimina después).
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();

  /// Código de acción: venta_anulada, producto_creado, caja_apertura, etc.
  TextColumn get accion => text()();

  /// Detalles opcionales (ej: motivo de anulación, ID del producto).
  TextColumn get detalles => text().nullable()();

  /// Epoch en milisegundos (igual que Merma para consistencia).
  IntColumn get fecha => integer()();
}
