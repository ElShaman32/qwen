import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:el_cuaderno_de_mario/core/utils/plataforma.dart';
import 'package:el_cuaderno_de_mario/core/widgets/logout_button.dart';
import 'package:el_cuaderno_de_mario/features/ventas/presentation/widgets/producto_pos_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  bool _camaraActiva = false;
  MobileScannerController? _scannerController;
  final AudioPlayer _player = AudioPlayer();
  bool? _estadoScan;
  bool _procesandoScan = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _scannerController?.dispose();
    _player.dispose();
    _resetTimer?.cancel();
    super.dispose();
  }

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
          child: _camaraActiva ? _buildCamaraInline() : _buildBusqueda(),
        ),

        // Grid de productos
        Expanded(
          child: _camaraActiva
              ? _listaEscaneados()
              : productosAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
                                onTap: () =>
                                    _onProductoTap(context, ref, producto),
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
                              onTap: () =>
                                  _onProductoTap(context, ref, producto),
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

  void _toggleCamara() {
    setState(() {
      _camaraActiva = !_camaraActiva;
      _scannerController ??= MobileScannerController();
    });
  }

  Widget _buildBusqueda() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar o escanear código...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            onChanged: (v) => setState(() => _query = v.toLowerCase().trim()),
          ),
        ),
        if (esMovil()) ...[
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: 'Escanear con cámara',
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _toggleCamara,
          ),
        ],
      ],
    );
  }

  /// Cámara compacta arriba; abajo queda libre para listar lo escaneado.
  Widget _buildCamaraInline() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MobileScanner(
              controller: _scannerController!,
              onDetect: _onDetectInline,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton.filled(
              tooltip: 'Linterna',
              icon: const Icon(Icons.flashlight_on),
              onPressed: () => _scannerController?.toggleTorch(),
            ),
          ),
          if (_estadoScan != null)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  _estadoScan! ? Icons.check_circle : Icons.cancel,
                  color: _estadoScan! ? Colors.green : Colors.red,
                ),
              ),
            ),
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton.filled(
              tooltip: 'Cerrar cámara',
              icon: const Icon(Icons.close),
              onPressed: _toggleCamara,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDetectInline(BarcodeCapture capture) async {
    if (_procesandoScan) return;
    final codigo =
        capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (codigo == null || codigo.isEmpty) return;

    _procesandoScan = true;
    HapticFeedback.heavyImpact();
    try {
      await _player.play(AssetSource('sonidos/beep_escaner.mp3'));
    } catch (_) {}

    final dao = ref.read(productoDaoProvider);
    final productos = await dao.buscar(codigo);
    final producto = productos.isNotEmpty
        ? productos.firstWhere(
            (p) => (p.codigo ?? '').toLowerCase() == codigo.toLowerCase(),
            orElse: () => productos.first,
          )
        : null;

    var ok = false;
    if (producto != null) {
      final carrito = ref.read(carritoProvider.notifier);
      ok = producto.esGranel
          ? carrito.agregarGranel(producto, 1.0)
          : carrito.agregarUno(producto);
    }

    if (mounted) setState(() => _estadoScan = ok);
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 900), () {
      _procesandoScan = false;
      if (mounted) setState(() => _estadoScan = null);
    });
  }

  /// Lista en vivo de lo escaneado (el carrito actual).
  Widget _listaEscaneados() {
    final carrito = ref.watch(carritoProvider);
    final theme = Theme.of(context);

    if (carrito.isEmpty) {
      return Center(
        child: Text(
          'Escanea un código y aquí se va armando la venta',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final total = ref.read(carritoProvider.notifier).totalUsd(carrito);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        for (final item in carrito)
          Card(
            child: ListTile(
              dense: true,
              title: Text(item.producto.nombre),
              subtitle: Text(item.producto.esGranel
                  ? '${Formato.numero(item.cantidad, decimales: 2)} ${item.producto.unidadMedida ?? 'kg'}'
                  : '${item.cantidad.toInt()} und'),
              trailing: Text(Formato.usd(item.subtotalUsd)),
            ),
          ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.ventasCarrito),
          icon: const Icon(Icons.shopping_cart_checkout),
          label: Text('Ir al carrito (${Formato.usd(total)})'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
      ],
    );
  }
}
