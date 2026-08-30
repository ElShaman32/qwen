import 'dart:convert';
import 'package:el_cuaderno_de_mario/core/database/app_database.dart';
import 'package:el_cuaderno_de_mario/core/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/caja_dao.dart';
import 'caja_providers.dart';

/// Pantalla de Caja: abrir, retirar, cerrar con arqueo y diferencia.
class CajaScreen extends ConsumerWidget {
  const CajaScreen({super.key});

  double _red2(double x) => (x * 100).round() / 100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cajaStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caja'),
        actions: const [LogoutButton()],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.apertura == null) {
            return _buildCerrada(context, ref, data.ultimoCierre);
          }
          return _buildAbierta(context, ref, data);
        },
      ),
    );
  }

  // ── CAJA CERRADA ────────────────────────────────────────────
  Widget _buildCerrada(
      BuildContext context, WidgetRef ref, CierreCajaData? ultimo) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.lock_outline,
                    size: 56, color: theme.colorScheme.outline),
                const SizedBox(height: 12),
                Text('Caja cerrada', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                if (ultimo != null) ...[
                  Text(
                    'Último cierre: ${Formato.fecha(DateTime.fromMillisecondsSinceEpoch(ultimo.fecha))}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _textoDiferencia(ultimo.diferenciaBs),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _colorDiferencia(ultimo.diferenciaBs),
                    ),
                  ),
                ] else
                  Text('Aún no hay cierres registrados',
                      style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _aperturaDialog(context, ref),
          icon: const Icon(Icons.lock_open),
          label: const Text('¡Dale! Abrir la caja'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
      ],
    );
  }

  // ── CAJA ABIERTA ────────────────────────────────────────────
  Widget _buildAbierta(
      BuildContext context, WidgetRef ref, CajaStateData data) {
    final theme = Theme.of(context);
    final apertura = data.apertura!;
    final resumen = data.resumen!;
    final fechaApertura = DateTime.fromMillisecondsSinceEpoch(apertura.fecha);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Apertura
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock_open, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('Caja abierta',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Por ${apertura.usuarioNombre} · ${Formato.fecha(fechaApertura)}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  'Inicial: ${Formato.bs(apertura.montoInicialBs)} + ${Formato.usd(apertura.montoInicialUsd)}',
                  style: theme.textTheme.bodySmall,
                ),
                if (apertura.novedad != null)
                  Text('Novedad: ${apertura.novedad}',
                      style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Efectivo esperado
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('EFECTIVO ESPERADO EN CAJÓN',
                    style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(
                  Formato.bs(resumen.esperadoBs),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  Formato.usd(resumen.esperadoUsd),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ventas del turno: ${resumen.numVentas} · ${Formato.usd(resumen.totalVendidoUsd)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Resumen por método
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resumen por método de pago',
                    style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                ...resumen.porMetodo.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(child: Text(e.key)),
                        Text(Formato.usd(e.value),
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Retiros
        if (data.retiros.isNotEmpty) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Retiros del turno', style: theme.textTheme.titleSmall),
                  ...data.retiros.map((r) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: Icon(Icons.money_off,
                            color: theme.colorScheme.error, size: 20),
                        title: Text(r.motivo, style: theme.textTheme.bodySmall),
                        trailing: Text('-${Formato.bs(r.montoBs)}',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      )),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Acciones
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _retiroDialog(context, ref, apertura.id),
                icon: const Icon(Icons.money_off),
                label: const Text('Retirar'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _cierreDialog(context, ref, data),
                icon: const Icon(Icons.lock),
                label: const Text('Cerrar la caja'),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _textoDiferencia(double d) {
    if (d == 0) return 'Cuadre perfecto 🎉';
    return d > 0 ? 'Sobró: ${Formato.bs(d)}' : 'Faltó: ${Formato.bs(d.abs())}';
  }

  Color _colorDiferencia(double d) =>
      d == 0 ? const Color(0xFF4CAF50) : const Color(0xFFE53935);

  // ── DIÁLOGO APERTURA ────────────────────────────────────────
  Future<void> _aperturaDialog(BuildContext context, WidgetRef ref) async {
    final bsController = TextEditingController();
    final usdController = TextEditingController();
    final notaController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abrir la caja'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bsController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Efectivo inicial en Bs',
                hintText: 'Ej: 500',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: usdController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Efectivo inicial en \$',
                hintText: 'Ej: 20',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notaController,
              decoration: const InputDecoration(
                labelText: 'Novedad (opcional)',
                hintText: 'Ej: recibí de cajera anterior',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final bs = double.tryParse(
                      bsController.text.trim().replaceAll(',', '.')) ??
                  0;
              final usd = double.tryParse(
                      usdController.text.trim().replaceAll(',', '.')) ??
                  0;
              final user = ref.read(currentUserProvider).value;

              await ref.read(cajaDaoProvider).abrir(
                    montoInicialBs: bs,
                    montoInicialUsd: usd,
                    novedad: notaController.text.trim().isEmpty
                        ? null
                        : notaController.text.trim(),
                    usuarioId: user?.uid ?? '',
                    usuarioNombre: user?.nombre ?? 'Cajero',
                  );

              ref.invalidate(cajaStateProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('¡Dale! Abrir'),
          ),
        ],
      ),
    );
  }

  // ── DIÁLOGO RETIRO ──────────────────────────────────────────
  Future<void> _retiroDialog(
      BuildContext context, WidgetRef ref, int aperturaId) async {
    final montoController = TextEditingController();
    final motivoController = TextEditingController();
    String? error;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Retiro de caja'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: montoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Monto en Bs *',
                  hintText: 'Ej: 100',
                  errorText: error,
                ),
                onChanged: (_) => setState(() => error = null),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: motivoController,
                decoration: const InputDecoration(
                  labelText: 'Motivo *',
                  hintText: 'Ej: compra de hielo',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final monto = double.tryParse(
                    montoController.text.trim().replaceAll(',', '.'));
                final motivo = motivoController.text.trim();

                if (monto == null || monto <= 0 || motivo.isEmpty) {
                  setState(() => error = 'Monto y motivo son obligatorios');
                  return;
                }

                final user = ref.read(currentUserProvider).value;
                await ref.read(cajaDaoProvider).retirar(
                      aperturaId: aperturaId,
                      montoBs: _red2(monto),
                      motivo: motivo,
                      usuarioId: user?.uid ?? '',
                      usuarioNombre: user?.nombre ?? 'Cajero',
                    );

                ref.invalidate(cajaStateProvider);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('¡Vale! Retirar'),
            ),
          ],
        ),
      ),
    );
  }

  // ── DIÁLOGO CIERRE CON ARQUEO ───────────────────────────────
  Future<void> _cierreDialog(
      BuildContext context, WidgetRef ref, CajaStateData data) async {
    final apertura = data.apertura!;
    final resumen = data.resumen!;
    final realController = TextEditingController();
    final notaController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final real =
              double.tryParse(realController.text.trim().replaceAll(',', '.'));
          final diferencia =
              real != null ? _red2(real - resumen.esperadoBs) : null;

          return AlertDialog(
            title: const Text('Cerrar la caja'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Esperado: ${Formato.bs(resumen.esperadoBs)}',
                    style: Theme.of(context).textTheme.bodyMedium),
                Text('Esperado en \$: ${Formato.usd(resumen.esperadoUsd)}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                TextField(
                  controller: realController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Contado en Bs *',
                    hintText: 'Ej: 1.250',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                if (diferencia != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _textoDiferencia(diferencia),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _colorDiferencia(diferencia),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: notaController,
                  decoration: const InputDecoration(
                    labelText: 'Nota (opcional)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: real == null
                    ? null
                    : () async {
                        final user = ref.read(currentUserProvider).value;
                        final resumenJson = jsonEncode({
                          'porMetodo': resumen.porMetodo,
                          'esperadoBs': resumen.esperadoBs,
                          'esperadoUsd': resumen.esperadoUsd,
                          'totalVendidoUsd': resumen.totalVendidoUsd,
                          'numVentas': resumen.numVentas,
                        });

                        await ref.read(cajaDaoProvider).cerrar(
                              aperturaId: apertura.id,
                              montoEsperadoBs: resumen.esperadoBs,
                              montoRealBs: _red2(real),
                              resumenJson: resumenJson,
                              nota: notaController.text.trim().isEmpty
                                  ? null
                                  : notaController.text.trim(),
                              usuarioId: user?.uid ?? '',
                              usuarioNombre: user?.nombre ?? 'Cajero',
                            );

                        ref.invalidate(cajaStateProvider);
                        if (context.mounted) Navigator.pop(context);
                      },
                child: const Text('¡Listo! Cerrar'),
              ),
            ],
          );
        },
      ),
    );
  }
}
