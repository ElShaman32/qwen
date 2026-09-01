import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/movimiento_outbox.dart';
import '../../auditoria/domain/auditoria_acciones.dart';

/// DAO de merma: registra y descuenta stock en UNA transacción.
class MermaDao {
  final AppDatabase _db;

  MermaDao(this._db);

  double _red2(double x) => (x * 100).round() / 100;

  Future<void> registrar({
    required ProductoData producto,
    required double cantidad,
    required String motivo,
    String? nota,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;

    await _db.transaction(() async {
      final mermaUuid = const Uuid().v4();
      await _db.into(_db.merma).insert(MermaCompanion.insert(
            uuid: mermaUuid,
            productoId: producto.id,
            productoNombre: producto.nombre,
            cantidad: cantidad,
            unidad: producto.esGranel ? (producto.unidadMedida ?? 'kg') : 'und',
            motivo: motivo,
            nota: Value(nota),
            costoUsd: Value(_red2(producto.costoUsd * cantidad)),
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: ahora,
          ));

      await (_db.update(_db.producto)..where((t) => t.id.equals(producto.id)))
          .write(ProductoCompanion.custom(
        stock: _db.producto.stock - Variable(cantidad),
        fechaActualizacion: Variable(ahora),
      ));

      // Outbox: merma + stock nuevo
      await encolarSync(_db, coleccion: 'merma', docId: mermaUuid, payload: {
        'productoId': producto.id,
        'productoNombre': producto.nombre,
        'cantidad': cantidad,
        'unidad': producto.esGranel ? (producto.unidadMedida ?? 'kg') : 'und',
        'motivo': motivo,
        'nota': nota,
        'costoUsd': _red2(producto.costoUsd * cantidad),
        'usuarioId': usuarioId,
        'usuarioNombre': usuarioNombre,
        'fecha': ahora,
      });
      final prodActual = await (_db.select(_db.producto)
            ..where((t) => t.id.equals(producto.id)))
          .getSingleOrNull();
      if (prodActual != null) {
        await encolarSync(_db,
            coleccion: 'inventario',
            docId: prodActual.uuid,
            payload: {
              'stock': prodActual.stock,
              'fechaActualizacion': prodActual.fechaActualizacion,
            });
      }
      // Movimiento crítico: registrar merma
      await registrarMovimiento(
        _db,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        accion: AccionesAuditoria.merma,
        detalles: '${producto.nombre}, $cantidad '
            '${producto.esGranel ? (producto.unidadMedida ?? 'kg') : 'und'}, '
            'motivo: $motivo',
      );
    });
  }

  /// Merma de los últimos [dias] días, más reciente primero.
  Future<List<MermaData>> recientes({int dias = 30}) {
    final inicio =
        DateTime.now().subtract(Duration(days: dias)).millisecondsSinceEpoch;
    return (_db.select(_db.merma)
          ..where((t) => t.fecha.isBiggerOrEqualValue(inicio))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }
}

final mermaDaoProvider =
    Provider<MermaDao>((ref) => MermaDao(ref.watch(databaseProvider)));

final mermaRecientesProvider = FutureProvider<List<MermaData>>(
    (ref) => ref.watch(mermaDaoProvider).recientes());
