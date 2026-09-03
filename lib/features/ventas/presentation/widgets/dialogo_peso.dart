import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/formato.dart';

/// Diálogo para pedir peso (kg/g) o volumen (lt/ml) de un granel.
/// Acepta coma o punto como separador decimal.
/// Chips horizontales scrolleables + diálogo scrolleable (sin overflow con teclado).
Future<double?> showDialogoPeso(
  BuildContext context,
  ProductoData producto, {
  double? inicial,
}) {
  final controller = TextEditingController(
    text: inicial != null ? Formato.numero(inicial, decimales: 3) : '',
  );
  final unidad = producto.unidadMedida ?? 'kg';
  final esPeso = unidad == 'kg';
  final esVolumen = unidad == 'lt';
  final permiteSubunidad = esPeso || esVolumen;

  return showDialog<double>(
    context: context,
    builder: (context) {
      bool sub = false;
      final s = Theme.of(context).colorScheme;

      return StatefulBuilder(
        builder: (context, setState) {
          final labelUnidad = sub
              ? (esPeso ? 'gramos' : 'mililitros')
              : (esPeso
                  ? 'kg'
                  : esVolumen
                      ? 'litros'
                      : unidad);

          final chipsRapidos = sub
              ? (esPeso
                  ? [
                      {'label': '100g', 'valor': 100.0},
                      {'label': '250g', 'valor': 250.0},
                      {'label': '500g', 'valor': 500.0},
                      {'label': '750g', 'valor': 750.0},
                      {'label': '1 kg', 'valor': 1000.0},
                    ]
                  : [
                      {'label': '100ml', 'valor': 100.0},
                      {'label': '250ml', 'valor': 250.0},
                      {'label': '500ml', 'valor': 500.0},
                      {'label': '750ml', 'valor': 750.0},
                      {'label': '1 L', 'valor': 1000.0},
                    ])
              : (esPeso
                  ? [
                      {'label': '0.1 kg', 'valor': 0.1},
                      {'label': '0.25 kg', 'valor': 0.25},
                      {'label': '0.5 kg', 'valor': 0.5},
                      {'label': '0.75 kg', 'valor': 0.75},
                      {'label': '1 kg', 'valor': 1.0},
                      {'label': '1.5 kg', 'valor': 1.5},
                      {'label': '2 kg', 'valor': 2.0},
                    ]
                  : [
                      {'label': '0.1 L', 'valor': 0.1},
                      {'label': '0.25 L', 'valor': 0.25},
                      {'label': '0.5 L', 'valor': 0.5},
                      {'label': '0.75 L', 'valor': 0.75},
                      {'label': '1 L', 'valor': 1.0},
                      {'label': '1.5 L', 'valor': 1.5},
                      {'label': '2 L', 'valor': 2.0},
                    ]);

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            scrollable: true, // ← FIX OVERFLOW: hace el diálogo scrolleable
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header con icono
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: s.primary.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      esPeso ? LucideIcons.scale : LucideIcons.beaker,
                      color: s.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    producto.nombre,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '¿Cuánto llevas?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: s.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Toggle de unidad (solo si permite subunidad)
                  if (permiteSubunidad) ...[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: s.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _UnidadButton(
                              label: esPeso ? 'kg' : 'litros',
                              selected: !sub,
                              onTap: () => setState(() => sub = false),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: _UnidadButton(
                              label: esPeso ? 'gramos' : 'ml',
                              selected: sub,
                              onTap: () => setState(() => sub = true),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Input de cantidad
                  TextField(
                    controller: controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    decoration: InputDecoration(
                      hintText: sub ? '500' : '0.250',
                      filled: true,
                      fillColor: s.surfaceContainerHigh.withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      suffixText: labelUnidad,
                      suffixStyle: TextStyle(
                        color: s.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chips horizontales scrolleables (FIX: ya no se aprietan)
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: chipsRapidos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final chip = chipsRapidos[index];
                        return ActionChip(
                          label: Text(chip['label'] as String),
                          onPressed: () {
                            controller.text = Formato.numero(
                              chip['valor'] as double,
                              decimales: sub ? 0 : 3,
                            );
                          },
                          backgroundColor: s.surfaceContainerHigh,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size(120, 48),
                ),
                onPressed: () {
                  final valor = double.tryParse(
                    controller.text.trim().replaceAll(',', '.'),
                  );
                  if (valor == null || valor <= 0) {
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

class _UnidadButton extends StatelessWidget {
  const _UnidadButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    return Material(
      color: selected ? s.primaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? s.onPrimaryContainer : s.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
