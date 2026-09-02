import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';

/// Item en el carrito de venta.
class ItemCarrito {
  final ProductoData producto;
  final double cantidad;

  const ItemCarrito({required this.producto, required this.cantidad});

  double get subtotalUsd => producto.precioUsd * cantidad;

  String get cantidadLabel => producto.esGranel
      ? '${Formato.numero(cantidad, decimales: 2)} ${producto.unidadMedida ?? 'kg'}'
      : '${cantidad.toInt()} und';
}

/// Estado global del carrito mientras dura la venta.
final carritoProvider =
    NotifierProvider<CarritoNotifier, List<ItemCarrito>>(CarritoNotifier.new);

class CarritoNotifier extends Notifier<List<ItemCarrito>> {
  @override
  List<ItemCarrito> build() => [];

  double totalUsd(List<ItemCarrito> items) =>
      items.fold(0.0, (acc, i) => acc + i.subtotalUsd);

  ItemCarrito? _obtener(int productoId) {
    for (final i in state) {
      if (i.producto.id == productoId) return i;
    }
    return null;
  }

  /// Agrega +1 unidad (producto normal). False si no hay existencia.
  bool agregarUno(ProductoData producto) {
    final actual = _obtener(producto.id)?.cantidad ?? 0;
    if (actual + 1 > producto.stock) return false;
    _setCantidad(producto, actual + 1);
    return true;
  }

  /// Agrega granel con peso exacto. False si excede existencia.
  bool agregarGranel(ProductoData producto, double peso) {
    final actual = _obtener(producto.id)?.cantidad ?? 0;
    if (actual + peso > producto.stock) return false;
    _setCantidad(producto, actual + peso);
    return true;
  }

  /// Reemplaza la cantidad (edición de granel). 0 o menos lo quita.
  bool editarGranel(ProductoData producto, double nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      quitar(producto.id);
      return true;
    }
    if (nuevaCantidad > producto.stock) return false;
    _setCantidad(producto, nuevaCantidad);
    return true;
  }

  bool disminuir(ProductoData producto) {
    final actual = _obtener(producto.id)?.cantidad ?? 0;
    if (actual <= 1) {
      quitar(producto.id);
      return true;
    }
    _setCantidad(producto, actual - 1);
    return true;
  }

  void quitar(int productoId) {
    state = [
      for (final i in state)
        if (i.producto.id != productoId) i
    ];
  }

  void limpiar() => state = [];

  void _setCantidad(ProductoData producto, double cantidad) {
    final idx = state.indexWhere((i) => i.producto.id == producto.id);
    if (idx >= 0) {
      state = [...state]..[idx] =
          ItemCarrito(producto: producto, cantidad: cantidad);
    } else {
      state = [...state, ItemCarrito(producto: producto, cantidad: cantidad)];
    }
  }
}
