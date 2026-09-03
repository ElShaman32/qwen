import 'package:el_cuaderno_de_mario/core/database/app_database.dart';
import 'package:el_cuaderno_de_mario/features/proveedores/data/proveedor_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config_notifier.dart';
import '../../../core/services/sync_service.dart';
import '../../caja/data/caja_dao.dart';
import '../../clientes/data/cliente_dao.dart';
import '../../inventario/data/producto_dao.dart';
import '../../merma/data/merma_dao.dart';
import '../../ventas/data/venta_dao.dart';
import '../domain/contabilidad_models.dart';
import 'contabilidad_service.dart';
import 'gasto_dao.dart';

/// Período contable seleccionado en la UI.
final periodoContableProvider =
    StateProvider<PeriodoContable>((ref) => PeriodoContable.mes);

/// Estado de Resultados del período seleccionado.
final estadoResultadosProvider = FutureProvider<EstadoResultados>((ref) {
  ref.watch(syncRefreshProvider);
  final periodo = ref.watch(periodoContableProvider);
  final servicio = ref.watch(contabilidadServiceProvider);

  return servicio.estadoResultados(
    periodo: periodo,
    ventaDao: ref.watch(ventaDaoProvider),
    gastoDao: ref.watch(gastoDaoProvider),
    mermaDao: ref.watch(mermaDaoProvider),
    proveedorDao: ref.watch(proveedorDaoProvider),
  );
});

/// Situación Financiera (activos - pasivos).
final situacionFinancieraProvider = FutureProvider<SituacionFinanciera>((ref) {
  ref.watch(syncRefreshProvider);
  final servicio = ref.watch(contabilidadServiceProvider);
  final config = ref.watch(appConfigProvider);

  return servicio.situacionFinanciera(
    cajaDao: ref.watch(cajaDaoProvider),
    clienteDao: ref.watch(clienteDaoProvider),
    productoDao: ref.watch(productoDaoProvider),
    proveedorDao: ref.watch(proveedorDaoProvider),
    config: config,
  );
});

/// Lista de gastos manuales del período seleccionado.
final gastosPeriodoProvider = FutureProvider<List<GastoData>>((ref) {
  ref.watch(syncRefreshProvider);
  final periodo = ref.watch(periodoContableProvider);
  final servicio = ref.watch(contabilidadServiceProvider);
  final gastoDao = ref.watch(gastoDaoProvider);

  final (inicio, fin) = servicio.rangoPeriodo(periodo);
  return gastoDao.enRango(inicio, fin);
});
