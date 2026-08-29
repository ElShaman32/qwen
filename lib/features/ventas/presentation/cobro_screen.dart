import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../../clientes/data/cliente_dao.dart';
import '../data/metodos_pago_provider.dart';
import '../data/venta_dao.dart';
import '../domain/venta_models.dart';
import 'carrito_notifier.dart';
import 'widgets/dialogo_seleccion_cliente.dart';

/// Pantalla de cobro: métodos activos, fiado con cliente, recibido,
/// vuelto normal y vuelto inteligente en $.
class CobroScreen extends ConsumerStatefulWidget {
  const CobroScreen({super.key});

  @override
  ConsumerState<CobroScreen> createState() => _CobroScreenState();
}

class _CobroScreenState extends ConsumerState<CobroScreen> {
  MetodoPago? _metodo;
  bool _esFiado = false;
  ClienteData? _cliente;
  final _recibidoController = TextEditingController();
  final _terceraController = TextEditingController();
  double? _disponibleUsd;

  @override
  void dispose() {
    _recibidoController.dispose();
    _terceraController.dispose();
    super.dispose();
  }

  double _red2(double x) => (x * 100).round() / 100;

  bool get _esEfectivo => _metodo?.id.startsWith('efectivo') ?? false;
  bool get _esEfectivoUsd => _metodo?.id == 'efectivo_usd';

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(carritoProvider);
    final config = ref.watch(appConfigProvider);
    final metodosAsync = ref.watch(metodosPagoProvider);
    final theme = Theme.of(context);

    final totalUsd = _red2(items.fold(0.0, (a, i) => a + i.subtotalUsd));

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cobro')),
        body: const Center(child: Text('No hay productos en el carrito')),
      );
    }

    final tasa = _esFiado
        ? config.tasaEfectiva
        : (_metodo?.id == 'tercera_moneda')
            ? config.tasaEfectiva // Bs por $ para mostrar/convertir
            : (_metodo?.tasaPropia ?? config.tasaEfectiva);
    final gravadoUsd = _red2(items
        .where((i) => !i.producto.exentoIva)
        .fold(0.0, (a, i) => a + i.subtotalUsd));
    final exentoUsd = _red2(totalUsd - gravadoUsd);
    final gravadoBs = _red2(gravadoUsd * tasa);
    final exentoBs = _red2(exentoUsd * tasa);
    final totalBs = _red2(gravadoBs + exentoBs);

    final esBs = !_esFiado && _metodo?.simbolo == 'Bs';
    final esTercera = !_esFiado && _metodo?.id == 'tercera_moneda';
    final totalEnMoneda = esBs ? totalBs : totalUsd;

    final recibido =
        double.tryParse(_recibidoController.text.trim().replaceAll(',', '.'));
    final vuelto =
        (_esEfectivo && recibido != null && recibido >= totalEnMoneda)
            ? _red2(recibido - totalEnMoneda)
            : 0.0;

    final excedeLimite = _esFiado &&
        _cliente != null &&
        _cliente!.limiteCreditoUsd != null &&
        (_cliente!.saldoPendienteUsd + totalUsd) >
            _cliente!.limiteCreditoUsd! + 0.001;

    final puedeCobrar = _esFiado
        ? (_cliente != null && !excedeLimite)
        : esTercera
            ? ((_metodo?.tasaPropia ?? 0) > 0)
            : (_metodo != null &&
                (!_esEfectivo ||
                    (recibido != null && recibido >= totalEnMoneda)));

    return Scaffold(
      appBar: AppBar(title: const Text('Cobro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total a pagar
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('TOTAL A PAGAR', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    Formato.usd(totalUsd),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    '${Formato.bs(totalBs)} · Tasa: ${Formato.numero(tasa, decimales: 2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (exentoBs > 0)
                    Text(
                      'Incluye exento: ${Formato.bs(exentoBs)}',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Métodos de pago + Fiado
          Text('Método de pago', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          metodosAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (metodos) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...metodos.map((m) => ChoiceChip(
                      label: Text(m.nombre),
                      selected: !_esFiado && _metodo?.id == m.id,
                      onSelected: (_) => setState(() {
                        _metodo = m;
                        _esFiado = false;
                        _terceraController.clear();
                        _disponibleUsd = null;
                        _recibidoController.clear();
                      }),
                    )),
                ChoiceChip(
                  label: const Text('Fiado'),
                  selected: _esFiado,
                  onSelected: (_) => setState(() {
                    _esFiado = true;
                    _metodo = null;
                    _terceraController.clear();
                    _disponibleUsd = null;
                    _recibidoController.clear();
                  }),
                ),
              ],
            ),
          ),

          // Fiado: selector de cliente
          if (_esFiado) ...[
            const SizedBox(height: 16),
            _buildSelectorCliente(context, totalUsd),
          ] else if (_metodo != null) ...[
            const SizedBox(height: 16),
            if (_esEfectivo) ...[
              TextField(
                controller: _recibidoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Recibido (${_metodo!.simbolo})',
                  hintText: esBs ? 'Ej: 600' : 'Ej: 20',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              if (vuelto > 0)
                Text(
                  'Vuelto: ${esBs ? Formato.bs(vuelto) : Formato.usd(vuelto)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              // Vuelto inteligente (solo efectivo USD)
              if (_esEfectivoUsd && vuelto > 0) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _abrirCambioInteligente(vuelto),
                  icon: const Icon(Icons.currency_exchange),
                  label: const Text('No tengo cambio suficiente en \$'),
                ),
                if (_disponibleUsd != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vuelto mixto:',
                            style: theme.textTheme.titleSmall),
                        Text(
                          'Entrega ${Formato.usd(_disponibleUsd!)} + '
                          '${Formato.bs(_red2((vuelto - _disponibleUsd!) * tasa))}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ]
            ] else if (esTercera) ...[
              _buildTercera(context, theme, totalUsd),
            ] else ...[
              _buildDatosMetodo(context, theme),
              Text(
                'Cobro exacto: ${esBs ? Formato.bs(totalBs) : Formato.usd(totalUsd)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: puedeCobrar ? _cobrar : null,
            icon: const Icon(Icons.check_circle),
            label: const Text('¡Vale! Cobrar'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorCliente(BuildContext context, double totalUsd) {
    final theme = Theme.of(context);

    if (_cliente == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'El fiado requiere un cliente registrado',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _seleccionarCliente,
                icon: const Icon(Icons.person_search),
                label: const Text('Seleccionar cliente'),
              ),
            ],
          ),
        ),
      );
    }

    final cliente = _cliente!;
    final nuevoSaldo = _red2(cliente.saldoPendienteUsd + totalUsd);
    final excede = cliente.limiteCreditoUsd != null &&
        nuevoSaldo > cliente.limiteCreditoUsd! + 0.001;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cliente.nombre,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Saldo: ${Formato.usd(cliente.saldoPendienteUsd)} → ${Formato.usd(nuevoSaldo)}',
                        style: theme.textTheme.bodySmall,
                      ),
                      if (cliente.limiteCreditoUsd != null)
                        Text(
                          'Límite: ${Formato.usd(cliente.limiteCreditoUsd!)}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: 'Cambiar cliente',
                  onPressed: _seleccionarCliente,
                ),
              ],
            ),
            if (excede) ...[
              const SizedBox(height: 8),
              Text(
                '⚠️ Este fiado excede el límite de crédito del cliente',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarCliente() async {
    final cliente = await showDialog<ClienteData>(
      context: context,
      builder: (_) => const DialogoSeleccionCliente(),
    );
    if (cliente != null && mounted) {
      setState(() => _cliente = cliente);
    }
  }

  Future<void> _abrirCambioInteligente(double vueltoUsd) async {
    final controller = TextEditingController();
    final resultado = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cuánto tienes en \$?'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Ej: 3,20'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              double.tryParse(controller.text.trim().replaceAll(',', '.')),
            ),
            child: const Text('¡Listo!'),
          ),
        ],
      ),
    );

    if (resultado == null) return;
    if (resultado < 0 || resultado > vueltoUsd) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('El monto debe ser menor o igual al vuelto')),
        );
      }
      return;
    }
    setState(() => _disponibleUsd = resultado);
  }

  Future<void> _cobrar() async {
    final items = ref.read(carritoProvider);
    final config = ref.read(appConfigProvider);
    final user = ref.read(currentUserProvider).value;

    final tasa = _esFiado
        ? config.tasaEfectiva
        : (_metodo?.id == 'tercera_moneda')
            ? config.tasaEfectiva // Bs por $ para mostrar/convertir
            : (_metodo?.tasaPropia ?? config.tasaEfectiva);
    final totalUsd = _red2(items.fold(0.0, (a, i) => a + i.subtotalUsd));
    final gravadoUsd = _red2(items
        .where((i) => !i.producto.exentoIva)
        .fold(0.0, (a, i) => a + i.subtotalUsd));
    final exentoUsd = _red2(totalUsd - gravadoUsd);
    final gravadoBs = _red2(gravadoUsd * tasa);
    final exentoBs = _red2(exentoUsd * tasa);
    final totalBs = _red2(gravadoBs + exentoBs);

    final esBs = !_esFiado && _metodo!.simbolo == 'Bs';

    final recibido = _esFiado
        ? null
        : double.tryParse(_recibidoController.text.trim().replaceAll(',', '.'));
    final vueltoTotal = _esEfectivo && recibido != null
        ? _red2(recibido - (esBs ? totalBs : totalUsd))
        : 0.0;

    double? vueltoUsd;
    double? vueltoBs;
    if (!_esFiado && _esEfectivoUsd && vueltoTotal > 0) {
      if (_disponibleUsd != null) {
        vueltoUsd = _disponibleUsd;
        vueltoBs = _red2((vueltoTotal - _disponibleUsd!) * tasa);
      } else {
        vueltoUsd = vueltoTotal;
      }
    } else if (!_esFiado && _esEfectivo && esBs && vueltoTotal > 0) {
      vueltoBs = vueltoTotal;
    }

    String? detallePago;
    if (!_esFiado) {
      if (_metodo!.id == 'pago_movil') {
        final partes = [_metodo!.telefono, _metodo!.cedula, _metodo!.banco]
            .where((s) => s.isNotEmpty)
            .toList();
        detallePago = partes.isEmpty ? null : partes.join(' · ');
      } else if (_metodo!.datosPago.isNotEmpty) {
        detallePago = _metodo!.datosPago;
      }
    }

    final pagos = _esFiado
        ? [
            Pago(
              metodoId: 'fiado',
              metodoNombre: 'Fiado (${_cliente!.nombre})',
              simbolo: '\$',
              esDivisa: false,
              montoUsd: totalUsd,
              montoBs: totalBs,
              tasa: tasa,
            ),
          ]
        : [
            Pago(
              metodoId: _metodo!.id,
              metodoNombre: _metodo!.nombre,
              simbolo: _metodo!.simbolo,
              esDivisa: _metodo!.esDivisa,
              montoUsd: totalUsd,
              montoBs: totalBs,
              tasa: tasa,
              recibido: _esEfectivo ? recibido : null,
              detallePago: detallePago,
              vueltoUsd: vueltoUsd,
              vueltoBs: vueltoBs,
              montoTercera: _metodo!.id == 'tercera_moneda' &&
                      (_metodo!.tasaPropia ?? 0) > 0
                  ? _red2(totalUsd / _metodo!.tasaPropia!)
                  : null,
              terceraSimbolo:
                  _metodo!.id == 'tercera_moneda' ? _metodo!.simbolo : null,
            ),
          ];

    // Impuestos: base/IVA solo sobre gravado; IGTF solo divisas (fiado no)
    final baseBs = gravadoBs / (1 + config.ivaRate);
    final ivaBs = _red2(gravadoBs - baseBs);
    final igtfBs = (!_esFiado && _metodo!.esDivisa)
        ? _red2(totalBs * config.igtfRate)
        : 0.0;

    try {
      final venta = await ref.read(ventaDaoProvider).registrarVenta(
        items: [
          for (final i in items)
            ItemVenta(
              productoId: i.producto.id,
              productoNombre: i.producto.nombre,
              codigo: i.producto.codigo,
              cantidad: i.cantidad,
              esGranel: i.producto.esGranel,
              unidadMedida: i.producto.unidadMedida,
              precioUnitarioUsd: i.producto.precioUsd,
              costoUnitarioUsd: i.producto.costoUsd,
              subtotalUsd: i.subtotalUsd,
              exentoIva: i.producto.exentoIva,
            ),
        ],
        pagos: pagos,
        totalUsd: totalUsd,
        totalBs: totalBs,
        tasaUsada: tasa,
        ivaBs: ivaBs,
        igtfBs: igtfBs,
        exentoBs: exentoBs,
        esFiado: _esFiado,
        clienteId: _esFiado ? _cliente!.id : null,
        usuarioId: user?.uid ?? '',
        usuarioNombre: user?.nombre ?? 'Cajero',
      );

      // Registrar el fiado en la cuenta del cliente (sube su saldo)
      if (_esFiado) {
        await ref.read(clienteDaoProvider).registrarMovimiento(
              clienteId: _cliente!.id,
              ventaId: venta.id,
              tipo: 'fiado',
              montoUsd: totalUsd,
              montoBs: totalBs,
              tasa: tasa,
              usuarioId: user?.uid ?? '',
              usuarioNombre: user?.nombre ?? 'Cajero',
            );
      }

      ref.read(carritoProvider.notifier).limpiar();
      if (!mounted) return;
      context.push(AppRoutes.ventasPostVenta, extra: venta);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la venta: $e')),
      );
    }
  }

  /// Tercera moneda: total en la moneda, recibido opcional y conversión.
  Widget _buildTercera(BuildContext context, ThemeData theme, double totalUsd) {
    final metodo = _metodo!;
    final valor = metodo.tasaPropia ?? 0;
    final totalTercera = valor > 0 ? _red2(totalUsd / valor) : 0.0;
    final recibido =
        double.tryParse(_terceraController.text.trim().replaceAll(',', '.'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total en ${metodo.simbolo}: ${Formato.numero(totalTercera, decimales: 2)}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '1 ${metodo.simbolo} = \$${Formato.numero(valor, decimales: 6)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _terceraController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Recibido en ${metodo.simbolo} (opcional)',
            hintText: 'Ej: 50000',
          ),
          onChanged: (_) => setState(() {}),
        ),
        if (recibido != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Equivale a ${Formato.usd(_red2(recibido * valor))}',
              style: theme.textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }

  /// Datos del método: QR para escanear + Pago Móvil estructurado.
  Widget _buildDatosMetodo(BuildContext context, ThemeData theme) {
    final m = _metodo!;
    final tieneEstructura = m.id == 'pago_movil' &&
        (m.telefono.isNotEmpty || m.cedula.isNotEmpty || m.banco.isNotEmpty);

    return Column(
      children: [
        if (m.qrUrl.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Escanea para pagar', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Image.network(
                    m.qrUrl,
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.qr_code, size: 72),
                  ),
                ],
              ),
            ),
          ),
        if (tieneEstructura || m.datosPago.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (m.telefono.isNotEmpty)
                    Text('Teléfono: ${m.telefono}',
                        style: theme.textTheme.bodyMedium),
                  if (m.cedula.isNotEmpty)
                    Text('Cédula/RIF: ${m.cedula}',
                        style: theme.textTheme.bodyMedium),
                  if (m.banco.isNotEmpty)
                    Text('Banco: ${m.banco}',
                        style: theme.textTheme.bodyMedium),
                  if (m.datosPago.isNotEmpty)
                    Text(m.datosPago, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
