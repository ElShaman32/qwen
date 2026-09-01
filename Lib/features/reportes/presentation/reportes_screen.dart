import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:el_cuaderno_de_mario/features/reportes/data/reportes_export.dart';
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
  bool _exportando = false;

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
            icon: const Icon(Icons.download),
            tooltip: 'Exportar reporte',
            onPressed: _exportando ? null : () => _mostrarMenuExportar(),
          ),
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

  String _nombrePeriodo() {
    switch (_periodo) {
      case 1:
        return 'Últimos 7 días';
      case 2:
        return 'Mes actual';
      default:
        return 'Hoy';
    }
  }

  int _inicioPeriodo() {
    switch (_periodo) {
      case 1:
        return ReportesService.inicioDeDias(7);
      case 2:
        return ReportesService.inicioDeMes();
      default:
        return ReportesService.inicioDeHoy();
    }
  }

  Future<void> _mostrarMenuExportar() async {
    final config = ref.read(appConfigProvider);
    if (!config.puedePersonalizar) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Exportar reportes está disponible en el plan Cuaderno y Calculadora'),
          ),
        );
      }
      return;
    }

    final formato = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Exportar a Excel'),
              subtitle: const Text('Hoja resumen + detalle de ventas'),
              onTap: () => Navigator.pop(ctx, 'excel'),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Exportar a PDF'),
              subtitle: const Text('Reporte ejecutivo en una página'),
              onTap: () => Navigator.pop(ctx, 'pdf'),
            ),
          ],
        ),
      ),
    );
    if (formato == null) return;
    if (formato == 'excel') {
      await _exportarExcel();
    } else {
      await _exportarPdf();
    }
  }

  Future<void> _exportarExcel() async {
    setState(() => _exportando = true);
    try {
      final config = ref.read(appConfigProvider);
      final svc = ref.read(reportesServiceProvider);
      final resumen = await svc.resumenDesde(_inicioPeriodo());
      final top = await svc.topProductos(_inicioPeriodo());
      final ventas = await svc.ventasDelPeriodo(_inicioPeriodo());
      await ReportesExport.exportarExcel(
        resumen: resumen,
        top: top,
        ventas: ventas,
        config: config,
        nombrePeriodo: _nombrePeriodo(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Listo! Reporte Excel generado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }

  Future<void> _exportarPdf() async {
    setState(() => _exportando = true);
    try {
      final config = ref.read(appConfigProvider);
      final svc = ref.read(reportesServiceProvider);
      final resumen = await svc.resumenDesde(_inicioPeriodo());
      final top = await svc.topProductos(_inicioPeriodo());
      await ReportesExport.exportarPdf(
        resumen: resumen,
        top: top,
        config: config,
        nombrePeriodo: _nombrePeriodo(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Chévere! Reporte PDF generado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }
}
