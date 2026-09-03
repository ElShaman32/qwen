import 'package:el_cuaderno_de_mario/core/services/sync_service.dart';
import 'package:el_cuaderno_de_mario/core/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../../clientes/data/cliente_dao.dart';
import '../../frase_dia/data/frase_repository.dart';
import '../../frase_dia/presentation/frase_dia_dialog.dart';
import '../../frase_dia/presentation/frase_dia_service.dart';
import '../../inventario/data/producto_dao.dart';
import '../../reportes/data/reportes_service.dart';
import 'widgets/alertas_app_bar_button.dart';
import 'widgets/connection_indicator.dart';
import 'widgets/quick_access_grid.dart';
import 'widgets/stats_card.dart';
import 'widgets/subscription_banner.dart';
import 'widgets/ventas_semana_chart.dart';

final _stockBajoProvider = FutureProvider<List<ProductoData>>((ref) {
  ref.watch(syncRefreshProvider);
  return ref.watch(productoDaoProvider).obtenerStockBajo();
});

final _fiadosPendientesProvider = FutureProvider<List<ClienteData>>((ref) {
  ref.watch(syncRefreshProvider);
  return ref.watch(clienteDaoProvider).conSaldoPendiente();
});

/// Últimos 7 días (ventas + ganancia) desde Drift, offline-first.
final _semanaProvider = FutureProvider<List<PuntoDia>>((ref) {
  ref.watch(syncRefreshProvider);
  final svc = ref.watch(reportesServiceProvider);
  return svc.resumenUltimosDias(7).then(
        (dias) => dias
            .map((d) => PuntoDia(
                  fecha: d.fecha,
                  ventas: d.ventas,
                  ganancia: d.ganancia,
                ))
            .toList(),
      );
});

/// Panel principal con datos reales del negocio.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    // Frase del día: primera apertura después de las 7am
// Se dispara una sola vez por arranque (post-frame para no bloquear el build)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final service = FraseDiaService(FraseRepository());
      final frase = await service.obtenerFraseSiCorresponde();
      if (frase != null && context.mounted) {
        await FraseDiaDialog.mostrar(context, frase);
      }
    });

    final resumen = ref.watch(resumenHoyProvider).valueOrNull;
    final stockBajo = ref.watch(_stockBajoProvider).valueOrNull ?? const [];
    final fiados = ref.watch(_fiadosPendientesProvider).valueOrNull ?? const [];
    final semanaAsync = ref.watch(_semanaProvider);

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
        actions: [
          if (config.plan == 'todos_juguetes') ...const [
            AlertasAppBarButton(),
            SizedBox(width: 8),
          ],
          const LogoutButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // ── HEADER: Saludo + Conexión + Tasa ──────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, $nombreUsuario! 👋',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Resumen del día',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const ConnectionIndicator(),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.trendingUp,
                          size: 14,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Tasa: Bs.${Formato.numero(config.tasaEfectiva, decimales: 2)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── BANNER SUSCRIPCIÓN ────────────────────────────────────
          const SubscriptionBanner(),
          const SizedBox(height: 16),

          // ── HERO: gráfico semanal ─────────────────────────────────
          semanaAsync.when(
            data: (puntos) => VentasSemanaChart(
              puntos: puntos,
              esAdmin: esAdmin,
            ),
            loading: () => Container(
              height: 220,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => Container(
              height: 220,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'Error cargando la semana',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── MÉTRICAS: 2x2 admin / 1x2 cajero ──────────────────────
          Text(
            'Métricas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
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
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  StatsCard(
                    label: 'Ventas del día',
                    value:
                        resumen != null ? Formato.usd(resumen.totalUsd) : '—',
                    icon: LucideIcons.shoppingCart,
                    iconColor: theme.colorScheme.primary,
                  ),
                  if (esAdmin)
                    StatsCard(
                      label: 'Ganancia del día',
                      value: resumen != null
                          ? Formato.usd(resumen.gananciaUsd)
                          : '—',
                      icon: LucideIcons.trophy,
                      iconColor: theme.colorScheme.tertiary,
                    ),
                  if (!esAdmin)
                    StatsCard(
                      label: 'Operaciones',
                      value: resumen != null ? '${resumen.numVentas}' : '—',
                      icon: LucideIcons.receipt,
                      iconColor: theme.colorScheme.primary,
                    ),
                  if (esAdmin)
                    StatsCard(
                      label: 'Stock bajo',
                      value: '${stockBajo.length}',
                      icon: LucideIcons.alertTriangle,
                      iconColor: stockBajo.isNotEmpty
                          ? theme.colorScheme.error
                          : theme.colorScheme.outline,
                    ),
                  if (esAdmin)
                    StatsCard(
                      label: 'Fiados por cobrar',
                      value:
                          totalFiados > 0 ? Formato.usd(totalFiados) : 'Al día',
                      icon: LucideIcons.users,
                      iconColor: totalFiados > 0
                          ? theme.colorScheme.tertiary
                          : theme.colorScheme.outline,
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // ── MÓDULOS ───────────────────────────────────────────────
          Text(
            'Módulos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
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
