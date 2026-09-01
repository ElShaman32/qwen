import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Botón de contacto directo a SiReBAi por WhatsApp.
/// Abre WhatsApp con mensaje prellenado, sin que el usuario escriba nada.
class SirebaiWhatsappButton extends StatelessWidget {
  final String mensaje;
  final Widget? child;

  const SirebaiWhatsappButton({
    super.key,
    this.mensaje = 'Hola SiReBAi, necesito ayuda con El Cuaderno de Mario',
    this.child,
  });

  static const _telefono = '584245829375';

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _abrirWhatsapp,
      icon: const Icon(Icons.chat),
      label: child ?? const Text('Contactar SiReBAi'),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF25D366), // WhatsApp green
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _abrirWhatsapp() async {
    final uri = Uri.parse(
      'https://wa.me/$_telefono?text=${Uri.encodeComponent(mensaje)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
