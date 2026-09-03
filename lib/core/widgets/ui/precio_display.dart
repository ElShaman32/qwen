import 'package:flutter/material.dart';
import '../../utils/formato.dart';

/// Bloque de precio reutilizable en toda la app.
///
/// [bsDominante] = true  → Bs grande + negrita, $ pequeño y gris (POS, carrito, cobro)
/// [bsDominante] = false → $ grande + negrita, Bs pequeño y gris (inventario, reportes)
/// [compacto] = true     → tamaños reducidos para listas densas
class PrecioDisplay extends StatelessWidget {
  const PrecioDisplay({
    super.key,
    required this.precioUsd,
    required this.tasa,
    this.bsDominante = true,
    this.compacto = false,
    this.alineacion = CrossAxisAlignment.end,
  });

  final double precioUsd;
  final double tasa;
  final bool bsDominante;
  final bool compacto;
  final CrossAxisAlignment alineacion;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final precioBs = precioUsd * tasa;

    final grande = compacto
        ? Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w800, color: s.onSurface)
        : Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: s.onSurface,
              letterSpacing: -0.2,
            );

    final chico = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: s.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        );

    final textoPrincipal =
        bsDominante ? Formato.bs(precioBs) : Formato.usd(precioUsd);
    final textoSecundario =
        bsDominante ? Formato.usd(precioUsd) : Formato.bs(precioBs);

    return Column(
      crossAxisAlignment: alineacion,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(textoPrincipal, style: grande),
        const SizedBox(height: 1),
        Text(textoSecundario, style: chico),
      ],
    );
  }
}
