import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../data/onboarding_data.dart';

/// Pantallas swipeables del onboarding (3-4 pantallas)
/// Pantalla pre-login: SIEMPRE muestra marca El Cuaderno de Mario + SiReBAi
class OnboardingScreens extends ConsumerStatefulWidget {
  const OnboardingScreens({super.key});

  @override
  ConsumerState<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends ConsumerState<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _siguiente() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Última pantalla -> ir a Legal
      context.go(AppRoutes.onboardingLegal);
    }
  }

  void _saltar() {
    // Saltar todas las pantallas e ir directo a Legal
    context.go(AppRoutes.onboardingLegal);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final esPantallaGrande = constraints.maxWidth > 600;
            final padding = esPantallaGrande ? 48.0 : 24.0;

            return Column(
              children: [
                // Header con marca + botón saltar
                _buildHeader(textTheme, colorScheme, padding),

                // Contenido swipeable
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingPages.length,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final page = onboardingPages[index];
                      return _buildPage(
                          page, constraints, textTheme, colorScheme, padding);
                    },
                  ),
                ),

                // Indicador de progreso
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: onboardingPages.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: esPantallaGrande ? 12 : 8,
                      dotHeight: esPantallaGrande ? 12 : 8,
                      activeDotColor: colorScheme.primary,
                      dotColor: colorScheme.outlineVariant,
                    ),
                  ),
                ),

                // Botones inferiores
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _siguiente,
                          child: Text(
                            _currentPage == onboardingPages.length - 1
                                ? 'Finalizar'
                                : 'Siguiente',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Botón "Saltar" solo en pantallas intermedias
                      if (_currentPage < onboardingPages.length - 1)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            onPressed: _saltar,
                            child: const Text('Saltar'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
      TextTheme textTheme, ColorScheme colorScheme, double padding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 16, padding, 0),
      child: Row(
        children: [
          // Logo de El Cuaderno de Mario (mismo asset del splash)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/Cuaderno.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.storefront,
                  size: 22,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'El Cuaderno de Mario',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'SiReBAi',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          // Botón saltar visible arriba también
          TextButton(
            onPressed: _saltar,
            child: const Text('Saltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    OnboardingPage page,
    BoxConstraints constraints,
    TextTheme textTheme,
    ColorScheme colorScheme,
    double padding,
  ) {
    final esPantallaGrande = constraints.maxWidth > 600;
    final iconSize = esPantallaGrande ? 180.0 : 120.0;
    final tituloStyle = esPantallaGrande
        ? textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)
        : textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);
    final descripcionStyle =
        esPantallaGrande ? textTheme.titleLarge : textTheme.bodyLarge;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono grande como "imagen"
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    page.iconEmoji,
                    style: TextStyle(fontSize: iconSize * 0.5),
                  ),
                ),
              ),
              SizedBox(height: esPantallaGrande ? 48 : 32),
              // Título
              Text(
                page.title,
                style: tituloStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Descripción
              Text(
                page.description,
                style: descripcionStyle?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
