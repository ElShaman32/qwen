import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'client_firebase.dart';
import 'sync_service.dart';

/// Listeners de Firestore en tiempo real.
///
/// Mantienen Drift actualizado automáticamente cuando hay cambios en Firestore.
/// Esto permite multi-cajero en tiempo real sin conflictos de stock/caja.
///
/// Estrategia: Firestore → Drift (no al revés)
/// - Los listeners solo DESCARGAN cambios remotos
/// - Las escrituras locales ya están en Drift (patrón outbox)
/// - SyncService sube los cambios locales a Firestore
class RealtimeListeners {
  RealtimeListeners(this._ref);

  final Ref _ref;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final List<StreamSubscription> _subscriptions = [];
  bool _activo = false;

  /// Inicia todos los listeners de colecciones críticas.
  /// Llamar DESPUÉS de que ClientFirebase esté inicializado.
  void iniciarTodos() {
    if (_activo) {
      _logger.w('⚠️ RealtimeListeners ya está activo');
      return;
    }

    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) {
      _logger.w(
          '⚠️ ClientFirebase no inicializado, no se pueden iniciar listeners');
      return;
    }

    _activo = true;
    _logger.i('🎧 Iniciando listeners de tiempo real...');

    _listenInventario();
    _listenVentas();
    _listenCaja();
    _listenClientes();

    _logger.i('✅ Todos los listeners activos');
  }

  /// Detiene todos los listeners.
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _activo = false;
    _logger.i('🛑 Todos los listeners detenidos');
  }

  // ─────────────────────────────────────────────────────────────────────
  // INVENTARIO (crítico para multi-cajero: evita vender sin stock)
  // ─────────────────────────────────────────────────────────────────────
  void _listenInventario() {
    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) return;

    final sub = clientFb.firestore.collection('inventario').snapshots().listen(
        (snapshot) async {
      final db = _ref.read(databaseProvider);
      int cambios = 0;

      for (var change in snapshot.docChanges) {
        try {
          await _syncProductoCambio(db, change);
          cambios++;
        } catch (e, stack) {
          _logger.e('Error sincronizando producto ${change.doc.id}',
              error: e, stackTrace: stack);
        }
      }

      if (cambios > 0) {
        _logger.i('📦 Inventario actualizado ($cambios cambios)');
        _ref.read(syncRefreshProvider.notifier).state++;
      }
    }, onError: (e) {
      _logger.e('❌ Error en listener de inventario: $e');
    });

    _subscriptions.add(sub);
  }

  Future<void> _syncProductoCambio(
      AppDatabase db, DocumentChange<Map<String, dynamic>> change) async {
    final doc = change.doc;
    final data = doc.data()!;
    final uuid = doc.id;

    if (change.type == DocumentChangeType.removed) {
      // Producto eliminado remotamente: desactivar localmente
      final local = await (db.select(db.producto)
            ..where((t) => t.uuid.equals(uuid)))
          .getSingleOrNull();
      if (local != null) {
        await (db.update(db.producto)..where((t) => t.id.equals(local.id)))
            .write(const ProductoCompanion(activo: Value(false)));
      }
      return;
    }

    final remotoTs = (data['fechaActualizacion'] as num?)?.toInt() ?? 0;
    final local = await (db.select(db.producto)
          ..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();

    if (local == null) {
      // Producto nuevo de otro dispositivo
      if (!data.containsKey('nombre')) return; // Doc esquelético, ignorar

      await db.into(db.producto).insert(ProductoCompanion.insert(
            uuid: uuid,
            nombre: (data['nombre'] as String?) ?? 'Sin nombre',
            codigo: Value(data['codigo'] as String?),
            categoria: Value(data['categoria'] as String?),
            precioUsd: (data['precioUsd'] as num?)?.toDouble() ?? 0,
            costoUsd: Value((data['costoUsd'] as num?)?.toDouble() ?? 0),
            precioMayor: Value((data['precioMayor'] as num?)?.toDouble()),
            stock: Value((data['stock'] as num?)?.toDouble() ?? 0),
            exentoIva: Value(data['exentoIva'] as bool? ?? false),
            esGranel: Value(data['esGranel'] as bool? ?? false),
            unidadMedida: Value(data['unidadMedida'] as String?),
            fechaVencimiento:
                Value((data['fechaVencimiento'] as num?)?.toInt()),
            stockMinimo: Value((data['stockMinimo'] as num?)?.toInt() ?? 5),
            activo: Value(data['activo'] as bool? ?? true),
            proveedorUuid: Value(data['proveedorUuid'] as String?),
            fechaCreacion: remotoTs,
            fechaActualizacion: remotoTs,
          ));
    } else {
      // Producto existente: solo actualizar si remoto es más reciente
      if (remotoTs > local.fechaActualizacion) {
        await (db.update(db.producto)..where((t) => t.id.equals(local.id)))
            .write(ProductoCompanion(
          nombre: Value((data['nombre'] as String?) ?? local.nombre),
          precioUsd:
              Value((data['precioUsd'] as num?)?.toDouble() ?? local.precioUsd),
          costoUsd:
              Value((data['costoUsd'] as num?)?.toDouble() ?? local.costoUsd),
          stock: Value((data['stock'] as num?)?.toDouble() ?? local.stock),
          activo: Value(data['activo'] as bool? ?? local.activo),
          fechaActualizacion: Value(remotoTs),
        ));
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  // VENTAS (crítico para reportes y auditoría)
  // ─────────────────────────────────────────────────────────────────────
  void _listenVentas() {
    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) return;

    final sub = clientFb.firestore.collection('ventas').snapshots().listen(
        (snapshot) async {
      final db = _ref.read(databaseProvider);
      int nuevas = 0;
      int anuladas = 0;

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final venta = await _crearVentaLocal(db, change.doc);
          if (venta) nuevas++;
        } else if (change.type == DocumentChangeType.modified) {
          final anulada = await _actualizarAnulacion(db, change.doc);
          if (anulada) anuladas++;
        }
      }

      if (nuevas > 0 || anuladas > 0) {
        _logger
            .i('🛒 Ventas actualizadas ($nuevas nuevas, $anuladas anuladas)');
        _ref.read(syncRefreshProvider.notifier).state++;
      }
    }, onError: (e) {
      _logger.e('❌ Error en listener de ventas: $e');
    });

    _subscriptions.add(sub);
  }

  Future<bool> _crearVentaLocal(AppDatabase db, DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return false;

    final uuid = doc.id;
    final existe = await (db.select(db.venta)
          ..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();

    if (existe != null) return false;

    int? clienteIdRemoto = (data['clienteId'] as num?)?.toInt();
    if (clienteIdRemoto != null) {
      final c = await (db.select(db.cliente)
            ..where((t) => t.id.equals(clienteIdRemoto!)))
          .getSingleOrNull();
      if (c == null) clienteIdRemoto = null;
    }

    await db.into(db.venta).insert(VentaCompanion.insert(
          uuid: uuid,
          numeroVenta: (data['numeroVenta'] as num?)?.toInt() ?? 0,
          fecha: (data['fecha'] as num?)?.toInt() ?? 0,
          itemsJson: (data['itemsJson'] as String?) ?? '[]',
          pagosJson: (data['pagosJson'] as String?) ?? '[]',
          totalUsd: (data['totalUsd'] as num?)?.toDouble() ?? 0,
          totalBs: (data['totalBs'] as num?)?.toDouble() ?? 0,
          tasaUsada: (data['tasaUsada'] as num?)?.toDouble() ?? 0,
          ivaBs: (data['ivaBs'] as num?)?.toDouble() ?? 0,
          igtfBs: (data['igtfBs'] as num?)?.toDouble() ?? 0,
          exentoBs: Value((data['exentoBs'] as num?)?.toDouble() ?? 0),
          esFiado: Value(data['esFiado'] as bool? ?? false),
          clienteId: Value(clienteIdRemoto),
          anulada: Value(data['anulada'] as bool? ?? false),
          motivoAnulacion: Value(data['motivoAnulacion'] as String?),
          usuarioId: (data['usuarioId'] as String?) ?? '',
          usuarioNombre: (data['usuarioNombre'] as String?) ?? '',
          fechaCreacion: (data['fecha'] as num?)?.toInt() ?? 0,
          fechaActualizacion:
              (data['fechaActualizacion'] as num?)?.toInt() ?? 0,
        ));

    return true;
  }

  Future<bool> _actualizarAnulacion(
      AppDatabase db, DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return false;

    final uuid = doc.id;
    final local = await (db.select(db.venta)..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();

    if (local == null) return false;

    final anuladaRemoto = data['anulada'] as bool? ?? false;
    if (anuladaRemoto && !local.anulada) {
      await (db.update(db.venta)..where((t) => t.id.equals(local.id)))
          .write(VentaCompanion(
        anulada: const Value(true),
        motivoAnulacion: Value(data['motivoAnulacion'] as String?),
      ));
      return true;
    }

    return false;
  }

  // ─────────────────────────────────────────────────────────────────────
  // CAJA (crítico para multi-cajero: aperturas/cierres compartidos)
  // ─────────────────────────────────────────────────────────────────────
  void _listenCaja() {
    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) return;

    final sub = clientFb.firestore.collection('caja').snapshots().listen(
        (snapshot) async {
      final db = _ref.read(databaseProvider);
      int nuevos = 0;

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final creado = await _crearCajaLocal(db, change.doc);
          if (creado) nuevos++;
        }
      }

      if (nuevos > 0) {
        _logger.i('💰 Caja actualizada ($nuevos docs nuevos)');
        _ref.read(syncRefreshProvider.notifier).state++;
      }
    }, onError: (e) {
      _logger.e('❌ Error en listener de caja: $e');
    });

    _subscriptions.add(sub);
  }

  Future<bool> _crearCajaLocal(AppDatabase db, DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return false;

    final tipo = data['tipo'] as String?;
    final uuid = doc.id;

    // Verificar si ya existe localmente
    final existe = await _existeCajaPorUuid(db, uuid);
    if (existe) return false;

    switch (tipo) {
      case 'apertura':
        await db.into(db.aperturaCaja).insert(AperturaCajaCompanion.insert(
              uuid: uuid,
              usuarioId: (data['usuarioId'] as String?) ?? '',
              usuarioNombre: (data['usuarioNombre'] as String?) ?? '',
              montoInicialBs:
                  Value((data['montoInicialBs'] as num?)?.toDouble() ?? 0),
              montoInicialUsd:
                  Value((data['montoInicialUsd'] as num?)?.toDouble() ?? 0),
              novedad: Value(data['novedad'] as String?),
              cerrada: Value(data['cerrada'] as bool? ?? false),
              fecha: (data['fecha'] as num?)?.toInt() ?? 0,
              fechaCierre: Value((data['fechaCierre'] as num?)?.toInt()),
            ));
        return true;

      case 'retiro':
        final aperturaUuid = data['aperturaUuid'] as String?;
        final aperturaId = aperturaUuid != null
            ? await _aperturaIdPorUuid(db, aperturaUuid)
            : null;
        if (aperturaId == null) {
          _logger.w('⚠️ Retiro sin apertura local: $uuid');
          return false;
        }

        await db.into(db.retiroCaja).insert(RetiroCajaCompanion.insert(
              uuid: uuid,
              aperturaId: aperturaId,
              usuarioId: (data['usuarioId'] as String?) ?? '',
              usuarioNombre: (data['usuarioNombre'] as String?) ?? '',
              montoBs: (data['montoBs'] as num?)?.toDouble() ?? 0,
              motivo: (data['motivo'] as String?) ?? '',
              fecha: (data['fecha'] as num?)?.toInt() ?? 0,
            ));
        return true;

      case 'cierre':
        final aperturaUuid = data['aperturaUuid'] as String?;
        final aperturaId = aperturaUuid != null
            ? await _aperturaIdPorUuid(db, aperturaUuid)
            : null;
        if (aperturaId == null) {
          _logger.w('⚠️ Cierre sin apertura local: $uuid');
          return false;
        }

        await db.into(db.cierreCaja).insert(CierreCajaCompanion.insert(
              uuid: uuid,
              aperturaId: aperturaId,
              usuarioId: (data['usuarioId'] as String?) ?? '',
              usuarioNombre: (data['usuarioNombre'] as String?) ?? '',
              montoEsperadoBs:
                  (data['montoEsperadoBs'] as num?)?.toDouble() ?? 0,
              montoRealBs: (data['montoRealBs'] as num?)?.toDouble() ?? 0,
              diferenciaBs: (data['diferenciaBs'] as num?)?.toDouble() ?? 0,
              resumenJson: (data['resumenJson'] as String?) ?? '',
              nota: Value(data['nota'] as String?),
              fecha: (data['fecha'] as num?)?.toInt() ?? 0,
            ));
        return true;
    }

    return false;
  }

  Future<bool> _existeCajaPorUuid(AppDatabase db, String uuid) async {
    final ap = await (db.select(db.aperturaCaja)
          ..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();
    if (ap != null) return true;

    final re = await (db.select(db.retiroCaja)
          ..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();
    if (re != null) return true;

    final ci = await (db.select(db.cierreCaja)
          ..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();
    return ci != null;
  }

  Future<int?> _aperturaIdPorUuid(AppDatabase db, String uuid) async {
    final ap = await (db.select(db.aperturaCaja)
          ..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();
    return ap?.id;
  }

  // ─────────────────────────────────────────────────────────────────────
  // CLIENTES (crítico para fiados y saldos)
  // ─────────────────────────────────────────────────────────────────────
  void _listenClientes() {
    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) return;

    final sub = clientFb.firestore.collection('clientes').snapshots().listen(
        (snapshot) async {
      final db = _ref.read(databaseProvider);
      int cambios = 0;

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added ||
            change.type == DocumentChangeType.modified) {
          final actualizado = await _syncClienteLocal(db, change.doc);
          if (actualizado) cambios++;
        }
      }

      if (cambios > 0) {
        _logger.i('👥 Clientes actualizados ($cambios cambios)');
        _ref.read(syncRefreshProvider.notifier).state++;
      }
    }, onError: (e) {
      _logger.e('❌ Error en listener de clientes: $e');
    });

    _subscriptions.add(sub);
  }

  Future<bool> _syncClienteLocal(AppDatabase db, DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return false;

    final uuid = doc.id;
    final remotoTs = (data['fechaActualizacion'] as num?)?.toInt() ?? 0;
    final local = await (db.select(db.cliente)
          ..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();

    if (local == null) {
      // Cliente nuevo de otro dispositivo
      await db.into(db.cliente).insert(ClienteCompanion.insert(
            uuid: uuid,
            nombre: (data['nombre'] as String?) ?? 'Sin nombre',
            cedula: Value(data['cedula'] as String?),
            telefono: Value(data['telefono'] as String?),
            saldoPendienteUsd:
                Value((data['saldoPendienteUsd'] as num?)?.toDouble() ?? 0),
            limiteCreditoUsd:
                Value((data['limiteCreditoUsd'] as num?)?.toDouble()),
            activo: Value(data['activo'] as bool? ?? true),
            fechaCreacion: remotoTs,
            fechaActualizacion: remotoTs,
          ));
      return true;
    } else if (remotoTs > local.fechaActualizacion) {
      // Cliente existente: actualizar si remoto es más reciente
      await (db.update(db.cliente)..where((t) => t.id.equals(local.id)))
          .write(ClienteCompanion(
        nombre: Value((data['nombre'] as String?) ?? local.nombre),
        telefono: Value((data['telefono'] as String?) ?? local.telefono),
        saldoPendienteUsd: Value(
            (data['saldoPendienteUsd'] as num?)?.toDouble() ??
                local.saldoPendienteUsd),
        activo: Value(data['activo'] as bool? ?? local.activo),
        fechaActualizacion: Value(remotoTs),
      ));
      return true;
    }

    return false;
  }
}

/// Provider global del servicio de listeners.
final realtimeListenersProvider = Provider<RealtimeListeners>((ref) {
  final listeners = RealtimeListeners(ref);
  ref.onDispose(listeners.dispose);
  return listeners;
});
