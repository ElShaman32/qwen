import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../domain/alerta.dart';

// ⬇️ lowerCamelCase (convención Flutter)
const int diasPlazoFiado = 7;

final alertasProvider = FutureProvider<ResumenAlertas>((ref) async {
  ref.watch(syncRefreshProvider);

  final db = ref.watch(databaseProvider);
  final ahora = DateTime.now();

  final hoy = DateTime(ahora.year, ahora.month, ahora.day);
  final hoyEpoch = hoy.millisecondsSinceEpoch ~/ 1000;
  final en3DiasEpoch =
      hoy.add(const Duration(days: 3)).millisecondsSinceEpoch ~/ 1000;
  final en7DiasEpoch =
      hoy.add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000;
  final haceNDiasEpoch = hoy
          .subtract(const Duration(days: diasPlazoFiado))
          .millisecondsSinceEpoch ~/
      1000;

  // 1. Productos próximos a vencer
  final productosVencimiento = await (db.select(db.producto)
        ..where((t) => t.fechaVencimiento.isNotNull()))
      .get();

  final venceHoy = <Alerta>[];
  final vence3Dias = <Alerta>[];
  final venceSemana = <Alerta>[];

  // ⬇️ Set para evitar duplicados por ID
  final vistosVencimiento = <int>{};

  for (final p in productosVencimiento) {
    if (vistosVencimiento.contains(p.id)) continue;
    vistosVencimiento.add(p.id);

    final fv = p.fechaVencimiento!;
    if (fv <= hoyEpoch) {
      venceHoy.add(Alerta(
        id: p.id,
        nombre: p.nombre,
        tipo: TipoAlerta.venceHoy,
        modulo: 'inventario',
        detalle: 'Vencido o vence hoy',
      ));
    } else if (fv <= en3DiasEpoch) {
      vence3Dias.add(Alerta(
        id: p.id,
        nombre: p.nombre,
        tipo: TipoAlerta.vence3Dias,
        modulo: 'inventario',
        detalle: 'Vence en 3 días',
      ));
    } else if (fv <= en7DiasEpoch) {
      venceSemana.add(Alerta(
        id: p.id,
        nombre: p.nombre,
        tipo: TipoAlerta.venceSemana,
        modulo: 'inventario',
        detalle: 'Vence esta semana',
      ));
    }
  }

  // 2. Stock bajo
  final productosStock = await db.select(db.producto).get();
  final stockBajo = <Alerta>[];
  final vistosStock = <int>{}; // ⬅️ Set para evitar duplicados

  for (final p in productosStock) {
    if (vistosStock.contains(p.id)) continue;
    vistosStock.add(p.id);

    final minimo = p.stockMinimo;
    if (minimo > 0 && p.stock <= minimo) {
      // ⬇️ Sin ?? porque unidadMedida no es nullable
      final unidad = p.esGranel ? p.unidadMedida : 'und';
      stockBajo.add(Alerta(
        id: p.id,
        nombre: p.nombre,
        tipo: TipoAlerta.stockBajo,
        modulo: 'inventario',
        detalle: 'Stock: ${p.stock.toStringAsFixed(2)} $unidad',
      ));
    }
  }

  // 3. Fiados vencidos
  final clientes = await (db.select(db.cliente)
        ..where((t) => t.saldoPendienteUsd.isBiggerThanValue(0.0)))
      .get();

  final fiadosVencidos = <Alerta>[];
  final vistosClientes = <int>{}; // ⬅️ Set para evitar duplicados

  for (final c in clientes) {
    if (vistosClientes.contains(c.id)) continue;
    vistosClientes.add(c.id);

    if (c.fechaActualizacion < haceNDiasEpoch) {
      fiadosVencidos.add(Alerta(
        id: c.id,
        nombre: c.nombre,
        tipo: TipoAlerta.fiadoVencido,
        modulo: 'clientes',
        detalle:
            'Saldo: \$${c.saldoPendienteUsd.toStringAsFixed(2)} (Sin actividad)',
      ));
    }
  }

  return ResumenAlertas(
    venceHoy: venceHoy,
    vence3Dias: vence3Dias,
    venceSemana: venceSemana,
    stockBajo: stockBajo,
    fiadosVencidos: fiadosVencidos,
  );
});
