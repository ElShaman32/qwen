import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../../inventario/data/producto_dao.dart';
import '../data/proveedor_dao.dart';

/// Diálogo para registrar una compra a un proveedor.
/// Permite agregar items (producto, cantidad, costo unitario).
class DialogoCompra extends ConsumerStatefulWidget {
  final ProveedorData proveedor;

  const DialogoCompra({super.key, required this.proveedor});

  @override
  ConsumerState<DialogoCompra> createState() => _DialogoCompraState();
}

class _DialogoCompraState extends ConsumerState<DialogoCompra> {
  final _facturaController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _costoController = TextEditingController();

  String _metodoPago = 'credito';
  final List<ItemCompra> _items = [];
  ProductoData? _productoSeleccionado;
  bool _guardando = false;

  double get _total => _items.fold(0.0, (acc, i) => acc + i.subtotalUsd);

  @override
  void dispose() {
    _facturaController.dispose();
    _cantidadController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  Future<void> _agregarItem() async {
    if (_productoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un producto')),
      );
      return;
    }

    final cantidad =
        double.tryParse(_cantidadController.text.trim().replaceAll(',', '.'));
    final costo =
        double.tryParse(_costoController.text.trim().replaceAll(',', '.'));

    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad inválida')),
      );
      return;
    }

    if (costo == null || costo < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Costo inválido')),
      );
      return;
    }

    final item = ItemCompra(
      productoId: _productoSeleccionado!.id,
      productoNombre: _productoSeleccionado!.nombre,
      cantidad: cantidad,
      costoUnitarioUsd: costo,
      subtotalUsd: cantidad * costo,
    );

    setState(() {
      _items.add(item);
      _productoSeleccionado = null;
      _cantidadController.clear();
      _costoController.clear();
    });
  }

  Future<void> _guardar() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un item')),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final user = ref.read(currentUserProvider).value;
      final dao = ref.read(proveedorDaoProvider);

      final exito = await dao.registrarCompra(
        proveedorId: widget.proveedor.id,
        numeroFactura: _facturaController.text.trim().isEmpty
            ? null
            : _facturaController.text.trim(),
        items: _items,
        metodoPago: _metodoPago,
        usuarioId: user?.uid ?? '',
        usuarioNombre: user?.nombre ?? 'Admin',
      );

      if (!mounted) return;
      setState(() => _guardando = false);

      if (exito) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Chévere! Compra registrada')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar la compra')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text('Registrar compra a ${widget.proveedor.nombre}'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Número de factura
              TextField(
                controller: _facturaController,
                decoration: const InputDecoration(
                  labelText: 'Número de factura (opcional)',
                  hintText: 'Ej: F-001234',
                ),
              ),
              const SizedBox(height: 16),

              // Método de pago
              Text('Método de pago', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _metodoPago,
                decoration: const InputDecoration(labelText: 'Método de pago'),
                items: const [
                  DropdownMenuItem(value: 'credito', child: Text('Crédito')),
                  DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                  DropdownMenuItem(
                      value: 'transferencia', child: Text('Transferencia')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _metodoPago = v);
                },
              ),
              const SizedBox(height: 16),

              // Selector de producto
              Text('Agregar item', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              FutureBuilder<List<ProductoData>>(
                future: ref.watch(productoDaoProvider).obtenerTodos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final productos = snapshot.data ?? [];
                  return DropdownButtonFormField<ProductoData>(
                    initialValue: _productoSeleccionado,
                    decoration: const InputDecoration(labelText: 'Producto'),
                    items: productos.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.nombre, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _productoSeleccionado = v),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Cantidad y costo
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cantidadController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Ej: 10',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _costoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Costo unitario (\$)',
                        hintText: 'Ej: 2.50',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _agregarItem,
                    icon: const Icon(Icons.add_circle),
                    tooltip: 'Agregar item',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Lista de items
              if (_items.isNotEmpty) ...[
                Text('Items agregados', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                ..._items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      dense: true,
                      title: Text(item.productoNombre),
                      subtitle: Text(
                        '${Formato.numero(item.cantidad)} × ${Formato.usd(item.costoUnitarioUsd)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            Formato.usd(item.subtotalUsd),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () =>
                                setState(() => _items.removeAt(index)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Text(
                  'Total: ${Formato.usd(_total)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('¡Listo! Registrar'),
        ),
      ],
    );
  }
}
