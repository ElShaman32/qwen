import 'package:drift/drift.dart';

/// Proveedores del negocio. Llevan control de saldo pendiente.
class Proveedor extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get nombre => text()();
  TextColumn get rif => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get correo => text().nullable()();
  TextColumn get direccion => text().nullable()();
  TextColumn get contacto => text().nullable()(); // persona de contacto
  RealColumn get saldoPendienteUsd => real().withDefault(const Constant(0))();
  TextColumn get notas => text().nullable()(); // notas internas
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}
