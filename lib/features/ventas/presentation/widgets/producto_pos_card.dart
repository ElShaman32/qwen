import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/widgets/ui/precio_display.dart';
import '../../../../core/widgets/ui/stock_chip.dart';

/// Card de producto en grid (tablet/desktop > 600px).
/// Bs dominante, stock semáforo, iconos Lucide.
class ProductoPosCard extends StatelessWidget {
  final ProductoData producto;
  final double tasa;
  final VoidCallback onTap;

  const ProductoPosCard({
    super.key,
    required this.producto,
    required this.tasa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final agotado = producto.stock <= 0;

    return Material(
      color: s.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: agotado ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: s.outlineVariant.withValues(alpha: 0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: s.primary.withValues(alpha: 0.10),
                    ),
                    child:
                        Icon(LucideIcons.package, color: s.primary, size: 20),
                  ),
                  const Spacer(),
                  if (producto.codigo != null && producto.codigo!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: s.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        producto.codigo!,
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: s.onSurfaceVariant,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                producto.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700, height: 1.2),
              ),
              const SizedBox(height: 6),
              StockChip(
                stock: producto.stock,
                esGranel: producto.esGranel,
                unidad: producto.unidadMedida,
              ),
              const Spacer(),
              PrecioDisplay(
                precioUsd: producto.precioUsd,
                tasa: tasa,
                bsDominante: true,
                alineacion: CrossAxisAlignment.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
