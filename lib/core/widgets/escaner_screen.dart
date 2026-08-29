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
Future<void> mostrarEscanerContinuo(
  BuildContext context, {
  required OnCodigoEscaneado onCodigo,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: _EscanerContinuo(onCodigo: onCodigo),
    ),
  );
}

enum _EstadoLectura { esperando, exito, fallo }

class _EscanerContinuo extends StatefulWidget {
  final OnCodigoEscaneado onCodigo;
  const _EscanerContinuo({required this.onCodigo});

  @override
  State<_EscanerContinuo> createState() => _EscanerContinuoState();
}

class _EscanerContinuoState extends State<_EscanerContinuo> {
  final _player = AudioPlayer();
  _EstadoLectura _estado = _EstadoLectura.esperando;
  bool _procesando = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _player.dispose();
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
      await _player.play(AssetSource('sounds/beep_escaner.mp3'));
    } catch (_) {}

    final encontrado = await widget.onCodigo(codigo);

    if (mounted) {
      setState(
        () =>
            _estado = encontrado ? _EstadoLectura.exito : _EstadoLectura.fallo,
      );
    }

    // Vuelve a "esperando" tras un breve momento, listo para el próximo escaneo.
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _estado = _EstadoLectura.esperando);
      _procesando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 420,
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
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
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
                  child: MobileScanner(onDetect: _onDetect),
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

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

/// Se conserva para Inventario, donde solo se necesita UN código
/// (autocompletar el campo, no agregar varios productos seguidos).
Future<String?> mostrarEscanerCompacto(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) =>
        const Dialog(insetPadding: EdgeInsets.all(24), child: _EscanerUnaVez()),
  );
}

class _EscanerUnaVez extends StatefulWidget {
  const _EscanerUnaVez();

  @override
  State<_EscanerUnaVez> createState() => _EscanerUnaVezState();
}

class _EscanerUnaVezState extends State<_EscanerUnaVez> {
  final _player = AudioPlayer();
  bool _yaDetectado = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_yaDetectado) return;
    final codigo = capture.barcodes.firstOrNull?.rawValue;
    if (codigo == null || codigo.isEmpty) return;

    _yaDetectado = true;
    HapticFeedback.heavyImpact();

    try {
      await _player.play(AssetSource('sounds/beep_escaner.mp3'));
    } catch (_) {}

    if (mounted) Navigator.of(context).pop(codigo);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 400,
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
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              child: MobileScanner(onDetect: _onDetect),
            ),
          ),
        ],
      ),
    );
  }
}
