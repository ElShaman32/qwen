import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/formato.dart';
import '../../../clientes/data/cliente_dao.dart';

/// Diálogo de búsqueda y selección de cliente (para ventas fiadas).
class DialogoSeleccionCliente extends ConsumerStatefulWidget {
  const DialogoSeleccionCliente({super.key});

  @override
  ConsumerState<DialogoSeleccionCliente> createState() =>
      _DialogoSeleccionClienteState();
}

class _DialogoSeleccionClienteState
    extends ConsumerState<DialogoSeleccionCliente> {
  final _controller = TextEditingController();
  List<ClienteData> _clientes = [];
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

  Future<void> _buscar(String query) async {
    final lista = await ref.read(clienteDaoProvider).buscar(query);
    if (!mounted) return;
    setState(() {
      _clientes = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Seleccionar cliente'),
      content: SizedBox(
        width: double.maxFinite,
        height: 360,
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre o cédula...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _buscar,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _clientes.isEmpty
                      ? const Center(child: Text('Sin clientes registrados'))
                      : ListView.builder(
                          itemCount: _clientes.length,
                          itemBuilder: (context, index) {
                            final cliente = _clientes[index];
                            final debe = cliente.saldoPendienteUsd > 0;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Text(
                                  cliente.nombre.isNotEmpty
                                      ? cliente.nombre[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              title: Text(cliente.nombre),
                              subtitle: debe
                                  ? Text(
                                      'Debe: ${Formato.usd(cliente.saldoPendienteUsd)}',
                                      style: TextStyle(
                                          color: theme.colorScheme.error),
                                    )
                                  : const Text('Al día'),
                              onTap: () => Navigator.pop(context, cliente),
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
