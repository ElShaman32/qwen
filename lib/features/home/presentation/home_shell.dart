import 'package:el_cuaderno_de_mario/core/services/connectivity_service.dart';
import 'package:el_cuaderno_de_mario/core/services/subscription_service.dart';
import 'package:el_cuaderno_de_mario/core/widgets/demo_mode_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../auth/application/current_user_provider.dart';
import 'widgets/connection_indicator.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
  final bool soloAdmin;
  final bool soloPagos;
  final bool soloPremium;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
    this.soloAdmin = false,
    this.soloPagos = false,
    this.soloPremium = false,
  });
}

const _allNavItems = [
  _NavItem(
      label: 'Panel',
      icon: LucideIcons.layoutDashboard,
      selectedIcon: LucideIcons.layoutDashboard,
      route: AppRoutes.home),
  _NavItem(
      label: 'Ventas',
      icon: LucideIcons.shoppingCart,
      selectedIcon: LucideIcons.shoppingCart,
      route: AppRoutes.ventas),
  _NavItem(
      label: 'Inventario',
      icon: LucideIcons.package,
      selectedIcon: LucideIcons.package,
      route: AppRoutes.inventario,
      soloAdmin: true),
  _NavItem(
      label: 'Caja',
      icon: LucideIcons.wallet,
      selectedIcon: LucideIcons.wallet,
      route: AppRoutes.caja),
  _NavItem(
      label: 'Clientes',
      icon: LucideIcons.users,
      selectedIcon: LucideIcons.users,
      route: AppRoutes.clientes,
      soloAdmin: true),
  _NavItem(
      label: 'Reportes',
      icon: LucideIcons.pieChart,
      selectedIcon: LucideIcons.pieChart,
      route: AppRoutes.reportes,
      soloAdmin: true),
  _NavItem(
      label: 'Config',
      icon: LucideIcons.settings,
      selectedIcon: LucideIcons.settings,
      route: AppRoutes.configuracion,
      soloAdmin: true),
  _NavItem(
      label: 'RRHH',
      icon: LucideIcons.briefcase,
      selectedIcon: LucideIcons.briefcase,
      route: AppRoutes.rrhh,
      soloAdmin: true,
      soloPagos: true),
  _NavItem(
      label: 'Proveedores',
      icon: LucideIcons.truck,
      selectedIcon: LucideIcons.truck,
      route: AppRoutes.proveedores,
      soloAdmin: true,
      soloPremium: true),
  _NavItem(
      label: 'Merma',
      icon: LucideIcons.trash2,
      selectedIcon: LucideIcons.trash2,
      route: AppRoutes.merma,
      soloAdmin: true,
      soloPremium: true),
  _NavItem(
      label: 'Movimientos',
      icon: LucideIcons.history,
      selectedIcon: LucideIcons.history,
      route: AppRoutes.movimientos,
      soloAdmin: true,
      soloPremium: true),
];

/// Shell principal post-login. Navegación adaptativa:
/// - Móvil (<600px): NavigationBar inferior
/// - Tablet (600-900px): NavigationRail lateral
/// - Desktop (>900px): NavigationDrawer permanente
class HomeShell extends ConsumerWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final config = ref.watch(appConfigProvider);
    final esAdmin = config.isDemoMode || (user.value?.esAdmin ?? false);

    final items = _allNavItems.where((i) {
      if (i.soloAdmin && !esAdmin) return false;
      if (i.soloPagos && !config.puedePersonalizar) return false;
      if (i.soloPremium && config.plan != 'todos_juguetes') return false;
      return true;
    }).toList();

    ref.watch(subscriptionServiceProvider);

    ref.listen(connectivityProvider, (prev, next) {
      final volvioOnline = next.value == true && prev?.value == false;
      if (volvioOnline) {
        ref.read(subscriptionServiceProvider).verificarSuscripcion();
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final location = GoRouterState.of(context).matchedLocation;
        if (location != AppRoutes.home) {
          context.go(AppRoutes.home);
        } else {
          SystemNavigator.pop();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 900;
          final isTablet = constraints.maxWidth > 600;

          if (isDesktop) {
            return _buildDesktopLayout(context, ref, items, config);
          } else if (isTablet) {
            return _buildTabletLayout(context, ref, items, config);
          } else {
            return _buildMobileLayout(context, ref, items, config);
          }
        },
      ),
    );
  }

  // ── DESKTOP ──────────────────────────────────────────────────
  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    List<_NavItem> items,
    AppConfigState config,
  ) {
    return Scaffold(
      // FIX: Column arriba, Row dentro de Expanded
      body: Column(
        children: [
          const DemoModeBanner(),
          Expanded(
            child: Row(
              children: [
                NavigationDrawer(
                  onDestinationSelected: (index) =>
                      context.go(items[index].route),
                  selectedIndex: _getCurrentIndex(context, items),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            config.nombreEfectivo,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const ConnectionIndicator(),
                        ],
                      ),
                    ),
                    const Divider(),
                    ...items.map((item) => NavigationDrawerDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label),
                        )),
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TABLET ───────────────────────────────────────────────────
  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    List<_NavItem> items,
    AppConfigState config,
  ) {
    return Scaffold(
      // FIX: Column arriba, Row dentro de Expanded
      body: Column(
        children: [
          const DemoModeBanner(),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _getCurrentIndex(context, items),
                  onDestinationSelected: (index) =>
                      context.go(items[index].route),
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: ConnectionIndicator(),
                  ),
                  destinations: items
                      .map((item) => NavigationRailDestination(
                            icon: Icon(item.icon),
                            selectedIcon: Icon(item.selectedIcon),
                            label: Text(item.label),
                          ))
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── MÓVIL ────────────────────────────────────────────────────
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    List<_NavItem> items,
    AppConfigState config,
  ) {
    final mobileItems = items.take(5).toList();

    return Scaffold(
      // FIX: Column explícito arriba del child (ya era así, solo mantengo)
      body: Column(
        children: [
          const DemoModeBanner(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getCurrentIndex(context, mobileItems),
        onDestinationSelected: (index) => context.go(mobileItems[index].route),
        destinations: mobileItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────────────

  int _getCurrentIndex(BuildContext context, List<_NavItem> items) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < items.length; i++) {
      if (location == items[i].route ||
          location.startsWith('${items[i].route}/')) {
        return i;
      }
    }
    return 0;
  }
}
