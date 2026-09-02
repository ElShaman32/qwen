import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

import '../data/onboarding_data.dart';

/// Pantalla de video de bienvenida.
/// Estrategia pragmática: thumbnail + botón que abre YouTube externo.
/// Evita problemas de build con webview y es más rápido en dispositivos de baja gama.
/// Pantalla pre-login: SIEMPRE muestra marca El Cuaderno de Mario + SiReBAi.
class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({super.key});

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  final Logger _logger = Logger();

  void _saltarVideo() {
    context.go(AppRoutes.onboardingScreens);
  }

  Future<void> _verVideo() async {
    try {
      final uri = Uri.parse(videoBienvenidaUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _mostrarError('No se pudo abrir el video');
      }
    } catch (e, stack) {
      _logger.e('Error al abrir video de YouTube', error: e, stackTrace: stack);
      _mostrarError('Error al abrir el video');
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
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

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header con logo de producto
                      _buildHeader(textTheme, colorScheme),
                      const SizedBox(height: 32),

                      // Thumbnail del video (hero visual interactivo)
                      _buildVideoThumbnail(colorScheme, esPantallaGrande),
                      const SizedBox(height: 32),

                      // Título
                      Text(
                        'Bienvenido a El Cuaderno de Mario',
                        style: esPantallaGrande
                            ? textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              )
                            : textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Descripción
                      Text(
                        'Descubre en 1 minuto cómo controlar tu bodega sin complicaciones',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Botón principal: Ver video (abre YouTube externo)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.icon(
                          onPressed: _verVideo,
                          icon: const Icon(Icons.play_circle_filled, size: 28),
                          label: const Text(
                            'Ver video de bienvenida',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Botón secundario: Saltar
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: _saltarVideo,
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Saltar y continuar'),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Nota informativa
                      Text(
                        'El video se abrirá en YouTube',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo de El Cuaderno de Mario (mismo asset del splash)
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/Cuaderno.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.storefront,
                size: 28,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'El Cuaderno de Mario',
                style: textTheme.titleLarge?.copyWith(
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
      ],
    );
  }

  Widget _buildVideoThumbnail(ColorScheme colorScheme, bool esGrande) {
    final size = esGrande ? 280.0 : 200.0;

    return GestureDetector(
      onTap: _verVideo,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.primary.withValues(alpha: 0.7),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Icono grande de play
            Icon(
              Icons.play_circle_filled,
              size: size * 0.5,
              color: colorScheme.onPrimaryContainer,
            ),
            // Badge de YouTube
            Positioned(
              bottom: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.youtube_searched_for,
                      size: 16,
                      color: colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'YouTube',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
