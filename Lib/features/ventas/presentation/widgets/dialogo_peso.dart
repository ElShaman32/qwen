import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';

/// Diálogo para pedir peso (kg/g) o volumen (lt/ml) de un granel.
/// Acepta coma o punto como separador decimal.
Future<double?> showDialogoPeso(
  BuildContext context,
  ProductoData producto, {
  double? inicial,
}) {
  final controller = TextEditingController(text: inicial?.toString() ?? '');
  final unidad = producto.unidadMedida ?? 'kg';
  final esPeso = unidad == 'kg';
  final esVolumen = unidad == 'lt';
  final permiteSubunidad = esPeso || esVolumen;

  return showDialog<double>(
    context: context,
    builder: (context) {
      bool sub = false; // gramos o mililitros

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(producto.nombre),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (permiteSubunidad) ...[
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text(unidad),
                        selected: !sub,
                        onSelected: (_) => setState(() => sub = false),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(esPeso ? 'gramos' : 'mililitros'),
                        selected: sub,
                        onSelected: (_) => setState(() => sub = true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: sub
                        ? (esPeso ? 'Peso (g)' : 'Volumen (ml)')
                        : (esPeso
                            ? 'Peso ($unidad)'
                            : esVolumen
                                ? 'Volumen ($unidad)'
                                : 'Cantidad ($unidad)'),
                    hintText: sub ? 'Ej: 500' : 'Ej: 0,250',
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
                onPressed: () {
                  final valor = double.tryParse(
                    controller.text.trim().replaceAll(',', '.'),
                  );
                  if (valor == null) {
                    Navigator.pop(context);
                    return;
                  }
                  // Convierte g→kg o ml→lt para el stock
                  Navigator.pop(context, sub ? valor / 1000 : valor);
                },
                child: const Text('¡Listo!'),
              ),
            ],
          );
        },
      );
    },
  );
}
