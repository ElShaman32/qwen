import 'package:el_cuaderno_de_mario/core/config/app_config_notifier.dart';
import 'package:el_cuaderno_de_mario/core/utils/plataforma.dart';
import 'package:el_cuaderno_de_mario/core/widgets/scanner_dialog.dart';
import 'package:el_cuaderno_de_mario/core/widgets/ui/form_section.dart';
import 'package:el_cuaderno_de_mario/core/widgets/ui/switch_row.dart';
import 'package:el_cuaderno_de_mario/features/inventario/data/categoria_dao.dart';
import 'package:el_cuaderno_de_mario/features/proveedores/data/proveedor_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/utils/formato.dart';
import '../../../core/utils/formatters.dart';
import '../data/producto_dao.dart';
import 'inventario_notifier.dart';

class ProductoFormScreen extends ConsumerStatefulWidget {
  final int? productoId;

  const ProductoFormScreen({super.key, this.productoId});

  @override
  ConsumerState<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends ConsumerState<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _codigoController = TextEditingController();
  final _categoriaController = TextEditingController();
  String? _proveedorUuidSeleccionado;
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
    if (_esEdicion) _cargarProducto();
  }

  Future<void> _cargarProducto() async {
    final dao = ref.read(productoDaoProvider);
    final producto = await dao.obtenerPorId(widget.productoId!);
    if (producto == null || !mounted) return;

    setState(() {
      _nombreController.text = producto.nombre;
      _codigoController.text = producto.codigo ?? '';
      _categoriaController.text = producto.categoria ?? '';
      _proveedorUuidSeleccionado = producto.proveedorUuid;
      _precioController.text = _formatMoney(producto.precioUsd);
      _precioMayorController.text = producto.precioMayor != null
          ? _formatMoney(producto.precioMayor!)
          : '';
      _costoController.text =
          producto.costoUsd > 0 ? _formatMoney(producto.costoUsd) : '';
      _exentoIva = producto.exentoIva;
      _stockController.text = _formatMoney(producto.stock, decimales: 3);
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
    _costoController.dispose();
    _stockController.dispose();
    _stockMinimoController.dispose();
    super.dispose();
  }

  /// Parsea texto con formato venezolano (1.500,50) a double.
  double _parseMoney(String s) {
    if (s.trim().isEmpty) return 0;
    return double.tryParse(s.replaceAll('.', '').replaceAll(',', '.').trim()) ??
        0;
  }

  /// Formatea double a string sin puntos (para cargar en el controller).
  String _formatMoney(double v, {int decimales = 2}) {
    if (v == 0) return '';
    return Formato.numero(v, decimales: decimales).replaceAll('.', '');
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final data = ProductoFormData(
      nombre: _nombreController.text,
      codigo: _codigoController.text,
      categoria: _categoriaController.text.trim().isEmpty
          ? null
          : _categoriaController.text.trim(),
      proveedorUuid: _proveedorUuidSeleccionado,
      precioUsd: _parseMoney(_precioController.text),
      costoUsd: _parseMoney(_costoController.text),
      precioMayor: _precioMayorController.text.trim().isEmpty
          ? null
          : _parseMoney(_precioMayorController.text),
      stock: _parseMoney(_stockController.text),
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
    final s = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── SECCIÓN 1: DATOS BÁSICOS ────────────────────────
            FormSection(
              titulo: 'Datos básicos',
              icono: LucideIcons.package,
              children: [
                TextFormField(
                  controller: _nombreController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto *',
                    hintText: 'Ej: harina de maíz 1kg',
                    prefixIcon: Icon(LucideIcons.tag),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa el nombre'
                      : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codigoController,
                        decoration: InputDecoration(
                          labelText: 'Código',
                          hintText: 'Barras o interno',
                          prefixIcon: const Icon(LucideIcons.barcode),
                          suffixIcon: esMovil()
                              ? IconButton(
                                  icon: const Icon(LucideIcons.scanLine,
                                      size: 20),
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
                      child: Consumer(
                        builder: (context, ref, _) {
                          final config = ref.watch(appConfigProvider);
                          final categoriasStream =
                              ref.watch(categoriaDaoProvider).observar();

                          if (!config.puedePersonalizar) {
                            return TextFormField(
                              controller: _categoriaController,
                              decoration: const InputDecoration(
                                labelText: 'Categoría',
                                hintText: 'Ej: víveres',
                                prefixIcon: Icon(LucideIcons.folderOpen),
                              ),
                            );
                          }

                          return StreamBuilder<List<dynamic>>(
                            stream: categoriasStream,
                            builder: (context, snapshot) {
                              final categorias = snapshot.data ?? [];
                              final nombres = categorias
                                  .map<dynamic>((c) => c.nombre as String)
                                  .toList();
                              final actual = _categoriaController.text.trim();
                              if (actual.isNotEmpty &&
                                  !nombres.contains(actual)) {
                                nombres.insert(0, actual);
                              }

                              return DropdownButtonFormField<String>(
                                initialValue:
                                    nombres.contains(actual) ? actual : null,
                                decoration: const InputDecoration(
                                  labelText: 'Categoría',
                                  prefixIcon: Icon(LucideIcons.folderOpen),
                                ),
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('Sin categoría'),
                                  ),
                                  for (final n in nombres)
                                    DropdownMenuItem<String>(
                                      value: n,
                                      child: Text(n,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                ],
                                onChanged: (v) {
                                  _categoriaController.text = v ?? '';
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final config = ref.watch(appConfigProvider);
                    if (!config.puedePersonalizar) {
                      return const SizedBox.shrink();
                    }

                    final proveedoresStream =
                        ref.watch(proveedorDaoProvider).observar();

                    return StreamBuilder<List<dynamic>>(
                      stream: proveedoresStream,
                      builder: (context, snapshot) {
                        final proveedores = snapshot.data ?? [];
                        final uuidActual = _proveedorUuidSeleccionado;
                        final existeEnLista =
                            proveedores.any((p) => p.uuid == uuidActual);

                        return DropdownButtonFormField<String>(
                          initialValue: existeEnLista ? uuidActual : null,
                          decoration: const InputDecoration(
                            labelText: 'Proveedor habitual',
                            hintText: 'Selecciona un proveedor',
                            prefixIcon: Icon(LucideIcons.truck),
                          ),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Sin proveedor asignado'),
                            ),
                            for (final p in proveedores)
                              DropdownMenuItem<String>(
                                value: p.uuid as String,
                                child: Text(p.nombre as String,
                                    overflow: TextOverflow.ellipsis),
                              ),
                          ],
                          onChanged: (v) {
                            setState(() => _proveedorUuidSeleccionado = v);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── SECCIÓN 2: PRECIOS ($ dominante) ────────────────
            FormSection(
              titulo: 'Precios',
              icono: LucideIcons.dollarSign,
              children: [
                TextFormField(
                  controller: _precioController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [MoneyInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Precio en USD *',
                    hintText: 'Ej: 1,50',
                    prefixIcon: Icon(LucideIcons.dollarSign),
                    prefixText: '\$ ',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa el precio';
                    final precio = _parseMoney(v);
                    if (precio <= 0) return 'Precio inválido';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _precioMayorController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [MoneyInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Precio por mayor (opcional)',
                    hintText: 'Ej: 1,20',
                    prefixIcon: Icon(LucideIcons.badgePercent),
                    prefixText: '\$ ',
                  ),
                ),
                TextFormField(
                  controller: _costoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [MoneyInputFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Costo en \$ (para calcular ganancia)',
                    hintText: 'Ej: 1,20',
                    prefixIcon: Icon(LucideIcons.calculator),
                    prefixText: '\$ ',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── SECCIÓN 3: TIPO DE PRODUCTO ─────────────────────
            FormSection(
              titulo: 'Tipo de producto',
              icono: LucideIcons.settings,
              children: [
                SwitchRow(
                  icono: LucideIcons.scale,
                  titulo: 'Producto a granel',
                  subtitulo: 'Se vende por peso o volumen (queso, carne, etc.)',
                  value: _esGranel,
                  onChanged: (v) => setState(() => _esGranel = v),
                ),
                SwitchRow(
                  icono: LucideIcons.ban,
                  titulo: 'Exento de IVA',
                  subtitulo: 'Alimentos de cesta básica y productos exentos',
                  value: _exentoIva,
                  onChanged: (v) => setState(() => _exentoIva = v),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── SECCIÓN 4: EXISTENCIA ───────────────────────────
            FormSection(
              titulo: 'Existencia',
              icono: LucideIcons.boxes,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _stockController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [MoneyInputFormatter(decimales: 3)],
                        decoration: InputDecoration(
                          labelText: _esGranel
                              ? 'Stock ($_unidadMedida) *'
                              : 'Stock (und) *',
                          hintText: _esGranel ? 'Ej: 15,5' : 'Ej: 20',
                          prefixIcon: const Icon(LucideIcons.boxes),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa el stock';
                          if (_parseMoney(v) < 0) return 'Stock inválido';
                          return null;
                        },
                      ),
                    ),
                    if (_esGranel) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _unidadMedida,
                          decoration: const InputDecoration(
                            labelText: 'Unidad',
                          ),
                          items: const [
                            DropdownMenuItem(value: 'kg', child: Text('kg')),
                            DropdownMenuItem(value: 'g', child: Text('g')),
                            DropdownMenuItem(value: 'lt', child: Text('lt')),
                          ],
                          onChanged: (v) =>
                              setState(() => _unidadMedida = v ?? 'kg'),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Stock mínimo (para alertas)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: s.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _stockMinimoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Ej: 5',
                    prefixIcon: Icon(LucideIcons.alertTriangle),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [5, 10, 20, 50].map((v) {
                    return ActionChip(
                      label: Text('$v'),
                      onPressed: () => _stockMinimoController.text = '$v',
                      backgroundColor: s.surfaceContainerHigh,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── SECCIÓN 5: VENCIMIENTO ──────────────────────────
            FormSection(
              titulo: 'Vencimiento',
              icono: LucideIcons.calendar,
              trailing: _fechaVencimiento != null
                  ? ActionChip(
                      avatar: Icon(LucideIcons.x, size: 14, color: s.error),
                      label: const Text('Quitar'),
                      onPressed: () => setState(() => _fechaVencimiento = null),
                      backgroundColor: s.errorContainer,
                      side: BorderSide.none,
                    )
                  : null,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _seleccionarFecha,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: s.surfaceContainerHigh.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: s.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.calendarDays,
                            size: 22, color: s.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _fechaVencimiento == null
                                    ? 'Fecha de vencimiento (opcional)'
                                    : Formato.fecha(_fechaVencimiento!),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              if (_fechaVencimiento != null)
                                Text(
                                  'Toca para cambiar',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: s.onSurfaceVariant),
                                ),
                            ],
                          ),
                        ),
                        Icon(LucideIcons.chevronRight,
                            size: 20, color: s.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── CTA GUARDAR ─────────────────────────────────────
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.save, size: 20),
              label: Text(_guardando
                  ? 'Guardando...'
                  : _esEdicion
                      ? '¡Listo! Guardar cambios'
                      : '¡Dale! Crear producto'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                shape: const StadiumBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
