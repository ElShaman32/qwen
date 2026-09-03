import 'package:drift/drift.dart';

class ConfiguracionLocal extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Plan de suscripción (viene del Maestro, controlado por desarrollador)
  TextColumn get plan => text().withDefault(const Constant('cuaderno'))();
  // Estado de suscripción (viene del Maestro, cacheado para offline)
  BoolColumn get cuentaActiva => boolean().withDefault(const Constant(true))();
  IntColumn get fechaVencimientoEpoch =>
      integer().withDefault(const Constant(0))();

  // Identidad y Branding
  TextColumn get appNombre => text().withDefault(const Constant(''))();
  TextColumn get appSlogan => text().withDefault(const Constant(''))();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get colorPrimario =>
      text().withDefault(const Constant('#1a5c2a'))();
  TextColumn get colorSecundario =>
      text().withDefault(const Constant('#ffd700'))();

  // Datos Fiscales
  TextColumn get rif => text().withDefault(const Constant(''))();
  TextColumn get direccion => text().withDefault(const Constant(''))();
  TextColumn get telefono => text().withDefault(const Constant(''))();

  // Tasas e Impuestos
  RealColumn get tasaBcv => real().withDefault(const Constant(1.0))();
  BoolColumn get usarTasaBcv => boolean().withDefault(const Constant(true))();
  RealColumn get tasaManual => real().nullable()();
  RealColumn get ivaRate => real().withDefault(const Constant(0.16))();
  RealColumn get igtfRate => real().withDefault(const Constant(0.03))();

  // Control Offline / Kill Switch
  IntColumn get timestampUltimaVerificacion =>
      integer().withDefault(const Constant(0))();

  // ── MODO DEMO ─────────────────────────────────────────────
  BoolColumn get isDemoMode => boolean().withDefault(const Constant(false))();
  IntColumn get demoStartTimestamp =>
      integer().withDefault(const Constant(0))();
  // ── ONBOARDING ───────────────────────────────────────────
  BoolColumn get acceptedLegal =>
      boolean().withDefault(const Constant(false))();

  IntColumn get timestampUltimaVerificacionMaestro =>
      integer().withDefault(const Constant(0))();
}
