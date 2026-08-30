import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../domain/venta_models.dart';

/// DAO de ventas. Registra la venta y descuenta stock en UNA transacción.
class VentaDao {
  final AppDatabase _db;

  VentaDao(this._db);

  /// Registra la venta + descuenta stock atómicamente.
  Future<VentaData> registrarVenta({
    required List<ItemVenta> items,
    required List<Pago> pagos,
    required double totalUsd,
    required double totalBs,
    required double tasaUsada,
    required double ivaBs,
    required double igtfBs,
    double exentoBs = 0,
    bool esFiado = false,
    int? clienteId,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;

    final ventaId = await _db.transaction(() async {
      // 1. Secuencial del ticket
      final numero = await _siguienteNumero();

      // 2. Insertar la venta
      final ventaUuid = const Uuid().v4();
      final id = await _db.into(_db.venta).insert(VentaCompanion.insert(
            uuid: ventaUuid,
            numeroVenta: numero,
            fecha: ahora,
            itemsJson: jsonEncode(items.map((e) => e.toJson()).toList()),
            pagosJson: jsonEncode(pagos.map((e) => e.toJson()).toList()),
            totalUsd: totalUsd,
            totalBs: totalBs,
            tasaUsada: tasaUsada,
            ivaBs: ivaBs,
            igtfBs: igtfBs,
            exentoBs: Value(exentoBs),
            esFiado: Value(esFiado),
            clienteId: Value(clienteId),
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: ahora,
            fechaActualizacion: ahora,
          ));

      // 3. Descontar stock (expresión SQL atómica, sin leer antes)
      for (final item in items) {
        if (item.productoId == null) continue;
        await (_db.update(_db.producto)
              ..where((t) => t.id.equals(item.productoId!)))
            .write(ProductoCompanion.custom(
          stock: _db.producto.stock - Variable(item.cantidad),
          fechaActualizacion: Variable(ahora),
        ));
      }

      // 4. Outbox: encolar venta + stock nuevo (misma transacción)
      await encolarSync(_db, coleccion: 'ventas', docId: ventaUuid, payload: {
        'numeroVenta': numero,
        'fecha': ahora,
        'itemsJson': jsonEncode(items.map((e) => e.toJson()).toList()),
        'pagosJson': jsonEncode(pagos.map((e) => e.toJson()).toList()),
        'totalUsd': totalUsd,
        'totalBs': totalBs,
        'tasaUsada': tasaUsada,
        'ivaBs': ivaBs,
        'igtfBs': igtfBs,
        'exentoBs': exentoBs,
        'esFiado': esFiado,
        'clienteId': clienteId,
        'anulada': false,
        'usuarioId': usuarioId,
        'usuarioNombre': usuarioNombre,
        'fechaActualizacion': ahora,
      });

      // Solo stock+timestamp: pasa las reglas incluso siendo cajero
      for (final item in items) {
        if (item.productoId == null) continue;
        final prod = await (_db.select(_db.producto)
              ..where((t) => t.id.equals(item.productoId!)))
            .getSingleOrNull();
        if (prod != null) {
          await encolarSync(_db,
              coleccion: 'inventario',
              docId: prod.uuid,
              payload: {
                'stock': prod.stock,
                'fechaActualizacion': prod.fechaActualizacion,
              });
        }
      }

      return id;
    });

    return obtenerPorId(ventaId);
  }

  Future<int> _siguienteNumero() async {
    final maxExpr = _db.venta.numeroVenta.max();
    final row =
        await (_db.selectOnly(_db.venta)..addColumns([maxExpr])).getSingle();
    return (row.read(maxExpr) ?? 0) + 1;
  }

  Future<VentaData> obtenerPorId(int id) {
    return (_db.select(_db.venta)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Ventas de hoy (no anuladas), más recientes primero.
  Future<List<VentaData>> ventasDelDia() {
    final ahora = DateTime.now();
    final inicioDia =
        DateTime(ahora.year, ahora.month, ahora.day).millisecondsSinceEpoch;

    return (_db.select(_db.venta)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicioDia) & t.anulada.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Ventas no anuladas desde [fechaEpoch], más recientes primero.
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

  /// Total vendido hoy en USD (no anuladas).
  Future<double> totalUsdDelDia() async {
    final ventas = await ventasDelDia();
    return ventas.fold<double>(0.0, (acc, v) => acc + v.totalUsd);
  }

  /// Anula una venta: reintegra stock y, si fue fiado, revierte el saldo
  /// del cliente. Todo en UNA transacción.
  Future<bool> anularVenta(
    int id,
    String motivo, {
    String usuarioId = '',
    String usuarioNombre = '',
  }) async {
    final venta = await obtenerPorId(id);
    if (venta.anulada) return false;

    final ahora = DateTime.now().millisecondsSinceEpoch;
    final items = (jsonDecode(venta.itemsJson) as List)
        .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
        .toList();

    return _db.transaction(() async {
      // 1. Reintegrar stock
      for (final item in items) {
        if (item.productoId == null) continue;
        await (_db.update(_db.producto)
              ..where((t) => t.id.equals(item.productoId!)))
            .write(ProductoCompanion.custom(
          stock: _db.producto.stock + Variable(item.cantidad),
          fechaActualizacion: Variable(ahora),
        ));
      }

      // 2. Revertir saldo del cliente si fue fiado
      String? pagoAnulacionUuid;
      if (venta.esFiado && venta.clienteId != null) {
        await (_db.update(_db.cliente)
              ..where((t) => t.id.equals(venta.clienteId!)))
            .write(ClienteCompanion.custom(
          saldoPendienteUsd:
              _db.cliente.saldoPendienteUsd - Variable(venta.totalUsd),
          fechaActualizacion: Variable(ahora),
        ));

        pagoAnulacionUuid = const Uuid().v4();
        await _db.into(_db.pagoFiado).insert(PagoFiadoCompanion.insert(
              uuid: pagoAnulacionUuid,
              clienteId: venta.clienteId!,
              ventaId: Value(venta.id),
              tipo: 'anulacion',
              montoUsd: venta.totalUsd,
              montoBs: venta.totalBs,
              tasa: venta.tasaUsada,
              nota: Value('Anulación venta #${venta.numeroVenta}'),
              usuarioId: usuarioId,
              usuarioNombre: usuarioNombre,
              fecha: ahora,
            ));
      }

      // 3. Marcar como anulada
      final filas = await (_db.update(_db.venta)..where((t) => t.id.equals(id)))
          .write(VentaCompanion(
        anulada: const Value(true),
        motivoAnulacion: Value(motivo),
        fechaActualizacion: Value(ahora),
      ));

      // 4. Outbox: anulación + stock repuesto + fiado revertido
      await encolarSync(_db,
          coleccion: 'ventas',
          docId: venta.uuid,
          operacion: 'update',
          payload: {
            'anulada': true,
            'motivoAnulacion': motivo,
            'fechaActualizacion': ahora,
          });

      for (final item in items) {
        if (item.productoId == null) continue;
        final prod = await (_db.select(_db.producto)
              ..where((t) => t.id.equals(item.productoId!)))
            .getSingleOrNull();
        if (prod != null) {
          await encolarSync(_db,
              coleccion: 'inventario',
              docId: prod.uuid,
              payload: {
                'stock': prod.stock,
                'fechaActualizacion': prod.fechaActualizacion,
              });
        }
      }

      if (venta.esFiado && venta.clienteId != null) {
        final cliente = await (_db.select(_db.cliente)
              ..where((t) => t.id.equals(venta.clienteId!)))
            .getSingleOrNull();
        if (cliente != null) {
          await encolarSync(_db,
              coleccion: 'clientes',
              docId: cliente.uuid,
              payload: payloadCliente(cliente));
        }
        if (pagoAnulacionUuid != null) {
          await encolarSync(_db,
              coleccion: 'pagos_fiados',
              docId: pagoAnulacionUuid,
              payload: {
                'clienteId': venta.clienteId,
                'ventaId': venta.id,
                'tipo': 'anulacion',
                'montoUsd': venta.totalUsd,
                'montoBs': venta.totalBs,
                'tasa': venta.tasaUsada,
                'nota': 'Anulación venta #${venta.numeroVenta}',
                'usuarioId': usuarioId,
                'usuarioNombre': usuarioNombre,
                'fecha': ahora,
              });
        }
      }

      return filas > 0;
    });
  }
}

final ventaDaoProvider = Provider<VentaDao>((ref) {
  return VentaDao(ref.watch(databaseProvider));
});
