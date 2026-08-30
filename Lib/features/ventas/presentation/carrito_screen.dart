import 'package:flutter/material.dart';
import 'widgets/carrito_panel.dart';

/// Carrito a pantalla completa para móvil/tablet.
class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: const CarritoPanel(),
    );
  }
}
