import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/formato.dart';

/// Fila compacta de producto para lista (más práctica en teléfonos).
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
    final theme = Theme.of(context);
    final agotado = producto.stock <= 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: agotado ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Nombre + stock
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            producto.nombre,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (producto.esGranel)
                          Icon(Icons.scale,
                              size: 16, color: theme.colorScheme.primary),
                        if (producto.exentoIva)
                          const Icon(Icons.money_off, size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      agotado ? 'Agotado' : _stockLabel(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: agotado
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Precios
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formato.usd(producto.precioUsd),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    Formato.bs(producto.precioUsd * tasa),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  String _stockLabel() => producto.esGranel
      ? 'Disp: ${Formato.numero(producto.stock, decimales: 2)} ${producto.unidadMedida ?? 'kg'}'
      : 'Disp: ${producto.stock.toInt()} und';
}
