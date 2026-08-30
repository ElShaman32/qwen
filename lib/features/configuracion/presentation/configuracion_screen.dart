import 'dart:io';

import 'package:el_cuaderno_de_mario/core/services/cloudinary_service.dart';
import 'package:el_cuaderno_de_mario/core/services/tasa_bcv_service.dart';
import 'package:el_cuaderno_de_mario/features/ventas/data/metodos_pago_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/config_service.dart';

/// Configuración operativa: tasa, impuestos y datos fiscales.
/// Solo admin. La identidad whitelabel (colores/logo) viene en Parte 2.
class ConfiguracionScreen extends ConsumerStatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  ConsumerState<ConfiguracionScreen> createState() =>
      _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends ConsumerState<ConfiguracionScreen> {
  final _tasaController = TextEditingController();
  final _ivaController = TextEditingController();
  final _igtfController = TextEditingController();
  final _rifController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _nombreNegocioController = TextEditingController();
  final _sloganController = TextEditingController();

  bool _subiendoLogo = false;
  bool _actualizandoTasa = false;
  bool _inicializado = false;
  bool _guardando = false;

  static const _coloresPrimarios = [
    '#1a5c2a',
    '#0d47a1',
    '#b71c1c',
    '#6a1b9a',
    '#e65100',
    '#00695c',
    '#37474f',
    '#880e4f',
  ];
  static const _coloresSecundarios = [
    '#ffd700',
    '#ffeb3b',
    '#ff8a65',
    '#80deea',
    '#c5e1a5',
    '#f48fb1',
    '#90a4ae',
    '#ffe082',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Prellena una sola vez con los valores actuales
    if (!_inicializado) {
      final config = ref.read(appConfigProvider);
      final tasaManual = config.tasaManual ?? 0;
      _tasaController.text =
          (tasaManual > 0 ? tasaManual : config.tasaEfectiva).toString();
      _ivaController.text = Formato.numero(config.ivaRate * 100, decimales: 0);
      _igtfController.text =
          Formato.numero(config.igtfRate * 100, decimales: 0);
      _nombreNegocioController.text = config.appNombre;
      _sloganController.text = config.appSlogan;
      _rifController.text = config.rif;
      _direccionController.text = config.direccion;
      _telefonoController.text = config.telefono;
      _inicializado = true;
    }
  }

  @override
  void dispose() {
    _tasaController.dispose();
    _ivaController.dispose();
    _igtfController.dispose();
    _nombreNegocioController.dispose();
    _sloganController.dispose();
    _rifController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  double? _parsear(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  Future<void> _guardar(Map<String, dynamic> campos) async {
    setState(() => _guardando = true);
    try {
      await ref.read(configServiceProvider).guardarCampos(campos);
      // Re-descarga y actualiza estado + Drift (tasa/tema aplican al instante)
      await ref.read(appConfigProvider.notifier).syncFromRemote();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Listo! Configuración guardada')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  /// Toggle: el admin decide automática o manual
  Future<void> _toggleUsarBcv(bool valor) async {
    await _guardar({'usarTasaBCV': valor});
  }

  /// Descarga la tasa BCV de las APIs y la guarda
  Future<void> _actualizarTasaBcv() async {
    setState(() => _actualizandoTasa = true);
    try {
      final tasa = await ref.read(tasaBcvServiceProvider).obtenerTasaBCV();
      if (tasa == null) {
        _snack(
            'No se pudo descargar la tasa BCV. Intenta más tarde o usa modo manual');
        return;
      }
      await _guardar({'tasa_bcv': tasa});
      await ref
          .read(configServiceProvider)
          .registrarHistorialTasa(tasa, 'bcv_api');
      if (mounted) {
        _snack(
            '¡Listo! Tasa BCV actualizada a ${Formato.numero(tasa, decimales: 2)}');
      }
    } finally {
      if (mounted) setState(() => _actualizandoTasa = false);
    }
  }

  /// Modo manual: el admin ingresa su propia tasa
  Future<void> _guardarTasaManual() async {
    final tasa = _parsear(_tasaController);
    if (tasa == null || tasa <= 0) {
      _snack('Tasa inválida');
      return;
    }
    await _guardar({'tasaManual': tasa});
    await ref
        .read(configServiceProvider)
        .registrarHistorialTasa(tasa, 'manual');
  }

  Future<void> _guardarImpuestos() async {
    final iva = _parsear(_ivaController);
    final igtf = _parsear(_igtfController);
    if (iva == null || igtf == null || iva < 0 || igtf < 0 || iva > 90) {
      _snack('Porcentajes inválidos');
      return;
    }
    await _guardar({'iva_rate': iva / 100, 'igtf_rate': igtf / 100});
  }

  Future<void> _guardarDatos() async {
    await _guardar({
      'rif': _rifController.text.trim(),
      'direccion': _direccionController.text.trim(),
      'telefono': _telefonoController.text.trim(),
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    // Solo admin
    if (user.value?.esAdmin != true) {
      return Scaffold(
        appBar: AppBar(title: const Text('Configuración')),
        body: const Center(
            child: Text('Solo el administrador puede configurar la bodega')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── TASA DE CAMBIO ────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tasa de cambio', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Tasa efectiva: ${Formato.numero(config.tasaEfectiva, decimales: 2)} Bs por \$',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Usar tasa BCV automática'),
                    subtitle: const Text('Descarga la tasa oficial del BCV'),
                    value: config.usarTasaBcv,
                    onChanged: _guardando ? null : _toggleUsarBcv,
                  ),
                  if (config.usarTasaBcv) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: (_guardando || _actualizandoTasa)
                            ? null
                            : _actualizarTasaBcv,
                        icon: _actualizandoTasa
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh),
                        label: Text(_actualizandoTasa
                            ? 'Descargando...'
                            : 'Actualizar tasa BCV'),
                      ),
                    ),
                  ] else ...[
                    TextField(
                      controller: _tasaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Tasa manual en Bs por \$',
                        hintText: 'Ej: 790,50',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _guardando ? null : _guardarTasaManual,
                        icon: const Icon(Icons.save),
                        label: const Text('¡Vale! Guardar tasa manual'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── IMPUESTOS ─────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Impuestos', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ivaController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'IVA %',
                            hintText: '16',
                            suffixText: '%',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _igtfController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'IGTF %',
                            hintText: '3',
                            suffixText: '%',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _guardando ? null : _guardarImpuestos,
                      icon: const Icon(Icons.percent),
                      label: const Text('¡Vale! Guardar impuestos'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── DATOS FISCALES ────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Datos de la bodega (ticket)',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _rifController,
                    decoration: const InputDecoration(
                      labelText: 'RIF',
                      hintText: 'J-12345678-9',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _direccionController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección',
                      hintText: 'Av. Principal, Caracas',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      hintText: '0212-1234567',
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _guardando ? null : _guardarDatos,
                      icon: const Icon(Icons.store),
                      label: const Text('¡Vale! Guardar datos'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildIdentidad(context, config),
                  const SizedBox(height: 12),
                  _buildMetodosPago(context, ref),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── IDENTIDAD (whitelabel, gated por plan) ─────────────────
  Widget _buildIdentidad(BuildContext context, AppConfigState config) {
    final theme = Theme.of(context);

    if (!config.puedePersonalizar) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.lock_outline, color: theme.colorScheme.outline),
              const SizedBox(height: 8),
              Text(
                'Mejora tu plan para personalizar tu bodega',
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Nombre, logo y colores propios están disponibles en el plan Cuaderno y Calculadora.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Identidad de tu bodega', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),

            // Logo
            Row(
              children: [
                _logoPreview(config),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        _subiendoLogo ? null : () => _cambiarLogo(context),
                    icon: _subiendoLogo
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.image),
                    label: const Text('Cambiar logo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _nombreNegocioController,
              decoration:
                  const InputDecoration(labelText: 'Nombre de la bodega'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sloganController,
              decoration: const InputDecoration(labelText: 'Slogan (opcional)'),
            ),
            const SizedBox(height: 12),

            Text('Color principal', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            _paletaColor(context, _coloresPrimarios, config.colorPrimario,
                (hex) => _guardar({'color_primario': hex})),
            const SizedBox(height: 12),

            Text('Color secundario', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            _paletaColor(context, _coloresSecundarios, config.colorSecundario,
                (hex) => _guardar({'color_secundario': hex})),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _guardando ? null : _guardarIdentidad,
                icon: const Icon(Icons.save),
                label: const Text('¡Vale! Guardar identidad'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoPreview(AppConfigState config) {
    final url = config.logoUrlEfectivo ?? '';
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: url.isNotEmpty
          ? ClipOval(
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.store),
              ),
            )
          : const Icon(Icons.store),
    );
  }

  Widget _paletaColor(BuildContext context, List<String> hexes,
      String seleccionado, ValueChanged<String> onPick) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: hexes.map((hex) {
        final sel = hex.toLowerCase() == (seleccionado).toLowerCase();
        return InkWell(
          onTap: () => onPick(hex),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _colorFromHex(hex),
              shape: BoxShape.circle,
              border: sel ? Border.all(color: Colors.black87, width: 3) : null,
            ),
            child: sel ? const Icon(Icons.check, color: Colors.white) : null,
          ),
        );
      }).toList(),
    );
  }

  Color _colorFromHex(String hex) {
    final v = int.tryParse(hex.replaceAll('#', ''), radix: 16) ?? 0;
    return Color(0xFF000000 | v);
  }

  Future<void> _guardarIdentidad() async {
    await _guardar({
      'app_nombre': _nombreNegocioController.text.trim(),
      'app_slogan': _sloganController.text.trim(),
    });
  }

  Future<void> _cambiarLogo(BuildContext context) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (file == null) return;

    setState(() => _subiendoLogo = true);
    try {
      final url = await ref
          .read(cloudinaryServiceProvider)
          .subirImagen(File(file.path));
      if (url == null) {
        _snack('No se pudo subir el logo. Verifica tu conexión');
        return;
      }
      await _guardar({'logo_url': url});
      if (mounted) _snack('¡Chévere! Logo actualizado');
    } finally {
      if (mounted) setState(() => _subiendoLogo = false);
    }
  }

  // ── MÉTODOS DE PAGO ────────────────────────────────────────
  Widget _buildMetodosPago(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final metodosAsync = ref.watch(metodosPagoAdminProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Métodos de pago', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
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
                  for (final m in metodos) _buildMetodoRow(context, ref, m),
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
      ),
    );
  }

  Widget _buildMetodoRow(BuildContext context, WidgetRef ref, MetodoPago m) {
    final theme = Theme.of(context);

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
        _subtituloMetodo(m),
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

  String _subtituloMetodo(MetodoPago m) {
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
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('¡Guardalo!'),
            ),
          ],
        ),
      ),
    );
  }
}
