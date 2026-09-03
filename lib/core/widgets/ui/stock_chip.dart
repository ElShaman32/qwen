import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../utils/formato.dart';

/// Chip semáforo de existencia: agotado (rojo), poco (naranja), disponible (primario).
/// Usado en ProductoPosRow, ProductoPosCard y cualquier lista de productos.
class StockChip extends StatelessWidget {
  const StockChip({
    super.key,
    required this.stock,
    required this.esGranel,
    this.unidad,
  });

  final double stock;
  final bool esGranel;
  final String? unidad;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    final Color color;
    final String texto;
    final IconData icono;

    if (stock <= 0) {
      color = s.error;
      texto = 'Agotado';
      icono = LucideIcons.x;
    } else if (stock <= 5) {
      color = const Color(0xFFE65100);
      texto = 'Queda poco';
      icono = LucideIcons.alertTriangle;
    } else {
      color = s.primary;
      texto = esGranel
          ? 'Stock: ${Formato.numero(stock, decimales: 2)} ${unidad ?? 'kg'}'
          : 'Stock: ${stock.toInt()} und';
      icono = LucideIcons.check;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            texto,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
