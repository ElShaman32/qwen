import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Placeholder de Home. En Fase 3 se convierte en el Dashboard/POS.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(config.appNombre),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              '¡App funcionando!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Bienvenido a ${config.appNombre}'),
            const SizedBox(height: 24),
            Text('Tasa BCV: ${config.tasaBcv}'),
            Text('IVA: ${(config.ivaRate * 100).toStringAsFixed(0)}%'),
          ],
        ),
      ),
    );
  }
}
