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

/// Item de una compra (para el JSON embebido).
class ItemCompra {
  final int productoId;
  final String productoNombre;
  final double cantidad;
  final double costoUnitarioUsd;
  final double subtotalUsd;

  const ItemCompra({
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.costoUnitarioUsd,
    required this.subtotalUsd,
  });

  Map<String, dynamic> toJson() => {
        'productoId': productoId,
        'productoNombre': productoNombre,
        'cantidad': cantidad,
        'costoUnitarioUsd': costoUnitarioUsd,
        'subtotalUsd': subtotalUsd,
      };

  factory ItemCompra.fromJson(Map<String, dynamic> json) => ItemCompra(
        productoId: (json['productoId'] as num).toInt(),
        productoNombre: json['productoNombre'] as String,
        cantidad: (json['cantidad'] as num).toDouble(),
        costoUnitarioUsd: (json['costoUnitarioUsd'] as num).toDouble(),
        subtotalUsd: (json['subtotalUsd'] as num).toDouble(),
      );
}

/// DAO completo de proveedores con compras y pagos.
class ProveedorDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  static double red2(double x) => (x * 100).round() / 100;

  final AppDatabase _db;

  ProveedorDao(this._db);

  // ═══════════════════════════════════════════════════════════
  // PROVEEDORES (CRUD)
  // ═══════════════════════════════════════════════════════════

  /// Lista todos los proveedores ordenados por nombre.
  Future<List<ProveedorData>> todos() {
    return (_db.select(_db.proveedor)
          ..orderBy([(t) => OrderingTerm(expression: t.nombre)]))
        .get();
  }

  /// Stream en vivo de proveedores (para UI reactiva).
  Stream<List<ProveedorData>> observar() {
    return (_db.select(_db.proveedor)
          ..orderBy([(t) => OrderingTerm(expression: t.nombre)]))
        .watch();
  }

  /// Obtiene un proveedor por ID.
  Future<ProveedorData?> obtenerPorId(int id) {
    return (_db.select(_db.proveedor)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserta un nuevo proveedor.
  Future<int> insertarProveedor({
    required String nombre,
    String? rif,
    String? telefono,
    String? correo,
    String? direccion,
    String? contacto,
    String? notas,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final proveedorUuid = const Uuid().v4();

    final id = await _db.into(_db.proveedor).insert(
          ProveedorCompanion.insert(
            uuid: proveedorUuid,
            nombre: nombre,
            rif: Value(rif),
            telefono: Value(telefono),
            correo: Value(correo),
            direccion: Value(direccion),
            contacto: Value(contacto),
            notas: Value(notas),
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: ahora,
            fechaActualizacion: ahora,
          ),
        );

    await encolarSync(_db,
        coleccion: 'proveedores',
        docId: proveedorUuid,
        payload: {
          'nombre': nombre,
          'rif': rif,
          'telefono': telefono,
          'correo': correo,
          'direccion': direccion,
          'contacto': contacto,
          'notas': notas,
          'saldoPendienteUsd': 0.0,
          'usuarioId': usuarioId,
          'usuarioNombre': usuarioNombre,
          'fechaCreacion': ahora,
          'fechaActualizacion': ahora,
        });

    await registrarMovimiento(
      _db,
      usuarioId: usuarioId,
      usuarioNombre: usuarioNombre,
      accion: AccionesAuditoria.proveedorCreado,
      detalles: nombre,
    );

    _logger.i('✅ Proveedor creado: $nombre');
    return id;
  }

  /// Actualiza datos básicos del proveedor (NO el saldo).
  Future<bool> actualizarProveedor({
    required int id,
    required String nombre,
    String? rif,
    String? telefono,
    String? correo,
    String? direccion,
    String? contacto,
    String? notas,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final anterior = await obtenerPorId(id);
    if (anterior == null) return false;

    final ahora = DateTime.now().millisecondsSinceEpoch;
    final filas = await (_db.update(_db.proveedor)
          ..where((t) => t.id.equals(id)))
        .write(ProveedorCompanion(
      nombre: Value(nombre),
      rif: Value(rif),
      telefono: Value(telefono),
      correo: Value(correo),
      direccion: Value(direccion),
      contacto: Value(contacto),
      notas: Value(notas),
      fechaActualizacion: Value(ahora),
    ));

    if (filas > 0) {
      await encolarSync(_db,
          coleccion: 'proveedores',
          docId: anterior.uuid,
          operacion: 'update',
          payload: {
            'nombre': nombre,
            'rif': rif,
            'telefono': telefono,
            'correo': correo,
            'direccion': direccion,
            'contacto': contacto,
            'notas': notas,
            'saldoPendienteUsd': anterior.saldoPendienteUsd,
            'fechaActualizacion': ahora,
          });

      await registrarMovimiento(
        _db,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        accion: AccionesAuditoria.proveedorActualizado,
        detalles: nombre,
      );
    }

    return filas > 0;
  }

  /// Elimina un proveedor. Solo si saldo = 0 y sin compras asociadas.
  Future<bool> eliminarProveedor({
    required int id,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final proveedor = await obtenerPorId(id);
    if (proveedor == null) return false;

    // Validar: no se puede eliminar si tiene saldo pendiente
    if (proveedor.saldoPendienteUsd.abs() > 0.001) {
      _logger
          .w('No se puede eliminar ${proveedor.nombre}: tiene saldo pendiente');
      return false;
    }

    // Validar: no se puede eliminar si tiene compras
    final tieneCompras = await (_db.select(_db.compra)
          ..where((t) => t.proveedorUuid.equals(proveedor.uuid))
          ..limit(1))
        .getSingleOrNull();

    if (tieneCompras != null) {
      _logger.w(
          'No se puede eliminar ${proveedor.nombre}: tiene compras asociadas');
      return false;
    }

    final filas =
        await (_db.delete(_db.proveedor)..where((t) => t.id.equals(id))).go();

    if (filas > 0) {
      await encolarSync(_db,
          coleccion: 'proveedores',
          docId: proveedor.uuid,
          operacion: 'delete',
          payload: {});

      await registrarMovimiento(
        _db,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        accion: AccionesAuditoria.proveedorEliminado,
        detalles: proveedor.nombre,
      );
    }

    return filas > 0;
  }

  // ═══════════════════════════════════════════════════════════
  // COMPRAS (entrada de stock + deuda)
  // ═══════════════════════════════════════════════════════════

  /// Registra una compra: crea la compra, aumenta stock de productos
  /// y suma al saldo del proveedor si es a crédito.
  Future<bool> registrarCompra({
    required int proveedorId,
    String? numeroFactura,
    required List<ItemCompra> items,
    required String metodoPago, // 'credito' | 'efectivo' | 'transferencia'
    double pagadoUsd = 0,
    String? notas,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final proveedor = await obtenerPorId(proveedorId);
    if (proveedor == null) return false;

    final totalUsd =
        red2(items.fold<double>(0.0, (acc, i) => acc + i.subtotalUsd));
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final compraUuid = const Uuid().v4();
    final esCredito = metodoPago == 'credito';
    final deudaUsd = esCredito ? red2(totalUsd - pagadoUsd) : 0.0;

    return await _db.transaction(() async {
      // 1. Crear la compra
      await _db.into(_db.compra).insert(
            CompraCompanion.insert(
              uuid: compraUuid,
              proveedorUuid: proveedor.uuid,
              proveedorNombre: proveedor.nombre,
              numeroFactura: Value(numeroFactura),
              totalUsd: totalUsd,
              itemsJson: jsonEncode(items.map((i) => i.toJson()).toList()),
              metodoPago: metodoPago,
              pagadoUsd: Value(pagadoUsd),
              afectaSaldo: const Value(true),
              notas: Value(notas),
              usuarioId: usuarioId,
              usuarioNombre: usuarioNombre,
              fecha: ahora,
              fechaCreacion: ahora,
              fechaActualizacion: ahora,
            ),
          );

      // 2. Crear los items de compra
      for (final item in items) {
        await _db.into(_db.compraItem).insert(
              CompraItemCompanion.insert(
                compraUuid: compraUuid,
                productoId: item.productoId,
                productoNombre: item.productoNombre,
                cantidad: item.cantidad,
                costoUnitarioUsd: item.costoUnitarioUsd,
                subtotalUsd: item.subtotalUsd,
              ),
            );
      }

      // 3. Actualizar stock y costo de cada producto
      for (final item in items) {
        await (_db.update(_db.producto)
              ..where((t) => t.id.equals(item.productoId)))
            .write(ProductoCompanion.custom(
          stock: _db.producto.stock + Variable(item.cantidad),
          costoUsd: Variable(item.costoUnitarioUsd), // último costo
          fechaActualizacion: Variable(ahora),
        ));

        // Encolar sync del producto
        final prod = await (_db.select(_db.producto)
              ..where((t) => t.id.equals(item.productoId)))
            .getSingleOrNull();
        if (prod != null) {
          await encolarSync(_db,
              coleccion: 'inventario',
              docId: prod.uuid,
              operacion: 'update',
              payload: {
                'stock': prod.stock,
                'costoUsd': prod.costoUsd,
                'fechaActualizacion': prod.fechaActualizacion,
              });
        }
      }

      // 4. Sumar deuda al proveedor si es a crédito
      if (esCredito && deudaUsd > 0) {
        await (_db.update(_db.proveedor)
              ..where((t) => t.id.equals(proveedorId)))
            .write(ProveedorCompanion.custom(
          saldoPendienteUsd:
              _db.proveedor.saldoPendienteUsd + Variable(deudaUsd),
          fechaActualizacion: Variable(ahora),
        ));
      }

      // 5. Outbox de la compra
      await encolarSync(_db, coleccion: 'compras', docId: compraUuid, payload: {
        'proveedorUuid': proveedor.uuid,
        'proveedorNombre': proveedor.nombre,
        'numeroFactura': numeroFactura,
        'totalUsd': totalUsd,
        'itemsJson': jsonEncode(items.map((i) => i.toJson()).toList()),
        'metodoPago': metodoPago,
        'pagadoUsd': pagadoUsd,
        'afectaSaldo': true,
        'notas': notas,
        'usuarioId': usuarioId,
        'usuarioNombre': usuarioNombre,
        'fecha': ahora,
        'fechaCreacion': ahora,
        'fechaActualizacion': ahora,
      });

      // 6. Outbox del proveedor actualizado (saldo)
      if (esCredito && deudaUsd > 0) {
        final provActualizado = await obtenerPorId(proveedorId);
        if (provActualizado != null) {
          await encolarSync(_db,
              coleccion: 'proveedores',
              docId: provActualizado.uuid,
              operacion: 'update',
              payload: {
                'saldoPendienteUsd': provActualizado.saldoPendienteUsd,
                'fechaActualizacion': provActualizado.fechaActualizacion,
              });
        }
      }

      // 7. Movimiento crítico
      await registrarMovimiento(
        _db,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        accion: AccionesAuditoria.compraRegistrada,
        detalles: '${proveedor.nombre}, \$${totalUsd.toStringAsFixed(2)}'
            '${esCredito ? " (crédito \$${deudaUsd.toStringAsFixed(2)})" : ""}',
      );

      _logger.i(
          '✅ Compra registrada: ${proveedor.nombre}, \$${totalUsd.toStringAsFixed(2)}');
      return true;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // PAGOS A PROVEEDORES (reduce saldo)
  // ═══════════════════════════════════════════════════════════

  /// Registra un pago a un proveedor, reduciendo su saldo pendiente.
  Future<bool> registrarPago({
    required int proveedorId,
    required double montoUsd,
    required String metodoPago,
    String? referencia,
    String? notas,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final proveedor = await obtenerPorId(proveedorId);
    if (proveedor == null) return false;

    if (montoUsd <= 0) {
      _logger.w('Monto de pago inválido: $montoUsd');
      return false;
    }

    final ahora = DateTime.now().millisecondsSinceEpoch;
    final pagoUuid = const Uuid().v4();
    final montoRedondeado = red2(montoUsd);

    return await _db.transaction(() async {
      // 1. Crear el pago
      await _db.into(_db.pagoProveedor).insert(
            PagoProveedorCompanion.insert(
              uuid: pagoUuid,
              proveedorUuid: proveedor.uuid,
              proveedorNombre: proveedor.nombre,
              montoUsd: montoRedondeado,
              metodoPago: metodoPago,
              referencia: Value(referencia),
              notas: Value(notas),
              usuarioId: usuarioId,
              usuarioNombre: usuarioNombre,
              fecha: ahora,
              fechaCreacion: ahora,
              fechaActualizacion: ahora,
            ),
          );

      // 2. Reducir saldo del proveedor (mínimo 0)
      final nuevoSaldo = (proveedor.saldoPendienteUsd - montoRedondeado)
          .clamp(0.0, double.infinity);
      await (_db.update(_db.proveedor)..where((t) => t.id.equals(proveedorId)))
          .write(ProveedorCompanion(
        saldoPendienteUsd: Value(nuevoSaldo),
        fechaActualizacion: Value(ahora),
      ));

      // 3. Outbox del pago
      await encolarSync(_db,
          coleccion: 'pagos_proveedor',
          docId: pagoUuid,
          payload: {
            'proveedorUuid': proveedor.uuid,
            'proveedorNombre': proveedor.nombre,
            'montoUsd': montoRedondeado,
            'metodoPago': metodoPago,
            'referencia': referencia,
            'notas': notas,
            'usuarioId': usuarioId,
            'usuarioNombre': usuarioNombre,
            'fecha': ahora,
            'fechaCreacion': ahora,
            'fechaActualizacion': ahora,
          });

      // 4. Outbox del proveedor actualizado (saldo)
      await encolarSync(_db,
          coleccion: 'proveedores',
          docId: proveedor.uuid,
          operacion: 'update',
          payload: {
            'saldoPendienteUsd': nuevoSaldo,
            'fechaActualizacion': ahora,
          });

      // 5. Movimiento crítico
      await registrarMovimiento(
        _db,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        accion: AccionesAuditoria.pagoProveedor,
        detalles:
            '${proveedor.nombre}, pago \$${montoRedondeado.toStringAsFixed(2)}',
      );

      _logger.i(
          '✅ Pago registrado: ${proveedor.nombre}, \$${montoRedondeado.toStringAsFixed(2)}');
      return true;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // CONSULTAS
  // ═══════════════════════════════════════════════════════════

  /// Suma total de saldos pendientes de todos los proveedores.
  /// Se usa en Contabilidad para calcular pasivos.
  Future<double> totalPasivosProveedores() async {
    final sumExpr = _db.proveedor.saldoPendienteUsd.sum();
    final row = await (_db.selectOnly(_db.proveedor)..addColumns([sumExpr]))
        .getSingle();
    return row.read(sumExpr) ?? 0.0;
  }

  /// Suma total de compras en un rango de fechas (para Contabilidad).
  /// Incluye compras a crédito y en efectivo (todo es costo de mercancía).
  Future<double> sumaComprasEnRango(int inicio, int fin) async {
    final compras = await (_db.select(_db.compra)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerOrEqualValue(fin)))
        .get();
    return compras.fold<double>(0.0, (acc, c) => acc + c.totalUsd);
  }

  /// Cuenta compras en un rango (para mostrar el número en el reporte).
  Future<int> cuentaComprasEnRango(int inicio, int fin) async {
    final compras = await (_db.select(_db.compra)
          ..where((t) =>
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerOrEqualValue(fin)))
        .get();
    return compras.length;
  }

  /// Compras de un proveedor, más recientes primero.
  Future<List<CompraData>> comprasDeProveedor(String proveedorUuid) {
    return (_db.select(_db.compra)
          ..where((t) => t.proveedorUuid.equals(proveedorUuid))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Pagos de un proveedor, más recientes primero.
  Future<List<PagoProveedorData>> pagosDeProveedor(String proveedorUuid) {
    return (_db.select(_db.pagoProveedor)
          ..where((t) => t.proveedorUuid.equals(proveedorUuid))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Todos los proveedores con saldo pendiente (para alertas/dashboard).
  Future<List<ProveedorData>> conSaldoPendiente() {
    return (_db.select(_db.proveedor)
          ..where((t) => t.saldoPendienteUsd.isBiggerThanValue(0.001))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.saldoPendienteUsd, mode: OrderingMode.desc)
          ]))
        .get();
  }
}

final proveedorDaoProvider = Provider<ProveedorDao>((ref) {
  return ProveedorDao(ref.watch(databaseProvider));
});
