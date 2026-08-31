import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../auth/application/current_user_provider.dart';

/// Item de acceso rápido en el dashboard.
class _QuickAccessItem {
  final String label;
  final IconData icon;
  final String route;
  final bool soloAdmin;
  final bool soloPagos;
  final bool soloPremium;

  const _QuickAccessItem({
    required this.label,
    required this.icon,
    required this.route,
    this.soloAdmin = false,
    this.soloPagos = false,
    this.soloPremium = false,
  });
}

const _allItems = [
  _QuickAccessItem(
      label: 'Ventas', icon: Icons.point_of_sale, route: AppRoutes.ventas),
  _QuickAccessItem(
      label: 'Inventario',
      icon: Icons.inventory_2,
      route: AppRoutes.inventario,
      soloAdmin: true),
  _QuickAccessItem(label: 'Caja', icon: Icons.payments, route: AppRoutes.caja),
  _QuickAccessItem(
      label: 'Clientes',
      icon: Icons.people,
      route: AppRoutes.clientes,
      soloAdmin: true),
  _QuickAccessItem(
      label: 'Reportes',
      icon: Icons.bar_chart,
      route: AppRoutes.reportes,
      soloAdmin: true),
  _QuickAccessItem(
      label: 'Configuración',
      icon: Icons.settings,
      route: AppRoutes.configuracion,
      soloAdmin: true),
  _QuickAccessItem(
      label: 'RRHH',
      icon: Icons.badge,
      route: AppRoutes.rrhh,
      soloAdmin: true,
      soloPagos: true),
  _QuickAccessItem(
      label: 'Merma',
      icon: Icons.delete,
      route: AppRoutes.merma,
      soloAdmin: true,
      soloPremium: true),
  _QuickAccessItem(
      label: 'Movimientos',
      icon: Icons.history,
      route: AppRoutes.movimientos,
      soloAdmin: true,
      soloPremium: true),
  _QuickAccessItem(
      label: 'Contabilidad',
      icon: Icons.account_balance,
      route: AppRoutes.contabilidad,
      soloAdmin: true,
      soloPremium: true),
];

/// Grid de accesos rápidos a módulos. Filtra por rol.
class QuickAccessGrid extends ConsumerWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final config = ref.watch(appConfigProvider);
    final esAdmin = user.value?.esAdmin ?? false;

    final items = _allItems.where((item) {
      if (item.soloAdmin && !esAdmin) return false;
      if (item.soloPagos && !config.puedePersonalizar) return false;
      if (item.soloPremium && config.plan != 'todos_juguetes') return false;
      return true;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsivo: 2 cols móvil, 3 tablet, 4 desktop
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildItem(context, items[index]),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, _QuickAccessItem item) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go(item.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: theme.textTheme.labelLarge,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
