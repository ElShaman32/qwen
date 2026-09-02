import 'package:el_cuaderno_de_mario/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/proveedor_dao.dart';
import 'dialogo_compra.dart';
import 'dialogo_pago.dart';

/// Detalle de un proveedor: info, saldo, historial de compras y pagos.
/// Gate: solo admin + puedePersonalizar (Cuaderno y Calculadora+).
class ProveedorDetailScreen extends ConsumerStatefulWidget {
  final int proveedorId;

  const ProveedorDetailScreen({super.key, required this.proveedorId});

  @override
  ConsumerState<ProveedorDetailScreen> createState() =>
      _ProveedorDetailScreenState();
}

class _ProveedorDetailScreenState extends ConsumerState<ProveedorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    Theme.of(context);

    // Gate por plan
    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Proveedor')),
        body: const Center(child: Text('No autorizado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del proveedor'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (opcion) async {
              if (opcion == 'editar') {
                context.push(
                    '${AppRoutes.proveedores}/editar/${widget.proveedorId}');
              } else if (opcion == 'eliminar') {
                await _confirmarEliminar(context);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'editar',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined, size: 20),
                  title: Text('Editar'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'eliminar',
                child: ListTile(
                  leading:
                      Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  title: Text('Eliminar', style: TextStyle(color: Colors.red)),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<ProveedorData?>(
        future:
            ref.watch(proveedorDaoProvider).obtenerPorId(widget.proveedorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final prov = snapshot.data;
          if (prov == null) {
            return const Center(child: Text('Proveedor no encontrado'));
          }
          return _buildContenido(context, prov);
        },
      ),
    );
  }

  Widget _buildContenido(BuildContext context, ProveedorData prov) {
    final theme = Theme.of(context);
    final tieneDeuda = prov.saldoPendienteUsd > 0.001;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info del proveedor
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              prov.nombre,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (prov.telefono != null &&
                              prov.telefono!.isNotEmpty)
                            IconButton(
                              tooltip: 'Llamar',
                              icon: const Icon(Icons.phone),
                              onPressed: () async {
                                final uri = Uri.parse('tel:${prov.telefono}');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (prov.rif != null && prov.rif!.isNotEmpty)
                        _buildInfoRow(context, 'RIF', prov.rif!),
                      if (prov.telefono != null && prov.telefono!.isNotEmpty)
                        _buildInfoRow(context, 'Teléfono',
                            Formato.telefono(prov.telefono!)),
                      if (prov.direccion != null && prov.direccion!.isNotEmpty)
                        _buildInfoRow(context, 'Dirección', prov.direccion!),
                      if (prov.contacto != null && prov.contacto!.isNotEmpty)
                        _buildInfoRow(context, 'Contacto', prov.contacto!),
                      if (prov.correo != null && prov.correo!.isNotEmpty)
                        _buildInfoRow(context, 'Correo', prov.correo!),
                      if (prov.notas != null && prov.notas!.isNotEmpty)
                        _buildInfoRow(context, 'Notas', prov.notas!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Saldo pendiente
              if (tieneDeuda)
                Card(
                  color: theme.colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.warning,
                            color: theme.colorScheme.onErrorContainer),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Saldo pendiente',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                        Text(
                          Formato.usd(prov.saldoPendienteUsd),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _abrirDialogoCompra(context, prov),
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('Registrar compra'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: tieneDeuda
                          ? () => _abrirDialogoPago(context, prov)
                          : null,
                      icon: const Icon(Icons.payment),
                      label: const Text('Registrar pago'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Historial de compras
              Text(
                'Historial de compras',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<CompraData>>(
                future: ref
                    .watch(proveedorDaoProvider)
                    .comprasDeProveedor(prov.uuid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final compras = snapshot.data ?? [];
                  if (compras.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Sin compras registradas',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: compras
                        .map((c) => _buildCompraRow(context, c))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Historial de pagos
              Text(
                'Historial de pagos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<PagoProveedorData>>(
                future:
                    ref.watch(proveedorDaoProvider).pagosDeProveedor(prov.uuid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final pagos = snapshot.data ?? [];
                  if (pagos.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Sin pagos registrados',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children:
                        pagos.map((p) => _buildPagoRow(context, p)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildCompraRow(BuildContext context, CompraData compra) {
    final theme = Theme.of(context);
    final fecha = DateTime.fromMillisecondsSinceEpoch(compra.fecha);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.shopping_bag,
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          compra.numeroFactura ?? 'Compra sin factura',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${Formato.fecha(fecha)} · ${compra.metodoPago}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Text(
          Formato.usd(compra.totalUsd),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPagoRow(BuildContext context, PagoProveedorData pago) {
    final theme = Theme.of(context);
    final fecha = DateTime.fromMillisecondsSinceEpoch(pago.fecha);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.tertiaryContainer,
          child: Icon(
            Icons.payment,
            color: theme.colorScheme.onTertiaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          pago.referencia ?? 'Pago sin referencia',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${Formato.fecha(fecha)} · ${pago.metodoPago}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Text(
          '-${Formato.usd(pago.montoUsd)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.tertiary,
          ),
        ),
      ),
    );
  }

  Future<void> _abrirDialogoCompra(
      BuildContext context, ProveedorData prov) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (_) => DialogoCompra(proveedor: prov),
    );
    if (resultado == true && mounted) {
      setState(() {}); // Refresh
    }
  }

  Future<void> _abrirDialogoPago(
      BuildContext context, ProveedorData prov) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (_) => DialogoPago(proveedor: prov),
    );
    if (resultado == true && mounted) {
      setState(() {}); // Refresh
    }
  }

  Future<void> _confirmarEliminar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar proveedor'),
        content: const Text(
          '¿Eliminar este proveedor?\n\n'
          'Solo se puede eliminar si no tiene saldo pendiente ni compras asociadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    final user = ref.read(currentUserProvider).value;
    final dao = ref.read(proveedorDaoProvider);

    final exito = await dao.eliminarProveedor(
      id: widget.proveedorId,
      usuarioId: user?.uid ?? '',
      usuarioNombre: user?.nombre ?? 'Admin',
    );

    if (!context.mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proveedor eliminado')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede eliminar: tiene saldo pendiente o compras asociadas',
          ),
        ),
      );
    }
  }
}
