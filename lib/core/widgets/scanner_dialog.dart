import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Callback que recibe cada código escaneado y retorna si fue válido
/// (para mostrar ✅) o no encontrado (para mostrar ❌).
typedef OnCodigoEscaneado = Future<bool> Function(String codigo);

/// Muestra el escáner en modo CONTINUO: no se cierra tras la primera
/// lectura, permite escanear varios productos seguidos. El cajero lo
/// cierra manualmente con el botón "Listo" cuando termina.
///
/// Uso en Ventas:
///   await mostrarEscanerContinuo(context, onCodigo: (codigo) async {
///     final encontrado = await carrito.agregarPorCodigo(codigo);
///     return encontrado;
///   });
Future<void> mostrarEscanerContinuo(
  BuildContext context, {
  required OnCodigoEscaneado onCodigo,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: _EscanerContinuo(onCodigo: onCodigo, dialogContext: dialogContext),
    ),
  );
}

enum _EstadoLectura { esperando, exito, fallo }

class _EscanerContinuo extends StatefulWidget {
  final OnCodigoEscaneado onCodigo;
  final BuildContext dialogContext;
  const _EscanerContinuo({
    required this.onCodigo,
    required this.dialogContext,
  });

  @override
  State<_EscanerContinuo> createState() => _EscanerContinuoState();
}

class _EscanerContinuoState extends State<_EscanerContinuo> {
  final _player = AudioPlayer();
  final _controller = MobileScannerController();
  _EstadoLectura _estado = _EstadoLectura.esperando;
  bool _procesando = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_procesando) return;
    final codigo = capture.barcodes.firstOrNull?.rawValue;
    if (codigo == null || codigo.isEmpty) return;

    _procesando = true;
    HapticFeedback.heavyImpact();

    try {
      await _player.play(AssetSource('sonidos/beep_escaner.mp3'));
    } catch (_) {}

    final encontrado = await widget.onCodigo(codigo);

    if (mounted) {
      setState(
        () =>
            _estado = encontrado ? _EstadoLectura.exito : _EstadoLectura.fallo,
      );
    }

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _estado = _EstadoLectura.esperando);
      _procesando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(280.0, 420.0);
        final height = (width * 1.35).clamp(360.0, 560.0);
        return SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Escanear productos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Linterna',
                      icon: const Icon(Icons.flashlight_on_outlined),
                      onPressed: () => _controller.toggleTorch(),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(widget.dialogContext).pop(),
                      child: const Text('Listo'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                      child: MobileScanner(
                        controller: _controller,
                        onDetect: _onDetect,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _iconoEstado(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _iconoEstado() {
    switch (_estado) {
      case _EstadoLectura.esperando:
        return const SizedBox.shrink(key: ValueKey('vacio'));
      case _EstadoLectura.exito:
        return Container(
          key: const ValueKey('exito'),
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: Colors.green, size: 28),
        );
      case _EstadoLectura.fallo:
        return Container(
          key: const ValueKey('fallo'),
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.cancel, color: Colors.red, size: 28),
        );
    }
  }
}

/// Escáner compacto para Inventario (UN solo código, autocompletar campo).
///
/// Uso en Inventario:
///   final codigo = await mostrarEscanerCompacto(context);
///   if (codigo != null) controller.text = codigo;
Future<String?> mostrarEscanerCompacto(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: _EscanerUnaVez(dialogContext: dialogContext),
    ),
  );
}

class _EscanerUnaVez extends StatefulWidget {
  final BuildContext dialogContext;
  const _EscanerUnaVez({required this.dialogContext});

  @override
  State<_EscanerUnaVez> createState() => _EscanerUnaVezState();
}

class _EscanerUnaVezState extends State<_EscanerUnaVez> {
  final _player = AudioPlayer();
  final _controller = MobileScannerController();
  bool _yaDetectado = false;

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_yaDetectado) return;
    final codigo = capture.barcodes.firstOrNull?.rawValue;
    if (codigo == null || codigo.isEmpty) return;

    _yaDetectado = true;
    HapticFeedback.heavyImpact();

    try {
      await _player.play(AssetSource('sonidos/beep_escaner.mp3'));
    } catch (_) {}

    if (mounted) Navigator.of(widget.dialogContext).pop(codigo);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(280.0, 420.0);
        final height = (width * 1.25).clamp(360.0, 520.0);
        return SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Escanear código',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Linterna',
                      icon: const Icon(Icons.flashlight_on_outlined),
                      onPressed: () => _controller.toggleTorch(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(widget.dialogContext).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  child: MobileScanner(
                    controller: _controller,
                    onDetect: _onDetect,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
