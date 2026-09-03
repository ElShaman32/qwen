import 'package:flutter/material.dart';
import '../../theme/brand_styles.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.titulo,
    required this.valor,
    this.subtitulo,
    this.icono,
    this.acciones,
  });

  final String titulo;
  final String valor;
  final String? subtitulo;
  final IconData? icono;
  final List<Widget>? acciones;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandStyles>()!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: brand.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [brand.heroShadow], // única sombra "cara" de la pantalla
      ),
      child: Stack(children: [
        Positioned(right: -40, top: -60, child: _circulo(s, 160, 0.10)),
        Positioned(right: 30, bottom: -70, child: _circulo(s, 120, 0.08)),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(titulo,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: s.onPrimary.withValues(alpha: 0.8))),
                ),
                if (icono != null)
                  Icon(icono, color: s.onPrimary.withValues(alpha: 0.9)),
              ]),
              const SizedBox(height: 8),
              Text(
                valor,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: s.onPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5),
              ),
              if (subtitulo != null)
                Text(subtitulo!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: s.onPrimary.withValues(alpha: 0.75))),
              if (acciones != null) ...[
                const SizedBox(height: 12),
                Row(children: acciones!),
              ],
            ],
          ),
        ),
      ]),
    );
  }

  Widget _circulo(ColorScheme s, double d, double a) => Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: s.onPrimary.withValues(alpha: a),
        ),
      );
}
