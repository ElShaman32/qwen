import 'package:drift/drift.dart';

/// Movimientos de la cuenta de crédito del cliente.
/// tipo: 'fiado' (aumenta saldo) | 'abono' (disminuye saldo)
class PagoFiado extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get clienteId => integer()();

  /// Venta que originó el fiado (null en abonos manuales).
  IntColumn get ventaId => integer().nullable()();

  TextColumn get tipo => text()(); // 'fiado' | 'abono'
  RealColumn get montoUsd => real()();
  RealColumn get montoBs => real()();
  RealColumn get tasa => real()();
  TextColumn get nota => text().nullable()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  IntColumn get fecha => integer()();
}
