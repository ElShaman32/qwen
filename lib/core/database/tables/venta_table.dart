import 'package:drift/drift.dart';

/// Tabla de ventas. Items y pagos van embebidos como JSON
/// (refleja la estructura de Firestore para facilitar sync).
class Venta extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();

  /// Secuencial por negocio para el ticket (Venta #123).
  IntColumn get numeroVenta => integer()();

  /// Epoch de la venta.
  IntColumn get fecha => integer()();

  /// Lista de ItemVenta serializada.
  TextColumn get itemsJson => text()();

  /// Lista de Pago serializada.
  TextColumn get pagosJson => text()();

  RealColumn get totalUsd => real()();
  RealColumn get totalBs => real()();

  /// Tasa usada al momento de la venta (auditoría).
  RealColumn get tasaUsada => real()();

  /// Desglose de impuestos (ticket).
  RealColumn get ivaBs => real()();
  RealColumn get igtfBs => real()();

  /// Monto exento de IVA en Bs (para ticket y reportes).
  RealColumn get exentoBs => real().withDefault(const Constant(0))();

  BoolColumn get esFiado => boolean().withDefault(const Constant(false))();
  IntColumn get clienteId => integer().nullable()();

  BoolColumn get anulada => boolean().withDefault(const Constant(false))();
  TextColumn get motivoAnulacion => text().nullable()();

  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();

  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}
