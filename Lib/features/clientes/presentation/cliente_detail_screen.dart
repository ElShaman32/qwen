import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/app_config_notifier.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/cliente_dao.dart';

/// Detalle del cliente: saldo, historial de fiados/abonos y acciones.
class ClienteDetailScreen extends ConsumerWidget {
  final int clienteId;

  const ClienteDetailScreen({super.key, required this.clienteId});

  double _red2(double x) => (x * 100).round() / 100;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clienteAsync = ref.watch(clientePorIdProvider(clienteId));
    final historialAsync = ref.watch(historialClienteProvider(clienteId));
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);

    return clienteAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (cliente) {
        if (cliente == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cliente')),
            body: const Center(child: Text('Cliente no encontrado')),
          );
        }

        final debe = cliente.saldoPendienteUsd > 0;

        return Scaffold(
          appBar: AppBar(title: Text(cliente.nombre)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Saldo
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('SALDO PENDIENTE',
                          style: theme.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        Formato.usd(cliente.saldoPendienteUsd),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: debe
                              ? theme.colorScheme.error
                              : const Color(0xFF4CAF50),
                        ),
                      ),
                      if (debe)
                        Text(
                          Formato.bs(
                              cliente.saldoPendienteUsd * config.tasaEfectiva),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      if (cliente.limiteCreditoUsd != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Límite: ${Formato.usd(cliente.limiteCreditoUsd!)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Acciones (Expanded dentro del Row, NUNCA minimumSize infinity)
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: debe
                          ? () => _dialogoAbono(context, ref, cliente, config)
                          : null,
                      icon: const Icon(Icons.payments),
                      label: const Text('Abonar'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context
                          .push('${AppRoutes.clientes}/editar/${cliente.id}'),
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Botón ancho completo FUERA del Row (SizedBox lo hace seguro)
              SizedBox(
                width: double.infinity,
                child: _buildBotonCobroWhatsApp(context, cliente, config, debe),
              ),
              const SizedBox(height: 24),

              // Historial
              Text('Historial', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              historialAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (movimientos) {
                  if (movimientos.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Sin movimientos todavía',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movimientos.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        _buildMovimiento(context, movimientos[index]),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMovimiento(BuildContext context, PagoFiadoData m) {
    final theme = Theme.of(context);
    final esFiado = m.tipo == 'fiado';
    final esAnulacion = m.tipo == 'anulacion';
    final fecha = DateTime.fromMillisecondsSinceEpoch(m.fecha);

    final color = esFiado
        ? theme.colorScheme.error
        : esAnulacion
            ? theme.colorScheme.tertiary
            : const Color(0xFF4CAF50);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: esFiado
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.primaryContainer,
        child: Icon(
          esFiado
              ? Icons.arrow_upward
              : esAnulacion
                  ? Icons.block
                  : Icons.arrow_downward,
          color: esFiado
              ? theme.colorScheme.onErrorContainer
              : theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(esFiado
          ? 'Fiado'
          : esAnulacion
              ? 'Anulación'
              : 'Abono'),
      subtitle: Text(
        '${Formato.fecha(fecha)}${m.nota != null ? ' · ${m.nota}' : ''}',
      ),
      trailing: Text(
        '${esFiado ? '+' : '-'}${Formato.usd(m.montoUsd)}',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  /// Botón de cobro manual por WhatsApp (Plan Cuaderno y Calculadora+).
  Widget _buildBotonCobroWhatsApp(BuildContext context, ClienteData cliente,
      AppConfigState config, bool debe) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        foregroundColor: const Color(0xFF25D366),
      ),
      onPressed: () => _onCobroWhatsApp(context, cliente, config, debe),
      icon: Icon(config.puedePersonalizar ? Icons.share : Icons.lock_outline),
      label: const Text('Cobrar por WhatsApp'),
    );
  }

  void _onCobroWhatsApp(BuildContext context, ClienteData cliente,
      AppConfigState config, bool debe) {
    if (!config.puedePersonalizar) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Disponible en el plan Cuaderno y Calculadora o superior'),
      ));
      return;
    }

    if (!debe) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Este cliente está al día 🎉'),
      ));
      return;
    }

    final telefono = cliente.telefono;
    if (telefono == null || telefono.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Este cliente no tiene teléfono registrado'),
      ));
      return;
    }

    _cobrarPorWhatsApp(cliente, config);
  }

  Future<void> _cobrarPorWhatsApp(
      ClienteData cliente, AppConfigState config) async {
    final tasa = config.tasaEfectiva;
    final mensaje =
        'Hola ${cliente.nombre} 👋, le saluda *${config.nombreEfectivo}*.\n'
        'Le recordamos que su saldo pendiente es de '
        '*${Formato.usd(cliente.saldoPendienteUsd)}* '
        '(${Formato.bs(cliente.saldoPendienteUsd * tasa)} a tasa de '
        '${Formato.numero(tasa, decimales: 2)}).\n'
        '¡Gracias por su preferencia! 🙏';

    final url =
        Uri.parse('https://wa.me/${_normalizarTelefono(cliente.telefono!)}'
            '?text=${Uri.encodeComponent(mensaje)}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  /// 0412-1234567 -> 584121234567 (formato internacional wa.me)
  String _normalizarTelefono(String telefono) {
    var digits = telefono.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('0')) digits = '58$digits';
    return digits;
  }

  /// Diálogo para registrar un abono (pago a cuenta).
  Future<void> _dialogoAbono(BuildContext context, WidgetRef ref,
      ClienteData cliente, AppConfigState config) async {
    final controller = TextEditingController();
    String? error;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final monto =
              double.tryParse(controller.text.trim().replaceAll(',', '.'));
          final tasa = config.tasaEfectiva;

          return AlertDialog(
            title: const Text('Abonar a la cuenta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Saldo: ${Formato.usd(cliente.saldoPendienteUsd)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Monto en \$',
                    hintText: 'Ej: 10',
                    errorText: error,
                  ),
                  onChanged: (_) => setState(() => error = null),
                ),
                if (monto != null && monto > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Equivalente: ${Formato.bs(_red2(monto * tasa))}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  if (monto == null || monto <= 0) {
                    setState(() => error = 'Monto inválido');
                    return;
                  }
                  if (monto > cliente.saldoPendienteUsd + 0.001) {
                    setState(() => error = 'No puede abonar más que el saldo');
                    return;
                  }

                  final user = ref.read(currentUserProvider).value;
                  await ref.read(clienteDaoProvider).registrarMovimiento(
                        clienteId: cliente.id,
                        tipo: 'abono',
                        montoUsd: _red2(monto),
                        montoBs: _red2(monto * tasa),
                        tasa: tasa,
                        usuarioId: user?.uid ?? '',
                        usuarioNombre: user?.nombre ?? 'Admin',
                      );

                  ref.invalidate(clientePorIdProvider);
                  ref.invalidate(historialClienteProvider);
                  ref.invalidate(clientesListProvider);

                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('¡Vale! Abonar'),
              ),
            ],
          );
        },
      ),
    );
  }
}
