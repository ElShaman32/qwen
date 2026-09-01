import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Dialog de "Acerca de" con versión de la app.
class AcercaDeDialog extends StatefulWidget {
  const AcercaDeDialog({super.key});

  @override
  State<AcercaDeDialog> createState() => _AcercaDeDialogState();
}

class _AcercaDeDialogState extends State<AcercaDeDialog> {
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _cargarInfo();
  }

  Future<void> _cargarInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Acerca de'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'El Cuaderno de Mario',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text('Cuentas claras, negocio próspero'),
          const SizedBox(height: 16),
          Text('Versión: $_version'),
          Text('Build: $_buildNumber'),
          const SizedBox(height: 16),
          const Text(
            'Desarrollado por SiReBAi',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
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
