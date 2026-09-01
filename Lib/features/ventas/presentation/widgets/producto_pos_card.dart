import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/formato.dart';

/// Card de producto en la pantalla de ventas (táctil, rápida).
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
    final theme = Theme.of(context);
    final agotado = producto.stock <= 0;

    return Card(
      child: InkWell(
        onTap: agotado ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      producto.nombre,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (producto.esGranel)
                    Icon(Icons.scale,
                        size: 16, color: theme.colorScheme.primary),
                  if (producto.exentoIva) const Icon(Icons.money_off, size: 16),
                ],
              ),
              const Spacer(),
              Text(
                Formato.usd(producto.precioUsd),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                Formato.bs(producto.precioUsd * tasa),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                agotado ? 'Agotado' : _stockLabel(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: agotado
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: agotado ? FontWeight.bold : null,
                ),
              ),
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
