import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_notifier.dart';
import '../data/config_service.dart';

/// Datos fiscales de la bodega: RIF, dirección, teléfono.
class DatosBodegaScreen extends ConsumerStatefulWidget {
  const DatosBodegaScreen({super.key});

  @override
  ConsumerState<DatosBodegaScreen> createState() => _DatosBodegaScreenState();
}

class _DatosBodegaScreenState extends ConsumerState<DatosBodegaScreen> {
  final _rifController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _guardando = false;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      final config = ref.read(appConfigProvider);
      _rifController.text = config.rif;
      _direccionController.text = config.direccion;
      _telefonoController.text = config.telefono;
      _inicializado = true;
    }
  }

  @override
  void dispose() {
    _rifController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    try {
      await ref.read(configServiceProvider).guardarCampos({
        'rif': _rifController.text.trim(),
        'direccion': _direccionController.text.trim(),
        'telefono': _telefonoController.text.trim(),
      });
      await ref.read(appConfigProvider.notifier).syncFromRemote();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Listo! Datos guardados')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Datos de la bodega')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(Icons.store, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Esta información aparece en el ticket de venta',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _rifController,
            decoration: const InputDecoration(
              labelText: 'RIF',
              hintText: 'J-12345678-9',
              prefixIcon: Icon(Icons.badge),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _direccionController,
            decoration: const InputDecoration(
              labelText: 'Dirección',
              hintText: 'Av. Principal, Caracas',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _telefonoController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              hintText: '0212-1234567',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _guardando ? null : _guardar,
            icon: _guardando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('¡Vale! Guardar datos'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ),
    );
  }
}
