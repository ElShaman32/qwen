import 'package:flutter/material.dart';
import '../../../core/widgets/marca_logo.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';

/// Pantalla de bloqueo cuando activa=false en el Maestro.
/// Suspensión manual de Mario (fraude, cancelación explícita).
class SuspensionScreen extends StatelessWidget {
  const SuspensionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MarcaLogo(size: 100),
                  const SizedBox(height: 32),
                  Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Cuenta suspendida',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu cuenta ha sido suspendida por el administrador. '
                    'Contacta a SiReBAi para más información.',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const SirebaiWhatsappButton(
                    mensaje:
                        'Hola SiReBAi, mi cuenta de El Cuaderno de Mario aparece como suspendida. Necesito información.',
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Soporte: SiReBAi',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
