import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_outbox.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

/// DAO de clientes y movimientos de fiado.
class ClienteDao {
  final AppDatabase _db;

  ClienteDao(this._db);

  Future<List<ClienteData>> obtenerTodos() {
    return (_db.select(_db.cliente)
          ..where((t) => t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.nombre)]))
        .get();
  }

  Future<List<ClienteData>> buscar(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return obtenerTodos();

    return (_db.select(_db.cliente)
          ..where((t) =>
              t.activo.equals(true) &
              (t.nombre.lower().like('%$q%') |
                  t.cedula.lower().like('%$q%') |
                  t.telefono.lower().like('%$q%')))
          ..orderBy([(t) => OrderingTerm(expression: t.nombre)]))
        .get();
  }

  Future<ClienteData?> obtenerPorId(int id) {
    return (_db.select(_db.cliente)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Clientes que deben (para alertas del Panel).
  Future<List<ClienteData>> conSaldoPendiente() {
    return (_db.select(_db.cliente)
          ..where((t) =>
              t.activo.equals(true) & t.saldoPendienteUsd.isBiggerThanValue(0))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.saldoPendienteUsd, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<int> insertar(ClienteCompanion companion) async {
    final id = await _db.into(_db.cliente).insert(companion);
    final creado = await obtenerPorId(id);
    if (creado != null) {
      await encolarSync(_db,
          coleccion: 'clientes',
          docId: creado.uuid,
          payload: payloadCliente(creado));
    }
    return id;
  }

  Future<bool> actualizar(int id, ClienteCompanion companion) async {
    final filas = await (_db.update(_db.cliente)..where((t) => t.id.equals(id)))
        .write(companion);
    if (filas > 0) {
      final actualizado = await obtenerPorId(id);
      if (actualizado != null) {
        await encolarSync(_db,
            coleccion: 'clientes',
            docId: actualizado.uuid,
            payload: payloadCliente(actualizado));
      }
    }
    return filas > 0;
  }

  Future<bool> desactivar(int id) async {
    final filas = await (_db.update(_db.cliente)..where((t) => t.id.equals(id)))
        .write(const ClienteCompanion(activo: Value(false)));
    if (filas > 0) {
      final actualizado = await obtenerPorId(id);
      if (actualizado != null) {
        await encolarSync(_db,
            coleccion: 'clientes',
            docId: actualizado.uuid,
            payload: payloadCliente(actualizado));
      }
    }
    return filas > 0;
  }

  /// Historial de fiados y abonos, más reciente primero.
  Future<List<PagoFiadoData>> historial(int clienteId) {
    return (_db.select(_db.pagoFiado)
          ..where((t) => t.clienteId.equals(clienteId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Registra fiado o abono y ajusta el saldo en UNA transacción.
  /// delta positivo = aumenta deuda ('fiado'), negativo no se usa aquí.
  Future<void> registrarMovimiento({
    required int clienteId,
    int? ventaId,
    required String tipo, // 'fiado' | 'abono'
    required double montoUsd,
    required double montoBs,
    required double tasa,
    String? nota,
    required String usuarioId,
    required String usuarioNombre,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;

    await _db.transaction(() async {
      final pagoUuid = const Uuid().v4();
      await _db.into(_db.pagoFiado).insert(PagoFiadoCompanion.insert(
            uuid: pagoUuid,
            clienteId: clienteId,
            ventaId: Value(ventaId),
            tipo: tipo,
            montoUsd: montoUsd,
            montoBs: montoBs,
            tasa: tasa,
            nota: Value(nota),
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: ahora,
          ));

      final delta = tipo == 'fiado' ? montoUsd : -montoUsd;
      await (_db.update(_db.cliente)..where((t) => t.id.equals(clienteId)))
          .write(ClienteCompanion.custom(
        saldoPendienteUsd: _db.cliente.saldoPendienteUsd + Variable(delta),
        fechaActualizacion: Variable(ahora),
      ));

      // Outbox: movimiento + saldo nuevo del cliente
      await encolarSync(_db,
          coleccion: 'pagos_fiados',
          docId: pagoUuid,
          payload: {
            'clienteId': clienteId,
            'ventaId': ventaId,
            'tipo': tipo,
            'montoUsd': montoUsd,
            'montoBs': montoBs,
            'tasa': tasa,
            'nota': nota,
            'usuarioId': usuarioId,
            'usuarioNombre': usuarioNombre,
            'fecha': ahora,
          });
      final cliente = await obtenerPorId(clienteId);
      if (cliente != null) {
        await encolarSync(_db,
            coleccion: 'clientes',
            docId: cliente.uuid,
            payload: payloadCliente(cliente));
      }
    });
  }
}

final clienteDaoProvider =
    Provider<ClienteDao>((ref) => ClienteDao(ref.watch(databaseProvider)));

/// Lista con búsqueda (se invalida al guardar/abonar).
final clientesListProvider =
    FutureProvider.autoDispose.family<List<ClienteData>, String>((ref, query) {
  return ref.watch(clienteDaoProvider).buscar(query);
});

/// Cliente por ID (pantalla detalle).
final clientePorIdProvider =
    FutureProvider.autoDispose.family<ClienteData?, int>((ref, id) {
  return ref.watch(clienteDaoProvider).obtenerPorId(id);
});

/// Historial por cliente.
final historialClienteProvider =
    FutureProvider.autoDispose.family<List<PagoFiadoData>, int>((ref, id) {
  return ref.watch(clienteDaoProvider).historial(id);
});
