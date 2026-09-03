import 'package:flutter/material.dart';

/// Fila icono + título/subtítulo + Switch.
/// Para toggles de formularios: exento IVA, activo, usar tasa BCV, etc.
class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.icono,
    required this.titulo,
    this.subtitulo,
    required this.value,
    required this.onChanged,
    this.color,
  });

  final IconData icono;
  final String titulo;
  final String? subtitulo;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final c = color ?? s.primary;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.withValues(alpha: 0.10),
          ),
          child: Icon(icono, size: 20, color: c),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (subtitulo != null)
                Text(
                  subtitulo!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: s.onSurfaceVariant),
                ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
