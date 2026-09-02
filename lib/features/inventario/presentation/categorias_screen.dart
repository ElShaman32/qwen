import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/database/app_database.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/categoria_dao.dart';

/// Gestión de categorías de productos.
/// Gate: solo admin + puedePersonalizar (Cuaderno y Calculadora+).
class CategoriasScreen extends ConsumerWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    // Gate por plan
    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categorías')),
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
                    'Categorías disponibles en el plan Cuaderno y Calculadora o superior',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje:
                      'Hola SiReBAi, quiero mejorar mi plan para tener categorías de productos',
                ),
              ],
            ),
          ),
        ),
      );
    }

    final categoriasStream = ref.watch(categoriaDaoProvider).observar();

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialogoCategoria(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nueva categoría'),
      ),
      body: StreamBuilder<List<CategoriaData>>(
        stream: categoriasStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final categorias = snapshot.data ?? [];

          if (categorias.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.category_outlined,
                        size: 64, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      'Sin categorías',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crea tu primera categoría para organizar tus productos',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final cat = categorias[index];
              return _buildCategoriaTile(context, ref, cat);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoriaTile(
      BuildContext context, WidgetRef ref, CategoriaData cat) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            cat.orden.toString(), // número de orden visual
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          cat.nombre,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Orden: ${cat.orden}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (opcion) async {
            if (opcion == 'editar') {
              await _dialogoCategoria(context, ref, categoria: cat);
            } else if (opcion == 'eliminar') {
              await _confirmarEliminar(context, ref, cat);
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
      ),
    );
  }

  Future<void> _dialogoCategoria(
    BuildContext context,
    WidgetRef ref, {
    CategoriaData? categoria,
  }) async {
    final controller = TextEditingController(text: categoria?.nombre ?? '');
    final formKey = GlobalKey<FormState>();
    final esEditar = categoria != null;
    bool guardando = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(esEditar ? 'Editar categoría' : 'Nueva categoría'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre de la categoría *',
                hintText: 'Ej: Bebidas, Lácteos, Limpieza',
              ),
              validator: (v) {
                final texto = (v ?? '').trim();
                if (texto.isEmpty) return 'El nombre es obligatorio';
                if (texto.length < 2) return 'Mínimo 2 caracteres';
                if (texto.length > 40) return 'Máximo 40 caracteres';
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: guardando
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setState(() => guardando = true);

                      try {
                        final user = ref.read(currentUserProvider).value;
                        final dao = ref.read(categoriaDaoProvider);

                        if (esEditar) {
                          await dao.actualizar(
                            id: categoria.id,
                            nombre: controller.text.trim(),
                            usuarioId: user?.uid ?? '',
                            usuarioNombre: user?.nombre ?? 'Admin',
                          );
                        } else {
                          await dao.insertar(
                            nombre: controller.text.trim(),
                            usuarioId: user?.uid ?? '',
                            usuarioNombre: user?.nombre ?? 'Admin',
                          );
                        }

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      } catch (e) {
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      } finally {
                        if (dialogContext.mounted) {
                          setState(() => guardando = false);
                        }
                      }
                    },
              child: guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(esEditar ? '¡Listo! Guardar' : '¡Dale! Crear'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarEliminar(
    BuildContext context,
    WidgetRef ref,
    CategoriaData cat,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text(
          '¿Eliminar "${cat.nombre}"?\n\n'
          'Los productos que tenían esta categoría quedarán sin categoría.',
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

    try {
      final user = ref.read(currentUserProvider).value;
      await ref.read(categoriaDaoProvider).eliminar(
            id: cat.id,
            usuarioId: user?.uid ?? '',
            usuarioNombre: user?.nombre ?? 'Admin',
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría eliminada')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
