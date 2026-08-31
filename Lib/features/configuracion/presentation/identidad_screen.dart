import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/services/cloudinary_service.dart';
import '../data/config_service.dart';

/// Identidad whitelabel: nombre, slogan, logo, colores.
/// Gate: plan Cuaderno y Calculadora o superior (puedePersonalizar).
class IdentidadScreen extends ConsumerStatefulWidget {
  const IdentidadScreen({super.key});

  @override
  ConsumerState<IdentidadScreen> createState() => _IdentidadScreenState();
}

class _IdentidadScreenState extends ConsumerState<IdentidadScreen> {
  final _nombreController = TextEditingController();
  final _sloganController = TextEditingController();
  bool _subiendoLogo = false;
  bool _guardando = false;
  bool _inicializado = false;

  static const _coloresPrimarios = [
    '#1a5c2a',
    '#0d47a1',
    '#b71c1c',
    '#6a1b9a',
    '#e65100',
    '#00695c',
    '#37474f',
    '#880e4f',
  ];
  static const _coloresSecundarios = [
    '#ffd700',
    '#ffeb3b',
    '#ff8a65',
    '#80deea',
    '#c5e1a5',
    '#f48fb1',
    '#90a4ae',
    '#ffe082',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      final config = ref.read(appConfigProvider);
      _nombreController.text = config.appNombre;
      _sloganController.text = config.appSlogan;
      _inicializado = true;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  Future<void> _guardar(Map<String, dynamic> campos) async {
    setState(() => _guardando = true);
    try {
      await ref.read(configServiceProvider).guardarCampos(campos);
      await ref.read(appConfigProvider.notifier).syncFromRemote();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Listo! Configuración guardada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _cambiarLogo() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (file == null) return;

    setState(() => _subiendoLogo = true);
    try {
      final url = await ref
          .read(cloudinaryServiceProvider)
          .subirImagen(File(file.path));
      if (url == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('No se pudo subir el logo. Verifica tu conexión')),
          );
        }
        return;
      }
      await _guardar({'logo_url': url});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Chévere! Logo actualizado')),
        );
      }
    } finally {
      if (mounted) setState(() => _subiendoLogo = false);
    }
  }

  void _mostrarSelectorColor(
    String titulo,
    List<String> colores,
    String seleccionado,
    String campoFirestore,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colores.map((hex) {
                final sel = hex.toLowerCase() == seleccionado.toLowerCase();
                return InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    _guardar({campoFirestore: hex});
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _colorFromHex(hex),
                      shape: BoxShape.circle,
                      border: sel
                          ? Border.all(color: Colors.black87, width: 3)
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: sel
                        ? const Icon(Icons.check, color: Colors.white, size: 28)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final v = int.tryParse(hex.replaceAll('#', ''), radix: 16) ?? 0;
    return Color(0xFF000000 | v);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);
    final logoUrl = config.logoUrlEfectivo ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Identidad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Logo
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey.shade300,
                  child: logoUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            logoUrl,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.store, size: 48),
                          ),
                        )
                      : const Icon(Icons.store, size: 48),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      icon: _subiendoLogo
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.camera_alt,
                              size: 18, color: Colors.white),
                      onPressed: _subiendoLogo ? null : _cambiarLogo,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Nombre
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la bodega',
              prefixIcon: Icon(Icons.storefront),
            ),
          ),
          const SizedBox(height: 16),

          // Slogan
          TextField(
            controller: _sloganController,
            decoration: const InputDecoration(
              labelText: 'Slogan (opcional)',
              prefixIcon: Icon(Icons.format_quote),
            ),
          ),
          const SizedBox(height: 24),

          // Color principal (bottom sheet)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _colorFromHex(config.colorPrimario),
              radius: 18,
            ),
            title: const Text('Color principal'),
            trailing:
                Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            onTap: () => _mostrarSelectorColor(
              'Color principal',
              _coloresPrimarios,
              config.colorPrimario,
              'color_primario',
            ),
          ),

          // Color secundario (bottom sheet)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: _colorFromHex(config.colorSecundario),
              radius: 18,
            ),
            title: const Text('Color secundario'),
            trailing:
                Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            onTap: () => _mostrarSelectorColor(
              'Color secundario',
              _coloresSecundarios,
              config.colorSecundario,
              'color_secundario',
            ),
          ),
          const SizedBox(height: 24),

          // Guardar nombre + slogan
          FilledButton.icon(
            onPressed: _guardando
                ? null
                : () => _guardar({
                      'app_nombre': _nombreController.text.trim(),
                      'app_slogan': _sloganController.text.trim(),
                    }),
            icon: _guardando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('¡Vale! Guardar identidad'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ),
    );
  }
}
