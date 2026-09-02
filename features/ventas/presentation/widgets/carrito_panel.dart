import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config_notifier.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/formato.dart';
import '../carrito_notifier.dart';
import 'dialogo_peso.dart';

/// Panel del carrito. Se usa como columna lateral (Windows)
/// y como pantalla completa (móvil/tablet).
class CarritoPanel extends ConsumerWidget {
  const CarritoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(carritoProvider);
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    final total = items.fold(0.0, (acc, i) => acc + i.subtotalUsd);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'Carrito vacío',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toca los productos para agregarlos',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Lista de items
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildItem(context, ref, item);
              },
            ),
          ),

          // Totales
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: theme.textTheme.titleMedium),
                    Text(
                      Formato.usd(total),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasa: ${Formato.numero(config.tasaEfectiva, decimales: 2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      Formato.bs(total * config.tasaEfectiva),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Acciones
          Row(
            children: [
              TextButton.icon(
                onPressed: () => ref.read(carritoProvider.notifier).limpiar(),
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Vaciar'),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.push(AppRoutes.ventasCobro),
                icon: const Icon(Icons.payments),
                label: const Text('¡Dale! Cobrar'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(160, 52),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, WidgetRef ref, ItemCarrito item) {
    final theme = Theme.of(context);
    final notifier = ref.read(carritoProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Nombre + subtotal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.producto.nombre,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item.cantidadLabel} × ${Formato.usd(item.producto.precioUsd)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
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
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => notifier.disminuir(item.producto),
            ),
            Text(
              '${item.cantidad.toInt()}',
              style: theme.textTheme.titleSmall,
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                final ok = notifier.agregarUno(item.producto);
                if (!ok) _snackbar(context, 'No hay más existencia disponible');
              },
            ),
          ],

          // Subtotal
          SizedBox(
            width: 80,
            child: Text(
              Formato.usd(item.subtotalUsd),
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Quitar
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.close, size: 18, color: theme.colorScheme.error),
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
