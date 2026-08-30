import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/utils/validaciones.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/rrhh_service.dart';

/// Gestión de equipo: crear cajeros, activar/desactivar, cambiar roles.
/// Solo planes pagos (puedePersonalizar).
class RrhhScreen extends ConsumerWidget {
  const RrhhScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final usuariosAsync = ref.watch(usuariosProvider);
    final yo = ref.watch(currentUserProvider).value;

    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('RRHH')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline,
                    size: 56, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 12),
                Text(
                  'Múltiples usuarios disponible en el plan Cuaderno y Calculadora o superior',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Equipo')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _dialogoCrear(context, ref),
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar cajero'),
      ),
      body: usuariosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (usuarios) {
          if (usuarios.isEmpty) {
            return const Center(child: Text('Sin usuarios registrados'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final u = usuarios[index];
              final esYo = u.uid == yo?.uid;
              return _buildUsuarioCard(context, ref, u, esYo);
            },
          );
        },
      ),
    );
  }

  Widget _buildUsuarioCard(
      BuildContext context, WidgetRef ref, UsuarioApp u, bool esYo) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: u.esAdmin
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.secondaryContainer,
              child: Text(
                u.nombre.isNotEmpty ? u.nombre[0].toUpperCase() : '?',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${u.nombre}${esYo ? ' (tú)' : ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    u.correo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Rol (no puedes cambiarte el tuyo)
            PopupMenuButton<String>(
              onSelected: (rol) async {
                if (esYo) {
                  _snack(context, 'No puedes cambiar tu propio rol');
                  return;
                }
                await ref.read(rrhhServiceProvider).setRol(u.uid, rol);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'cajero', child: Text('Cajero')),
                PopupMenuItem(value: 'admin', child: Text('Admin')),
              ],
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: u.esAdmin
                      ? theme.colorScheme.primary.withValues(alpha: 0.15)
                      : theme.colorScheme.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      u.esAdmin ? 'Admin' : 'Cajero',
                      style: theme.textTheme.labelMedium,
                    ),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Activo (no puedes desactivarte a ti mismo)
            Switch(
              value: u.activo,
              onChanged: (v) async {
                if (esYo) {
                  _snack(context, 'No puedes desactivarte a ti mismo');
                  return;
                }
                if (!v) {
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text('Desactivar a ${u.nombre}'),
                      content: const Text(
                          'No podrá iniciar sesión hasta que lo actives de nuevo.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text('Desactivar'),
                        ),
                      ],
                    ),
                  );
                  if (confirmar != true) return;
                }
                await ref.read(rrhhServiceProvider).setActivo(u.uid, v);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogoCrear(BuildContext context, WidgetRef ref) async {
    final nombreController = TextEditingController();
    final correoController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool guardando = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nuevo cajero'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre completo *'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa el nombre'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo *'),
                  validator: Validaciones.correo,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña *'),
                  validator: Validaciones.passwordCreacion,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: guardando
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setState(() => guardando = true);

                      final error =
                          await ref.read(rrhhServiceProvider).crearCajero(
                                nombre: nombreController.text,
                                correo: correoController.text,
                                password: passwordController.text,
                              );

                      if (!context.mounted) return;
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(error ?? '¡Chévere! Cajero creado'),
                        backgroundColor: error == null
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                      ));
                    },
              child: guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('¡Dale! Crear'),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
