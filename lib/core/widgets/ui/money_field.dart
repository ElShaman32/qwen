import 'package:flutter/material.dart';

/// Campo de monto con prefijo de moneda. NO formatea en vivo
/// (no pelea con el controller ni con el teclado del cajero).
class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    this.label,
    this.esBs = false,
    this.hintText,
    this.validator,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String? label;
  final bool esBs;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: s.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              esBs ? 'Bs' : '\$',
              style: TextStyle(
                color: s.primary,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 52),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
