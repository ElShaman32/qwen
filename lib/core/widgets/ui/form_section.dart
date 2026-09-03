import 'package:flutter/material.dart';

/// Sección de formulario agrupada en card con título e icono.
/// Úsala para agrupar campos: "Datos del producto", "Precios", "Fiado"...
class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    required this.titulo,
    this.icono,
    this.trailing,
    required this.children,
  });

  final String titulo;
  final IconData? icono;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: s.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: s.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icono != null) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: s.primary.withValues(alpha: 0.10),
                  ),
                  child: Icon(icono, size: 16, color: s.primary),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  titulo,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          ..._espaciados(),
        ],
      ),
    );
  }

  List<Widget> _espaciados() {
    final out = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      out.add(children[i]);
      if (i < children.length - 1) out.add(const SizedBox(height: 14));
    }
    return out;
  }
}
