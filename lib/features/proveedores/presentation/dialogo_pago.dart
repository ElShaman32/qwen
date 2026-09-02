import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/proveedor_dao.dart';

/// Diálogo para registrar un pago a un proveedor.
class DialogoPago extends ConsumerStatefulWidget {
  final ProveedorData proveedor;

  const DialogoPago({super.key, required this.proveedor});

  @override
  ConsumerState<DialogoPago> createState() => _DialogoPagoState();
}

class _DialogoPagoState extends ConsumerState<DialogoPago> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _referenciaController = TextEditingController();

  String _metodoPago = 'efectivo';
  bool _guardando = false;

  @override
  void dispose() {
    _montoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final user = ref.read(currentUserProvider).value;
      final dao = ref.read(proveedorDaoProvider);

      final monto =
          double.tryParse(_montoController.text.trim().replaceAll(',', '.')) ??
              0;

      final exito = await dao.registrarPago(
        proveedorId: widget.proveedor.id,
        montoUsd: monto,
        metodoPago: _metodoPago,
        referencia: _referenciaController.text.trim().isEmpty
            ? null
            : _referenciaController.text.trim(),
        usuarioId: user?.uid ?? '',
        usuarioNombre: user?.nombre ?? 'Admin',
      );

      if (!mounted) return;
      setState(() => _guardando = false);

      if (exito) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Listo! Pago registrado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar el pago')),
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
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text('Pagar a ${widget.proveedor.nombre}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo pendiente: ${Formato.usd(widget.proveedor.saldoPendienteUsd)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Monto
            TextFormField(
              controller: _montoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto a pagar (\$)',
                hintText: 'Ej: 50.00',
              ),
              validator: (v) {
                final monto =
                    double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                if (monto == null || monto <= 0) return 'Monto inválido';
                if (monto > widget.proveedor.saldoPendienteUsd + 0.001) {
                  return 'No puede ser mayor al saldo pendiente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Método de pago
            Text('Método de pago', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _metodoPago,
              decoration: const InputDecoration(labelText: 'Método de pago'),
              items: const [
                DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                DropdownMenuItem(
                    value: 'transferencia', child: Text('Transferencia')),
                DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _metodoPago = v);
              },
            ),
            const SizedBox(height: 16),

            // Referencia
            TextField(
              controller: _referenciaController,
              decoration: const InputDecoration(
                labelText: 'Referencia (opcional)',
                hintText: 'Ej: Depósito Banesco #123456',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('¡Vale! Pagar'),
        ),
      ],
    );
  }
}
