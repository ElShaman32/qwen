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

/// Log de todas las acciones: quién hizo qué y cuándo.
/// Solo plan Todos los Juguetes.
class AuditoriaScreen extends ConsumerStatefulWidget {
  const AuditoriaScreen({super.key});

  @override
  ConsumerState<AuditoriaScreen> createState() => _AuditoriaScreenState();
}

class _AuditoriaScreenState extends ConsumerState<AuditoriaScreen> {
  String _busqueda = '';
  bool _mostrandoBusqueda = false;
  bool _exportando = false;
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
    // Dar foco al campo de búsqueda tras el rebuild
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

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    // Gate por plan: solo Todos los Juguetes
    if (config.plan != 'todos_juguetes') {
      return Scaffold(
        appBar: AppBar(title: const Text('Auditoría')),
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
                    'Auditoría disponible en el plan Todos los Juguetes',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan a Todos los Juguetes para tener Auditoría',
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
        // Si estamos buscando: mostrar campo de texto. Si no: título normal.
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
            : const Text('Auditoría'),
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
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _busqueda.isEmpty
                      ? 'Aún no hay acciones registradas. ¡Chévere!'
                      : 'Sin resultados para "$_busqueda"',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: logs.length,
            itemBuilder: (context, i) => _buildRow(context, logs[i]),
          );
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, AuditoriaLogData log) {
    final theme = Theme.of(context);
    final fecha = DateTime.fromMillisecondsSinceEpoch(log.fecha);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.history,
              color: theme.colorScheme.onPrimaryContainer, size: 20),
        ),
        title: Text(_accionLegible(log.accion)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${log.usuarioNombre} · ${Formato.fechaHora(fecha)}',
              style: theme.textTheme.bodySmall,
            ),
            if (log.detalles != null && log.detalles!.isNotEmpty)
              Text(log.detalles!, style: theme.textTheme.bodySmall),
          ],
        ),
        isThreeLine: log.detalles != null && log.detalles!.isNotEmpty,
      ),
    );
  }

  String _accionLegible(String accion) {
    const etiquetas = {
      'login': 'Inicio de sesión',
      'logout': 'Cierre de sesión',
      'venta_anulada': 'Venta anulada',
      'caja_apertura': 'Apertura de caja',
      'caja_cierre': 'Cierre de caja',
      'caja_retiro': 'Retiro de caja',
      'producto_creado': 'Producto creado',
      'producto_actualizado': 'Producto actualizado',
      'producto_eliminado': 'Producto eliminado',
      'cliente_creado': 'Cliente creado',
      'fiado_registrado': 'Fiado registrado',
      'abono_registrado': 'Abono registrado',
      'tasa_actualizada': 'Tasa actualizada',
      'config_actualizada': 'Configuración actualizada',
      'usuario_creado': 'Usuario creado',
      'usuario_rol_cambiado': 'Rol cambiado',
      'usuario_estado_cambiado': 'Estado de usuario cambiado',
      'auditoria_exportada': 'Auditoría exportada',
    };
    return etiquetas[accion] ?? accion;
  }

  Future<void> _exportarExcel(WidgetRef ref) async {
    setState(() => _exportando = true);
    try {
      final ruta = await ref.read(auditoriaExportProvider).exportar();
      if (!mounted) return;

      if (Platform.isAndroid || Platform.isIOS) {
        await Share.shareXFiles(
          [XFile(ruta)],
          subject: 'Auditoría - El Cuaderno de Mario',
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('¡Listo! Auditoría lista para compartir')),
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
