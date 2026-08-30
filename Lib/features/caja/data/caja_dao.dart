import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

/// DAO de caja: aperturas, cierres, retiros y ventas del turno.
class CajaDao {
  final AppDatabase _db;

  CajaDao(this._db);

  /// Apertura activa (no cerrada). Null si la caja está cerrada.
  Future<AperturaCajaData?> aperturaActiva() async {
    final rows = await (_db.select(_db.aperturaCaja)
          ..where((t) => t.cerrada.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  /// Abre la caja con el efectivo inicial reportado.
  Future<AperturaCajaData> abrir({
    required double montoInicialBs,
    required double montoInicialUsd,
    String? novedad,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final aperturaUuid = const Uuid().v4();
    final id =
        await _db.into(_db.aperturaCaja).insert(AperturaCajaCompanion.insert(
              uuid: aperturaUuid,
              usuarioId: usuarioId,
              usuarioNombre: usuarioNombre,
              montoInicialBs: Value(montoInicialBs),
              montoInicialUsd: Value(montoInicialUsd),
              novedad: Value(novedad),
              fecha: ahora,
            ));

    // Outbox
    await encolarSync(_db, coleccion: 'caja', docId: aperturaUuid, payload: {
      'tipo': 'apertura',
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'montoInicialBs': montoInicialBs,
      'montoInicialUsd': montoInicialUsd,
      'novedad': novedad,
      'cerrada': false,
      'fecha': ahora,
    });

    return (_db.select(_db.aperturaCaja)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  /// Retiro de efectivo durante el turno.
  Future<void> retirar({
    required int aperturaId,
    required double montoBs,
    required String motivo,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final retiroUuid = const Uuid().v4();
    await _db.into(_db.retiroCaja).insert(RetiroCajaCompanion.insert(
          uuid: retiroUuid,
          aperturaId: aperturaId,
          usuarioId: usuarioId,
          usuarioNombre: usuarioNombre,
          montoBs: montoBs,
          motivo: motivo,
          fecha: DateTime.now().millisecondsSinceEpoch,
        ));

    // Outbox
    await encolarSync(_db, coleccion: 'caja', docId: retiroUuid, payload: {
      'tipo': 'retiro',
      'aperturaId': aperturaId,
      'usuarioId': usuarioId,
      'usuarioNombre': usuarioNombre,
      'montoBs': montoBs,
      'motivo': motivo,
      'fecha': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Retiros de una apertura.
  Future<List<RetiroCajaData>> retirosDe(int aperturaId) {
    return (_db.select(_db.retiroCaja)
          ..where((t) => t.aperturaId.equals(aperturaId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Ventas no anuladas desde la apertura (para esperado y resumen).
  Future<List<VentaData>> ventasDesde(int fechaEpoch) {
    return (_db.select(_db.venta)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(fechaEpoch) &
              t.anulada.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Cierra la caja: crea CierreCaja y marca la apertura como cerrada.
  Future<CierreCajaData> cerrar({
    required int aperturaId,
    required double montoEsperadoBs,
    required double montoRealBs,
    required String resumenJson,
    String? nota,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final diferencia = _red2(montoRealBs - montoEsperadoBs);

    final id = await _db.transaction(() async {
      final apertura = await (_db.select(_db.aperturaCaja)
            ..where((t) => t.id.equals(aperturaId)))
          .getSingle();
      final cierreUuid = const Uuid().v4();

      final cierreId = await _db.into(_db.cierreCaja).insert(
            CierreCajaCompanion.insert(
              uuid: cierreUuid,
              aperturaId: aperturaId,
              usuarioId: usuarioId,
              usuarioNombre: usuarioNombre,
              montoEsperadoBs: montoEsperadoBs,
              montoRealBs: montoRealBs,
              diferenciaBs: diferencia,
              resumenJson: resumenJson,
              nota: Value(nota),
              fecha: ahora,
            ),
          );

      await (_db.update(_db.aperturaCaja)
            ..where((t) => t.id.equals(aperturaId)))
          .write(AperturaCajaCompanion(
        cerrada: const Value(true),
        fechaCierre: Value(ahora),
      ));

      // Outbox: cierre + apertura marcada cerrada
      await encolarSync(_db, coleccion: 'caja', docId: cierreUuid, payload: {
        'tipo': 'cierre',
        'aperturaUuid': apertura.uuid,
        'usuarioId': usuarioId,
        'usuarioNombre': usuarioNombre,
        'montoEsperadoBs': montoEsperadoBs,
        'montoRealBs': montoRealBs,
        'diferenciaBs': diferencia,
        'resumenJson': resumenJson,
        'nota': nota,
        'fecha': ahora,
      });
      await encolarSync(_db,
          coleccion: 'caja',
          docId: apertura.uuid,
          operacion: 'update',
          payload: {'tipo': 'apertura', 'cerrada': true, 'fechaCierre': ahora});

      return cierreId;
    });

    return (_db.select(_db.cierreCaja)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  /// Apertura activa DE UN USUARIO específico (multi-caja simultánea).
  Future<AperturaCajaData?> aperturaActivaDe(String usuarioId) async {
    final rows = await (_db.select(_db.aperturaCaja)
          ..where(
              (t) => t.cerrada.equals(false) & t.usuarioId.equals(usuarioId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  /// Último cierre de un usuario (pantalla de caja cerrada).
  Future<CierreCajaData?> ultimoCierreDe(String usuarioId) async {
    final rows = await (_db.select(_db.cierreCaja)
          ..where((t) => t.usuarioId.equals(usuarioId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  /// Ventas no anuladas DE UN USUARIO desde [fechaEpoch]
  /// (cada cajero cuadra solo lo suyo).
  Future<List<VentaData>> ventasDeUsuarioDesde(
      String usuarioId, int fechaEpoch) {
    return (_db.select(_db.venta)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) &
              t.fecha.isBiggerOrEqualValue(fechaEpoch) &
              t.anulada.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Último cierre (para mostrar en pantalla).
  Future<CierreCajaData?> ultimoCierre() async {
    final rows = await (_db.select(_db.cierreCaja)
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  double _red2(double x) => (x * 100).round() / 100;
}

final cajaDaoProvider =
    Provider<CajaDao>((ref) => CajaDao(ref.watch(databaseProvider)));
