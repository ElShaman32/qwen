import 'package:el_cuaderno_de_mario/core/services/connectivity_service.dart';
import 'package:el_cuaderno_de_mario/core/services/subscription_service.dart';
import 'package:el_cuaderno_de_mario/core/widgets/demo_mode_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final bool soloPagos; // Cuaderno y Calculadora+
  final bool soloPremium; // Todos los Juguetes

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
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: AppRoutes.home),
  _NavItem(
      label: 'Ventas',
      icon: Icons.point_of_sale_outlined,
      selectedIcon: Icons.point_of_sale,
      route: AppRoutes.ventas),
  _NavItem(
      label: 'Inventario',
      icon: Icons.inventory_2_sharp,
      selectedIcon: Icons.inventory,
      route: AppRoutes.inventario,
      soloAdmin: true),
  _NavItem(
      label: 'Caja',
      icon: Icons.payments_outlined,
      selectedIcon: Icons.payments,
      route: AppRoutes.caja),
  _NavItem(
      label: 'Clientes',
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      route: AppRoutes.clientes,
      soloAdmin: true),
  _NavItem(
      label: 'Reportes',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
      route: AppRoutes.reportes,
      soloAdmin: true),
  _NavItem(
      label: 'Config',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: AppRoutes.configuracion,
      soloAdmin: true),
  _NavItem(
      label: 'RRHH',
      icon: Icons.badge_outlined,
      selectedIcon: Icons.badge,
      route: AppRoutes.rrhh,
      soloAdmin: true,
      soloPagos: true),
  _NavItem(
      label: 'Proveedores',
      icon: Icons.local_shipping,
      selectedIcon: Icons.people,
      route: AppRoutes.proveedores,
      soloAdmin: true,
      soloPremium: true),
  _NavItem(
      label: 'Merma',
      icon: Icons.delete_outline,
      selectedIcon: Icons.delete,
      route: AppRoutes.merma,
      soloAdmin: true,
      soloPremium: true),
  _NavItem(
      label: 'Movimientos',
      icon: Icons.history_outlined,
      selectedIcon: Icons.timeline,
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
// En modo demo SIEMPRE es admin (sin sesión Firebase)
    final esAdmin = config.isDemoMode || (user.value?.esAdmin ?? false);
    // Filtrar items por rol Y por plan
    final items = _allNavItems.where((i) {
      if (i.soloAdmin && !esAdmin) return false;
      if (i.soloPagos && !config.puedePersonalizar) return false;
      if (i.soloPremium && config.plan != 'todos_juguetes') return false;
      return true;
    }).toList();

    // Activar verificación periódica de suscripción
    ref.watch(subscriptionServiceProvider);

    // Verificar al volver online tras estar offline
    ref.listen(connectivityProvider, (prev, next) {
      // prev/next son AsyncValue<bool>, accedemos al .value
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
          // Atrás en pestaña secundaria -> volver al Panel
          context.go(AppRoutes.home);
        } else {
          // Atrás en el Panel -> salir de la app (estándar Android)
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

  // ── DESKTOP: NavigationDrawer permanente ────────────────────
  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    List<_NavItem> items,
    AppConfigState config,
  ) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            onDestinationSelected: (index) => context.go(items[index].route),
            selectedIndex: _getCurrentIndex(context, items),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.nombreEfectivo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
          const DemoModeBanner(), // ← AGREGAR
          Expanded(child: child), // ← MODIFICAR: envolver con Expanded
        ],
      ),
    );
  }

  // ── TABLET: NavigationRail lateral ──────────────────────────
  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    List<_NavItem> items,
    AppConfigState config,
  ) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _getCurrentIndex(context, items),
            onDestinationSelected: (index) => context.go(items[index].route),
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
          const DemoModeBanner(), // ← AGREGAR
          Expanded(child: child), // ← MODIFICAR: envolver con Expanded
        ],
      ),
    );
  }

  // ── MÓVIL: NavigationBar inferior ──────────────────────────
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    List<_NavItem> items,
    AppConfigState config,
  ) {
    // En móvil mostramos máximo 5 items (límite de NavigationBar)
    final mobileItems = items.take(5).toList();

    return Scaffold(
      body: Column(
        // ← MODIFICAR: envolver child con Column
        children: [
          const DemoModeBanner(), // ← AGREGAR
          Expanded(child: child), // ← MODIFICAR: envolver con Expanded
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

  // ── HELPERS ─────────────────────────────────────────────────

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
