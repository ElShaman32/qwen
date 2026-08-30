import 'dart:async';

import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../config/app_config_notifier.dart';
import 'client_firebase.dart';
import 'connectivity_service.dart';
import 'sync_service.dart';

class SyncScheduler {
  SyncScheduler(this._ref);

  final Ref _ref;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  Timer? _timer;
  Timer? _sonda;
  Timer? _debounce;
  StreamSubscription<void>? _outboxSub;
  bool _sincronizando = false;
  bool _arrancado = false;

  void iniciar() {
    // 1. Sonda de arranque: espera a que ClientFirebase esté listo
    //    (cubre activación/login en instalaciones nuevas, donde a los 5s
    //    de main() todavía no hay sesión).
    _sonda =
        Timer.periodic(const Duration(seconds: 5), (_) => _intentoArranque());

    // 2. Volvió el internet -> vaciar cola de una
    _ref.listen(connectivityProvider, (prev, next) {
      if (next.valueOrNull == true) {
        _logger.i('📶 Conexión detectada, sincronizando cola');
        syncAhora();
      }
    });

    // 3. Red de seguridad periódica (30 min)
    _timer = Timer.periodic(const Duration(minutes: 30), (_) => syncAhora());

    // 4. Alguien encoló algo -> flush inmediato (debounce 2s)
    _outboxSub = syncOutboxEvents.stream.listen((_) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 2), () => syncAhora());
    });
  }

  /// Secuencia de arranque: config fresca + sync completo, una sola vez.
  Future<void> _intentoArranque() async {
    if (_arrancado) return;
    if (!ClientFirebase().isInitialized) return;
    _arrancado = true;
    _sonda?.cancel();

    // 1. Configuración fresca desde Firestore (nombre, colores, tasa...)
    await _ref.read(appConfigProvider.notifier).syncFromRemote();

    // 2. Tasa BCV automática: se agrega cuando me pases tasa_bcv_service.dart

    // 3. Sync completo (cola + descargas)
    await syncAhora();

    // 4. Avisar a la UI que hay datos nuevos
    _ref.read(syncRefreshProvider.notifier).state++;
  }

  Future<void> syncAhora() async {
    if (_sincronizando) return;
    final online = _ref.read(connectivityProvider).valueOrNull ?? false;
    if (!online) return;

    _sincronizando = true;
    try {
      final ok = await _ref.read(syncServiceProvider).syncCompleto();
      if (ok) _ref.read(syncRefreshProvider.notifier).state++;
    } catch (e) {
      _logger.e('Error en sync programado: $e');
    } finally {
      _sincronizando = false;
    }
  }

  void dispose() {
    _timer?.cancel();
    _sonda?.cancel();
    _debounce?.cancel();
    _outboxSub?.cancel();
  }
}

final syncSchedulerProvider = Provider<SyncScheduler>((ref) {
  final scheduler = SyncScheduler(ref);
  scheduler.iniciar();
  ref.onDispose(scheduler.dispose);
  return scheduler;
});
