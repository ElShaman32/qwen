import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/utils/formato.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/gasto_dao.dart';
import '../domain/contabilidad_models.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

/// Diálogo para registrar un gasto manual.
/// El usuario ingresa el monto en Bs o $ y la app lo convierte a USD
/// usando la tasa efectiva actual.
Future<bool> showDialogoGasto(BuildContext context, WidgetRef ref) async {
  final categoriaController = ValueNotifier<String>(CategoriasGasto.otros);
  final descripcionController = TextEditingController();
  final montoController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool enBs = true; // toggle Bs/$ para el monto
  bool guardando = false;

  final config = ref.read(appConfigProvider);
  final tasa = config.tasaEfectiva;

  final resultado = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          title: const Text('Agregar gasto'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Categoría
                  ValueListenableBuilder<String>(
                    valueListenable: categoriaController,
                    builder: (context, categoria, _) {
                      return DropdownButtonFormField<String>(
                        initialValue: categoria,
                        decoration:
                            const InputDecoration(labelText: 'Categoría *'),
                        items: CategoriasGasto.todas
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    '${CategoriasGasto.emoji(c)} ${CategoriasGasto.etiqueta(c)}',
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) categoriaController.value = v;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Descripción
                  TextFormField(
                    controller: descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción *',
                      hintText: 'Ej: pago de luz del local',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ingresa una descripción'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  // Monto + toggle moneda
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: montoController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText: enBs ? 'Monto en Bs *' : 'Monto en \$ *',
                            hintText: enBs ? 'Ej: 500' : 'Ej: 15',
                          ),
                          validator: (v) {
                            final monto = double.tryParse(
                                (v ?? '').trim().replaceAll(',', '.'));
                            if (monto == null || monto <= 0) {
                              return 'Ingresa un monto válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Toggle Bs/$
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: true, label: Text('Bs')),
                            ButtonSegment(value: false, label: Text('\$')),
                          ],
                          selected: {enBs},
                          onSelectionChanged: (sel) =>
                              setState(() => enBs = sel.first),
                          multiSelectionEnabled: false,
                        ),
                      ),
                    ],
                  ),
                  // Vista previa de conversión
                  if (tasa > 0)
                    Builder(builder: (context) {
                      final monto = double.tryParse(montoController.text
                              .trim()
                              .replaceAll(',', '.')) ??
                          0;
                      if (monto <= 0) return const SizedBox.shrink();
                      final usd = enBs ? monto / tasa : monto;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          enBs
                              ? 'Equivale a ${Formato.usd(usd)} (tasa ${Formato.numero(tasa, decimales: 2)})'
                              : 'Equivale a ${Formato.bs(monto * tasa)} (tasa ${Formato.numero(tasa, decimales: 2)})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: guardando
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setState(() => guardando = true);

                      try {
                        final monto = double.parse(
                            montoController.text.trim().replaceAll(',', '.'));
                        final montoUsd = enBs ? monto / tasa : monto;
                        final user = ref.read(currentUserProvider).value;

                        await ref.read(gastoDaoProvider).insertar(
                              categoria: categoriaController.value,
                              descripcion: descripcionController.text.trim(),
                              montoUsd: montoUsd,
                              tasa: tasa,
                              fecha: DateTime.now().millisecondsSinceEpoch,
                              usuarioId: user?.uid ?? '',
                              usuarioNombre: user?.nombre ?? 'Admin',
                            );

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext, true);
                        }
                      } catch (e, stack) {
                        _logger.e('Error guardando gasto',
                            error: e, stackTrace: stack);
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            SnackBar(content: Text('Error al guardar: $e')),
                          );
                        }
                      } finally {
                        if (dialogContext.mounted) {
                          setState(() => guardando = false);
                        }
                      }
                    },
              child: guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('¡Listo! Guardar'),
            ),
          ],
        );
      },
    ),
  );

  // Limpiar recursos
  descripcionController.dispose();
  montoController.dispose();
  categoriaController.dispose();

  return resultado ?? false;
}
