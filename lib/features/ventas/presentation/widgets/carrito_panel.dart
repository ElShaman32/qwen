import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/config/app_config_notifier.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/formato.dart';
import '../../../../core/widgets/ui/precio_display.dart';
import '../carrito_notifier.dart';
import 'dialogo_peso.dart';

/// Panel del carrito. Se usa como columna lateral (Windows)
/// y como pantalla completa (móvil/tablet).
/// Bs dominante en totales y líneas.
class CarritoPanel extends ConsumerWidget {
  const CarritoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(carritoProvider);
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);
    final s = theme.colorScheme;

    final totalUsd = items.fold(0.0, (acc, i) => acc + i.subtotalUsd);
    final totalBs = totalUsd * config.tasaEfectiva;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.shoppingCart,
                  size: 56, color: s.outline.withValues(alpha: 0.6)),
              const SizedBox(height: 12),
              Text(
                'Carrito vacío',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Toca los productos para agregarlos',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: s.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Lista de items ────────────────────────────────────
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                  height: 1, color: s.outlineVariant.withValues(alpha: 0.4)),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildItem(context, ref, item, config.tasaEfectiva);
              },
            ),
          ),

          // ── Totales: Bs dominante ─────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: s.outlineVariant.withValues(alpha: 0.5)),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formato.bs(totalBs),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: s.onSurface,
                          ),
                        ),
                        Text(
                          Formato.usd(totalUsd),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: s.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tasa: Bs.${Formato.numero(config.tasaEfectiva, decimales: 2)}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: s.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),

          // ── Acciones ──────────────────────────────────────────
          Row(
            children: [
              TextButton.icon(
                onPressed: () => ref.read(carritoProvider.notifier).limpiar(),
                icon: const Icon(LucideIcons.trash2, size: 18),
                label: const Text('Vaciar'),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.ventasCobro),
                icon: const Icon(LucideIcons.wallet, size: 20),
                label: const Text('¡Dale! Cobrar'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(160, 52),
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, WidgetRef ref, ItemCarrito item, double tasa) {
    final theme = Theme.of(context);
    final s = theme.colorScheme;
    final notifier = ref.read(carritoProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Icono del producto
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: s.primary.withValues(alpha: 0.10),
            ),
            child: Icon(LucideIcons.package, color: s.primary, size: 18),
          ),
          const SizedBox(width: 10),

          // Nombre + detalle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.producto.nombre,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item.cantidadLabel} × ${Formato.bs(item.producto.precioUsd * tasa)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: s.onSurfaceVariant),
                ),
              ],
            ),
          ),

          // Controles de cantidad
          if (item.producto.esGranel)
            TextButton(
              onPressed: () async {
                final peso = await showDialogoPeso(
                  context,
                  item.producto,
                  inicial: item.cantidad,
                );
                if (peso != null) {
                  final ok = notifier.editarGranel(item.producto, peso);
                  if (!ok && context.mounted) {
                    _snackbar(context, 'No hay más existencia disponible');
                  }
                }
              },
              child: const Text('Editar'),
            )
          else ...[
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(LucideIcons.minusCircle,
                  size: 20, color: s.onSurfaceVariant),
              onPressed: () => notifier.disminuir(item.producto),
            ),
            Text('${item.cantidad.toInt()}',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(LucideIcons.plusCircle, size: 20, color: s.primary),
              onPressed: () {
                final ok = notifier.agregarUno(item.producto);
                if (!ok) _snackbar(context, 'No hay más existencia disponible');
              },
            ),
          ],

          // Subtotal: Bs dominante
          SizedBox(
            width: 90,
            child: PrecioDisplay(
              precioUsd: item.subtotalUsd,
              tasa: tasa,
              bsDominante: true,
              compacto: true,
            ),
          ),

          // Quitar
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(LucideIcons.x, size: 16, color: s.error),
            onPressed: () => notifier.quitar(item.producto.id),
          ),
        ],
      ),
    );
  }

  void _snackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: const Duration(seconds: 2)),
    );
  }
}
