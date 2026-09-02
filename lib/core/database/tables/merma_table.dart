import 'package:drift/drift.dart';

/// Registro de merma (vencidos, dañados, robos). Solo admin.
class Merma extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get productoId => integer()();

  /// Snapshot para el reporte aunque el producto se elimine.
  TextColumn get productoNombre => text()();
  RealColumn get cantidad => real()();

  /// und / kg / g / lb (heredado del producto).
  TextColumn get unidad => text()();

  /// vencido | danado | robo | otro
  TextColumn get motivo => text()();
  TextColumn get nota => text().nullable()();

  /// Pérdida en $ (costoUsd × cantidad) al momento de registrar.
  RealColumn get costoUsd => real().withDefault(const Constant(0))();

  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fecha => integer()();
}
