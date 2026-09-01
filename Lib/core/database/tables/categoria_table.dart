import 'package:drift/drift.dart';

/// Categorías de productos gestionables por el admin.
/// Orden determina posición en el POS (menor = primero).
class Categoria extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get nombre => text()();
  IntColumn get orden => integer()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}
