import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../data/auditoria_export.dart';
import '../data/auditoria_providers.dart';

/// Pantalla de Movimientos críticos.
/// Diseño congelado en Decisiones.md: tarjetas con icono por tipo, chips de filtro,
/// búsqueda y export Excel. Gate de lectura: puedePersonalizar (Cuaderno y Calculadora+).
class MovimientosScreen extends ConsumerStatefulWidget {
  const MovimientosScreen({super.key});

  @override
  ConsumerState<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends ConsumerState<MovimientosScreen> {
  String _busqueda = '';
  bool _mostrandoBusqueda = false;
  bool _exportando = false;
  String _filtroTipo =
      'todos'; // 'todos' | 'ventas' | 'caja' | 'inventario' | 'usuarios' | 'config'
  final _busquedaController = TextEditingController();
  final _busquedaFocus = FocusNode();

  @override
  void dispose() {
    _busquedaController.dispose();
    _busquedaFocus.dispose();
    super.dispose();
  }

  void _abrirBusqueda() {
    setState(() => _mostrandoBusqueda = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _busquedaFocus.requestFocus();
    });
  }

  void _cerrarBusqueda() {
    setState(() {
      _mostrandoBusqueda = false;
      _busqueda = '';
    });
    _busquedaController.clear();
  }

  /// Aplica el filtro de tipo sobre la lista ya filtrada por búsqueda.
  List<AuditoriaLogData> _filtrarPorTipo(List<AuditoriaLogData> logs) {
    if (_filtroTipo == 'todos') return logs;
    return logs.where((log) {
      switch (_filtroTipo) {
        case 'ventas':
          return log.accion == 'venta_anulada' || log.accion == 'nota_credito';
        case 'caja':
          return const {
            'caja_apertura',
            'caja_cierre',
            'caja_retiro',
            'cierre_caja',
            'retiro_caja',
          }.contains(log.accion);
        case 'inventario':
          return log.accion == 'merma' ||
              log.accion.startsWith('producto_') ||
              log.accion.startsWith('categoria_') ||
              log.accion.startsWith('proveedor_') ||
              log.accion == 'compra_registrada' ||
              log.accion == 'pago_proveedor';
        case 'usuarios':
          return log.accion.startsWith('usuario_');
        case 'config':
          return log.accion == 'config_cambiada' ||
              log.accion == 'config_actualizada' ||
              log.accion == 'tasa_actualizada';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    // Gate por plan: solo planes pagos (Cuaderno y Calculadora+)
    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Movimientos')),
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
                    'Movimientos disponible en el plan Cuaderno y Calculadora o superior',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan para ver los Movimientos de mi bodega',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final logsAsync = ref.watch(auditoriaListProvider(_busqueda));

    return Scaffold(
      appBar: AppBar(
        leading: _mostrandoBusqueda
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _cerrarBusqueda,
              )
            : null,
        title: _mostrandoBusqueda
            ? TextField(
                controller: _busquedaController,
                focusNode: _busquedaFocus,
                decoration: const InputDecoration(
                  hintText: 'Buscar por acción o detalle...',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (valor) => setState(() => _busqueda = valor),
              )
            : const Text('Movimientos'),
        actions: [
          if (!_mostrandoBusqueda)
            IconButton(
              tooltip: 'Buscar',
              icon: const Icon(Icons.search),
              onPressed: _abrirBusqueda,
            ),
          IconButton(
            tooltip: 'Exportar a Excel',
            icon: _exportando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.file_download_outlined),
            onPressed: _exportando ? null : () => _exportarExcel(ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildChipsFiltro(theme),
          Expanded(
            child: logsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (logs) {
                final filtrados = _filtrarPorTipo(logs);
                if (filtrados.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        logs.isEmpty
                            ? 'Aún no hay movimientos registrados'
                            : 'Sin resultados para este filtro',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtrados.length,
                  itemBuilder: (context, i) =>
                      _buildTarjeta(context, filtrados[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsFiltro(ThemeData theme) {
    const filtros = <String, String>{
      'todos': 'Todos',
      'ventas': 'Ventas',
      'caja': 'Caja',
      'inventario': 'Inventario',
      'usuarios': 'Usuarios',
      'config': 'Config',
    };

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filtros.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final key = filtros.keys.elementAt(i);
          final label = filtros.values.elementAt(i);
          final activo = _filtroTipo == key;
          return FilterChip(
            label: Text(label),
            selected: activo,
            onSelected: (_) => setState(() => _filtroTipo = key),
            selectedColor: theme.colorScheme.primaryContainer,
            checkmarkColor: theme.colorScheme.onPrimaryContainer,
          );
        },
      ),
    );
  }

  Widget _buildTarjeta(BuildContext context, AuditoriaLogData log) {
    final theme = Theme.of(context);
    final fecha = DateTime.fromMillisecondsSinceEpoch(log.fecha);
    final estilo = _estiloAccion(log.accion, theme);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: estilo.color.withValues(alpha: 0.15),
          child: Icon(estilo.icono, color: estilo.color, size: 20),
        ),
        title: Text(
          estilo.titulo,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${log.usuarioNombre} · ${Formato.fechaHora(fecha)}',
              style: theme.textTheme.bodySmall,
            ),
            if (log.detalles != null && log.detalles!.isNotEmpty)
              Text(
                log.detalles!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        isThreeLine: log.detalles != null && log.detalles!.isNotEmpty,
      ),
    );
  }

  _EstiloAccion _estiloAccion(String accion, ThemeData theme) {
    switch (accion) {
      case 'venta_anulada':
        return _EstiloAccion(
          titulo: 'Venta anulada',
          icono: Icons.cancel_outlined,
          color: theme.colorScheme.error,
        );
      case 'caja_apertura':
        return _EstiloAccion(
          titulo: 'Apertura de caja',
          icono: Icons.lock_open,
          color: Colors.green.shade700,
        );
      case 'caja_cierre':
      case 'cierre_caja':
        return _EstiloAccion(
          titulo: 'Cierre de caja',
          icono: Icons.lock_outline,
          color: Colors.blue.shade700,
        );
      case 'caja_retiro':
      case 'retiro_caja':
        return _EstiloAccion(
          titulo: 'Retiro de caja',
          icono: Icons.attach_money,
          color: Colors.orange.shade700,
        );
      case 'merma':
        return _EstiloAccion(
          titulo: 'Merma registrada',
          icono: Icons.delete_outline,
          color: theme.colorScheme.error,
        );
      case 'usuario_modificado':
      case 'usuario_creado':
      case 'usuario_rol_cambiado':
      case 'usuario_estado_cambiado':
        return _EstiloAccion(
          titulo: _tituloUsuario(accion),
          icono: Icons.people_outline,
          color: Colors.purple.shade700,
        );
      case 'config_cambiada':
      case 'config_actualizada':
        return _EstiloAccion(
          titulo: 'Configuración cambiada',
          icono: Icons.settings_outlined,
          color: Colors.grey.shade700,
        );
      case 'tasa_actualizada':
        return _EstiloAccion(
          titulo: 'Tasa actualizada',
          icono: Icons.trending_up,
          color: Colors.green.shade700,
        );
      case 'login':
        return _EstiloAccion(
          titulo: 'Inicio de sesión',
          icono: Icons.login,
          color: theme.colorScheme.primary,
        );
      case 'logout':
        return _EstiloAccion(
          titulo: 'Cierre de sesión',
          icono: Icons.logout,
          color: theme.colorScheme.outline,
        );
      case 'nota_credito':
        return _EstiloAccion(
          titulo: 'Devolución registrada',
          icono: Icons.assignment_return,
          color: Colors.amber.shade700,
        );
      case 'categoria_creada':
        return _EstiloAccion(
          titulo: 'Categoría creada',
          icono: Icons.category_outlined,
          color: Colors.teal.shade700,
        );
      case 'categoria_actualizada':
        return _EstiloAccion(
          titulo: 'Categoría actualizada',
          icono: Icons.edit_outlined,
          color: Colors.teal.shade700,
        );
      case 'categoriaEliminada':
        return _EstiloAccion(
          titulo: 'Categoría eliminada',
          icono: Icons.delete_outline,
          color: Colors.teal.shade700,
        );
      case 'proveedor_creado':
        return _EstiloAccion(
          titulo: 'Proveedor creado',
          icono: Icons.local_shipping_outlined,
          color: Colors.indigo.shade700,
        );
      case 'proveedor_actualizado':
        return _EstiloAccion(
          titulo: 'Proveedor actualizado',
          icono: Icons.edit_outlined,
          color: Colors.indigo.shade700,
        );
      case 'proveedor_eliminado':
        return _EstiloAccion(
          titulo: 'Proveedor eliminado',
          icono: Icons.delete_outline,
          color: Colors.indigo.shade700,
        );
      case 'compra_registrada':
        return _EstiloAccion(
          titulo: 'Compra registrada',
          icono: Icons.shopping_bag_outlined,
          color: Colors.green.shade700,
        );
      case 'pago_proveedor':
        return _EstiloAccion(
          titulo: 'Pago a proveedor',
          icono: Icons.payment,
          color: Colors.blue.shade700,
        );
      default:
        return _EstiloAccion(
          titulo: accion.replaceAll('_', ' '),
          icono: Icons.history,
          color: theme.colorScheme.outline,
        );
    }
  }

  String _tituloUsuario(String accion) {
    switch (accion) {
      case 'usuario_creado':
        return 'Usuario creado';
      case 'usuario_rol_cambiado':
        return 'Rol cambiado';
      case 'usuario_estado_cambiado':
        return 'Estado de usuario cambiado';
      case 'usuario_modificado':
      default:
        return 'Usuario modificado';
    }
  }

  Future<void> _exportarExcel(WidgetRef ref) async {
    setState(() => _exportando = true);
    try {
      final ruta = await ref.read(auditoriaExportProvider).exportar();
      if (!mounted) return;
      if (Platform.isAndroid || Platform.isIOS) {
        await SharePlus.instance.share(
          ShareParams(
            subject: 'Movimientos - El Cuaderno de Mario',
            files: [XFile(ruta)],
          ),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('¡Listo! Movimientos listos para compartir')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Listo! Guardado en: $ruta'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al exportar: $e')),
      );
    } finally {
      if (mounted) setState(() => _exportando = false);
    }
  }
}

class _EstiloAccion {
  final String titulo;
  final IconData icono;
  final Color color;

  const _EstiloAccion({
    required this.titulo,
    required this.icono,
    required this.color,
  });
}
