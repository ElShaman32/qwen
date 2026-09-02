import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../../auth/application/current_user_provider.dart';
import '../../caja/presentation/caja_providers.dart';
import '../../reportes/data/reportes_service.dart';
import '../data/nota_credito_dao.dart';
import '../domain/venta_models.dart';
import 'ventas_historial_screen.dart';

/// Estado de un item en la pantalla de devolución.
class _ItemDevolucionEstado {
  final ItemVenta item;
  final double cantidadVendida;
  final double cantidadDevuelta;
  double cantidadADevolver = 0; // ⬅️ Ahora se inicializa directo

  _ItemDevolucionEstado({
    required this.item,
    required this.cantidadVendida,
    required this.cantidadDevuelta,
  });

  double get cantidadDisponible => cantidadVendida - cantidadDevuelta;

  double get subtotalDevolucion => item.precioUnitarioUsd * cantidadADevolver;

  String get unidad => item.esGranel ? (item.unidadMedida ?? 'kg') : 'und';
}

/// Pantalla de devolución parcial de una venta.
/// Gate: solo admin + plan puedePersonalizar.
class DevolucionScreen extends ConsumerStatefulWidget {
  final VentaData venta;

  const DevolucionScreen({super.key, required this.venta});

  @override
  ConsumerState<DevolucionScreen> createState() => _DevolucionScreenState();
}

class _DevolucionScreenState extends ConsumerState<DevolucionScreen> {
  final _motivoController = TextEditingController();
  List<_ItemDevolucionEstado> _items = [];
  bool _cargando = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargarItems();
  }

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _cargarItems() async {
    final venta = widget.venta;
    final itemsVenta = (jsonDecode(venta.itemsJson) as List)
        .map((e) => ItemVenta.fromJson(e as Map<String, dynamic>))
        .toList();

    final dao = ref.read(notaCreditoDaoProvider);
    final estados = <_ItemDevolucionEstado>[];

    for (final item in itemsVenta) {
      final devuelto = item.productoId != null
          ? await dao.cantidadDevuelta(venta.uuid, item.productoId!)
          : 0.0;

      estados.add(_ItemDevolucionEstado(
        item: item,
        cantidadVendida: item.cantidad,
        cantidadDevuelta: devuelto,
      ));
    }

    setState(() {
      _items = estados;
      _cargando = false;
    });
  }

  double get _totalDevolverUsd {
    return _items.fold(
      0.0,
      (acc, item) => acc + item.subtotalDevolucion,
    );
  }

  double get _totalDevolverBs {
    return _totalDevolverUsd * widget.venta.tasaUsada;
  }

  bool get _hayDevolucion {
    return _items.any((i) => i.cantidadADevolver > 0);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    // Gate por plan
    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Devolución')),
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
                    'Devoluciones disponibles en el plan Cuaderno y Calculadora o superior',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan para tener devoluciones',
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: Text('Devolución #${widget.venta.numeroVenta}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Devolución #${widget.venta.numeroVenta}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info de la venta original
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Venta original',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: ${Formato.usd(widget.venta.totalUsd)} · '
                          'Fecha: ${Formato.fecha(DateTime.fromMillisecondsSinceEpoch(widget.venta.fecha))}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de items
                Text(
                  'Productos a devolver',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final estado = entry.value;
                  return _buildItemRow(context, index, estado);
                }),
                const SizedBox(height: 16),

                // Motivo
                TextField(
                  controller: _motivoController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo de la devolución *',
                    hintText: 'Ej: producto dañado, cliente insatisfecho',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),

          // Resumen y botón confirmar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total a devolver:',
                        style: theme.textTheme.titleMedium,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formato.usd(_totalDevolverUsd),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            Formato.bs(_totalDevolverBs),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: (_hayDevolucion && !_guardando)
                          ? _confirmarDevolucion
                          : null,
                      icon: _guardando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.assignment_return),
                      label: const Text('Confirmar devolución'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(
    BuildContext context,
    int index,
    _ItemDevolucionEstado estado,
  ) {
    final theme = Theme.of(context);
    final disponible = estado.cantidadDisponible;

    if (disponible <= 0) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.check_circle,
                  color: theme.colorScheme.outline, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${estado.item.productoNombre} (todo devuelto)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    estado.item.productoNombre,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  Formato.usd(estado.item.precioUnitarioUsd),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Vendido: ${Formato.numero(estado.cantidadVendida, decimales: estado.item.esGranel ? 2 : 0)} ${estado.unidad}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 12),
                Text(
                  'Devuelto: ${Formato.numero(estado.cantidadDevuelta, decimales: estado.item.esGranel ? 2 : 0)} ${estado.unidad}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Cantidad a devolver',
                      hintText:
                          'Máx: ${Formato.numero(disponible, decimales: estado.item.esGranel ? 2 : 0)}',
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final cantidad =
                          double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                      setState(() {
                        estado.cantidadADevolver =
                            cantidad.clamp(0.0, disponible);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Subtotal:',
                      style: theme.textTheme.labelSmall,
                    ),
                    Text(
                      Formato.usd(estado.subtotalDevolucion),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarDevolucion() async {
    final motivo = _motivoController.text.trim();

    if (motivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El motivo de la devolución es obligatorio'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!_hayDevolucion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar al menos un producto para devolver'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Confirmación
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar devolución'),
        content: Text(
          'Se devolverán ${Formato.usd(_totalDevolverUsd)} '
          '(${Formato.bs(_totalDevolverBs)}).\n\n'
          'El stock se reintegrará automáticamente'
          '${widget.venta.esFiado ? ' y se ajustará el saldo del cliente' : ''}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _guardando = true);

    try {
      final user = ref.read(currentUserProvider).value;

      // Construir items de devolución
      final itemsDevolucion = _items
          .where((i) => i.cantidadADevolver > 0)
          .map((i) => ItemDevolucion(
                productoId: i.item.productoId,
                productoNombre: i.item.productoNombre,
                cantidad: i.cantidadADevolver,
                precioUnitarioUsd: i.item.precioUnitarioUsd,
                subtotalUsd: i.subtotalDevolucion,
                costoUnitarioUsd: i.item.costoUnitarioUsd, // ⬅️ NUEVO
              ))
          .toList();

      final ok = await ref.read(notaCreditoDaoProvider).registrarDevolucion(
            venta: widget.venta,
            itemsDevolucion: itemsDevolucion,
            montoUsd: _totalDevolverUsd,
            montoBs: _totalDevolverBs,
            tasa: widget.venta.tasaUsada,
            motivo: motivo,
            usuarioId: user?.uid ?? '',
            usuarioNombre: user?.nombre ?? 'Admin',
          );

      if (!mounted) return;

      if (ok) {
        // Invalidar providers para refrescar UI
        ref.invalidate(ventasHistorialProvider);
        ref.invalidate(resumenHoyProvider);
        ref.invalidate(resumenPeriodoProvider);
        ref.invalidate(topPeriodoProvider);
        ref.invalidate(cajaStateProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Listo! Devolución registrada')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al registrar la devolución'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }
}
