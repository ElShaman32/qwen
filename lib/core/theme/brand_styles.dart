import 'package:flutter/material.dart';

/// Recursos visuales de marca derivados del ColorScheme dinámico.
class BrandStyles extends ThemeExtension<BrandStyles> {
  const BrandStyles({
    required this.heroGradient,
    required this.headerGradient,
    required this.softShadow,
    required this.heroShadow,
  });

  final LinearGradient heroGradient;
  final LinearGradient headerGradient;
  final BoxShadow softShadow;
  final BoxShadow heroShadow;

  factory BrandStyles.from(ColorScheme s) => BrandStyles(
        heroGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [s.primary, Color.lerp(s.primary, Colors.black, 0.28)!],
        ),
        headerGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [s.primaryContainer.withValues(alpha: 0.5), s.surface],
        ),
        // Sombras baratas: blur corto, alpha bajo (gama baja OK)
        softShadow: BoxShadow(
          color: s.shadow.withValues(alpha: 0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        heroShadow: BoxShadow(
          color: s.primary.withValues(alpha: 0.28),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      );

  @override
  ThemeExtension<BrandStyles> copyWith({
    LinearGradient? heroGradient,
    LinearGradient? headerGradient,
    BoxShadow? softShadow,
    BoxShadow? heroShadow,
  }) =>
      BrandStyles(
        heroGradient: heroGradient ?? this.heroGradient,
        headerGradient: headerGradient ?? this.headerGradient,
        softShadow: softShadow ?? this.softShadow,
        heroShadow: heroShadow ?? this.heroShadow,
      );

  @override
  ThemeExtension<BrandStyles> lerp(covariant BrandStyles? other, double t) {
    if (other == null) return this;
    return BrandStyles(
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
      headerGradient:
          LinearGradient.lerp(headerGradient, other.headerGradient, t)!,
      softShadow: BoxShadow.lerp(softShadow, other.softShadow, t) ?? softShadow,
      heroShadow: BoxShadow.lerp(heroShadow, other.heroShadow, t) ?? heroShadow,
    );
  }
}
