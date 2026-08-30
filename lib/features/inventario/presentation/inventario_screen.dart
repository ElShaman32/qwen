import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:el_cuaderno_de_mario/core/widgets/scanner_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import 'inventario_notifier.dart';
import 'widgets/producto_card.dart';

/// Pantalla principal de inventario.
/// Búsqueda estilo Telegram: icono en AppBar, campo aparece al tocarlo.
class InventarioScreen extends ConsumerStatefulWidget {
  const InventarioScreen({super.key});

  @override
  ConsumerState<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends ConsumerState<InventarioScreen> {
  bool _buscando = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _abrirBusqueda() {
    setState(() => _buscando = true);
  }

  void _cerrarBusqueda() {
    _searchController.clear();
    ref.read(inventarioProvider.notifier).buscar('');
    setState(() => _buscando = false);
  }

  void _limpiarTexto() {
    _searchController.clear();
    ref.read(inventarioProvider.notifier).buscar('');
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final state = ref.watch(inventarioProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // En modo búsqueda: flecha atrás para cerrar
        leading: _buscando ? BackButton(onPressed: _cerrarBusqueda) : null,
        title: _buscando ? _buildSearchField(theme) : const Text('Inventario'),
        actions: [
          if (_buscando) ...[
            // Botón limpiar texto (X) si hay texto
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _limpiarTexto,
              ),
          ] else ...[
            // Icono de búsqueda (estilo Telegram)
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Buscar',
              onPressed: _abrirBusqueda,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${state.productos.length}',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('${AppRoutes.inventario}/nuevo'),
        icon: const Icon(Icons.add),
        label: const Text('¡Dale! Agregar'),
      ),
      body: state.cargando
          ? const Center(child: CircularProgressIndicator())
          : state.productos.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.productos.length,
                  itemBuilder: (context, index) {
                    final producto = state.productos[index];
                    return ProductoCard(
                      producto: producto,
                      tasa: config.tasaEfectiva,
                      onTap: () => context.push(
                          '${AppRoutes.inventario}/editar/${producto.id}'),
                      onEdit: () => context.push(
                          '${AppRoutes.inventario}/editar/${producto.id}'),
                      onDelete: () => _confirmarEliminar(
                          context, ref, producto.id, producto.nombre),
                    );
                  },
                ),
    );
  }

  /// Campo de búsqueda que aparece al tocar el icono (estilo Telegram).
  Widget _buildSearchField(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o código...',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onChanged: (value) {
              ref.read(inventarioProvider.notifier).buscar(value);
              setState(() {});
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          tooltip: 'Escanear código',
          onPressed: () async {
            final codigo = await mostrarEscanerCompacto(context);
            if (codigo != null) {
              _searchController.text = codigo;
              ref.read(inventarioProvider.notifier).buscar(codigo);
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 80, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'No hay productos todavía',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona "Agregar" para crear tu primer producto',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(
      BuildContext context, WidgetRef ref, int id, String nombre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que quieres eliminar "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(inventarioProvider.notifier).eliminarProducto(id);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
