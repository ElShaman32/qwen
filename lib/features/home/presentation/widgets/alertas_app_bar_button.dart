import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/alerta.dart';
import '../providers/alertas_provider.dart';

class AlertasAppBarButton extends ConsumerWidget {
  const AlertasAppBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertasAsync = ref.watch(alertasProvider);
    final theme = Theme.of(context);

    return alertasAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (resumen) {
        if (!resumen.hayAlertas) return const SizedBox.shrink();

        return Badge(
          label: Text('${resumen.totalAlertas}'),
          backgroundColor: theme.colorScheme.error,
          textColor: theme.colorScheme.onError,
          child: IconButton(
            icon: Icon(Icons.notifications_active,
                color: theme.colorScheme.onSurface),
            tooltip: 'Ver alertas inteligentes',
            onPressed: () => _mostrarBottomSheet(context, ref, resumen),
          ),
        );
      },
    );
  }

  void _mostrarBottomSheet(
      BuildContext context, WidgetRef ref, ResumenAlertas resumen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _AlertasSheetContent(
          resumen: resumen,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _AlertasSheetContent extends StatelessWidget {
  final ResumenAlertas resumen;
  final ScrollController scrollController;

  const _AlertasSheetContent(
      {required this.resumen, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Handle y Título
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              Text('Centro de Alertas',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Lista Scrolleable
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              if (resumen.venceHoy.isNotEmpty)
                _SeccionAlerta(
                    titulo: '🔴 Vence hoy',
                    alertas: resumen.venceHoy,
                    color: theme.colorScheme.error),
              if (resumen.vence3Dias.isNotEmpty)
                _SeccionAlerta(
                    titulo: '🟠 Vence en 3 días',
                    alertas: resumen.vence3Dias,
                    color: theme.colorScheme.tertiary),
              if (resumen.venceSemana.isNotEmpty)
                _SeccionAlerta(
                    titulo: '🟡 Vence esta semana',
                    alertas: resumen.venceSemana,
                    color: theme.colorScheme.secondary),
              if (resumen.stockBajo.isNotEmpty)
                _SeccionAlerta(
                    titulo: '📦 Stock bajo',
                    alertas: resumen.stockBajo,
                    color: theme.colorScheme.secondary),
              if (resumen.fiadosVencidos.isNotEmpty)
                _SeccionAlerta(
                    titulo: '💸 Fiados vencidos',
                    alertas: resumen.fiadosVencidos,
                    color: theme.colorScheme.error),
            ],
          ),
        ),
      ],
    );
  }
}

class _SeccionAlerta extends StatelessWidget {
  final String titulo;
  final List<Alerta> alertas;
  final Color color;

  const _SeccionAlerta(
      {required this.titulo, required this.alertas, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(titulo,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600, color: color)),
        ),
        ...alertas.map((alerta) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(_getIcon(alerta.tipo), color: color, size: 20),
                ),
                title: Text(alerta.nombre,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: alerta.detalle != null
                    ? Text(alerta.detalle!, style: theme.textTheme.bodySmall)
                    : null,
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () {
                  Navigator.pop(context); // Cierra el sheet
                  final ruta = alerta.modulo == 'inventario'
                      ? AppRoutes.inventarioEditar
                          .replaceAll(':id', alerta.id.toString())
                      : AppRoutes.clientesDetalle
                          .replaceAll(':id', alerta.id.toString());
                  context.push(ruta);
                },
              ),
            )),
        const SizedBox(height: 8),
      ],
    );
  }

  IconData _getIcon(TipoAlerta tipo) {
    switch (tipo) {
      case TipoAlerta.venceHoy:
      case TipoAlerta.vence3Dias:
      case TipoAlerta.venceSemana:
        return Icons.calendar_today;
      case TipoAlerta.stockBajo:
        return Icons.inventory_2;
      case TipoAlerta.fiadoVencido:
        return Icons.money_off;
    }
  }
}
