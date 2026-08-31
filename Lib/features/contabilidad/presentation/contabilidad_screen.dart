import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../data/contabilidad_export.dart';
import '../data/contabilidad_providers.dart';
import '../domain/contabilidad_models.dart';
import 'dialogo_gasto.dart';

/// Cuaderno Contable: estado de resultados + situación financiera + gastos.
/// Gate: puedePersonalizar (Cuaderno y Calculadora+). Solo admin.
class ContabilidadScreen extends ConsumerWidget {
  const ContabilidadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    // Gate: SOLO plan Todos los Juguetes (el premium)
    if (config.plan != 'todos_juguetes') {
      return Scaffold(
        appBar: AppBar(title: const Text('Contabilidad')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(Icons.workspace_premium,
                      size: 56, color: Theme.of(context).colorScheme.outline),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Contabilidad disponible solo en el plan Todos los Juguetes',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan a Todos los Juguetes para tener el Cuaderno Contable',
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Declaraciones DESPUÉS del gate (orden correcto)
    final periodo = ref.watch(periodoContableProvider);
    final resultadosAsync = ref.watch(estadoResultadosProvider);
    final situacionAsync = ref.watch(situacionFinancieraProvider);
    final gastosAsync = ref.watch(gastosPeriodoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contabilidad'),
        actions: [
          IconButton(
            tooltip: 'Exportar a Excel',
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _exportarExcel(context, ref, periodo),
          ),
          IconButton(
            tooltip: 'Agregar gasto',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              final ok = await showDialogoGasto(context, ref);
              if (ok && context.mounted) _refrescar(ref);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSelectorPeriodo(context, ref, periodo),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                resultadosAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error calculando: $e')),
                  data: (r) => _buildEstadoResultados(context, r),
                ),
                const SizedBox(height: 16),
                gastosAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text('Error cargando gastos: $e')),
                  data: (gastos) => _buildListaGastos(context, ref, gastos),
                ),
                const SizedBox(height: 16),
                situacionAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error calculando: $e')),
                  data: (s) => _buildSituacionFinanciera(context, s),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Refresca los providers tras agregar un gasto.
  void _refrescar(WidgetRef ref) {
    ref.invalidate(estadoResultadosProvider);
    ref.invalidate(gastosPeriodoProvider);
    ref.invalidate(situacionFinancieraProvider);
  }

  /// Exporta el cuaderno contable a Excel.
  Future<void> _exportarExcel(
    BuildContext context,
    WidgetRef ref,
    PeriodoContable periodo,
  ) async {
    try {
      final ruta =
          await ref.read(contabilidadExportProvider).exportar(periodo: periodo);

      if (!context.mounted) return;

      if (Platform.isAndroid || Platform.isIOS) {
        await SharePlus.instance.share(
          ShareParams(
            subject: 'Contabilidad - ${_etiquetaPeriodo(periodo)}',
            files: [XFile(ruta)],
          ),
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('¡Listo! Contabilidad lista para compartir')),
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

  String _etiquetaPeriodo(PeriodoContable periodo) {
    switch (periodo) {
      case PeriodoContable.hoy:
        return 'Hoy';
      case PeriodoContable.sieteDias:
        return 'Últimos 7 días';
      case PeriodoContable.mes:
        return 'Mes actual';
    }
  }

  /// Selector de período: hoy / 7 días / mes
  Widget _buildSelectorPeriodo(
    BuildContext context,
    WidgetRef ref,
    PeriodoContable periodo,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SegmentedButton<PeriodoContable>(
        segments: const [
          ButtonSegment(value: PeriodoContable.hoy, label: Text('Hoy')),
          ButtonSegment(
              value: PeriodoContable.sieteDias, label: Text('7 días')),
          ButtonSegment(value: PeriodoContable.mes, label: Text('Mes')),
        ],
        selected: {periodo},
        onSelectionChanged: (seleccion) {
          ref.read(periodoContableProvider.notifier).state = seleccion.first;
        },
        multiSelectionEnabled: false,
      ),
    );
  }

  /// Estado de Resultados: ingresos - gastos = utilidad
  Widget _buildEstadoResultados(BuildContext context, EstadoResultados r) {
    final theme = Theme.of(context);
    final colorUtilidad = r.utilidadNetaUsd >= 0
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE53935);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Estado de Resultados',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _fila('Ingresos (${r.numVentas} ventas)', r.ingresosUsd, theme,
                color: theme.colorScheme.primary),
            _fila('Gastos manuales (${r.numGastos})', -r.gastosManualesUsd,
                theme),
            _fila('Gastos de merma', -r.gastosMermaUsd, theme),
            const Divider(),
            _fila('Utilidad neta', r.utilidadNetaUsd, theme,
                color: colorUtilidad, bold: true),
          ],
        ),
      ),
    );
  }

  /// Lista de gastos manuales del período.
  Widget _buildListaGastos(
      BuildContext context, WidgetRef ref, List<GastoData> gastos) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gastos manuales',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final ok = await showDialogoGasto(context, ref);
                    if (ok && context.mounted) _refrescar(ref);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (gastos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Sin gastos registrados en este período',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...gastos.map((g) => _buildGastoRow(context, g)),
          ],
        ),
      ),
    );
  }

  /// Fila individual de un gasto.
  Widget _buildGastoRow(BuildContext context, GastoData gasto) {
    final theme = Theme.of(context);
    final fecha = DateTime.fromMillisecondsSinceEpoch(gasto.fecha);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(CategoriasGasto.emoji(gasto.categoria),
              style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gasto.descripcion,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${CategoriasGasto.etiqueta(gasto.categoria)} · ${Formato.fecha(fecha)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-${Formato.usd(gasto.montoUsd)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Situación Financiera: activos - pasivos = patrimonio
  Widget _buildSituacionFinanciera(
      BuildContext context, SituacionFinanciera s) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Situación Financiera',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('ACTIVOS', style: theme.textTheme.labelLarge),
            _fila('Efectivo en caja', s.efectivoCajaUsd, theme),
            _fila('Cuentas por cobrar (fiados)', s.cuentasPorCobrarUsd, theme),
            _fila('Inventario (a costo)', s.inventarioCostoUsd, theme),
            const Divider(),
            _fila('Total activos', s.activosTotalesUsd, theme, bold: true),
            const SizedBox(height: 8),
            Text('PASIVOS', style: theme.textTheme.labelLarge),
            _fila('Deudas a proveedores', s.pasivosUsd, theme),
            const Divider(),
            _fila('Patrimonio', s.patrimonioUsd, theme,
                color: theme.colorScheme.primary, bold: true),
          ],
        ),
      ),
    );
  }

  /// Fila de monto con formato venezolano.
  Widget _fila(
    String etiqueta,
    double montoUsd,
    ThemeData theme, {
    Color? color,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            Formato.usd(montoUsd),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
