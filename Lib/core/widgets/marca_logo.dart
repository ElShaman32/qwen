import 'package:flutter/material.dart';

/// Logo de la marca El Cuaderno de Mario para pantallas pre-login.
/// Usa imagen local desde assets, con fallback a icono si no existe.
class MarcaLogo extends StatelessWidget {
  final double size;

  const MarcaLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/Cuaderno.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildFallbackLogo(theme),
      ),
    );
  }

  Widget _buildFallbackLogo(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        Icons.storefront,
        size: size * 0.5,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }
}
