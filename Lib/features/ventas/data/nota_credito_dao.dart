import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/movimiento_outbox.dart';
import '../../auditoria/domain/auditoria_acciones.dart';

/// DAO de notas de crédito (devoluciones parciales).
/// Sigue el patrón transaccional de VentaDao.anularVenta.
class NotaCreditoDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final AppDatabase _db;

  NotaCreditoDao(this._db);

  static double red2(double x) => (x * 100).round() / 100;

  /// Cantidad total devuelta de un producto en una venta específica.
  Future<double> cantidadDevuelta(String ventaUuid, int productoId) async {
    final notas = await (_db.select(_db.notaCredito)
          ..where((t) => t.ventaUuid.equals(ventaUuid)))
        .get();

    double total = 0;
    for (final nota in notas) {
      final items = (jsonDecode(nota.itemsJson) as List)
          .map((e) => ItemDevolucion.fromJson(e as Map<String, dynamic>))
          .toList();

      for (final item in items) {
        if (item.productoId == productoId) {
          total += item.cantidad;
        }
      }
    }

    return total;
  }

  /// Registra una devolución parcial.
  /// Transacción atómica: crea nota + reintegra stock + revierte fiado + encola sync.
  Future<bool> registrarDevolucion({
    required VentaData venta,
    required List<ItemDevolucion> itemsDevolucion,
    required double montoUsd,
    required double montoBs,
    required double tasa,
    required String motivo,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    try {
      // Validar que la venta no esté anulada
      if (venta.anulada) {
        _logger.w('Intento de devolver venta anulada: ${venta.uuid}');
        return false;
      }

      final ahora = DateTime.now().millisecondsSinceEpoch;
      final notaUuid = const Uuid().v4();

      return await _db.transaction(() async {
        // 1. Crear la nota de crédito
        await _db.into(_db.notaCredito).insert(
              NotaCreditoCompanion.insert(
                uuid: notaUuid,
                ventaUuid: venta.uuid,
                ventaNumero: venta.numeroVenta,
                tipo: 'devolucion',
                itemsJson:
                    jsonEncode(itemsDevolucion.map((i) => i.toJson()).toList()),
                montoUsd: montoUsd,
                montoBs: montoBs,
                tasa: tasa,
                motivo: motivo,
                usuarioId: usuarioId,
                usuarioNombre: usuarioNombre,
                fecha: ahora,
                fechaCreacion: ahora,
                fechaActualizacion: ahora,
              ),
            );

        // 2. Reintegrar stock
        for (final item in itemsDevolucion) {
          if (item.productoId == null) continue;

          await (_db.update(_db.producto)
                ..where((t) => t.id.equals(item.productoId!)))
              .write(ProductoCompanion.custom(
            stock: _db.producto.stock + Variable(item.cantidad),
            fechaActualizacion: Variable(ahora),
          ));
        }

        // 3. Revertir saldo del cliente si fue fiado
        if (venta.esFiado && venta.clienteId != null) {
          await (_db.update(_db.cliente)
                ..where((t) => t.id.equals(venta.clienteId!)))
              .write(ClienteCompanion.custom(
            saldoPendienteUsd:
                _db.cliente.saldoPendienteUsd - Variable(montoUsd),
            fechaActualizacion: Variable(ahora),
          ));
        }

        // 4. Outbox: encolar nota + stock actualizado + cliente actualizado
        await encolarSync(_db,
            coleccion: 'notas_credito',
            docId: notaUuid,
            payload: {
              'ventaUuid': venta.uuid,
              'ventaNumero': venta.numeroVenta,
              'tipo': 'devolucion',
              'itemsJson':
                  jsonEncode(itemsDevolucion.map((i) => i.toJson()).toList()),
              'montoUsd': montoUsd,
              'montoBs': montoBs,
              'tasa': tasa,
              'motivo': motivo,
              'usuarioId': usuarioId,
              'usuarioNombre': usuarioNombre,
              'fecha': ahora,
              'fechaCreacion': ahora,
              'fechaActualizacion': ahora,
            });

        // Stock actualizado
        for (final item in itemsDevolucion) {
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

        // Cliente actualizado (si fue fiado)
        if (venta.esFiado && venta.clienteId != null) {
          final cliente = await (_db.select(_db.cliente)
                ..where((t) => t.id.equals(venta.clienteId!)))
              .getSingleOrNull();

          if (cliente != null) {
            await encolarSync(_db,
                coleccion: 'clientes',
                docId: cliente.uuid,
                payload: {
                  'saldoPendienteUsd': cliente.saldoPendienteUsd,
                  'fechaActualizacion': cliente.fechaActualizacion,
                });
          }
        }

        // 5. Movimiento crítico
        await registrarMovimiento(
          _db,
          usuarioId: usuarioId,
          usuarioNombre: usuarioNombre,
          accion: AccionesAuditoria.notaCredito,
          detalles:
              'Venta #${venta.numeroVenta}, devuelto: \$${montoUsd.toStringAsFixed(2)}',
        );

        _logger.i(
            '✅ Devolución registrada: Venta #${venta.numeroVenta}, $montoUsd USD');
        return true;
      });
    } catch (e, stack) {
      _logger.e('Error registrando devolución', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Todas las notas de crédito de una venta.
  Future<List<NotaCreditoData>> notasDeVenta(String ventaUuid) {
    return (_db.select(_db.notaCredito)
          ..where((t) => t.ventaUuid.equals(ventaUuid))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }
}

/// Item devuelto en una nota de crédito.
class ItemDevolucion {
  final int? productoId;
  final String productoNombre;
  final double cantidad;
  final double precioUnitarioUsd;
  final double subtotalUsd;
  final double costoUnitarioUsd;

  const ItemDevolucion({
    this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitarioUsd,
    required this.subtotalUsd,
    this.costoUnitarioUsd = 0, // ⬅️ NUEVO
  });

  Map<String, dynamic> toJson() => {
        'productoId': productoId,
        'productoNombre': productoNombre,
        'cantidad': cantidad,
        'precioUnitarioUsd': precioUnitarioUsd,
        'subtotalUsd': subtotalUsd,
        'costoUnitarioUsd': costoUnitarioUsd, // ⬅️ NUEVO
      };

  factory ItemDevolucion.fromJson(Map<String, dynamic> json) => ItemDevolucion(
        productoId: json['productoId'] as int?,
        productoNombre: json['productoNombre'] as String? ?? '',
        cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0,
        precioUnitarioUsd: (json['precioUnitarioUsd'] as num?)?.toDouble() ?? 0,
        subtotalUsd: (json['subtotalUsd'] as num?)?.toDouble() ?? 0,
        costoUnitarioUsd:
            (json['costoUnitarioUsd'] as num?)?.toDouble() ?? 0, // ⬅️ NUEVO
      );
}

final notaCreditoDaoProvider = Provider<NotaCreditoDao>((ref) {
  return NotaCreditoDao(ref.watch(databaseProvider));
});
