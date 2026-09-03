import 'package:drift/drift.dart';

/// Gastos manuales registrados por el admin.
/// Categorías: impuestos, servicios, reparaciones, alquiler, sueldos, mercancia, otros.
/// Los ingresos y merma se calculan automáticamente (no van en esta tabla).
class Gasto extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get categoria =>
      text()(); // impuestos|servicios|reparaciones|alquiler|sueldos|mercancia|otros
  TextColumn get descripcion => text()();
  RealColumn get montoUsd => real()();
  RealColumn get tasa => real()(); // tasa al momento del gasto
  IntColumn get fecha => integer()(); // epoch ms
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}
