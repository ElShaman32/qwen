import 'dart:io';
import 'dart:math' as math;

import 'package:el_cuaderno_de_mario/features/reportes/data/historial_tasa_export.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../data/historial_tasa_providers.dart';

/// Histórico de tasas de cambio.
/// Gate: Cuaderno y Calculadora+.
class HistorialTasasScreen extends ConsumerWidget {
  const HistorialTasasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Histórico de tasas')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 56,
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Histórico de tasas disponible en el plan Cuaderno y Calculadora o superior',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan para ver el histórico de tasas',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final periodo = ref.watch(periodoHistorialTasaProvider);
    final graficoAsync = ref.watch(historialTasasGraficoProvider);
    final tablaAsync = ref.watch(historialTasasTablaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de tasas'),
        actions: [
          IconButton(
            tooltip: 'Exportar a Excel',
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _exportarExcel(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSelectorPeriodo(context, ref, periodo),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(historialTasasGraficoProvider);
                ref.invalidate(historialTasasTablaProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  graficoAsync.when(
                    loading: () => const _CardLoading(),
                    error: (e, _) => _CardError(error: e.toString()),
                    data: (tasas) => _buildResumenYGrafico(
                      context,
                      tasas,
                      config.tasaEfectiva,
                    ),
                  ),
                  const SizedBox(height: 16),
                  tablaAsync.when(
                    loading: () => const _CardLoading(),
                    error: (e, _) => _CardError(error: e.toString()),
                    data: (tasas) => _buildTabla(context, tasas),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorPeriodo(
    BuildContext context,
    WidgetRef ref,
    PeriodoHistorialTasa periodo,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SegmentedButton<PeriodoHistorialTasa>(
          segments: const [
            ButtonSegment(
              value: PeriodoHistorialTasa.sieteDias,
              label: Text('7 días'),
            ),
            ButtonSegment(
              value: PeriodoHistorialTasa.treintaDias,
              label: Text('30 días'),
            ),
            ButtonSegment(
              value: PeriodoHistorialTasa.noventaDias,
              label: Text('90 días'),
            ),
            ButtonSegment(
              value: PeriodoHistorialTasa.todo,
              label: Text('Todo'),
            ),
          ],
          selected: {periodo},
          onSelectionChanged: (seleccion) {
            ref.read(periodoHistorialTasaProvider.notifier).state =
                seleccion.first;
          },
          multiSelectionEnabled: false,
        ),
      ),
    );
  }

  Widget _buildResumenYGrafico(
    BuildContext context,
    List<HistorialTasaData> tasas,
    double tasaActual,
  ) {
    final theme = Theme.of(context);

    if (tasas.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.show_chart,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                'Aún no hay tasas registradas',
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Cuando actualices la tasa BCV o guardes una tasa manual, aparecerá aquí.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final primera = tasas.first.tasa;
    final ultima = tasas.last.tasa;
    final variacion = primera > 0 ? ((ultima - primera) / primera) : 0.0;
    final colorVariacion =
        variacion >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFE53935);

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth > 760;
            final children = [
              _MiniResumenTasa(
                titulo: 'Tasa actual',
                valor: '${Formato.numero(tasaActual, decimales: 2)} Bs',
                icono: Icons.attach_money,
                color: theme.colorScheme.primary,
              ),
              _MiniResumenTasa(
                titulo: 'Última registrada',
                valor: '${Formato.numero(ultima, decimales: 2)} Bs',
                icono: Icons.schedule,
                color: Colors.blue.shade700,
              ),
              _MiniResumenTasa(
                titulo: 'Variación',
                valor:
                    '${variacion >= 0 ? '+' : ''}${Formato.porcentaje(variacion)}',
                icono: variacion >= 0 ? Icons.trending_up : Icons.trending_down,
                color: colorVariacion,
              ),
            ];

            if (desktop) {
              return Row(
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    Expanded(child: children[i]),
                    if (i != children.length - 1) const SizedBox(width: 12),
                  ],
                ],
              );
            }

            return Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1) const SizedBox(height: 8),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 280,
              child: _buildGraficoLineal(context, tasas),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraficoLineal(
    BuildContext context,
    List<HistorialTasaData> tasas,
  ) {
    final theme = Theme.of(context);

    if (tasas.length == 1) {
      return Center(
        child: Text(
          'Solo hay una tasa registrada. Actualiza otra tasa para ver la tendencia.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    final valores = tasas.map((t) => t.tasa).toList();
    final minY = valores.reduce(math.min);
    final maxY = valores.reduce(math.max);
    final padding = ((maxY - minY).abs() * 0.15).clamp(0.5, double.infinity);

    final spots = <FlSpot>[
      for (int i = 0; i < tasas.length; i++)
        FlSpot(i.toDouble(), tasas[i].tasa),
    ];

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (tasas.length - 1).toDouble(),
        minY: math.max(0, minY - padding),
        maxY: maxY + padding,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _intervaloY(minY, maxY),
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.dividerColor.withValues(alpha: 0.35),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
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
              interval: _intervaloX(tasas.length),
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= tasas.length) {
                  return const SizedBox.shrink();
                }
                final fecha = tasas[index].fecha;
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${fecha.day}/${fecha.month}',
                    style: theme.textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (items) {
              return items.map((item) {
                final index = item.x.round();
                final tasa = tasas[index];
                return LineTooltipItem(
                  '${Formato.fecha(tasa.fecha)}\n'
                  '${Formato.numero(tasa.tasa, decimales: 2)} Bs por \$',
                  TextStyle(
                    color: theme.colorScheme.onInverseSurface,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.25,
            color: theme.colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: tasas.length <= 20,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.22),
                  theme.colorScheme.primary.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabla(BuildContext context, List<HistorialTasaData> tasas) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Registros',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (tasas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Sin registros para este período',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...tasas.map((tasa) => _buildFilaTasa(context, tasa)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilaTasa(BuildContext context, HistorialTasaData tasa) {
    final theme = Theme.of(context);
    final esAuto = tasa.fuente.contains('bcv');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                (esAuto ? Colors.green : Colors.orange).withValues(alpha: 0.14),
            child: Icon(
              esAuto ? Icons.cloud_sync : Icons.edit,
              size: 18,
              color: esAuto ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formato.fechaHora(tasa.fecha),
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  _etiquetaFuente(tasa.fuente),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${Formato.numero(tasa.tasa, decimales: 2)} Bs',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  double _intervaloX(int cantidad) {
    if (cantidad <= 6) return 1;
    if (cantidad <= 14) return 2;
    if (cantidad <= 31) return 5;
    if (cantidad <= 90) return 15;
    return (cantidad / 6).ceilToDouble();
  }

  double _intervaloY(double min, double max) {
    final diff = (max - min).abs();
    if (diff <= 5) return 1;
    if (diff <= 20) return 5;
    if (diff <= 50) return 10;
    return 25;
  }

  String _etiquetaFuente(String fuente) {
    switch (fuente) {
      case 'bcv_api':
        return 'BCV manual';
      case 'bcv_api_auto':
        return 'BCV automática';
      case 'manual':
        return 'Manual';
      default:
        return fuente.replaceAll('_', ' ');
    }
  }

  /// Exporta el histórico de tasas a Excel.
  Future<void> _exportarExcel(BuildContext context, WidgetRef ref) async {
    try {
      final tasas = ref.read(historialTasasTablaProvider).valueOrNull ?? [];
      if (tasas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay datos para exportar')),
        );
        return;
      }

      final periodo = ref.read(periodoHistorialTasaProvider);
      final etiqueta = switch (periodo) {
        PeriodoHistorialTasa.sieteDias => 'Últimos 7 días',
        PeriodoHistorialTasa.treintaDias => 'Últimos 30 días',
        PeriodoHistorialTasa.noventaDias => 'Últimos 90 días',
        PeriodoHistorialTasa.todo => 'Todo el histórico',
      };

      final ruta = await ref
          .read(historialTasaExportProvider)
          .exportar(tasas: tasas, etiquetaPeriodo: etiqueta);

      if (!context.mounted) return;

      if (Platform.isAndroid || Platform.isIOS) {
        await SharePlus.instance.share(
          ShareParams(
            subject: 'Histórico de tasas - $etiqueta',
            files: [XFile(ruta)],
          ),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('¡Listo! Histórico listo para compartir')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Listo! Guardado en: $ruta'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al exportar: $e')),
      );
    }
  }
}

class _MiniResumenTasa extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final Color color;

  const _MiniResumenTasa({
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.14),
              child: Icon(icono, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    valor,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardLoading extends StatelessWidget {
  const _CardLoading();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _CardError extends StatelessWidget {
  final String error;

  const _CardError({required this.error});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $error'),
      ),
    );
  }
}
