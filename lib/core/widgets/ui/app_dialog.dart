import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Diálogo de confirmación Soft UI. Retorna true si confirmó.
/// Úsalo en vez de AlertDialog manual para acciones destructivas o críticas.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoConfirmar = '¡Dale!',
  String textoCancelar = 'Cancelar',
  bool destructivo = false,
  IconData? icono,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final s = Theme.of(context).colorScheme;
      final c = destructivo ? s.error : s.primary;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.withValues(alpha: 0.12),
              ),
              child: Icon(
                icono ??
                    (destructivo
                        ? LucideIcons.alertTriangle
                        : LucideIcons.circleHelp),
                color: c,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: s.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(textoCancelar),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: destructivo ? s.error : null,
              foregroundColor: destructivo ? s.onError : null,
              shape: const StadiumBorder(),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(textoConfirmar),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
