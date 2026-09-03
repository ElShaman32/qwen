import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/brand_styles.dart';
import '../../../../core/utils/formato.dart';

/// Punto de la serie semanal (lleva ambas series; el widget elige por rol).
class PuntoDia {
  const PuntoDia({
    required this.fecha,
    required this.ventas,
    required this.ganancia,
  });

  final DateTime fecha;
  final double ventas;
  final double ganancia;
}

/// Hero con gráfico de línea semanal (fl_chart).
/// Admin ve ganancias; cajero ve ventas.
class VentasSemanaChart extends StatelessWidget {
  const VentasSemanaChart({
    super.key,
    required this.puntos,
    required this.esAdmin,
  });

  final List<PuntoDia> puntos;
  final bool esAdmin;

  double _valor(PuntoDia p) => esAdmin ? p.ganancia : p.ventas;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandStyles>()!;
    final linea = s.secondary;
    final total = puntos.fold(0.0, (a, p) => a + _valor(p));
    final maxY = puntos.map(_valor).fold(0.0, (a, v) => v > a ? v : a);
    final fmtDia = DateFormat('EEE', 'es');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: brand.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [brand.heroShadow],
      ),
      child: Stack(children: [
        Positioned(
          right: -40,
          top: -60,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: s.onPrimary.withValues(alpha: 0.10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      esAdmin
                          ? 'Ganancias de la semana'
                          : 'Ventas de la semana',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: s.onPrimary.withValues(alpha: 0.8),
                          ),
                    ),
                  ),
                  Text(
                    Formato.usd(total),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: s.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    maxY: maxY <= 0 ? 10 : maxY * 1.2,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: s.onPrimary.withValues(alpha: 0.08),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 18,
                          getTitlesWidget: (v, _) {
                            final i = v.round();
                            if (i < 0 || i >= puntos.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                fmtDia.format(puntos[i].fecha),
                                style: TextStyle(
                                  color: s.onPrimary.withValues(alpha: 0.6),
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < puntos.length; i++)
                            FlSpot(i.toDouble(), _valor(puntos[i])),
                        ],
                        isCurved: true,
                        preventCurveOverShooting: true,
                        color: linea,
                        barWidth: 2.5,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              linea.withValues(alpha: 0.35),
                              linea.withValues(alpha: 0.02),
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
      ]),
    );
  }
}
