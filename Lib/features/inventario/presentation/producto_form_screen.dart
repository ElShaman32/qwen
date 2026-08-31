import 'package:el_cuaderno_de_mario/core/utils/plataforma.dart';
import 'package:el_cuaderno_de_mario/core/widgets/scanner_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/formato.dart';
import '../data/producto_dao.dart';
import 'inventario_notifier.dart';

/// Formulario para crear o editar un producto.
class ProductoFormScreen extends ConsumerStatefulWidget {
  final int? productoId; // null = crear, int = editar

  const ProductoFormScreen({super.key, this.productoId});

  @override
  ConsumerState<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends ConsumerState<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _codigoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precioController = TextEditingController();
  final _precioMayorController = TextEditingController();
  final _costoController = TextEditingController();
  final _stockController = TextEditingController();
  final _stockMinimoController = TextEditingController(text: '5');

  bool _esGranel = false;
  String _unidadMedida = 'kg';
  DateTime? _fechaVencimiento;
  bool _guardando = false;
  bool _exentoIva = false;

  bool get _esEdicion => widget.productoId != null;

  @override
  void initState() {
    super.initState();
    if (_esEdicion) {
      _cargarProducto();
    }
  }

  Future<void> _cargarProducto() async {
    final dao = ref.read(productoDaoProvider);
    final producto = await dao.obtenerPorId(widget.productoId!);
    if (producto == null || !mounted) return;

    setState(() {
      _nombreController.text = producto.nombre;
      _codigoController.text = producto.codigo ?? '';
      _categoriaController.text = producto.categoria ?? '';
      _precioController.text = producto.precioUsd.toString();
      _precioMayorController.text = producto.precioMayor?.toString() ?? '';
      _costoController.text =
          producto.costoUsd > 0 ? producto.costoUsd.toString() : '';
      _exentoIva = producto.exentoIva;
      _stockController.text = producto.stock.toString();
      _stockMinimoController.text = producto.stockMinimo.toString();
      _esGranel = producto.esGranel;
      final unidad = producto.unidadMedida ?? 'kg';
      _unidadMedida = ['kg', 'g', 'lt'].contains(unidad) ? unidad : 'kg';
      if (producto.fechaVencimiento != null) {
        _fechaVencimiento =
            DateTime.fromMillisecondsSinceEpoch(producto.fechaVencimiento!);
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _categoriaController.dispose();
    _precioController.dispose();
    _precioMayorController.dispose();
    _stockController.dispose();
    _stockMinimoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final data = ProductoFormData(
      nombre: _nombreController.text,
      codigo: _codigoController.text,
      categoria: _categoriaController.text,
      precioUsd: double.parse(_precioController.text),
      costoUsd:
          double.tryParse(_costoController.text.trim().replaceAll(',', '.')) ??
              0,
      precioMayor: _precioMayorController.text.isEmpty
          ? null
          : double.parse(_precioMayorController.text),
      stock: double.parse(_stockController.text),
      exentoIva: _exentoIva,
      esGranel: _esGranel,
      unidadMedida: _esGranel ? _unidadMedida : null,
      fechaVencimiento: _fechaVencimiento?.millisecondsSinceEpoch,
      stockMinimo: int.tryParse(_stockMinimoController.text) ?? 5,
    );

    final notifier = ref.read(inventarioProvider.notifier);
    final exito = _esEdicion
        ? await notifier.actualizarProducto(widget.productoId!, data)
        : await notifier.crearProducto(data);

    if (!mounted) return;

    setState(() => _guardando = false);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_esEdicion
              ? '¡Listo! Producto actualizado'
              : '¡Chévere! Producto creado'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      // Deja ver el mensaje y regresa al inventario
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) context.pop();
    }
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (fecha != null) {
      setState(() => _fechaVencimiento = fecha);
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nombre
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto *',
                hintText: 'Ej: Harina de maíz 1kg',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Ingresa el nombre' : null,
            ),
            const SizedBox(height: 16),

            // Código y categoría
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _codigoController,
                    decoration: InputDecoration(
                      labelText: 'Código',
                      hintText: 'Barras o interno',
                      suffixIcon: esMovil()
                          ? IconButton(
                              icon: const Icon(Icons.qr_code_scanner),
                              tooltip: 'Escanear código',
                              onPressed: () async {
                                final codigo =
                                    await mostrarEscanerCompacto(context);
                                if (codigo != null) {
                                  _codigoController.text = codigo;
                                }
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _categoriaController,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      hintText: 'Ej: Víveres',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Precio USD
            TextFormField(
              controller: _precioController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Precio en USD *',
                hintText: 'Ej: 1.50',
                prefixText: '\$ ',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ingresa el precio';
                final precio = double.tryParse(v);
                if (precio == null || precio <= 0) {
                  return 'Precio inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Precio mayor (opcional)
            TextFormField(
              controller: _precioMayorController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Precio por mayor (opcional)',
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),
            TextFormField(
              controller: _costoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Costo en \$ (para ganancias)',
                hintText: 'Ej: 1.20',
              ),
            ),

            // Toggle granel
            SwitchListTile(
              title: const Text('Producto a granel'),
              subtitle: const Text('Se vende por peso (queso, carne, etc.)'),
              value: _esGranel,
              onChanged: (v) => setState(() => _esGranel = v),
            ),
            SwitchListTile(
              title: const Text('Exento de IVA'),
              subtitle:
                  const Text('Alimentos de cesta básica y productos exentos'),
              value: _exentoIva,
              onChanged: (v) => setState(() => _exentoIva = v),
            ),

            // Stock
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _esGranel ? 'Stock (kg) *' : 'Stock (und) *',
                      hintText: _esGranel ? 'Ej: 15.5' : 'Ej: 20',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa el stock';
                      if (double.tryParse(v) == null) return 'Stock inválido';
                      return null;
                    },
                  ),
                ),
                if (_esGranel) ...[
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _unidadMedida,
                    items: const [
                      DropdownMenuItem(value: 'kg', child: Text('kg')),
                      DropdownMenuItem(value: 'g', child: Text('g')),
                      DropdownMenuItem(value: 'lt', child: Text('lt')),
                    ],
                    onChanged: (v) => setState(() => _unidadMedida = v ?? 'kg'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Stock mínimo
            TextFormField(
              controller: _stockMinimoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock mínimo (para alertas)',
                hintText: 'Ej: 5',
              ),
            ),
            const SizedBox(height: 16),

            // Fecha de vencimiento
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _fechaVencimiento == null
                    ? 'Fecha de vencimiento (opcional)'
                    : 'Vence: ${Formato.fecha(_fechaVencimiento!)}',
              ),
              trailing: _fechaVencimiento != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _fechaVencimiento = null),
                    )
                  : null,
              onTap: _seleccionarFecha,
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
                      : '¡Dale! Crear producto'),
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
