import 'package:flutter/material.dart';

class ListRow extends StatelessWidget {
  const ListRow({
    super.key,
    required this.icon,
    required this.titulo,
    this.subtitulo,
    this.iconColor,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String titulo;
  final String? subtitulo;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final c = iconColor ?? s.primary;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: c.withValues(alpha: 0.12),
        ),
        child: Icon(icon, color: c, size: 22),
      ),
      title: Text(titulo,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: subtitulo == null
          ? null
          : Text(subtitulo!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: s.onSurfaceVariant)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
