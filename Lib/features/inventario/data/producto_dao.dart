import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

/// DAO de productos. Maneja todas las operaciones CRUD contra Drift.
class ProductoDao {
  final AppDatabase _db;

  ProductoDao(this._db);

  /// Obtiene todos los productos activos, ordenados por nombre.
  Future<List<ProductoData>> obtenerTodos() {
    return (_db.select(_db.producto)
          ..where((t) => t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.nombre)]))
        .get();
  }

  /// Busca productos por nombre o código (búsqueda local).
  Future<List<ProductoData>> buscar(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return obtenerTodos();

    return (_db.select(_db.producto)
          ..where((t) =>
              t.activo.equals(true) &
              (t.nombre.lower().like('%$q%') | t.codigo.lower().like('%$q%')))
          ..orderBy([(t) => OrderingTerm(expression: t.nombre)]))
        .get();
  }

  /// Obtiene un producto por ID.
  Future<ProductoData?> obtenerPorId(int id) {
    return (_db.select(_db.producto)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Obtiene productos con stock bajo (stock <= stockMinimo).
  Future<List<ProductoData>> obtenerStockBajo() {
    return (_db.select(_db.producto)
          ..where((t) =>
              t.activo.equals(true) &
              const CustomExpression<bool>('stock <= stock_minimo'))
          ..orderBy([(t) => OrderingTerm(expression: t.stock)]))
        .get();
  }

  /// Inserta un nuevo producto.
  Future<int> insertar(ProductoCompanion companion) async {
    final id = await _db.into(_db.producto).insert(companion);
    final creado = await obtenerPorId(id);
    if (creado != null) {
      await encolarSync(_db,
          coleccion: 'inventario',
          docId: creado.uuid,
          payload: payloadProducto(creado));
    }
    return id;
  }

  /// Actualiza un producto existente.
  Future<bool> actualizar(int id, ProductoCompanion companion) async {
    final filas = await (_db.update(_db.producto)
          ..where((t) => t.id.equals(id)))
        .write(companion);
    if (filas > 0) {
      final actualizado = await obtenerPorId(id);
      if (actualizado != null) {
        await encolarSync(_db,
            coleccion: 'inventario',
            docId: actualizado.uuid,
            payload: payloadProducto(actualizado));
      }
    }
    return filas > 0;
  }

  /// Soft delete: marca como inactivo.
  Future<bool> desactivar(int id) async {
    final filas = await (_db.update(_db.producto)
          ..where((t) => t.id.equals(id)))
        .write(const ProductoCompanion(activo: Value(false)));
    if (filas > 0) {
      final actualizado = await obtenerPorId(id);
      if (actualizado != null) {
        await encolarSync(_db,
            coleccion: 'inventario',
            docId: actualizado.uuid,
            payload: payloadProducto(actualizado));
      }
    }
    return filas > 0;
  }

  /// Cuenta total de productos activos (para límite de plan gratis).
  Future<int> contarActivos() async {
    final count = _db.producto.id.count();
    final query = _db.selectOnly(_db.producto)
      ..addColumns([count])
      ..where(_db.producto.activo.equals(true));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}

final productoDaoProvider = Provider<ProductoDao>((ref) {
  final db = ref.watch(databaseProvider);
  return ProductoDao(db);
});
