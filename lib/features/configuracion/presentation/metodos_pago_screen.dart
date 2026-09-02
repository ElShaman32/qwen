import 'dart:io';

import 'package:el_cuaderno_de_mario/features/configuracion/data/config_service.dart';
import 'package:el_cuaderno_de_mario/features/ventas/data/metodos_pago_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/cloudinary_service.dart';

/// Gestión de métodos de pago (lógica completa migrada del archivo original).
class MetodosPagoScreen extends ConsumerWidget {
  const MetodosPagoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final metodosAsync = ref.watch(metodosPagoAdminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Métodos de pago')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Solo los activos aparecen en el cobro',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          metodosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (metodos) => Column(
              children: [
                for (final m in metodos) _MetodoRow(metodo: m),
                if (!metodos.any((m) => m.id == 'tercera_moneda'))
                  TextButton.icon(
                    onPressed: () async {
                      await ref
                          .read(configServiceProvider)
                          .guardarMetodo('tercera_moneda', {
                        'activo': false,
                        'nombre': 'Tercera moneda',
                        'simbolo': 'COP',
                        'esDivisa': false,
                        'datosPago': '',
                        'tasaPropia': null,
                      });
                      ref.invalidate(metodosPagoAdminProvider);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar tercera moneda'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row de método individual ─────────────────────────────────────────────

class _MetodoRow extends ConsumerWidget {
  final MetodoPago metodo;
  const _MetodoRow({required this.metodo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final m = metodo;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Text(
          m.simbolo.isNotEmpty ? m.simbolo.substring(0, 1) : '?',
          style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
        ),
      ),
      title: Text(m.nombre),
      subtitle: Text(
        _subtitulo(m),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar',
            onPressed: () => _dialogoMetodo(context, ref, m),
          ),
          Switch(
            value: m.activo,
            onChanged: (v) async {
              await ref
                  .read(configServiceProvider)
                  .guardarMetodo(m.id, {'activo': v});
              ref.invalidate(metodosPagoAdminProvider);
              ref.invalidate(metodosPagoProvider);
            },
          ),
        ],
      ),
    );
  }

  String _subtitulo(MetodoPago m) {
    final partes = <String>[];
    if (m.id == 'tercera_moneda' && m.tasaPropia != null) {
      partes.add('1 ${m.simbolo} = \$${m.tasaPropia}');
    } else if (m.tasaPropia != null) {
      partes.add('Tasa propia: ${m.tasaPropia}');
    }
    if (m.datosPago.isNotEmpty) partes.add(m.datosPago);
    return partes.isEmpty
        ? (m.activo ? 'Activo' : 'Inactivo')
        : partes.join(' · ');
  }

  Future<void> _dialogoMetodo(
      BuildContext context, WidgetRef ref, MetodoPago m) async {
    final esTercera = m.id == 'tercera_moneda';
    final esPagoMovil = m.id == 'pago_movil';
    final permiteQr = esPagoMovil || m.id == 'zelle' || m.id == 'binance';

    final nombreController = TextEditingController(text: m.nombre);
    final simboloController = TextEditingController(text: m.simbolo);
    final datosController = TextEditingController(text: m.datosPago);
    final tasaController = TextEditingController(
        text: m.tasaPropia != null ? m.tasaPropia.toString() : '');
    final telefonoController = TextEditingController(text: m.telefono);
    final cedulaController = TextEditingController(text: m.cedula);
    final bancoController = TextEditingController(text: m.banco);

    String qrUrl = m.qrUrl;
    bool subiendoQr = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Editar ${m.nombre}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (esTercera) ...[
                  TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre',
                          hintText: 'Ej: Peso colombiano')),
                  const SizedBox(height: 12),
                  TextField(
                      controller: simboloController,
                      decoration: const InputDecoration(
                          labelText: 'Símbolo', hintText: 'Ej: COP')),
                  const SizedBox(height: 12),
                ],
                if (esPagoMovil) ...[
                  TextField(
                    controller: telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: 'Teléfono', hintText: '0412-1234567'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cedulaController,
                    decoration: const InputDecoration(
                        labelText: 'Cédula/RIF', hintText: 'V-12.345.678'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bancoController,
                    decoration: const InputDecoration(
                        labelText: 'Banco', hintText: 'Ej: Bancaribe'),
                  ),
                  const SizedBox(height: 12),
                ] else if (!esTercera) ...[
                  TextField(
                    controller: datosController,
                    decoration: const InputDecoration(
                      labelText: 'Datos de pago (opcional)',
                      hintText: 'Correo, ID...',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: tasaController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: esTercera
                        ? 'Valor de 1 unidad en \$'
                        : 'Tasa propia en Bs por \$ (opcional)',
                    hintText: esTercera ? 'Ej: 0.00025' : 'Ej: 37.50',
                  ),
                ),
                if (permiteQr) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (qrUrl.isNotEmpty)
                        Container(
                          width: 72,
                          height: 72,
                          color: Colors.white,
                          child: Image.network(qrUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.qr_code)),
                        )
                      else
                        const Icon(Icons.qr_code, size: 48),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: subiendoQr
                              ? null
                              : () async {
                                  final picker = ImagePicker();
                                  final file = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 90);
                                  if (file == null) return;
                                  setState(() => subiendoQr = true);
                                  final url = await ref
                                      .read(cloudinaryServiceProvider)
                                      .subirImagen(File(file.path),
                                          folder: 'qr');
                                  setState(() {
                                    subiendoQr = false;
                                    if (url != null) qrUrl = url;
                                  });
                                },
                          icon: subiendoQr
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.upload),
                          label: const Text('Subir QR'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final tasa = double.tryParse(
                    tasaController.text.trim().replaceAll(',', '.'));
                final campos = <String, dynamic>{'tasaPropia': tasa};

                if (esTercera) {
                  campos['nombre'] = nombreController.text.trim().isEmpty
                      ? 'Tercera moneda'
                      : nombreController.text.trim();
                  campos['simbolo'] = simboloController.text.trim().isEmpty
                      ? 'TM'
                      : simboloController.text.trim();
                } else if (esPagoMovil) {
                  campos['telefono'] = telefonoController.text.trim();
                  campos['cedula'] = cedulaController.text.trim();
                  campos['banco'] = bancoController.text.trim();
                } else {
                  campos['datosPago'] = datosController.text.trim();
                }
                if (permiteQr) campos['qrUrl'] = qrUrl;

                await ref
                    .read(configServiceProvider)
                    .guardarMetodo(m.id, campos);
                ref.invalidate(metodosPagoAdminProvider);
                ref.invalidate(metodosPagoProvider);
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('¡Guardalo!'),
            ),
          ],
        ),
      ),
    );
  }
}
