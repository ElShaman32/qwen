import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../data/cliente_dao.dart';

/// Crear o editar cliente.
class ClienteFormScreen extends ConsumerStatefulWidget {
  final int? clienteId;

  const ClienteFormScreen({super.key, this.clienteId});

  @override
  ConsumerState<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends ConsumerState<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _limiteController = TextEditingController();
  bool _guardando = false;

  bool get _esEdicion => widget.clienteId != null;

  @override
  void initState() {
    super.initState();
    if (_esEdicion) _cargar();
  }

  Future<void> _cargar() async {
    final cliente =
        await ref.read(clienteDaoProvider).obtenerPorId(widget.clienteId!);
    if (cliente == null || !mounted) return;

    setState(() {
      _nombreController.text = cliente.nombre;
      _cedulaController.text = cliente.cedula ?? '';
      _telefonoController.text = cliente.telefono ?? '';
      _limiteController.text = cliente.limiteCreditoUsd?.toString() ?? '';
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    _limiteController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final dao = ref.read(clienteDaoProvider);
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final limite =
        double.tryParse(_limiteController.text.trim().replaceAll(',', '.'));

    if (_esEdicion) {
      await dao.actualizar(
          widget.clienteId!,
          ClienteCompanion(
            nombre: Value(_nombreController.text.trim()),
            cedula: Value(_cedulaController.text.trim().isEmpty
                ? null
                : _cedulaController.text.trim()),
            telefono: Value(_telefonoController.text.trim().isEmpty
                ? null
                : _telefonoController.text.trim()),
            limiteCreditoUsd: Value(limite),
            fechaActualizacion: Value(ahora),
          ));
    } else {
      await dao.insertar(ClienteCompanion.insert(
        uuid: const Uuid().v4(),
        nombre: _nombreController.text.trim(),
        cedula: Value(_cedulaController.text.trim().isEmpty
            ? null
            : _cedulaController.text.trim()),
        telefono: Value(_telefonoController.text.trim().isEmpty
            ? null
            : _telefonoController.text.trim()),
        limiteCreditoUsd: Value(limite),
        fechaCreacion: ahora,
        fechaActualizacion: ahora,
      ));
    }

    ref.invalidate(clientesListProvider);
    if (_esEdicion) ref.invalidate(clientePorIdProvider);

    if (!mounted) return;
    setState(() => _guardando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_esEdicion
            ? '¡Listo! Cliente actualizado'
            : '¡Chévere! Cliente registrado'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar cliente' : 'Nuevo cliente'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreController,
              inputFormatters: [CapitalizeFirstLetterFormatter()],
              decoration: const InputDecoration(
                labelText: 'Nombre completo *',
                hintText: 'Ej: María Rodríguez',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Ingresa el nombre' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cedulaController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [CedulaFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Cédula',
                      hintText: 'V-12.345.678',
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
            TextFormField(
              controller: _limiteController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Límite de crédito en \$ (opcional)',
                hintText: 'Ej: 50',
                helperText: 'Se aplica en el plan Todos los Juguetes',
              ),
            ),
            const SizedBox(height: 32),
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
                      ? '¡Listo! Guardar'
                      : '¡Dale! Registrar'),
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
