import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../../inventario/data/producto_dao.dart';
import '../../inventario/presentation/inventario_notifier.dart';
import '../../ventas/presentation/ventas_screen.dart';
import '../data/merma_dao.dart';

const _motivos = {
  'vencido': 'Vencido',
  'danado': 'Dañado',
  'robo': 'Robo',
  'otro': 'Otro',
};

/// Gestión de merma (Plan Todos los Juguetes).
class MermaScreen extends ConsumerWidget {
  const MermaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final mermaAsync = ref.watch(mermaRecientesProvider);
    final theme = Theme.of(context);

    if (config.plan != 'todos_juguetes') {
      return Scaffold(
        appBar: AppBar(title: const Text('Merma')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline,
                    size: 56, color: theme.colorScheme.outline),
                const SizedBox(height: 12),
                Text(
                  'Gestión de merma disponible en el plan Todos los Juguetes',
                  style: theme.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Merma')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialogoRegistrar(context, ref),
        icon: const Icon(Icons.delete_outline),
        label: const Text('Registrar merma'),
      ),
      body: mermaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (lista) {
          final perdida = lista.fold(0.0, (a, m) => a + m.costoUsd);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pérdidas (30 días)',
                              style: theme.textTheme.labelLarge),
                          Text('${lista.length} registros',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                      Text(
                        Formato.usd(perdida),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (lista.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Sin merma registrada este mes. ¡Chévere!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ...lista.map((m) => _buildRow(context, m)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, MermaData m) {
    final theme = Theme.of(context);
    final fecha = DateTime.fromMillisecondsSinceEpoch(m.fecha);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.errorContainer,
          child: Icon(Icons.delete_outline,
              color: theme.colorScheme.onErrorContainer),
        ),
        title: Text(m.productoNombre),
        subtitle: Text(
          '${Formato.fecha(fecha)} · ${_motivos[m.motivo] ?? m.motivo}'
          '${m.nota != null ? ' · ${m.nota}' : ''}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${Formato.numero(m.cantidad, decimales: m.unidad == 'und' ? 0 : 2)} ${m.unidad}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '-${Formato.usd(m.costoUsd)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogoRegistrar(BuildContext context, WidgetRef ref) async {
    final producto = await showDialog<ProductoData>(
      context: context,
      builder: (_) => const _DialogoSeleccionProducto(),
    );
    if (producto == null || !context.mounted) return;
    await _dialogoDatos(context, ref, producto);
  }

  Future<void> _dialogoDatos(
      BuildContext context, WidgetRef ref, ProductoData producto) async {
    final cantidadController = TextEditingController();
    final notaController = TextEditingController();
    String motivo = 'vencido';
    String? error;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(producto.nombre),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Existencia: ${Formato.numero(producto.stock, decimales: producto.esGranel ? 2 : 0)} '
                '${producto.esGranel ? (producto.unidadMedida ?? 'kg') : 'und'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cantidadController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: producto.esGranel
                      ? 'Cantidad (${producto.unidadMedida ?? 'kg'})'
                      : 'Cantidad (und)',
                  errorText: error,
                ),
                onChanged: (_) => setState(() => error = null),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: motivo,
                items: _motivos.entries
                    .map((e) =>
                        DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (v) => setState(() => motivo = v ?? 'vencido'),
                decoration: const InputDecoration(labelText: 'Motivo'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notaController,
                decoration: const InputDecoration(labelText: 'Nota (opcional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final cantidad = double.tryParse(
                    cantidadController.text.trim().replaceAll(',', '.'));
                if (cantidad == null || cantidad <= 0) {
                  setState(() => error = 'Cantidad inválida');
                  return;
                }
                if (cantidad > producto.stock) {
                  setState(
                      () => error = 'No puedes registrar más de la existencia');
                  return;
                }

                final user = ref.read(currentUserProvider).value;
                await ref.read(mermaDaoProvider).registrar(
                      producto: producto,
                      cantidad: cantidad,
                      motivo: motivo,
                      nota: notaController.text.trim().isEmpty
                          ? null
                          : notaController.text.trim(),
                      usuarioId: user?.uid ?? '',
                      usuarioNombre: user?.nombre ?? 'Admin',
                    );

                ref.invalidate(mermaRecientesProvider);
                ref.invalidate(posProductosProvider);
                ref.invalidate(inventarioProvider);

                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('¡Vale! Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Selector de producto con búsqueda (paso 1 del registro).
class _DialogoSeleccionProducto extends ConsumerStatefulWidget {
  const _DialogoSeleccionProducto();

  @override
  ConsumerState<_DialogoSeleccionProducto> createState() =>
      _DialogoSeleccionProductoState();
}

class _DialogoSeleccionProductoState
    extends ConsumerState<_DialogoSeleccionProducto> {
  final _controller = TextEditingController();
  List<ProductoData> _productos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _buscar('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _buscar(String q) async {
    final lista = await ref.read(productoDaoProvider).buscar(q);
    if (!mounted) return;
    setState(() {
      _productos = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Producto con merma'),
      content: SizedBox(
        width: double.maxFinite,
        height: 360,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre o código...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _buscar,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _productos.length,
                      itemBuilder: (context, index) {
                        final p = _productos[index];
                        return ListTile(
                          title: Text(p.nombre),
                          subtitle: Text(
                              'Disp: ${Formato.numero(p.stock, decimales: p.esGranel ? 2 : 0)}'),
                          onTap: () => Navigator.pop(context, p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
