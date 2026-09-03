import 'package:drift/drift.dart';

/// Registro de compra a un proveedor (entrada de stock + deuda).
class Compra extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get proveedorUuid => text()();
  TextColumn get proveedorNombre => text()(); // snapshot
  TextColumn get numeroFactura => text().nullable()();
  RealColumn get totalUsd => real()();
  TextColumn get itemsJson => text()(); // array de items comprados
  TextColumn get metodoPago =>
      text()(); // 'credito' | 'efectivo' | 'transferencia'
  RealColumn get pagadoUsd => real().withDefault(const Constant(0))();
  BoolColumn get afectaSaldo => boolean().withDefault(const Constant(true))();
  TextColumn get notas => text().nullable()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fecha => integer()();
  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}

/// Item dentro de una compra (embedded en itemsJson).
class CompraItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get compraUuid => text()();
  IntColumn get productoId => integer()();
  TextColumn get productoNombre => text()(); // snapshot
  RealColumn get cantidad => real()();
  RealColumn get costoUnitarioUsd => real()();
  RealColumn get subtotalUsd => real()();
}

/// Pago realizado a un proveedor (reduce saldo).
class PagoProveedor extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get proveedorUuid => text()();
  TextColumn get proveedorNombre => text()(); // snapshot
  RealColumn get montoUsd => real()();
  TextColumn get metodoPago => text()(); // efectivo, transferencia, etc.
  TextColumn get referencia => text().nullable()();
  TextColumn get notas => text().nullable()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fecha => integer()();
  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}
