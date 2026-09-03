import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:el_cuaderno_de_mario/core/services/demo_mode_service.dart';

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
    // Verificar si el demo sigue activo antes de actualizar
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('⏰ Período de prueba finalizado'),
        content: const Text(
          'Tus 24 horas de prueba han terminado.\n\n'
          'Regístrate ahora para seguir usando la app con todos tus datos.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // 1. Cerrar el diálogo PRIMERO
              Navigator.of(ctx).pop();
              // 2. Navegar después de que el diálogo se cierre
              Future.microtask(() {
                if (mounted) {
                  context.go(AppRoutes.leadForm);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
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
    // Si el demo se desactivó mientras el timer corría, detenerlo
    final appConfig = ref.read(appConfigProvider);
    if (!appConfig.isDemoMode) {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appConfig = ref.watch(appConfigProvider);

    if (!appConfig.isDemoMode) return const SizedBox.shrink();

    // SafeArea con bottom:false → respeta la barra de notificaciones
    // pero no agrega padding inferior extra
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          border: Border(
            bottom: BorderSide(color: Colors.orange.shade300, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.science_outlined,
                color: Colors.orange.shade800, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '🎯 Modo prueba · $_tiempoRestanteStr restantes',
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
// En el método build, cambiar el onPressed del botón:
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () => context.go(AppRoutes.leadForm), // ← CAMBIAR
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Registrarme',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
