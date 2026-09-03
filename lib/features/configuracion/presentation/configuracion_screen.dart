import 'package:el_cuaderno_de_mario/core/utils/plataforma.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../../auth/application/current_user_provider.dart';
import 'widgets/acerca_de_dialog.dart';
import 'widgets/faq_dialog.dart';

/// Hub de configuración estilo Telegram.
/// Solo admin. La lógica de cada sección está en sub-pantallas.
class ConfiguracionScreen extends ConsumerWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    if (user.value?.esAdmin != true) {
      return Scaffold(
        appBar: AppBar(title: const Text('Configuración')),
        body: const Center(
          child: Text('Solo el administrador puede configurar la bodega'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header estilo Telegram (logo + nombre + RIF + slogan)
          _Header(config: config, theme: theme),
          const SizedBox(height: 8),

          // Sección 1: Datos de la bodega
          _SectionHeader(title: 'Negocio', theme: theme),
          _ConfigTile(
            icon: LucideIcons.store,
            title: 'Datos de la bodega',
            subtitle: 'RIF, dirección, teléfono (aparecen en el ticket)',
            onTap: () => context.push(AppRoutes.configDatos),
          ),
          _ConfigTile(
            icon: LucideIcons.palette,
            title: 'Identidad',
            subtitle: config.puedePersonalizar
                ? 'Nombre, logo, colores'
                : 'Disponible en plan Cuaderno y Calculadora',
            trailing: config.puedePersonalizar
                ? null
                : Icon(LucideIcons.lockKeyhole,
                    size: 20, color: theme.colorScheme.outline),
            onTap: config.puedePersonalizar
                ? () => context.push(AppRoutes.configIdentidad)
                : null,
          ),

          const SizedBox(height: 8),

          // Sección 2: Operaciones
          _SectionHeader(title: 'Operaciones', theme: theme),
          _ConfigTile(
            icon: LucideIcons.badgePercent,
            title: 'Impuestos y tasa',
            subtitle:
                'Tasa: ${Formato.numero(config.tasaEfectiva, decimales: 2)} · IVA: ${(config.ivaRate * 100).toInt()}% · IGTF: ${(config.igtfRate * 100).toInt()}%',
            onTap: () => context.push(AppRoutes.configImpuestos),
          ),
          _ConfigTile(
            icon: LucideIcons.circleDollarSign,
            title: 'Métodos de pago',
            subtitle: 'Configurar métodos del cobro',
            onTap: () => context.push(AppRoutes.configMetodosPago),
          ),
          if (config.puedePersonalizar && esMovil())
            _ConfigTile(
              icon: LucideIcons.printer,
              title: 'Impresora',
              subtitle: 'Configurar impresora térmica Bluetooth',
              onTap: () => context.push(AppRoutes.impresora),
            ),

          const SizedBox(height: 8),

          // Sección 3: Suscripción
          _SectionHeader(title: 'Suscripción', theme: theme),
          _ConfigTile(
            icon: _iconoSuscripcion(config),
            title: _tituloSuscripcion(config),
            subtitle: _subtituloSuscripcion(config),
            onTap: null,
          ),

          const SizedBox(height: 8),

          // Sección 4: Acerca de
          _SectionHeader(title: 'Soporte', theme: theme),
          _ConfigTile(
            icon: LucideIcons.info,
            title: 'Acerca de',
            subtitle: 'Versión de la app',
            onTap: () => showDialog(
              context: context,
              builder: (_) => const AcercaDeDialog(),
            ),
          ),
          _ConfigTile(
            icon: LucideIcons.messageCircleQuestionMark,
            title: 'Preguntas frecuentes',
            subtitle: 'Dudas comunes',
            onTap: () => showDialog(
              context: context,
              builder: (_) => const FaqDialog(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SirebaiWhatsappButton(
              mensaje: 'Hola SiReBAi, necesito ayuda con El Cuaderno de Mario',
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  IconData _iconoSuscripcion(AppConfigState config) {
    if (config.estaVencido) return LucideIcons.alertTriangle;
    switch (config.plan) {
      case 'cuaderno':
        return LucideIcons.book;
      case 'cuaderno_calculadora':
        return LucideIcons.calculator;
      case 'todos_juguetes':
        return LucideIcons.star;
      default:
        return LucideIcons.idCardLanyard;
    }
  }

  String _tituloSuscripcion(AppConfigState config) {
    if (config.estaVencido) return 'Suscripción vencida';
    switch (config.plan) {
      case 'cuaderno':
        return 'Plan Cuaderno (gratis)';
      case 'cuaderno_calculadora':
        return 'Plan Cuaderno y Calculadora';
      case 'todos_juguetes':
        return 'Plan Todos los Juguetes';
      default:
        return 'Plan activo';
    }
  }

  String _subtituloSuscripcion(AppConfigState config) {
    if (config.estaVencido) return 'Mejora tu plan para seguir usando todo';
    if (config.fechaVencimientoEpoch == 0) return 'Sin fecha de vencimiento';
    final fecha =
        DateTime.fromMillisecondsSinceEpoch(config.fechaVencimientoEpoch);
    return 'Vence: ${Formato.fecha(fecha)}';
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final AppConfigState config;
  final ThemeData theme;

  const _Header({required this.config, required this.theme});

  @override
  Widget build(BuildContext context) {
    final logoUrl = config.logoUrlEfectivo ?? '';
    return Container(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: theme.colorScheme.surface,
              child: logoUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        logoUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(LucideIcons.store, size: 36),
                      ),
                    )
                  : const Icon(LucideIcons.store, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.nombreEfectivo,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (config.rif.isNotEmpty)
                    Text(
                      'RIF: ${config.rif}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ConfigTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _ConfigTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
      ),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: trailing ??
          (onTap != null
              ? Icon(LucideIcons.chevronRight, color: theme.colorScheme.outline)
              : const SizedBox.shrink()),
      onTap: onTap,
    );
  }
}
