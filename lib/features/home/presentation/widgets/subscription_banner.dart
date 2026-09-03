import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_config_notifier.dart';
import '../../../../core/widgets/sirebai_whatsapp_button.dart';

/// Banner no intrusivo que aparece cuando la suscripción venció.
/// Solo se muestra a admins. No bloquea el uso de la app.
class SubscriptionBanner extends ConsumerWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    // Solo mostrar si está vencido y NO suspendido
    if (!config.estaVencido || config.estaSuspendido) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final planNombre = _planNombre(config.plan);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: theme.colorScheme.tertiary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Suscripción vencida',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tu plan $planNombre venció. Contacta a SiReBAi para renovar '
            'o cambiar al plan gratuito.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          SirebaiWhatsappButton(
            mensaje:
                'Hola SiReBAi, mi suscripción de ${config.nombreEfectivo} venció. Quiero renovar o cambiar de plan.',
            child: const Text('Renovar suscripción',
                style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  String _planNombre(String plan) {
    switch (plan) {
      case 'cuaderno_calculadora':
        return 'Cuaderno y Calculadora';
      case 'todos_juguetes':
        return 'Todos los Juguetes';
      default:
        return 'Cuaderno';
    }
  }
}