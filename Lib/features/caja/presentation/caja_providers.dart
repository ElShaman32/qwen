import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../auth/application/current_user_provider.dart';
import '../data/caja_dao.dart';
import '../domain/caja_calculos.dart';

/// Estado compuesto de la pantalla de Caja (por usuario).
class CajaStateData {
  final AperturaCajaData? apertura;
  final CierreCajaData? ultimoCierre;
  final ResumenCaja? resumen;
  final List<RetiroCajaData> retiros;

  const CajaStateData({
    this.apertura,
    this.ultimoCierre,
    this.resumen,
    this.retiros = const [],
  });
}

/// Caja individual: cada usuario abre, vende y cuadra la suya.
/// El esperado en cajón solo cuenta LAS VENTAS DE ESE USUARIO en su turno.
final cajaStateProvider = FutureProvider<CajaStateData>((ref) async {
  final uid = ref.watch(currentUserProvider).value?.uid ?? '';
  if (uid.isEmpty) return const CajaStateData();

  final dao = ref.watch(cajaDaoProvider);
  final apertura = await dao.aperturaActivaDe(uid);

  if (apertura == null) {
    return CajaStateData(ultimoCierre: await dao.ultimoCierreDe(uid));
  }

  final ventas = await dao.ventasDeUsuarioDesde(uid, apertura.fecha);
  final retiros = await dao.retirosDe(apertura.id);

  return CajaStateData(
    apertura: apertura,
    resumen: CajaCalculos.calcular(
      apertura: apertura,
      ventas: ventas,
      retiros: retiros,
    ),
    retiros: retiros,
  );
});
