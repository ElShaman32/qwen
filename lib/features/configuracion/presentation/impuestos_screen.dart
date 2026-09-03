import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/services/tasa_bcv_service.dart';
import '../../../core/utils/formato.dart';
import '../data/config_service.dart';

/// Impuestos (IVA/IGTF) y tasa de cambio.
class ImpuestosScreen extends ConsumerStatefulWidget {
  const ImpuestosScreen({super.key});

  @override
  ConsumerState<ImpuestosScreen> createState() => _ImpuestosScreenState();
}

class _ImpuestosScreenState extends ConsumerState<ImpuestosScreen> {
  final _tasaController = TextEditingController();
  final _ivaController = TextEditingController();
  final _igtfController = TextEditingController();
  bool _guardando = false;
  bool _actualizandoTasa = false;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      final config = ref.read(appConfigProvider);
      final tasaManual = config.tasaManual ?? 0;
      _tasaController.text =
          (tasaManual > 0 ? tasaManual : config.tasaEfectiva).toString();
      _ivaController.text = Formato.numero(config.ivaRate * 100, decimales: 0);
      _igtfController.text =
          Formato.numero(config.igtfRate * 100, decimales: 0);
      _inicializado = true;
    }
  }

  @override
  void dispose() {
    _tasaController.dispose();
    _ivaController.dispose();
    _igtfController.dispose();
    super.dispose();
  }

  double? _parsear(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  Future<void> _guardar(Map<String, dynamic> campos) async {
    setState(() => _guardando = true);
    try {
      await ref.read(configServiceProvider).guardarCampos(campos);
      await ref.read(appConfigProvider.notifier).syncFromRemote();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Listo! Configuración guardada')),
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

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _toggleUsarBcv(bool valor) async {
    await _guardar({'usarTasaBCV': valor});
  }

  Future<void> _actualizarTasaBcv() async {
    setState(() => _actualizandoTasa = true);
    try {
      final tasa = await ref.read(tasaBcvServiceProvider).obtenerTasaBCV();
      if (tasa == null) {
        _snack(
            'No se pudo descargar la tasa BCV. Intenta más tarde o usa modo manual');
        return;
      }
      await _guardar({'tasa_bcv': tasa});
      await ref
          .read(configServiceProvider)
          .registrarHistorialTasa(tasa, 'bcv_api');
      if (mounted) {
        _snack(
            '¡Listo! Tasa BCV actualizada a ${Formato.numero(tasa, decimales: 2)}');
      }
    } finally {
      if (mounted) setState(() => _actualizandoTasa = false);
    }
  }

  Future<void> _guardarTasaManual() async {
    final tasa = _parsear(_tasaController);
    if (tasa == null || tasa <= 0) {
      _snack('Tasa inválida');
      return;
    }
    await _guardar({'tasaManual': tasa});
    await ref
        .read(configServiceProvider)
        .registrarHistorialTasa(tasa, 'manual');
  }

  Future<void> _guardarImpuestos() async {
    final iva = _parsear(_ivaController);
    final igtf = _parsear(_igtfController);
    if (iva == null || igtf == null || iva < 0 || igtf < 0 || iva > 90) {
      _snack('Porcentajes inválidos');
      return;
    }
    await _guardar({'iva_rate': iva / 100, 'igtf_rate': igtf / 100});
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Impuestos y tasa')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── TASA DE CAMBIO ──────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tasa de cambio', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Tasa efectiva: ${Formato.numero(config.tasaEfectiva, decimales: 2)} Bs por \$',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Usar tasa BCV automática'),
                    subtitle: const Text('Descarga la tasa oficial del BCV'),
                    value: config.usarTasaBcv,
                    onChanged: _guardando ? null : _toggleUsarBcv,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push(AppRoutes.historialTasas),
                      icon: const Icon(Icons.show_chart, size: 18),
                      label: const Text('Ver histórico de tasas'),
                    ),
                  ),
                  if (config.usarTasaBcv) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: (_guardando || _actualizandoTasa)
                            ? null
                            : _actualizarTasaBcv,
                        icon: _actualizandoTasa
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh),
                        label: Text(_actualizandoTasa
                            ? 'Descargando...'
                            : 'Actualizar tasa BCV'),
                      ),
                    ),
                  ] else ...[
                    TextField(
                      controller: _tasaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Tasa manual en Bs por \$',
                        hintText: 'Ej: 790,50',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _guardando ? null : _guardarTasaManual,
                        icon: const Icon(Icons.save),
                        label: const Text('¡Vale! Guardar tasa manual'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── IMPUESTOS ───────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Impuestos', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ivaController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'IVA %',
                            hintText: '16',
                            suffixText: '%',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _igtfController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'IGTF %',
                            hintText: '3',
                            suffixText: '%',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _guardando ? null : _guardarImpuestos,
                      icon: const Icon(Icons.percent),
                      label: const Text('¡Vale! Guardar impuestos'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
