import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

import '../data/onboarding_data.dart';

/// Pantalla de aceptación de términos legales
/// Pantalla pre-login: SIEMPRE muestra marca El Cuaderno de Mario + SiReBAi
class LegalScreen extends ConsumerStatefulWidget {
  const LegalScreen({super.key});

  @override
  ConsumerState<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends ConsumerState<LegalScreen> {
  final Logger _logger = Logger();
  bool _aceptoTerminos = false;
  bool _guardando = false;

  Future<void> _continuar() async {
    if (!_aceptoTerminos) return;

    setState(() => _guardando = true);

    try {
      // Guardar aceptación de términos en Drift
      await ref.read(appConfigProvider.notifier).aceptarTerminos();

      // Navegar a Activación (NO al home, el usuario elige allí)
      if (!mounted) return;
      context.go(AppRoutes.activacion);
    } catch (e, stack) {
      _logger.e('Error al continuar desde legal', error: e, stackTrace: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al continuar. Intenta de nuevo.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _abrirPoliticaPrivacidad() async {
    try {
      final uri = Uri.parse(politicaPrivacidadUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _mostrarError('No se pudo abrir la página');
      }
    } catch (e, stack) {
      _logger.e('Error al abrir política', error: e, stackTrace: stack);
      _mostrarError('Error al abrir la política de privacidad');
    }
  }

  void _mostrarTerminosCompletos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y condiciones'),
        content: SingleChildScrollView(
          child: Text(
            textoLegalCompleto,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
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
                      // Icono
                      Container(
                        width: esPantallaGrande ? 120 : 80,
                        height: esPantallaGrande ? 120 : 80,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.gavel,
                          size: esPantallaGrande ? 64 : 48,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Marca del producto
                      Text(
                        'El Cuaderno de Mario',
                        style: textTheme.headlineSmall?.copyWith(
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
                      const SizedBox(height: 32),

                      // Título
                      Text(
                        'Términos y condiciones',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      Text(
                        'Para continuar, debes aceptar nuestros términos y condiciones y política de privacidad.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Card con checkbox
                      Card(
                        elevation: 0,
                        color: colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Checkbox Aceptar
                              InkWell(
                                onTap: () => setState(
                                  () => _aceptoTerminos = !_aceptoTerminos,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _aceptoTerminos,
                                      onChanged: (value) => setState(
                                        () => _aceptoTerminos = value ?? false,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Text(
                                          'Acepto los términos y condiciones y la política de privacidad',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Link a política de privacidad
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: _abrirPoliticaPrivacidad,
                                  icon: const Icon(Icons.open_in_new, size: 16),
                                  label: const Text(
                                    'Ver política de privacidad',
                                  ),
                                ),
                              ),

                              // Botón ver términos completos
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: _mostrarTerminosCompletos,
                                  icon: const Icon(
                                    Icons.description_outlined,
                                    size: 16,
                                  ),
                                  label: const Text('Ver términos completos'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Botón Continuar
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: _aceptoTerminos && !_guardando
                              ? _continuar
                              : null,
                          child: _guardando
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Continuar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nota informativa
                      Text(
                        'Podrás elegir entre registrarte, iniciar sesión o probar gratis 24h',
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
}
