import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:el_cuaderno_de_mario/core/database/tables/caja_tables.dart';
import 'package:el_cuaderno_de_mario/core/database/tables/merma_table.dart';
import 'package:el_cuaderno_de_mario/core/database/tables/auditoria_log_table.dart';
import 'package:el_cuaderno_de_mario/core/database/tables/sync_queue_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/configuracion_local_table.dart';
import 'tables/historial_tasa_table.dart';
import 'tables/producto_table.dart';
import 'tables/venta_table.dart';
import 'tables/cliente_table.dart';
import 'tables/pago_fiado_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  ConfiguracionLocal,
  HistorialTasa,
  Producto,
  Venta,
  Cliente,
  PagoFiado,
  AperturaCaja,
  CierreCaja,
  RetiroCaja,
  Merma,
  AuditoriaLog,
  SyncQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(
              configuracionLocal, configuracionLocal.cuentaActiva);
          await m.addColumn(
              configuracionLocal, configuracionLocal.fechaVencimientoEpoch);
        }
        if (from < 3) {
          await m.createTable(producto);
        }
        if (from < 4) {
          await m.createTable(venta);
        }
        if (from < 5) {
          await m.addColumn(producto, producto.exentoIva);
          await m.addColumn(venta, venta.exentoBs);
        }
        if (from < 6) {
          await m.createTable(cliente);
          await m.createTable(pagoFiado);
        }
        if (from < 7) {
          await m.createTable(aperturaCaja);
          await m.createTable(cierreCaja);
          await m.createTable(retiroCaja);
        }
        if (from < 8) {
          await m.addColumn(producto, producto.costoUsd);
        }
        if (from < 10) {
          await m.createTable(merma);
        }
        if (from < 11) {
          await m.createTable(auditoriaLog);
        }
        if (from < 12) {
          await m.createTable(syncQueue);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cuaderno_mario.db'));
    return NativeDatabase.createInBackground(file);
  });
}
