import 'package:drift/drift.dart';

/// Tabla de ventas realizadas.
class Ventas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numeroVenta => text().unique()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  RealColumn get totalUsd => real()();
  RealColumn get totalBs => real()();
  RealColumn get baseImponible => real()();
  RealColumn get iva => real()();
  RealColumn get igtf => real()();
  TextColumn get metodoPago => text()();
  TextColumn get datosCliente => text().nullable()();
  BoolColumn get anulada => boolean().withDefault(const Constant(false))();
  TextColumn get motivoAnulacion => text().nullable()();
  IntColumn get usuarioId => integer().nullable()();
  IntColumn get cajaId => integer().nullable()();
}
