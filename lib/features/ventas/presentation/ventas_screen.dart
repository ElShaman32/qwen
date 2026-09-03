import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:el_cuaderno_de_mario/core/utils/plataforma.dart';
import 'package:el_cuaderno_de_mario/core/widgets/logout_button.dart';
import 'package:el_cuaderno_de_mario/features/ventas/data/caja_requerida_provider.dart'
    show debeExigirCajaProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/sync_service.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/ui/precio_display.dart';
import '../../inventario/data/producto_dao.dart';
import 'carrito_notifier.dart';
import 'widgets/carrito_panel.dart';
import 'widgets/dialogo_peso.dart';
import 'widgets/producto_pos_card.dart';
import 'widgets/producto_pos_row.dart';

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
    final tasa = ref.watch(appConfigProvider).tasaEfectiva;
    final debeBloquearAsync = ref.watch(debeExigirCajaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history),
            tooltip: 'Historial de ventas',
            onPressed: () => context.push(AppRoutes.ventasHistorial),
          ),
          const LogoutButton(),
        ],
      ),
      body: Column(
        children: [
          debeBloquearAsync.whenOrNull(
                data: (debe) =>
                    debe ? const _BannerCajaCerrada() : const SizedBox.shrink(),
              ) ??
              const SizedBox.shrink(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
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
                return _buildProductos(ref);
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          (items.isEmpty || MediaQuery.of(context).size.width > 900)
              ? null
              : FloatingActionButton.extended(
                  onPressed: () => _irAlCarrito(context, ref),
                  icon: const Icon(LucideIcons.shoppingCart),
                  label: Text('${items.length} · ${Formato.bs(total * tasa)}'),
                ),
    );
  }

  Widget _buildProductos(WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final productosAsync = ref.watch(posProductosProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: _camaraActiva ? _buildCamaraInline() : _buildBusqueda(),
        ),
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
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.packageSearch,
                                size: 48,
                                color: Theme.of(context).colorScheme.outline),
                            const SizedBox(height: 8),
                            Text(
                              _query.isEmpty
                                  ? 'No hay productos activos'
                                  : 'Sin resultados para "$_query"',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                            ),
                          ],
                        ),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
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

                        return GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220,
                            childAspectRatio: 0.80,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
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

  Future<void> _onProductoTap(
    BuildContext context,
    WidgetRef ref,
    ProductoData producto,
  ) async {
    final debeBloquear = ref.read(debeExigirCajaProvider).value ?? false;
    if (debeBloquear) {
      _snackbar(context, 'Abre tu caja antes de vender');
      return;
    }

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

  void _irAlCarrito(BuildContext context, WidgetRef ref) {
    final debeBloquear = ref.read(debeExigirCajaProvider).value ?? false;
    if (debeBloquear) {
      _snackbar(context, 'Abre tu caja antes de cobrar');
      return;
    }
    context.push(AppRoutes.ventasCarrito);
  }

  void _toggleCamara() {
    setState(() {
      _camaraActiva = !_camaraActiva;
      _scannerController ??= MobileScannerController();
    });
  }

  Widget _buildBusqueda() {
    final s = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: s.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: s.outlineVariant.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: s.onSurfaceVariant, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              autofocus: !esMovil(),
              decoration: const InputDecoration(
                hintText: 'Buscar producto o código...',
                border: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase().trim()),
            ),
          ),
          if (esMovil())
            FilledButton.icon(
              onPressed: _toggleCamara,
              icon: const Icon(LucideIcons.scanBarcode, size: 18),
              label: const Text('Escanear'),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                shape: const StadiumBorder(),
                minimumSize: const Size(0, 40),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCamaraInline() {
    final s = Theme.of(context).colorScheme;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            MobileScanner(
              controller: _scannerController!,
              onDetect: _onDetectInline,
            ),
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: _CircleAction(
                icon: LucideIcons.flashlight,
                onTap: () => _scannerController?.toggleTorch(),
              ),
            ),
            if (_estadoScan != null)
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Icon(
                    _estadoScan! ? LucideIcons.check : LucideIcons.x,
                    color: _estadoScan! ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ),
              ),
            Positioned(
              bottom: 8,
              right: 8,
              child: _CircleAction(
                icon: LucideIcons.x,
                color: s.error,
                onTap: _toggleCamara,
              ),
            ),
            Positioned(
              top: 12,
              left: 52,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: s.primary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Escaneando...',
                  style: TextStyle(
                      color: s.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
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

  Widget _listaEscaneados() {
    final carrito = ref.watch(carritoProvider);
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final tasa = ref.read(appConfigProvider).tasaEfectiva;

    if (carrito.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.scanBarcode,
                  size: 52, color: s.outline.withValues(alpha: 0.7)),
              const SizedBox(height: 12),
              Text('Escanea un código',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Los productos aparecerán aquí automáticamente',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: s.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    final totalUsd = ref.read(carritoProvider.notifier).totalUsd(carrito);
    final totalBs = totalUsd * tasa;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      children: [
        for (final item in carrito)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: s.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: s.outlineVariant.withValues(alpha: 0.4)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: s.primary.withValues(alpha: 0.12),
                  ),
                  child: Icon(LucideIcons.package, color: s.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.producto.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        item.producto.esGranel
                            ? '${Formato.numero(item.cantidad, decimales: 2)} ${item.producto.unidadMedida ?? 'kg'}'
                            : '${item.cantidad.toInt()} und',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: s.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                PrecioDisplay(
                  precioUsd: item.subtotalUsd,
                  tasa: tasa,
                  bsDominante: true,
                  compacto: true,
                ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        FilledButton.icon(
          onPressed: () => _irAlCarrito(context, ref),
          icon: const Icon(LucideIcons.arrowRight, size: 20),
          label: Text('Ir al carrito (${Formato.bs(totalBs)})'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            shape: const StadiumBorder(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS PRIVADOS (solo los que NO son reutilizables)
// ─────────────────────────────────────────────────────────────

/// Botón circular flotante sobre la cámara.
class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: color ?? Colors.black87),
        ),
      ),
    );
  }
}

/// Banner de caja cerrada.
class _BannerCajaCerrada extends StatelessWidget {
  const _BannerCajaCerrada();

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: s.errorContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: s.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: s.error.withValues(alpha: 0.15),
            ),
            child: Icon(LucideIcons.alertTriangle,
                color: s.onErrorContainer, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Debes abrir tu caja antes de vender',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: s.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.caja),
            style: TextButton.styleFrom(
              foregroundColor: s.onErrorContainer,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Abrir caja'),
          ),
        ],
      ),
    );
  }
}
