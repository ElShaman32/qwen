import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/widgets/ui/precio_display.dart';
import '../../../../core/widgets/ui/stock_chip.dart';

/// Fila compacta de producto para lista (teléfonos < 600px).
/// Bs dominante, stock semáforo, iconos Lucide.
class ProductoPosRow extends StatelessWidget {
  final ProductoData producto;
  final double tasa;
  final VoidCallback onTap;

  const ProductoPosRow({
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
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: agotado ? null : onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: s.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: s.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: s.primary.withValues(alpha: 0.10),
                ),
                child: Icon(LucideIcons.package, color: s.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            producto.nombre,
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (producto.esGranel)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(LucideIcons.scale,
                                size: 14, color: s.primary),
                          ),
                        if (producto.exentoIva)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(LucideIcons.banknote,
                                size: 14, color: s.onSurfaceVariant),
                          ),
                      ],
                    ),
                    if (producto.codigo != null && producto.codigo!.isNotEmpty)
                      Text(
                        'Cód. ${producto.codigo}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: s.onSurfaceVariant),
                      ),
                    const SizedBox(height: 4),
                    StockChip(
                      stock: producto.stock,
                      esGranel: producto.esGranel,
                      unidad: producto.unidadMedida,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PrecioDisplay(
                precioUsd: producto.precioUsd,
                tasa: tasa,
                bsDominante: true,
                compacto: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
