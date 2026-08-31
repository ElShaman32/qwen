import 'package:el_cuaderno_de_mario/core/services/printer_config_service.dart';
import 'package:el_cuaderno_de_mario/core/services/printer_service.dart';
import 'package:el_cuaderno_de_mario/core/utils/plataforma.dart';
import 'package:el_cuaderno_de_mario/features/ventas/domain/construir_ticket_termico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../domain/ticket_generator.dart';

/// Pantalla post-venta: resumen + ticket WhatsApp/copiar/ver.
class PostVentaScreen extends ConsumerWidget {
  const PostVentaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venta = GoRouterState.of(context).extra as VentaData?;
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    if (venta == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Venta')),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go(AppRoutes.ventas),
            child: const Text('Ir a Ventas'),
          ),
        ),
      );
    }

    final ticket = TicketGenerator.generar(venta, config);

    return Scaffold(
      appBar: AppBar(title: Text('Venta #${venta.numeroVenta}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          Icon(Icons.check_circle, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '¡Chévere! Venta registrada',
              style: theme.textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              Formato.usd(venta.totalUsd),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Center(
            child: Text(
              Formato.bs(venta.totalBs),
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => _compartirWhatsApp(ticket),
            icon: const Icon(Icons.share),
            label: const Text('Compartir por WhatsApp'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: ticket));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket copiado')),
                );
              }
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copiar ticket'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          if (config.puedePersonalizar && esMovil()) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _imprimirTicket(context, ref, venta),
              icon: const Icon(Icons.print),
              label: const Text('Imprimir ticket'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Ticket #${venta.numeroVenta}'),
                content: SingleChildScrollView(
                  child: SelectableText(
                    ticket,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.receipt_long),
            label: const Text('Ver ticket'),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => context.go(AppRoutes.ventas),
                  child: const Text('Nueva venta'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Ir al Panel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _compartirWhatsApp(String ticket) async {
    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(ticket)}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _imprimirTicket(
      BuildContext context, WidgetRef ref, VentaData venta) async {
    final config = ref.read(appConfigProvider);
    final printerConfig =
        await ref.read(printerConfigServiceProvider).cargarImpresora();

    if (printerConfig == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Configura tu impresora en Configuración primero'),
        ));
      }
      return;
    }

    final service = ref.read(printerServiceProvider);
    final conectado = await service.estaConectada() ||
        await service.conectar(printerConfig.macAddress);

    if (!conectado) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Impresora sin conexión. Enciéndela y vuelve a intentar.'),
        ));
      }
      return;
    }

    final ok =
        await service.imprimirBytes(construirTicketTermico(venta, config));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(ok ? '¡Ticket impreso!' : 'No se pudo imprimir')),
      );
    }
  }
}
