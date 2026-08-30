import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/formato.dart';
import '../data/reportes_service.dart';

/// Reportes: hoy / 7 días / mes, con totales, métodos y top productos.
class ReportesScreen extends ConsumerStatefulWidget {
  const ReportesScreen({super.key});

  @override
  ConsumerState<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends ConsumerState<ReportesScreen> {
  int _periodo = 0;

  @override
  Widget build(BuildContext context) {
    final resumenAsync = ref.watch(resumenPeriodoProvider(_periodo));
    final topAsync = ref.watch(topPeriodoProvider(_periodo));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: () {
              ref.invalidate(resumenPeriodoProvider);
              ref.invalidate(topPeriodoProvider);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Selector de período
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, icon: Text('Hoy')),
              ButtonSegment(value: 1, icon: Text('7 días')),
              ButtonSegment(value: 2, icon: Text('Mes')),
            ],
            selected: {_periodo},
            onSelectionChanged: (v) => setState(() => _periodo = v.first),
          ),
          const SizedBox(height: 16),

          resumenAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (r) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _statCard(context, 'Vendido',
                          Formato.usd(r.totalUsd), Icons.trending_up),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(context, 'En Bs', Formato.bs(r.totalBs),
                          Icons.payments),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(context, 'Ventas', '${r.numVentas}',
                          Icons.receipt_long),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(context, 'Ticket prom.',
                          Formato.usd(r.ticketPromedio), Icons.calculate),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.emoji_events,
                                color: Color(0xFF4CAF50)),
                            const SizedBox(width: 8),
                            Text('Ganancia estimada',
                                style: theme.textTheme.labelLarge),
                          ],
                        ),
                        Text(
                          Formato.usd(r.gananciaUsd),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Impuestos
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('IVA recaudado',
                                style: theme.textTheme.labelSmall),
                            Text(Formato.bs(r.ivaBs),
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Exento', style: theme.textTheme.labelSmall),
                            Text(Formato.bs(r.exentoBs),
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Por método de pago
                if (r.porMetodo.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Por método de pago',
                              style: theme.textTheme.titleSmall),
                          const SizedBox(height: 8),
                          ...r.porMetodo.entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(child: Text(e.key)),
                                  Text(Formato.usd(e.value),
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Top productos
          Text('Más vendidos', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          topAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (tops) {
              if (tops.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Sin ventas en el período',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (final t in tops)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  t.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                _cantidadLabel(t),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                Formato.usd(t.totalUsd),
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _cantidadLabel(TopProducto t) {
    final esEntero = t.cantidad == t.cantidad.roundToDouble();
    return esEntero
        ? '${t.cantidad.toInt()} und'
        : Formato.numero(t.cantidad, decimales: 2);
  }

  Widget _statCard(
      BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(label, style: theme.textTheme.labelSmall),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
