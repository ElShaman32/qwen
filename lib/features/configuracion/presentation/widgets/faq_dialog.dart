import 'package:flutter/material.dart';

/// Dialog de preguntas frecuentes.
class FaqDialog extends StatelessWidget {
  const FaqDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Preguntas frecuentes'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: const [
            _FaqItem(
              pregunta: '¿Por qué la tasa BCV no se actualiza sola?',
              respuesta:
                  'Activa el toggle "Usar tasa BCV automática" en Impuestos y tasa. '
                  'La app descarga la tasa al abrir (si no se actualizó en las últimas 4 horas).',
            ),
            _FaqItem(
              pregunta: '¿Puedo tener varios cajeros?',
              respuesta:
                  'Sí, en el plan Cuaderno y Calculadora puedes crear hasta 3 usuarios. '
                  'El plan Todos los Juguetes permite usuarios ilimitados.',
            ),
            _FaqItem(
              pregunta: '¿Qué pasa si no hay internet?',
              respuesta:
                  'La app funciona offline. Las ventas se guardan localmente y se suben '
                  'automáticamente cuando vuelve la conexión.',
            ),
            _FaqItem(
              pregunta: '¿Cómo imprimo tickets?',
              respuesta:
                  'Emparéjala primero en los ajustes de Bluetooth de Android. '
                  'Luego ve a Configuración → Impresora → Buscar → Selecciona tu impresora.',
            ),
            _FaqItem(
              pregunta: '¿Puedo exportar reportes a Excel?',
              respuesta:
                  'Sí, en el plan Cuaderno y Calculadora o superior. Ve a Reportes → Exportar.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String pregunta;
  final String respuesta;

  const _FaqItem({required this.pregunta, required this.respuesta});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pregunta,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            respuesta,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
