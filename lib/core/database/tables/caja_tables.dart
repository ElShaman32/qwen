import 'package:drift/drift.dart';

/// Apertura de caja. Solo una activa (no cerrada) a la vez.
class AperturaCaja extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();

  /// Efectivo inicial en el cajón (Bs y $ por separado).
  RealColumn get montoInicialBs => real().withDefault(const Constant(0))();
  RealColumn get montoInicialUsd => real().withDefault(const Constant(0))();

  /// Novedad reportada al abrir (ej: "recibí de cajera anterior").
  TextColumn get novedad => text().nullable()();

  BoolColumn get cerrada => boolean().withDefault(const Constant(false))();
  IntColumn get fecha => integer()();
  IntColumn get fechaCierre => integer().nullable()();
}

/// Cierre con arqueo: esperado vs real y diferencia.
class CierreCaja extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get aperturaId => integer()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();

  /// Efectivo Bs esperado según ventas - retiros + apertura.
  RealColumn get montoEsperadoBs => real()();

  /// Efectivo Bs contado por el cajero.
  RealColumn get montoRealBs => real()();

  /// real - esperado (positivo sobra, negativo falta).
  RealColumn get diferenciaBs => real()();

  /// Resumen por método de pago serializado.
  TextColumn get resumenJson => text()();

  TextColumn get nota => text().nullable()();
  IntColumn get fecha => integer()();
}

/// Retiros de caja durante el turno.
class RetiroCaja extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get aperturaId => integer()();
  TextColumn get usuarioId => text()();
  TextColumn get usuarioNombre => text()();
  RealColumn get montoBs => real()();
  TextColumn get motivo => text()();
  IntColumn get fecha => integer()();
}
