import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:el_cuaderno_de_mario/core/services/demo_mode_service.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DemoModeBanner extends ConsumerStatefulWidget {
  const DemoModeBanner({super.key});

  @override
  ConsumerState<DemoModeBanner> createState() => _DemoModeBannerState();
}

class _DemoModeBannerState extends ConsumerState<DemoModeBanner> {
  Timer? _timer;
  String _tiempoRestanteStr = 'Calculando...';

  @override
  void initState() {
    super.initState();
    _actualizarTiempo();
    _timer =
        Timer.periodic(const Duration(seconds: 30), (_) => _actualizarTiempo());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _actualizarTiempo() async {
    final appConfig = ref.read(appConfigProvider);
    if (!appConfig.isDemoMode) {
      _timer?.cancel();
      return;
    }

    final demoService = DemoModeService();
    final restante = await demoService.tiempoRestante();

    if (restante == Duration.zero) {
      _timer?.cancel();
      if (mounted) {
        setState(() => _tiempoRestanteStr = '00:00:00');
        _mostrarDialogoVencimiento();
      }
      return;
    }

    final horas = restante.inHours.toString().padLeft(2, '0');
    final minutos = (restante.inMinutes % 60).toString().padLeft(2, '0');
    final segundos = (restante.inSeconds % 60).toString().padLeft(2, '0');

    if (mounted) {
      setState(() => _tiempoRestanteStr = '$horas:$minutos:$segundos');
    }
  }

  void _mostrarDialogoVencimiento() {
    final s = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                color: s.tertiary.withValues(alpha: 0.12),
              ),
              child: Icon(LucideIcons.clock, color: s.tertiary, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              'Período de prueba finalizado',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Tus 24 horas de prueba han terminado.\n\n'
              'Regístrate ahora para seguir usando la app con todos tus datos.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: s.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.microtask(() {
                if (mounted) context.go(AppRoutes.leadForm);
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: s.tertiary,
              foregroundColor: s.onTertiary,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: const Text('Registrarme ahora'),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(DemoModeBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    final appConfig = ref.read(appConfigProvider);
    if (!appConfig.isDemoMode) _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final appConfig = ref.watch(appConfigProvider);
    if (!appConfig.isDemoMode) return const SizedBox.shrink();

    final s = Theme.of(context).colorScheme;
    // Color de alerta: usa tertiary del tema si existe, si no naranja demo
    final alerta = s.tertiary;
    final alertaContainer = s.tertiaryContainer;
    final alertaOn = s.onTertiaryContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: alertaContainer,
        border: Border(
          bottom: BorderSide(color: alerta.withValues(alpha: 0.25), width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Icono en círculo
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: alerta.withValues(alpha: 0.18),
              ),
              child: Icon(LucideIcons.flaskConical, color: alertaOn, size: 14),
            ),
            const SizedBox(width: 10),
            // Texto con contador en chip
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: alertaOn,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                  children: [
                    const TextSpan(text: 'Modo prueba · '),
                    TextSpan(
                      text: _tiempoRestanteStr,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const TextSpan(text: ' restantes'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Botón píldora con altura fija (NO recibe ancho infinito)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 32),
              child: FilledButton(
                onPressed: () => context.go(AppRoutes.leadForm),
                style: FilledButton.styleFrom(
                  backgroundColor: alerta,
                  foregroundColor: s.onTertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: const StadiumBorder(),
                  minimumSize: const Size(0, 0),
                ),
                child: const Text('Registrarme'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
