import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../data/reporte_cajero_providers.dart';
import '../data/reportes_service.dart';

/// Reporte de ventas por cajero: ranking + gráfico comparativo.
/// Gate: puedePersonalizar (Cuaderno y Calculadora+). Solo admin.
class ReporteCajeroScreen extends ConsumerStatefulWidget {
  const ReporteCajeroScreen({super.key});

  @override
  ConsumerState<ReporteCajeroScreen> createState() =>
      _ReporteCajeroScreenState();
}

class _ReporteCajeroScreenState extends ConsumerState<ReporteCajeroScreen> {
  int _periodo = 0;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    // Gate por plan
    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ventas por cajero')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(Icons.lock_outline,
                      size: 56, color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Reporte por cajero disponible en el plan Cuaderno y Calculadora o superior',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan para ver el reporte por cajero',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final reporteAsync = ref.watch(reportePorCajeroProvider(_periodo));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas por cajero'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(reportePorCajeroProvider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Hoy')),
              ButtonSegment(value: 1, label: Text('7 días')),
              ButtonSegment(value: 2, label: Text('Mes')),
            ],
            selected: {_periodo},
            onSelectionChanged: (v) => setState(() => _periodo = v.first),
          ),
          const SizedBox(height: 16),
          reporteAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (cajeros) => _buildContenido(context, cajeros),
          ),
        ],
      ),
    );
  }

  Widget _buildContenido(BuildContext context, List<ResumenCajero> cajeros) {
    final theme = Theme.of(context);

    if (cajeros.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.people_outline,
                size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Sin ventas en este período',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando los cajeros registren ventas, verás el ranking aquí.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ranking (top 3)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Ranking de cajeros',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < cajeros.length; i++)
                  _buildFilaRanking(context, i, cajeros[i], cajeros.first),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Gráfico de barras horizontales
        if (cajeros.length > 1)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comparación visual',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: (cajeros.length * 55.0).clamp(150.0, 400.0),
                    child: _buildGraficoBarras(context, cajeros),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        // Tabla detallada
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalle por cajero',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...cajeros.map((c) => _buildFilaDetalle(context, c)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilaRanking(
    BuildContext context,
    int posicion,
    ResumenCajero cajero,
    ResumenCajero topCajero,
  ) {
    final theme = Theme.of(context);
    final porcentaje =
        topCajero.totalUsd > 0 ? (cajero.totalUsd / topCajero.totalUsd) : 0.0;

    final icono = switch (posicion) {
      0 => Icons.emoji_events,
      1 => Icons.looks_two,
      2 => Icons.looks_3,
      _ => Icons.tag,
    };
    final color = switch (posicion) {
      0 => const Color(0xFFFFB300), // dorado
      1 => const Color(0xFF90A4AE), // plata
      2 => const Color(0xFF8D6E63), // bronce
      _ => theme.colorScheme.outline,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icono, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cajero.nombre,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: porcentaje,
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formato.usd(cajero.totalUsd),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${cajero.numVentas} ventas',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoBarras(
      BuildContext context, List<ResumenCajero> cajeros) {
    final theme = Theme.of(context);
    final max = cajeros.fold<double>(
        0.0, (acc, c) => c.totalUsd > acc ? c.totalUsd : acc);

    final bars = <BarChartGroupData>[
      for (int i = 0; i < cajeros.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: cajeros[i].totalUsd,
              width: 28,
              color:
                  i == 0 ? const Color(0xFFFFB300) : theme.colorScheme.primary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ],
        ),
    ];

    return BarChart(
      BarChartData(
        maxY: max * 1.15,
        minY: 0,
        barGroups: bars,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.dividerColor.withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 54,
              getTitlesWidget: (value, meta) {
                return Text(
                  Formato.numero(value, decimales: 0),
                  style: theme.textTheme.labelSmall,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= cajeros.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _nombreCorto(cajeros[i].nombre),
                    style: theme.textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final cajero = cajeros[group.x];
              return BarTooltipItem(
                '${cajero.nombre}\n${Formato.usd(cajero.totalUsd)}',
                TextStyle(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilaDetalle(BuildContext context, ResumenCajero cajero) {
    final theme = Theme.of(context);
    final colorGanancia = cajero.gananciaUsd >= 0
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53935);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    cajero.nombre.isNotEmpty
                        ? cajero.nombre[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    cajero.nombre,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _chip('Ventas', '${cajero.numVentas}', theme),
                const SizedBox(width: 8),
                _chip('Vendido', Formato.usd(cajero.totalUsd), theme),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _chip(
                    'Ticket prom.', Formato.usd(cajero.ticketPromedio), theme),
                const SizedBox(width: 8),
                _chip(
                  'Ganancia',
                  Formato.usd(cajero.gananciaUsd),
                  theme,
                  color: colorGanancia,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String value, ThemeData theme, {Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            Text(
              value,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nombreCorto(String nombre) {
    if (nombre.length <= 10) return nombre;
    final partes = nombre.split(' ');
    return partes.first.length <= 10
        ? partes.first
        : partes.first.substring(0, 10);
  }
}
