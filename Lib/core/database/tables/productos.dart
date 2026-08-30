import 'package:drift/drift.dart';

/// Tabla de productos del inventario.
class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get codigo => text().nullable().unique()();
  TextColumn get nombre => text()();
  TextColumn get categoria => text().withDefault(const Constant(''))();
  RealColumn get precioUsd => real()();
  RealColumn get precioBs => real()();
  RealColumn get stock => real().withDefault(const Constant(0.0))();
  BoolColumn get esGranel => boolean().withDefault(const Constant(false))();
  TextColumn get unidadMedida => text().withDefault(const Constant('und'))();
  RealColumn get precioMayor => real().nullable()();
  IntColumn get cantidadMayor => integer().nullable()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaActualizacion =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}
