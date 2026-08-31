import 'dart:convert';
import 'package:el_cuaderno_de_mario/features/caja/presentation/caja_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../../reportes/data/reportes_service.dart';
import '../data/venta_dao.dart';
import '../domain/ticket_generator.dart';
import '../domain/venta_models.dart';

/// Historial de ventas con ticket y anulación (solo admin).
final ventasHistorialProvider =
    FutureProvider.family<List<VentaData>, int>((ref, periodo) {
  final dao = ref.watch(ventaDaoProvider);
  return dao.ventasDesde(periodo == 1
      ? ReportesService.inicioDeDias(7)
      : ReportesService.inicioDeHoy());
});

class VentasHistorialScreen extends ConsumerStatefulWidget {
  const VentasHistorialScreen({super.key});

  @override
  ConsumerState<VentasHistorialScreen> createState() =>
      _VentasHistorialScreenState();
}

class _VentasHistorialScreenState extends ConsumerState<VentasHistorialScreen> {
  int _periodo = 0;

  @override
  Widget build(BuildContext context) {
    final ventasAsync = ref.watch(ventasHistorialProvider(_periodo));
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, icon: Text('Hoy')),
                ButtonSegment(value: 1, icon: Text('7 días')),
              ],
              selected: {_periodo},
              onSelectionChanged: (v) => setState(() => _periodo = v.first),
            ),
          ),
          Expanded(
            child: ventasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (ventas) {
                if (ventas.isEmpty) {
                  return const Center(child: Text('Sin ventas en el período'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ventas.length,
                  itemBuilder: (context, index) {
                    final v = ventas[index];
                    return _buildVentaRow(context, v);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVentaRow(BuildContext context, VentaData v) {
    final theme = Theme.of(context);
    final f = DateTime.fromMillisecondsSinceEpoch(v.fecha);
    final hora =
        '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: v.anulada
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.primaryContainer,
          child: Icon(
            v.anulada ? Icons.block : Icons.receipt_long,
            color: v.anulada
                ? theme.colorScheme.onErrorContainer
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          '#${v.numeroVenta} · $hora${v.anulada ? ' · ANULADA' : ''}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            decoration: v.anulada ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${_metodosLabel(v)} · ${v.usuarioNombre}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Text(
          Formato.usd(v.totalUsd),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: v.anulada ? TextDecoration.lineThrough : null,
          ),
        ),
        onTap: () => _detalleVenta(context, v),
      ),
    );
  }

  String _metodosLabel(VentaData v) {
    try {
      final pagos = (jsonDecode(v.pagosJson) as List)
          .map((e) => Pago.fromJson(e as Map<String, dynamic>))
          .toList();
      return pagos.map((p) => p.metodoNombre).toSet().join(' + ');
    } catch (_) {
      return '';
    }
  }

  void _detalleVenta(BuildContext context, VentaData v) {
    final config = ref.read(appConfigProvider);
    final user = ref.read(currentUserProvider).value;
    final esAdmin = user?.esAdmin ?? false;
    final ticket = TicketGenerator.generar(v, config);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Venta #${v.numeroVenta}'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              ticket,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        actions: [
          if (!v.anulada && esAdmin)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _dialogoAnular(context, v);
              },
              child: Text(
                'Anular',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copiar ticket',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: ticket));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket copiado')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'WhatsApp',
            onPressed: () => launchUrl(
              Uri.parse('https://wa.me/?text=${Uri.encodeComponent(ticket)}'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _dialogoAnular(BuildContext context, VentaData v) async {
    final motivoController = TextEditingController();
    String? error;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Anular venta #${v.numeroVenta}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Esto reintegra el stock y revierte el fiado del cliente si aplica. No se puede deshacer.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: motivoController,
                decoration: InputDecoration(
                  labelText: 'Motivo de anulación *',
                  hintText: 'Ej: cobro erróneo, devolución',
                  errorText: error,
                ),
                onChanged: (_) => setState(() => error = null),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                final motivo = motivoController.text.trim();
                if (motivo.isEmpty) {
                  setState(() => error = 'El motivo es obligatorio');
                  return;
                }

                final user = ref.read(currentUserProvider).value;
                await ref.read(ventaDaoProvider).anularVenta(
                      v.id,
                      motivo,
                      usuarioId: user?.uid ?? '',
                      usuarioNombre: user?.nombre ?? 'Admin',
                    );

                // Recalcular historial, reportes, dashboard y caja
                ref.invalidate(ventasHistorialProvider);
                ref.invalidate(resumenHoyProvider);
                ref.invalidate(resumenPeriodoProvider);
                ref.invalidate(topPeriodoProvider);
                ref.invalidate(cajaStateProvider);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Venta anulada')),
                  );
                }
              },
              child: const Text('¡Vale! Anular'),
            ),
          ],
        ),
      ),
    );
  }
}
