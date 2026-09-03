import 'package:flutter/material.dart';
import 'package:flutter_lucide_animated/flutter_lucide_animated.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config_notifier.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/ui/animated_module_tile.dart';
import '../../../auth/application/current_user_provider.dart';

class _Modulo {
  const _Modulo({
    required this.label,
    required this.icono,
    required this.route,
    required this.color,
    this.soloAdmin = false,
    this.soloPagos = false,
    this.soloPremium = false,
  });

  final String label;
  final LucideAnimatedIconData icono;
  final String route;
  final Color color;
  final bool soloAdmin;
  final bool soloPagos;
  final bool soloPremium;
}

/// Grid de módulos estilo "Fast Menu": círculos coloreados con iconos
/// animados (draw-in al aparecer). Gates idénticos a HomeShell.
class QuickAccessGrid extends ConsumerWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final user = ref.watch(currentUserProvider);
    final esAdmin = config.isDemoMode || (user.value?.esAdmin ?? false);

    // Colores semánticos fijos por módulo (independientes del whitelabel,
    // como colores de categoría).
    final modulos = <_Modulo>[
      const _Modulo(
          label: 'Ventas',
          icono: cart,
          route: AppRoutes.ventas,
          color: Color(0xFF2E7D32)),
      const _Modulo(
          label: 'Inventario',
          icono: box,
          route: AppRoutes.inventario,
          color: Color(0xFF1565C0),
          soloAdmin: true),
      const _Modulo(
          label: 'Caja',
          icono: hand_coins,
          route: AppRoutes.caja,
          color: Color(0xFFEF6C00)),
      const _Modulo(
          label: 'Clientes',
          icono: users,
          route: AppRoutes.clientes,
          color: Color(0xFF00897B),
          soloAdmin: true),
      const _Modulo(
          label: 'Reportes',
          icono: chart_pie,
          route: AppRoutes.reportes,
          color: Color(0xFF6A1B9A),
          soloAdmin: true),
      const _Modulo(
          label: 'Config',
          icono: settings,
          route: AppRoutes.configuracion,
          color: Color(0xFF455A64),
          soloAdmin: true),
      const _Modulo(
          label: 'RRHH',
          icono: id_card,
          route: AppRoutes.rrhh,
          color: Color(0xFFC2185B),
          soloAdmin: true,
          soloPagos: true),
      const _Modulo(
          label: 'Proveedores',
          icono: truck,
          route: AppRoutes.proveedores,
          color: Color(0xFF5D4037),
          soloAdmin: true,
          soloPremium: true),
      const _Modulo(
          label: 'Merma',
          icono: delete,
          route: AppRoutes.merma,
          color: Color(0xFFC62828),
          soloAdmin: true,
          soloPremium: true),
      const _Modulo(
          label: 'Movimientos',
          icono: history,
          route: AppRoutes.movimientos,
          color: Color(0xFF0097A7),
          soloAdmin: true,
          soloPremium: true),
      const _Modulo(
          label: 'Contabilidad',
          icono: file_chart_line,
          route: AppRoutes.contabilidad,
          color: Color(0xFF283593),
          soloAdmin: true,
          soloPremium: true),
    ].where((m) {
      if (m.soloAdmin && !esAdmin) return false;
      if (m.soloPagos && !config.puedePersonalizar) return false;
      if (m.soloPremium && config.plan != 'todos_juguetes') return false;
      return true;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 900
            ? 6
            : constraints.maxWidth > 600
                ? 5
                : 4;
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 12,
          children: [
            for (var i = 0; i < modulos.length; i++)
              AnimatedModuleTile(
                index: i,
                icono: modulos[i].icono,
                label: modulos[i].label,
                color: modulos[i].color,
                onTap: () => context.go(modulos[i].route),
              ),
          ],
        );
      },
    );
  }
}
