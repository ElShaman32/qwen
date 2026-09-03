import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:drift/drift.dart';

import '../config/app_config_notifier.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'client_firebase.dart';
import 'connectivity_service.dart';
import 'sync_service.dart';
import 'tasa_bcv_service.dart';
import 'realtime_listeners.dart';

class SyncScheduler {
  SyncScheduler(this._ref);

  final Ref _ref;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  Timer? _timer;
  Timer? _sonda;
  Timer? _debounce;
  RealtimeListeners? _listeners;
  StreamSubscription<void>? _outboxSub;
  bool _sincronizando = false;
  bool _arrancado = false;

  void iniciar() {
    // 1. Sonda de arranque: espera a que ClientFirebase esté listo
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

  /// Secuencia de arranque: config fresca + tasa BCV + sync completo.
  Future<void> _intentoArranque() async {
    if (_arrancado) return;
    if (!ClientFirebase().isInitialized) return;

    // 1. Verificar que Firebase Auth del CLIENTE restauró la sesión
    final user = ClientFirebase().auth.currentUser;
    if (user == null) return;

    // 2. CRÍTICO: verificar que el documento usuarios/{uid} existe y es válido.
    //    Las reglas de Firestore requieren este documento para TODAS las lecturas.
    //    Si no existe (proyecto nuevo) o está inactivo, NO hay nada que descargar.
    try {
      final perfilDoc = await ClientFirebase()
          .firestore
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (!perfilDoc.exists) {
        _logger.w(
            '⚠️ Documento usuarios/${user.uid} no existe, esperando registro admin');
        return; // La sonda reintentará en 5s
      }

      final data = perfilDoc.data();
      final rol = data?['rol'] as String?;
      final activo = data?['activo'] as bool?;

      if (rol == null || (rol != 'admin' && rol != 'cajero')) {
        _logger.w('⚠️ Perfil sin rol válido: $rol, esperando corrección');
        return;
      }

      if (activo != true) {
        _logger.w('⚠️ Usuario inactivo, no se puede sincronizar');
        return;
      }
    } catch (e) {
      // Si falla la verificación (permisos, red), esperar próximo tick
      _logger.w('⚠️ No se pudo verificar perfil: $e, esperando');
      return;
    }

    // 3. Todo OK: marcar como arrancado y ejecutar secuencia
    _arrancado = true;
    _sonda?.cancel();

    // 4. Configuración fresca desde Firestore
    await _ref.read(appConfigProvider.notifier).syncFromRemote();

    // 5. Tasa BCV automática (solo si el toggle está ON)
    await _actualizarTasaBcvAutomatica();

    // 6. Sync completo (cola + descargas)
    await syncAhora();

    // 7. Listeners de tiempo real (diferidos 2s: los datos críticos
    //    ya se descargaron, los listeners solo capturan cambios NUEVOS)
    Future.delayed(const Duration(seconds: 2), () {
      _listeners = _ref.read(realtimeListenersProvider);
      _listeners!.iniciarTodos();
    });

    // 8. Avisar a la UI que hay datos nuevos
    _ref.read(syncRefreshProvider.notifier).state++;
  }

  /// Descarga tasa BCV desde API y la escribe en Drift + Firestore + historial.
  /// Solo si el toggle `usarTasaBcv` está activado.
  Future<void> _actualizarTasaBcvAutomatica() async {
    try {
      final config = _ref.read(appConfigProvider);
      if (!config.usarTasaBcv) return;

      // No actualizar si ya se actualizó en las últimas 4 horas
      final horasDesdeVerificacion = DateTime.now()
          .difference(
            DateTime.fromMillisecondsSinceEpoch(
                config.timestampUltimaVerificacion),
          )
          .inHours;
      if (horasDesdeVerificacion < 4) {
        _logger
            .i('💱 Tasa BCV reciente (${horasDesdeVerificacion}h), omitiendo');
        return;
      }

      final clientFb = ClientFirebase();
      if (!clientFb.isInitialized) return;

      final nuevaTasa =
          await _ref.read(tasaBcvServiceProvider).obtenerTasaBCV();
      if (nuevaTasa == null || nuevaTasa <= 0) {
        _logger.w('💱 API de tasa BCV no respondió, manteniendo anterior');
        return;
      }

      final ahora = DateTime.now();
      final ahoraEpoch = ahora.millisecondsSinceEpoch;

      // 1. Escribir en Drift (configuracion_local)
      final db = _ref.read(databaseProvider);
      final existente =
          await (db.select(db.configuracionLocal)..limit(1)).getSingleOrNull();
      if (existente != null) {
        await (db.update(db.configuracionLocal)
              ..where((t) => t.id.equals(existente.id)))
            .write(ConfiguracionLocalCompanion(
          tasaBcv: Value(nuevaTasa),
          timestampUltimaVerificacion: Value(ahoraEpoch),
        ));
      }

      // 2. Historial de tasas (fecha es DateTime, no epoch)
      await db.into(db.historialTasa).insert(HistorialTasaCompanion.insert(
            tasa: nuevaTasa,
            fuente: const Value('bcv_api_auto'),
            fecha: Value(ahora), // ← DateTime, no int
          ));

      // 3. Escribir en Firestore del cliente
      await clientFb.firestore
          .collection('configuracion')
          .doc('generales')
          .set({
        'tasa_bcv': nuevaTasa,
        'timestampUltimaVerificacion': ahoraEpoch,
      }, SetOptions(merge: true));

      // 4. Actualizar el state del provider
      _ref.read(appConfigProvider.notifier).actualizarTasaYTimestamp(
            nuevaTasa,
            ahoraEpoch,
          );

      _logger.i('💱 Tasa BCV actualizada automáticamente: $nuevaTasa');
    } catch (e, s) {
      _logger.e('Error actualizando tasa BCV automática',
          error: e, stackTrace: s);
    }
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
