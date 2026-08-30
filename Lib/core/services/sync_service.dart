import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../database/app_database.dart';
import '../database/database_provider.dart';
import 'client_firebase.dart';

/// Servicio de sincronización Drift <-> Firestore.
///
/// - Sube la cola de operaciones (outbox) a Firestore.
/// - Descarga inventario y clientes (Firestore = fuente de verdad,
///   pero SOLO si la cola quedó vacía, para no pisar cambios pendientes).
/// - Conflict resolution por timestamp: gana el más reciente.
class SyncService {
  SyncService(this._ref);

  final Ref _ref;
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Sincronización completa: primero sube pendientes, luego descarga.
  /// Retorna true si quedó todo al día.
  Future<bool> syncCompleto() async {
    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) return false;

    final colaVacia = await vaciarCola();

    if (colaVacia) {
      await completarRemoto();
      await descargarInventario();
      await descargarClientes();
      await descargarCaja();
      await descargarVentas();
    }

    return colaVacia;
  }

  // ───────────────────────────────────────────────────────────────────────
  // SUBIR (cola -> Firestore)
  // ───────────────────────────────────────────────────────────────────────

  /// Procesa hasta 50 operaciones pendientes por pasada.
  /// Retorna true si la cola quedó vacía.
  Future<bool> vaciarCola() async {
    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) return false;

    final db = _ref.read(databaseProvider);
    final ops = await (db.select(db.syncQueue)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp)])
          ..limit(50))
        .get();

    if (ops.isEmpty) return true;
    _logger.i('🔄 Vaciando cola de sync: ${ops.length} operaciones');

    for (final op in ops) {
      try {
        final payload = jsonDecode(op.payload) as Map<String, dynamic>;
        final docRef =
            clientFb.firestore.collection(op.coleccion).doc(op.docId);

        switch (op.operacion) {
          case 'set':
            await docRef.set(payload, SetOptions(merge: true));
          case 'update':
            await docRef.update(payload);
          case 'delete':
            await docRef.delete();
        }

        // Éxito: sale de la cola
        await (db.delete(db.syncQueue)..where((t) => t.id.equals(op.id))).go();
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          // Las reglas de Firestore rechazan esta op: reintentar es inútil.
          // Loguear el error real y descartarla para no atascar la cola.
          _logger.e(
              '❌ Operación rechazada por reglas: ${op.coleccion}/${op.docId}');
          await (db.delete(db.syncQueue)..where((t) => t.id.equals(op.id)))
              .go();
          continue;
        }
        await (db.update(db.syncQueue)..where((t) => t.id.equals(op.id)))
            .write(SyncQueueCompanion(intentos: Value(op.intentos + 1)));
        _logger.w('⚠️ Sync pausado (${ops.length} pendientes): $e');
        return false;
      } on ArgumentError catch (e) {
        // Ruta inválida u operación vieja en cola: descartar para no atascar.
        // completarRemoto() re-subirá el dato real con la ruta correcta.
        _logger.e('❌ Operación inválida en cola, descartada: '
            '${op.coleccion}/${op.docId} ($e)');
        await (db.delete(db.syncQueue)..where((t) => t.id.equals(op.id))).go();
        continue;
      } catch (e) {
        await (db.update(db.syncQueue)..where((t) => t.id.equals(op.id)))
            .write(SyncQueueCompanion(intentos: Value(op.intentos + 1)));
        _logger
            .w('⚠️ Sync pausado sin conexión (${ops.length} pendientes): $e');
        return false;
      }

      // ¿Quedan más de 50? Recursión controlada.
      final quedan = await _conteoCola(db);
      if (quedan > 0) return vaciarCola();
      return true;
    }

    return true;
  }

  Future<int> _conteoCola(AppDatabase db) async {
    final expr = db.syncQueue.id.count();
    final fila =
        await (db.selectOnly(db.syncQueue)..addColumns([expr])).getSingle();
    return fila.read(expr) ?? 0;
  }

  // ───────────────────────────────────────────────────────────────────────
  // BAJAR (Firestore -> Drift), fuente de verdad con timestamp
  // ───────────────────────────────────────────────────────────────────────

  Future<void> descargarInventario() async {
    try {
      final clientFb = ClientFirebase();
      if (!clientFb.isInitialized) return;
      final db = _ref.read(databaseProvider);

      final snap = await clientFb.firestore.collection('inventario').get();

      for (final doc in snap.docs) {
        final data = doc.data();
        final remotoTs = (data['fechaActualizacion'] as num?)?.toInt() ?? 0;

        final local = await (db.select(db.producto)
              ..where((t) => t.uuid.equals(doc.id)))
            .getSingleOrNull();

        if (local == null) {
          // Doc "esquelético" (solo stock, escrito por un cajero):
          // no crear localmente hasta que el admin suba el doc completo.
          if (!data.containsKey('nombre')) continue;
          // Producto creado en OTRO dispositivo: se crea localmente.
          await db.into(db.producto).insert(ProductoCompanion.insert(
                uuid: doc.id,
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
                fechaCreacion: remotoTs,
                fechaActualizacion: remotoTs,
              ));
        } else if (remotoTs > local.fechaActualizacion) {
          // Remoto más reciente: gana Firestore.
          await (db.update(db.producto)..where((t) => t.id.equals(local.id)))
              .write(ProductoCompanion(
            nombre: Value((data['nombre'] as String?) ?? local.nombre),
            precioUsd: Value(
                (data['precioUsd'] as num?)?.toDouble() ?? local.precioUsd),
            costoUsd:
                Value((data['costoUsd'] as num?)?.toDouble() ?? local.costoUsd),
            stock: Value((data['stock'] as num?)?.toDouble() ?? local.stock),
            activo: Value(data['activo'] as bool? ?? local.activo),
            fechaActualizacion: Value(remotoTs),
          ));
        }
        // Si local es más reciente, NO se pisa: su cambio está en cola
        // y se subirá en el próximo vaciado.
      }

      _logger.i('✅ Inventario reconciliado (${snap.docs.length} docs)');
    } catch (e, stack) {
      _logger.e('Error descargando inventario', error: e, stackTrace: stack);
    }
  }

  Future<void> descargarClientes() async {
    try {
      final clientFb = ClientFirebase();
      if (!clientFb.isInitialized) return;
      final db = _ref.read(databaseProvider);

      final snap = await clientFb.firestore.collection('clientes').get();

      for (final doc in snap.docs) {
        final data = doc.data();
        final remotoTs = (data['fechaActualizacion'] as num?)?.toInt() ?? 0;

        final local = await (db.select(db.cliente)
              ..where((t) => t.uuid.equals(doc.id)))
            .getSingleOrNull();

        if (local == null) {
          await db.into(db.cliente).insert(ClienteCompanion.insert(
                uuid: doc.id,
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
        } else if (remotoTs > local.fechaActualizacion) {
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
        }
      }

      _logger.i('✅ Clientes reconciliados (${snap.docs.length} docs)');
    } catch (e, stack) {
      _logger.e('Error descargando clientes', error: e, stackTrace: stack);
    }
  }

  /// Descarga caja desde Firestore.
  /// La caja es inmutable (no se edita), así que solo creamos lo que falta.
  Future<void> descargarCaja() async {
    try {
      final clientFb = ClientFirebase();
      if (!clientFb.isInitialized) return;
      final db = _ref.read(databaseProvider);

      final snap = await clientFb.firestore.collection('caja').get();
      int creadas = 0;

      for (final doc in snap.docs) {
        final data = doc.data();
        final tipo = data['tipo'] as String?;
        final uuid = doc.id;

        // Solo procesamos si no existe localmente (por uuid)
        final existeLocal = await _existeCajaPorUuid(db, uuid);
        if (existeLocal) continue;

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
            creadas++;
          case 'retiro':
            // Necesitamos el aperturaId local (resolvemos por aperturaUuid)
            final aperturaUuid = data['aperturaUuid'] as String?;
            final aperturaId = aperturaUuid != null
                ? await _aperturaIdPorUuid(db, aperturaUuid)
                : null;
            if (aperturaId == null) {
              _logger.w('️ Retiro sin apertura local: $uuid');
              continue;
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
            creadas++;
          case 'cierre':
            final aperturaUuid = data['aperturaUuid'] as String?;
            final cierreAperturaId = aperturaUuid != null
                ? await _aperturaIdPorUuid(db, aperturaUuid)
                : null;
            if (cierreAperturaId == null) {
              _logger.w('⚠️ Cierre sin apertura local: $uuid');
              continue;
            }
            await db.into(db.cierreCaja).insert(CierreCajaCompanion.insert(
                  uuid: uuid,
                  aperturaId: cierreAperturaId,
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
            creadas++;
        }
      }

      if (creadas > 0) {
        _logger.i('✅ Caja descargada ($creadas docs nuevos)');
      }
    } catch (e, stack) {
      _logger.e('Error descargando caja', error: e, stackTrace: stack);
    }
  }

  /// Descarga ventas desde Firestore (las que faltan localmente).
  /// NO toca stock ni saldos: esos se sincronizan por sus colecciones.
  Future<void> descargarVentas() async {
    try {
      final clientFb = ClientFirebase();
      if (!clientFb.isInitialized) return;
      final db = _ref.read(databaseProvider);

      final snap = await clientFb.firestore.collection('ventas').get();
      int nuevas = 0;
      int anuladas = 0;

      for (final doc in snap.docs) {
        final data = doc.data();
        final uuid = doc.id;

        final local = await (db.select(db.venta)
              ..where((t) => t.uuid.equals(uuid)))
            .getSingleOrNull();

        if (local == null) {
          // Venta de OTRO dispositivo: se crea localmente (solo registro)
          int? clienteIdRemoto = (data['clienteId'] as num?)?.toInt();
          if (clienteIdRemoto != null) {
            final c = await (db.select(db.cliente)
                  ..where((t) => t.id.equals(clienteIdRemoto!)))
                .getSingleOrNull();
            if (c == null) clienteIdRemoto = null; // evita referencia colgada
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
          nuevas++;
        } else if ((data['anulada'] as bool? ?? false) && !local.anulada) {
          // Anulada en otro dispositivo: reflejar localmente
          await (db.update(db.venta)..where((t) => t.id.equals(local.id)))
              .write(VentaCompanion(
            anulada: const Value(true),
            motivoAnulacion: Value(data['motivoAnulacion'] as String?),
          ));
          anuladas++;
        }
      }

      if (nuevas > 0 || anuladas > 0) {
        _logger.i('✅ Ventas descargadas ($nuevas nuevas, $anuladas anuladas)');
      }
    } catch (e, stack) {
      _logger.e('Error descargando ventas', error: e, stackTrace: stack);
    }
  }

  /// Helpers para resolver aperturaId local desde uuid remoto
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

  /// Poblado inicial / catch-up: sube a Firestore los documentos locales
  /// que aún no existen en remoto. Solo escribe los faltantes, así que
  /// después de la primera pasada el costo es ~cero.
  Future<void> completarRemoto() async {
    final clientFb = ClientFirebase();
    if (!clientFb.isInitialized) return;
    await _completarInventario(clientFb);
    await _completarClientes(clientFb);
    await _completarMerma(clientFb);
    await _completarCaja(clientFb);
  }

  Future<void> _completarInventario(ClientFirebase clientFb) async {
    try {
      final db = _ref.read(databaseProvider);
      final snap = await clientFb.firestore.collection('inventario').get();
      final remotos = {for (final d in snap.docs) d.id: d.data()};
      final locales = await (db.select(db.producto)
            ..where((t) => t.activo.equals(true)))
          .get();

      int subidos = 0;
      for (final p in locales) {
        final data = remotos[p.uuid];
        // Solo salta si el doc remoto YA está completo.
        // Docs esqueléticos (solo stock, creados por un update de cajero)
        // se completan con el payload entero.
        if (data != null && data.containsKey('nombre')) continue;

        await clientFb.firestore
            .collection('inventario')
            .doc(p.uuid)
            .set(payloadProducto(p), SetOptions(merge: true));
        subidos++;
      }
      if (subidos > 0) {
        _logger.i('✅ Inventario completado en remoto ($subidos docs)');
      }
    } on FirebaseException catch (e) {
      _logger.w('⚠️ Completar inventario requiere admin: ${e.code}');
    } catch (e, s) {
      _logger.e('Error completando inventario', error: e, stackTrace: s);
    }
  }

  Future<void> _completarClientes(ClientFirebase clientFb) async {
    try {
      final db = _ref.read(databaseProvider);
      final snap = await clientFb.firestore.collection('clientes').get();
      final remotos = snap.docs.map((d) => d.id).toSet();
      final locales = await (db.select(db.cliente)).get();

      for (final c in locales) {
        if (remotos.contains(c.uuid)) continue;
        await clientFb.firestore
            .collection('clientes')
            .doc(c.uuid)
            .set(payloadCliente(c), SetOptions(merge: true));
      }
      _logger.i('✅ Clientes completados en remoto');
    } on FirebaseException catch (e) {
      _logger.w('⚠️ Completar clientes omitido: ${e.code}');
    } catch (e, s) {
      _logger.e('Error completando clientes', error: e, stackTrace: s);
    }
  }

  Future<void> _completarMerma(ClientFirebase clientFb) async {
    try {
      final db = _ref.read(databaseProvider);
      final snap = await clientFb.firestore.collection('merma').get();
      final remotos = snap.docs.map((d) => d.id).toSet();
      final locales = await (db.select(db.merma)).get();

      for (final m in locales) {
        if (remotos.contains(m.uuid)) continue;
        await clientFb.firestore.collection('merma').doc(m.uuid).set({
          'productoId': m.productoId,
          'productoNombre': m.productoNombre,
          'cantidad': m.cantidad,
          'unidad': m.unidad,
          'motivo': m.motivo,
          'nota': m.nota,
          'costoUsd': m.costoUsd,
          'usuarioId': m.usuarioId,
          'usuarioNombre': m.usuarioNombre,
          'fecha': m.fecha,
        }, SetOptions(merge: true));
      }
      _logger.i('✅ Merma completada en remoto');
    } on FirebaseException catch (e) {
      _logger.w('⚠️ Completar merma omitido: ${e.code}');
    } catch (e, s) {
      _logger.e('Error completando merma', error: e, stackTrace: s);
    }
  }

  Future<void> _completarCaja(ClientFirebase clientFb) async {
    try {
      final db = _ref.read(databaseProvider);
      final snap = await clientFb.firestore.collection('caja').get();
      final remotos = snap.docs.map((d) => d.id).toSet();

      final aperturas = await (db.select(db.aperturaCaja)).get();
      final uuidPorId = <int, String>{for (final a in aperturas) a.id: a.uuid};

      for (final a in aperturas) {
        if (remotos.contains(a.uuid)) continue;
        await clientFb.firestore.collection('caja').doc(a.uuid).set({
          'tipo': 'apertura',
          'usuarioId': a.usuarioId,
          'usuarioNombre': a.usuarioNombre,
          'montoInicialBs': a.montoInicialBs,
          'montoInicialUsd': a.montoInicialUsd,
          'novedad': a.novedad,
          'cerrada': a.cerrada,
          'fecha': a.fecha,
          'fechaCierre': a.fechaCierre,
        }, SetOptions(merge: true));
      }

      final retiros = await (db.select(db.retiroCaja)).get();
      for (final r in retiros) {
        if (remotos.contains(r.uuid)) continue;
        await clientFb.firestore.collection('caja').doc(r.uuid).set({
          'tipo': 'retiro',
          'aperturaUuid': uuidPorId[r.aperturaId],
          'usuarioId': r.usuarioId,
          'usuarioNombre': r.usuarioNombre,
          'montoBs': r.montoBs,
          'motivo': r.motivo,
          'fecha': r.fecha,
        }, SetOptions(merge: true));
      }

      final cierres = await (db.select(db.cierreCaja)).get();
      for (final c in cierres) {
        if (remotos.contains(c.uuid)) continue;
        await clientFb.firestore.collection('caja').doc(c.uuid).set({
          'tipo': 'cierre',
          'aperturaUuid': uuidPorId[c.aperturaId],
          'usuarioId': c.usuarioId,
          'usuarioNombre': c.usuarioNombre,
          'montoEsperadoBs': c.montoEsperadoBs,
          'montoRealBs': c.montoRealBs,
          'diferenciaBs': c.diferenciaBs,
          'resumenJson': c.resumenJson,
          'nota': c.nota,
          'fecha': c.fecha,
        }, SetOptions(merge: true));
      }

      _logger.i('✅ Caja completada en remoto');
    } on FirebaseException catch (e) {
      _logger.w('⚠️ Completar caja omitido: ${e.code}');
    } catch (e, s) {
      _logger.e('Error completando caja', error: e, stackTrace: s);
    }
  }
}

/// Versión de refresh: los providers que leen Drift la watchean para
/// recargarse cuando el sync descarga datos nuevos (fix dashboard en 0).
final syncRefreshProvider = StateProvider<int>((ref) => 0);
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref);
});
