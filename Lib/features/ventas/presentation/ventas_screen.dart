import 'package:el_cuaderno_de_mario/core/widgets/logout_button.dart';
import 'package:el_cuaderno_de_mario/core/widgets/scanner_dialog.dart';
import 'package:el_cuaderno_de_mario/features/ventas/presentation/widgets/producto_pos_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/sync_service.dart';
import '../../../core/utils/formato.dart';
import '../../inventario/data/producto_dao.dart';
import 'carrito_notifier.dart';
import 'widgets/carrito_panel.dart';
import 'widgets/dialogo_peso.dart';
import 'widgets/producto_pos_card.dart';

/// Productos activos para el POS.
final posProductosProvider = FutureProvider<List<ProductoData>>((ref) {
  ref.watch(syncRefreshProvider);
  return ref.watch(productoDaoProvider).obtenerTodos();
});

/// Pantalla de ventas.
/// Windows (>900px): dividida 40/60 (productos | carrito).
/// Móvil/Tablet: productos + FAB que abre el carrito.
class VentasScreen extends ConsumerStatefulWidget {
  const VentasScreen({super.key});

  @override
  ConsumerState<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends ConsumerState<VentasScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(carritoProvider);
    final total = items.fold(0.0, (acc, i) => acc + i.subtotalUsd);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial de ventas',
            onPressed: () => context.push(AppRoutes.ventasHistorial),
          ),
          const LogoutButton(),
        ],
      ),
      floatingActionButton: items.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.ventasCarrito),
              icon: const Icon(Icons.shopping_cart),
              label: Text('${items.length} · ${Formato.usd(total)}'),
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Windows: layout POS 40/60
          if (constraints.maxWidth > 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: _buildProductos(ref)),
                const VerticalDivider(width: 1),
                const Expanded(flex: 3, child: CarritoPanel()),
              ],
            );
          }
          // Móvil/Tablet: solo productos (carrito en FAB)
          return _buildProductos(ref);
        },
      ),
    );
  }

  Widget _buildProductos(WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final productosAsync = ref.watch(posProductosProvider);

    return Column(
      children: [
        // Búsqueda siempre visible (POS necesita rapidez)
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar o escanear código...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                  ),
                  onChanged: (v) =>
                      setState(() => _query = v.toLowerCase().trim()),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Escanear código',
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () => _escanearProducto(context, ref),
              ),
            ],
          ),
        ),

        // Grid de productos
        Expanded(
          child: productosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (productos) {
              final filtrados = _query.isEmpty
                  ? productos
                  : productos
                      .where((p) =>
                          p.nombre.toLowerCase().contains(_query) ||
                          (p.codigo ?? '').toLowerCase().contains(_query))
                      .toList();

              if (filtrados.isEmpty) {
                return const Center(child: Text('Sin resultados'));
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Teléfonos (<600px): lista compacta, más práctica.
                  if (constraints.maxWidth < 600) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: filtrados.length,
                      itemBuilder: (context, index) {
                        final producto = filtrados[index];
                        return ProductoPosRow(
                          producto: producto,
                          tasa: config.tasaEfectiva,
                          onTap: () => _onProductoTap(context, ref, producto),
                        );
                      },
                    );
                  }

                  // Escritorio/tablet ancha: grid.
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filtrados.length,
                    itemBuilder: (context, index) {
                      final producto = filtrados[index];
                      return ProductoPosCard(
                        producto: producto,
                        tasa: config.tasaEfectiva,
                        onTap: () => _onProductoTap(context, ref, producto),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Al tocar un producto: normal suma 1, granel pide peso.
  Future<void> _onProductoTap(
    BuildContext context,
    WidgetRef ref,
    ProductoData producto,
  ) async {
    final notifier = ref.read(carritoProvider.notifier);

    if (producto.esGranel) {
      final peso = await showDialogoPeso(context, producto);
      if (peso != null && peso > 0) {
        final ok = notifier.agregarGranel(producto, peso);
        if (!ok && context.mounted) {
          _snackbar(context, 'No hay más existencia disponible');
        }
      }
      return;
    }

    final ok = notifier.agregarUno(producto);
    if (!ok) _snackbar(context, 'No hay más existencia disponible');
  }

  void _snackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _escanearProducto(BuildContext context, WidgetRef ref) async {
    await mostrarEscanerContinuo(
      context,
      onCodigo: (codigo) async {
        final dao = ref.read(productoDaoProvider);
        final productos = await dao.buscar(codigo);
        final producto = productos.firstWhere(
          (p) => (p.codigo ?? '').toLowerCase() == codigo.toLowerCase(),
          orElse: () => productos.first,
        );

        if (productos.isEmpty) return false;

        final carrito = ref.read(carritoProvider.notifier);
        if (producto.esGranel) {
          // Para granel, agrega 1 kg por defecto (el cajero ajusta después)
          return carrito.agregarGranel(producto, 1.0);
        } else {
          return carrito.agregarUno(producto);
        }
      },
    );
  }
}
