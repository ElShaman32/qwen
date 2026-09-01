import 'package:drift/drift.dart';

/// Nota de crédito: devolución parcial de productos de una venta.
class NotaCredito extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get ventaUuid => text()();
  IntColumn get ventaNumero => integer()();
  TextColumn get tipo => text()(); // 'devolucion' (futuro: 'ajuste_precio')
  TextColumn get itemsJson => text()(); // Array de items devueltos
  RealColumn get montoUsd => real()();
  RealColumn get montoBs => real()();
  RealColumn get tasa => real()(); // Tasa al momento de la devolución
  TextColumn get motivo => text()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fecha => integer()(); // epoch ms
  IntColumn get fechaCreacion => integer()();
  IntColumn get fechaActualizacion => integer()();
}
