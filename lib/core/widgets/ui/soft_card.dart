import 'package:flutter/material.dart';
import '../../theme/brand_styles.dart';

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.onTap,
    this.elevated = false,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool elevated;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandStyles>()!;
    return Material(
      color: s.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: s.outlineVariant.withValues(alpha: 0.45)),
            boxShadow: elevated ? [brand.softShadow] : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
