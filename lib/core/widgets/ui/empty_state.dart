import 'package:flutter/material.dart';
import 'package:flutter_lucide_animated/flutter_lucide_animated.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.iconoAnimado, // ej: search, inbox, wallet (constantes del paquete)
    required this.titulo,
    this.descripcion,
  });

  final dynamic iconoAnimado;
  final String titulo;
  final String? descripcion;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          LucideAnimatedIcon(
            icon: iconoAnimado,
            trigger: AnimationTrigger.loop,
            size: 64,
            color: s.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(titulo,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          if (descripcion != null) ...[
            const SizedBox(height: 4),
            Text(descripcion!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: s.onSurfaceVariant)),
          ],
        ]),
      ),
    );
  }
}
