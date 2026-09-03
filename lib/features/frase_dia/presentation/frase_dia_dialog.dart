import 'package:flutter/material.dart';
import '../data/frase_repository.dart';

/// Dialog motivacional con la frase del día.
/// Logo de la app como hero (Opción A: siempre marca del producto).
class FraseDiaDialog extends StatelessWidget {
  final Frase frase;

  const FraseDiaDialog({super.key, required this.frase});

  /// Muestra el dialog si la frase no es null.
  static Future<void> mostrar(BuildContext context, Frase? frase) async {
    if (frase == null) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => FraseDiaDialog(frase: frase),
    );
  }

  IconData _iconoPorCategoria(String categoria) {
    switch (categoria) {
      case 'ventas':
        return Icons.trending_up_rounded;
      case 'humor':
        return Icons.emoji_events_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Logo de la app (hero) ─────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/Cuaderno.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                // Fallback si el asset no está registrado o falla la carga
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Chip de categoría ────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconoPorCategoria(frase.categoria),
                    size: 16,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Frase del día',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Frase ────────────────────────────────────────────
            Text(
              '"${frase.texto}"',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),

            // ── Autor ────────────────────────────────────────────
            if (frase.autor != null && frase.autor!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '— ${frase.autor}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // ── Botón ────────────────────────────────────────────
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('¡Dale! A trabajar'),
            ),
          ],
        ),
      ),
    );
  }
}
