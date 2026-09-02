import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/services/movimiento_outbox.dart';
import '../../auditoria/domain/auditoria_acciones.dart';

/// DAO de categorías de productos.
class CategoriaDao {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final AppDatabase _db;

  CategoriaDao(this._db);

  /// Lista todas las categorías ordenadas por `orden` ascendente.
  Future<List<CategoriaData>> todas() {
    return (_db.select(_db.categoria)
          ..orderBy([(t) => OrderingTerm(expression: t.orden)]))
        .get();
  }

  /// Stream en vivo de categorías (para UI reactiva).
  Stream<List<CategoriaData>> observar() {
    return (_db.select(_db.categoria)
          ..orderBy([(t) => OrderingTerm(expression: t.orden)]))
        .watch();
  }

  /// Siguiente valor de orden (máximo + 1).
  Future<int> _siguienteOrden() async {
    final maxExpr = _db.categoria.orden.max();
    final row = await (_db.selectOnly(_db.categoria)..addColumns([maxExpr]))
        .getSingle();
    return (row.read(maxExpr) ?? 0) + 1;
  }

  /// Inserta una nueva categoría.
  Future<int> insertar({
    required String nombre,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final categoriaUuid = const Uuid().v4();
    final orden = await _siguienteOrden();

    final id = await _db.into(_db.categoria).insert(
          CategoriaCompanion.insert(
            uuid: categoriaUuid,
            nombre: nombre,
            orden: orden,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: ahora,
            fechaActualizacion: ahora,
          ),
        );

    // Outbox
    await encolarSync(_db,
        coleccion: 'categorias',
        docId: categoriaUuid,
        payload: {
          'nombre': nombre,
          'orden': orden,
          'usuarioId': usuarioId,
          'usuarioNombre': usuarioNombre,
          'fechaCreacion': ahora,
          'fechaActualizacion': ahora,
        });

    // Movimiento crítico
    await registrarMovimiento(
      _db,
      usuarioId: usuarioId,
      usuarioNombre: usuarioNombre,
      accion: AccionesAuditoria.categoriaCreada,
      detalles: nombre,
    );

    _logger.i('✅ Categoría creada: $nombre');
    return id;
  }

  /// Actualiza el nombre de una categoría.
  /// Si el nombre cambia, actualiza todos los productos que tenían el nombre viejo.
  Future<bool> actualizar({
    required int id,
    required String nombre,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final anterior = await (_db.select(_db.categoria)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    final ahora = DateTime.now().millisecondsSinceEpoch;
    final filas = await (_db.update(_db.categoria)
          ..where((t) => t.id.equals(id)))
        .write(CategoriaCompanion(
      nombre: Value(nombre),
      fechaActualizacion: Value(ahora),
    ));

    if (filas > 0 && anterior != null) {
      // Si el nombre cambió, actualizar productos
      if (anterior.nombre != nombre) {
        await (_db.update(_db.producto)
              ..where((t) => t.categoria.equals(anterior.nombre)))
            .write(ProductoCompanion(categoria: Value(nombre)));

        _logger.i('🔄 Productos actualizados: ${anterior.nombre} → $nombre');
      }

      // Outbox
      await encolarSync(_db,
          coleccion: 'categorias',
          docId: anterior.uuid,
          operacion: 'update',
          payload: {
            'nombre': nombre,
            'orden': anterior.orden,
            'fechaActualizacion': ahora,
          });

      // Movimiento crítico
      await registrarMovimiento(
        _db,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        accion: AccionesAuditoria.categoriaActualizada,
        detalles: '${anterior.nombre} → $nombre',
      );
    }

    return filas > 0;
  }

  /// Elimina una categoría. Los productos quedan sin categoría (null).
  Future<bool> eliminar({
    required int id,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final categoria = await (_db.select(_db.categoria)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (categoria == null) return false;

    final filas =
        await (_db.delete(_db.categoria)..where((t) => t.id.equals(id))).go();

    if (filas > 0) {
      // Quitar referencia en productos (busca por nombre, no por ID)
      await (_db.update(_db.producto)
            ..where((t) => t.categoria.equals(categoria.nombre)))
          .write(const ProductoCompanion(categoria: Value(null)));

      // Outbox delete
      await encolarSync(_db,
          coleccion: 'categorias',
          docId: categoria.uuid,
          operacion: 'delete',
          payload: {});

      // Movimiento crítico
      await registrarMovimiento(
        _db,
        usuarioId: usuarioId,
        usuarioNombre: usuarioNombre,
        accion: AccionesAuditoria.categoriaEliminada,
        detalles: categoria.nombre,
      );

      _logger.i('🗑️ Categoría eliminada: ${categoria.nombre}');
    }

    return filas > 0;
  }
}

final categoriaDaoProvider = Provider<CategoriaDao>((ref) {
  return CategoriaDao(ref.watch(databaseProvider));
});
