import 'package:drift/drift.dart';

/// Cliente de la bodega (para fiados y datos de venta).
class Cliente extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get nombre => text()();
  TextColumn get cedula => text().nullable()();
  TextColumn get telefono => text().nullable()();

  /// Saldo pendiente en USD (fuente de verdad; Bs se calcula con tasa actual).
  RealColumn get saldoPendienteUsd => real().withDefault(const Constant(0))();

  /// Límite de crédito (Plan Todos los Juguetes).
  RealColumn get limiteCreditoUsd => real().nullable()();

  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}
