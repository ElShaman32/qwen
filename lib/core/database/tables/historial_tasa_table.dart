import 'package:drift/drift.dart';

/// Histórico de tasas de cambio para auditoría y reportes.
class HistorialTasa extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get tasa => real()();
  TextColumn get fuente => text().withDefault(const Constant('manual'))();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
}
