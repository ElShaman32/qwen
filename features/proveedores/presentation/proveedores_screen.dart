import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../data/proveedor_dao.dart';

/// Lista de proveedores con saldos pendientes.
/// Gate: solo admin + puedePersonalizar (Cuaderno y Calculadora+).
class ProveedoresScreen extends ConsumerWidget {
  const ProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    // Gate por plan
    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Proveedores')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(Icons.lock_outline,
                      size: 56, color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Proveedores disponible en el plan Cuaderno y Calculadora o superior',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan para gestionar proveedores',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final proveedoresStream = ref.watch(proveedorDaoProvider).observar();

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.proveedoresNuevo),
        icon: const Icon(Icons.add),
        label: const Text('¡Dale! Agregar'),
      ),
      body: StreamBuilder<List<ProveedorData>>(
        stream: proveedoresStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final proveedores = snapshot.data ?? [];

          if (proveedores.isEmpty) {
            return _buildEmptyState(theme);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              final prov = proveedores[index];
              return _buildProveedorTile(context, prov);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping_outlined,
              size: 80, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text('No hay proveedores todavía',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Presiona "Agregar" para registrar tu primer proveedor',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProveedorTile(BuildContext context, ProveedorData prov) {
    final theme = Theme.of(context);
    final tieneDeuda = prov.saldoPendienteUsd > 0.001;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tieneDeuda
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.local_shipping,
            color: tieneDeuda
                ? theme.colorScheme.onErrorContainer
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          prov.nombre,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          [
            if (prov.rif != null && prov.rif!.isNotEmpty) prov.rif!,
            if (prov.telefono != null && prov.telefono!.isNotEmpty)
              Formato.telefono(prov.telefono!),
          ].join(' · '),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: tieneDeuda
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Debe',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      )),
                  Text(
                    Formato.usd(prov.saldoPendienteUsd),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              )
            : Icon(Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant),
        onTap: () => context.push('${AppRoutes.proveedores}/${prov.id}'),
      ),
    );
  }
}
