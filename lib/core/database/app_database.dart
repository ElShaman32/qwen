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
import 'tables/gasto.dart';
import 'tables/nota_credito_table.dart';
import 'tables/categoria_table.dart';
import 'tables/proveedor_table.dart';
import 'tables/compra_table.dart';

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
  ArqueoParcial,
  Merma,
  AuditoriaLog,
  SyncQueue,
  Gasto,
  NotaCredito,
  Categoria,
  Proveedor,
  Compra,
  CompraItem,
  PagoProveedor,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 22;

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
        if (from < 13) {
          await m.createTable(gasto);
        }
        if (from < 14) {
          await m.createTable(notaCredito);
        }
        if (from < 15) {
          await m.createTable(categoria);
        }
        if (from < 16) {
          await m.createTable(proveedor);
          await m.createTable(compra);
          await m.createTable(compraItem);
          await m.createTable(pagoProveedor);
        }
        if (from < 17) {
          await m.addColumn(proveedor, proveedor.correo);
        }
        if (from < 18) {
          await m.addColumn(producto, producto.proveedorUuid);
        }
        if (from < 19) {
          await m.addColumn(configuracionLocal, configuracionLocal.isDemoMode);
          await m.addColumn(
              configuracionLocal, configuracionLocal.demoStartTimestamp);
        }
        if (from < 20) {
          await m.addColumn(
              configuracionLocal, configuracionLocal.acceptedLegal);
        }
        if (from < 21) {
          await m.addColumn(
            configuracionLocal,
            configuracionLocal.timestampUltimaVerificacionMaestro,
          );
        }
        if (from < 22) {
          await m.createTable(arqueoParcial);
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
