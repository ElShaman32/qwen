import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/application/current_user_provider.dart';
import '../data/proveedor_dao.dart';

/// Formulario para crear o editar un proveedor.
class ProveedorFormScreen extends ConsumerStatefulWidget {
  final int? proveedorId; // null = crear, int = editar

  const ProveedorFormScreen({super.key, this.proveedorId});

  @override
  ConsumerState<ProveedorFormScreen> createState() =>
      _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends ConsumerState<ProveedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _rifController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _contactoController = TextEditingController();
  final _notasController = TextEditingController();

  bool _guardando = false;

  bool get _esEdicion => widget.proveedorId != null;

  @override
  void initState() {
    super.initState();
    if (_esEdicion) {
      _cargarProveedor();
    }
  }

  Future<void> _cargarProveedor() async {
    final dao = ref.read(proveedorDaoProvider);
    final prov = await dao.obtenerPorId(widget.proveedorId!);
    if (prov == null || !mounted) return;

    setState(() {
      _nombreController.text = prov.nombre;
      _rifController.text = prov.rif ?? '';
      _telefonoController.text = prov.telefono ?? '';
      _correoController.text = prov.correo ?? '';
      _direccionController.text = prov.direccion ?? '';
      _contactoController.text = prov.contacto ?? '';
      _notasController.text = prov.notas ?? '';
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rifController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _direccionController.dispose();
    _contactoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final user = ref.read(currentUserProvider).value;
      final dao = ref.read(proveedorDaoProvider);

      final nombre = _nombreController.text.trim();
      final rif = _rifController.text.trim().isEmpty
          ? null
          : _rifController.text.trim();
      final telefono = _telefonoController.text.trim().isEmpty
          ? null
          : _telefonoController.text.trim();
      final correo = _correoController.text.trim().isEmpty
          ? null
          : _correoController.text.trim();
      final direccion = _direccionController.text.trim().isEmpty
          ? null
          : _direccionController.text.trim();
      final contacto = _contactoController.text.trim().isEmpty
          ? null
          : _contactoController.text.trim();
      final notas = _notasController.text.trim().isEmpty
          ? null
          : _notasController.text.trim();

      bool exito;
      if (_esEdicion) {
        exito = await dao.actualizarProveedor(
          id: widget.proveedorId!,
          nombre: nombre,
          rif: rif,
          telefono: telefono,
          correo: correo,
          direccion: direccion,
          contacto: contacto,
          notas: notas,
          usuarioId: user?.uid ?? '',
          usuarioNombre: user?.nombre ?? 'Admin',
        );
      } else {
        await dao.insertarProveedor(
          nombre: nombre,
          rif: rif,
          telefono: telefono,
          correo: correo,
          direccion: direccion,
          contacto: contacto,
          notas: notas,
          usuarioId: user?.uid ?? '',
          usuarioNombre: user?.nombre ?? 'Admin',
        );
        exito = true;
      }

      if (!mounted) return;
      setState(() => _guardando = false);

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_esEdicion
                ? '¡Listo! Proveedor actualizado'
                : '¡Chévere! Proveedor creado'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 700));
        if (mounted) context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el proveedor')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar proveedor' : 'Nuevo proveedor'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nombre (obligatorio)
            TextFormField(
              controller: _nombreController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre del proveedor *',
                hintText: 'Ej: Distribuidora Polar',
              ),
              validator: (v) {
                final texto = (v ?? '').trim();
                if (texto.isEmpty) return 'Ingresa el nombre';
                if (texto.length < 2) return 'Mínimo 2 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // RIF y Teléfono
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rifController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'RIF',
                      hintText: 'J-12345678-9',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      hintText: '0412-1234567',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Correo
            TextFormField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'Ej: ventas@polar.com',
              ),
            ),
            const SizedBox(height: 16),

            // Dirección
            TextFormField(
              controller: _direccionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                hintText: 'Ej: Zona Industrial, Galpón 4',
              ),
            ),
            const SizedBox(height: 16),

            // Persona de contacto
            TextFormField(
              controller: _contactoController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Persona de contacto',
                hintText: 'Ej: María Pérez',
              ),
            ),
            const SizedBox(height: 16),

            // Notas
            TextFormField(
              controller: _notasController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas internas',
                hintText: 'Ej: Entrega los martes, pago a 15 días',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // Botón guardar
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_guardando
                  ? 'Guardando...'
                  : _esEdicion
                      ? '¡Listo! Guardar cambios'
                      : '¡Dale! Crear proveedor'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
