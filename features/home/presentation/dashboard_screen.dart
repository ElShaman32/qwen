import 'package:el_cuaderno_de_mario/core/services/sync_service.dart';
import 'package:el_cuaderno_de_mario/core/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../../clientes/data/cliente_dao.dart';
import '../../inventario/data/producto_dao.dart';
import '../../reportes/data/reportes_service.dart';
import 'widgets/connection_indicator.dart';
import 'widgets/quick_access_grid.dart';
import 'widgets/stats_card.dart';
import 'widgets/subscription_banner.dart';

final _stockBajoProvider = FutureProvider<List<ProductoData>>((ref) {
  ref.watch(syncRefreshProvider);
  return ref.watch(productoDaoProvider).obtenerStockBajo();
});

final _fiadosPendientesProvider = FutureProvider<List<ClienteData>>((ref) {
  ref.watch(syncRefreshProvider);
  return ref.watch(clienteDaoProvider).conSaldoPendiente();
});

/// Panel principal con datos reales del negocio.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    final resumen = ref.watch(resumenHoyProvider).valueOrNull;
    final stockBajo = ref.watch(_stockBajoProvider).valueOrNull ?? const [];
    final fiados = ref.watch(_fiadosPendientesProvider).valueOrNull ?? const [];

    final totalFiados = fiados.fold(0.0, (acc, c) => acc + c.saldoPendienteUsd);

    final esAdmin = user.value?.esAdmin ?? false;
    final nombreUsuario = user.value?.nombre ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: (config.logoUrlEfectivo ?? '').isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    config.logoUrlEfectivo ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.store),
                  ),
                ),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config.nombreEfectivo,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (config.sloganEfectivo.isNotEmpty)
              Text(
                config.sloganEfectivo,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: const [
          ConnectionIndicator(),
          SizedBox(width: 8),
          LogoutButton(),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '¡Hola, $nombreUsuario!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '¿Qué vamos a hacer hoy?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          const SubscriptionBanner(),
          const SizedBox(height: 16),
          Text(
            'Resumen del día',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 600
                      ? 3
                      : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  StatsCard(
                    label: 'Ventas del día',
                    value:
                        resumen != null ? Formato.usd(resumen.totalUsd) : '—',
                    icon: Icons.point_of_sale,
                    iconColor: theme.colorScheme.primary,
                  ),
                  StatsCard(
                    label: esAdmin ? 'Ganancia del día' : 'Operaciones',
                    value: resumen != null
                        ? (esAdmin
                            ? Formato.usd(resumen.gananciaUsd)
                            : '${resumen.numVentas}')
                        : '—',
                    icon: esAdmin ? Icons.emoji_events : Icons.receipt_long,
                    iconColor: esAdmin
                        ? const Color(0xFF4CAF50)
                        : theme.colorScheme.primary,
                  ),
                  if (esAdmin) ...[
                    StatsCard(
                      label: 'Stock bajo',
                      value: '${stockBajo.length}',
                      icon: Icons.warning_amber_rounded,
                      iconColor: stockBajo.isNotEmpty
                          ? theme.colorScheme.error
                          : theme.colorScheme.outline,
                    ),
                    StatsCard(
                      label: 'Fiados por cobrar',
                      value:
                          totalFiados > 0 ? Formato.usd(totalFiados) : 'Al día',
                      icon: Icons.people,
                      iconColor: totalFiados > 0
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.outline,
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Módulos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const QuickAccessGrid(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
