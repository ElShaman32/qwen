import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/services/printer_config_service.dart';
import '../../../core/services/printer_service.dart';
import '../../../core/widgets/sirebai_whatsapp_button.dart';
import '../../ventas/domain/ticket_termico.dart';

/// Configuración de impresora térmica Bluetooth.
/// Gate: plan Cuaderno y Calculadora o superior (puedePersonalizar).
class PrinterConfigScreen extends ConsumerStatefulWidget {
  const PrinterConfigScreen({super.key});

  @override
  ConsumerState<PrinterConfigScreen> createState() =>
      _PrinterConfigScreenState();
}

class _PrinterConfigScreenState extends ConsumerState<PrinterConfigScreen> {
  List<BluetoothInfo> _dispositivos = [];
  bool _buscando = false;
  bool _conectando = false;
  bool _imprimiendo = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final theme = Theme.of(context);
    final configImpresoraAsync = ref.watch(printerConfigProvider);

    // Gate por plan
    if (!config.puedePersonalizar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Impresora')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(Icons.lock_outline,
                      size: 56, color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Impresión térmica disponible en el plan Cuaderno y Calculadora',
                    style: theme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const SirebaiWhatsappButton(
                  mensaje: 'Hola SiReBAi, quiero mejorar mi plan para usar '
                      'impresora térmica',
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Impresora')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Impresora actual
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: configImpresoraAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (guardada) => Row(
                  children: [
                    Icon(Icons.print,
                        size: 40,
                        color: guardada != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guardada?.nombre ?? 'Sin impresora configurada',
                            style: theme.textTheme.titleMedium,
                          ),
                          if (guardada != null)
                            Text(
                              guardada.macAddress,
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    if (guardada != null)
                      TextButton(
                        onPressed: _olvidar,
                        child: const Text('Olvidar'),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Empareja la impresora primero en los ajustes de Bluetooth de '
            'Android, y luego selecciónala aquí.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Buscar dispositivos emparejados
          FilledButton.icon(
            onPressed: _buscando ? null : _buscar,
            icon: _buscando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bluetooth_searching),
            label: const Text('Buscar impresoras emparejadas'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: 16),

          // Lista de dispositivos
          if (_dispositivos.isNotEmpty) ...[
            Text('Selecciona tu impresora:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            for (final device in _dispositivos)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.print),
                  title:
                      Text(device.name.isNotEmpty ? device.name : 'Impresora'),
                  subtitle: Text(device.macAdress),
                  trailing: _conectando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: _conectando ? null : () => _conectar(device),
                ),
              ),
          ],

          // Probar impresión
          configImpresoraAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (guardada) => guardada == null
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _imprimiendo ? null : _probar,
                        icon: _imprimiendo
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.receipt_long),
                        label: const Text('Imprimir ticket de prueba'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _buscar() async {
    setState(() {
      _buscando = true;
      _dispositivos = [];
    });
    final devices =
        await ref.read(printerServiceProvider).escanearDispositivos();
    if (!mounted) return;
    setState(() {
      _buscando = false;
      _dispositivos = devices;
    });
    if (devices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No hay impresoras emparejadas. Emparéjala primero en '
            'los ajustes de Bluetooth de Android.'),
      ));
    }
  }

  Future<void> _conectar(BluetoothInfo device) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _conectando = true);
    final ok =
        await ref.read(printerServiceProvider).conectar(device.macAdress);
    if (!mounted) return;

    if (ok) {
      await ref.read(printerConfigServiceProvider).guardarImpresora(
            PrinterConfig(
              macAddress: device.macAdress,
              nombre: device.name.isNotEmpty ? device.name : 'Impresora',
            ),
          );
      ref.invalidate(printerConfigProvider);
      messenger.showSnackBar(SnackBar(
        content: Text('¡Chévere! ${device.name} quedó lista'),
      ));
    } else {
      messenger.showSnackBar(const SnackBar(
        content: Text('No se pudo conectar. Verifica que la impresora esté '
            'encendida y cerca.'),
      ));
    }
    setState(() => _conectando = false);
  }

  Future<void> _probar() async {
    setState(() => _imprimiendo = true);
    final t = TicketTermico(ancho: 48);
    t.iniciar();
    t.titulo('El Cuaderno de Mario');
    t.linea('Prueba de impresion OK');
    t.linea('Si lees esto, tu impresora quedo lista.');
    t.corte();

    final ok = await ref.read(printerServiceProvider).imprimirBytes(t.bytes());
    if (!mounted) return;
    setState(() => _imprimiendo = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? '¡Ticket de prueba impreso!' : 'No se pudo imprimir'),
    ));
  }

  Future<void> _olvidar() async {
    await ref.read(printerConfigServiceProvider).limpiarImpresora();
    ref.invalidate(printerConfigProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Impresora olvidada')),
    );
  }
}
