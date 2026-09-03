import 'package:drift/drift.dart';

/// Tabla de productos. Soporta granel (stock en decimales).
class Producto extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// UUID para sincronización con Firestore.
  TextColumn get uuid => text().unique()();

  TextColumn get nombre => text()();

  /// Código de barras o código interno. Nullable.
  TextColumn get codigo => text().nullable()();

  TextColumn get categoria => text().nullable()();

  /// UUID del proveedor habitual (enlace para reposición/alertas). Nullable.
  TextColumn get proveedorUuid => text().nullable()();

  /// Precio en USD (precio FINAL, tax inclusive según Decisiones.md).
  RealColumn get precioUsd => real()();

  /// Costo de reposición en USD (para calcular ganancias).
  RealColumn get costoUsd => real().withDefault(const Constant(0))();

  /// Precio por mayor (opcional, Plan Cuaderno y Calculadora+).
  RealColumn get precioMayor => real().nullable()();

  /// Stock en double para soportar granel (15.5 kg).
  RealColumn get stock => real().withDefault(const Constant(0))();

  /// Producto exento de IVA (alimentos de cesta básica).
  BoolColumn get exentoIva => boolean().withDefault(const Constant(false))();

  /// Si es producto a granel (queso, carne, etc.).
  BoolColumn get esGranel => boolean().withDefault(const Constant(false))();

  /// Unidad de medida si es granel: kg, g, lb.
  TextColumn get unidadMedida => text().nullable()();

  /// Fecha de vencimiento como epoch ms. Nullable.
  IntColumn get fechaVencimiento => integer().nullable()();

  /// Stock mínimo para alertas.
  IntColumn get stockMinimo => integer().withDefault(const Constant(5))();

  /// Soft delete: si es false, no aparece en POS pero se conserva el historial.
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  /// Epoch de creación.
  IntColumn get fechaCreacion => integer()();

  /// Epoch de última actualización (para sync con Firestore).
  IntColumn get fechaActualizacion => integer()();
}
