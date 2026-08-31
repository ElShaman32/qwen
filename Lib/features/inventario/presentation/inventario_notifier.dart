import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../data/producto_dao.dart';

/// Datos del formulario de producto.
class ProductoFormData {
  final String nombre;
  final String? codigo;
  final String? categoria;
  final double precioUsd;
  final double costoUsd;
  final double? precioMayor;
  final bool exentoIva;
  final double stock;
  final bool esGranel;
  final String? unidadMedida;
  final int? fechaVencimiento;
  final int stockMinimo;

  const ProductoFormData({
    required this.nombre,
    this.codigo,
    this.categoria,
    required this.precioUsd,
    this.precioMayor,
    this.costoUsd = 0,
    this.exentoIva = false,
    required this.stock,
    this.esGranel = false,
    this.unidadMedida,
    this.fechaVencimiento,
    this.stockMinimo = 5,
  });
}

/// Estado del inventario: lista de productos + búsqueda.
class InventarioState {
  final List<ProductoData> productos;
  final String busqueda;
  final bool cargando;
  final String? error;

  const InventarioState({
    this.productos = const [],
    this.busqueda = '',
    this.cargando = false,
    this.error,
  });

  InventarioState copyWith({
    List<ProductoData>? productos,
    String? busqueda,
    bool? cargando,
    String? error,
  }) {
    return InventarioState(
      productos: productos ?? this.productos,
      busqueda: busqueda ?? this.busqueda,
      cargando: cargando ?? this.cargando,
      error: error,
    );
  }
}

final inventarioProvider =
    NotifierProvider<InventarioNotifier, InventarioState>(
        InventarioNotifier.new);

class InventarioNotifier extends Notifier<InventarioState> {
  static const _uuid = Uuid();

  @override
  InventarioState build() {
    ref.watch(syncRefreshProvider);
    _cargarProductos();
    return const InventarioState(cargando: true);
  }

  Future<void> _cargarProductos() async {
    try {
      final dao = ref.read(productoDaoProvider);
      final productos = await dao.obtenerTodos();
      state = state.copyWith(productos: productos, cargando: false);
    } catch (e) {
      state = state.copyWith(cargando: false, error: e.toString());
    }
  }

  /// Actualiza el filtro de búsqueda y recarga.
  Future<void> buscar(String query) async {
    state = state.copyWith(busqueda: query);
    try {
      final dao = ref.read(productoDaoProvider);
      final productos = await dao.buscar(query);
      state = state.copyWith(productos: productos);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Crea un nuevo producto.
  Future<bool> crearProducto(ProductoFormData data) async {
    try {
      final dao = ref.read(productoDaoProvider);
      final ahora = DateTime.now().millisecondsSinceEpoch;

      await dao.insertar(ProductoCompanion.insert(
        uuid: _uuid.v4(),
        nombre: data.nombre.trim(),
        codigo: Value(
            data.codigo?.trim().isEmpty == true ? null : data.codigo?.trim()),
        categoria: Value(data.categoria?.trim().isEmpty == true
            ? null
            : data.categoria?.trim()),
        precioUsd: data.precioUsd,
        precioMayor: Value(data.precioMayor),
        costoUsd: Value(data.costoUsd),
        exentoIva: Value(data.exentoIva),
        stock: Value(data.stock),
        esGranel: Value(data.esGranel),
        unidadMedida: Value(data.esGranel ? data.unidadMedida : null),
        fechaVencimiento: Value(data.fechaVencimiento),
        stockMinimo: Value(data.stockMinimo),
        fechaCreacion: ahora,
        fechaActualizacion: ahora,
      ));

      await _cargarProductos();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al crear producto: $e');
      return false;
    }
  }

  /// Actualiza un producto existente.
  Future<bool> actualizarProducto(int id, ProductoFormData data) async {
    try {
      final dao = ref.read(productoDaoProvider);
      final ahora = DateTime.now().millisecondsSinceEpoch;

      await dao.actualizar(
          id,
          ProductoCompanion(
            nombre: Value(data.nombre.trim()),
            codigo: Value(data.codigo?.trim().isEmpty == true
                ? null
                : data.codigo?.trim()),
            categoria: Value(data.categoria?.trim().isEmpty == true
                ? null
                : data.categoria?.trim()),
            precioUsd: Value(data.precioUsd),
            precioMayor: Value(data.precioMayor),
            costoUsd: Value(data.costoUsd),
            exentoIva: Value(data.exentoIva),
            stock: Value(data.stock),
            esGranel: Value(data.esGranel),
            unidadMedida: Value(data.esGranel ? data.unidadMedida : null),
            fechaVencimiento: Value(data.fechaVencimiento),
            stockMinimo: Value(data.stockMinimo),
            fechaActualizacion: Value(ahora),
          ));

      await _cargarProductos();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al actualizar producto: $e');
      return false;
    }
  }

  /// Soft delete de un producto.
  Future<bool> eliminarProducto(int id) async {
    try {
      final dao = ref.read(productoDaoProvider);
      await dao.desactivar(id);
      await _cargarProductos();
      return true;
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar producto: $e');
      return false;
    }
  }
}
