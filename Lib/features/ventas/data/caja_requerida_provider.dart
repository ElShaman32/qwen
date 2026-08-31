import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../auth/application/current_user_provider.dart';
import '../../caja/data/caja_dao.dart';

/// ¿El usuario actual debe tener caja abierta para vender?
///
/// Lógica:
/// - Admin: NUNCA exige caja (puede vender siempre)
/// - Cajero con caja abierta: NO exige (puede vender)
/// - Cajero sin caja abierta: SÍ exige (bloquea la venta)
///
/// Retorna true si DEBE bloquearse la venta por falta de caja.
/// Se invalida manualmente desde caja_screen.dart al abrir/cerrar.
final debeExigirCajaProvider = FutureProvider.autoDispose<bool>((ref) async {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.value;

  // Sin sesión: no hay nada que validar
  if (user == null) return false;

  // Admin siempre puede vender
  if (user.esAdmin) return false;

  // Cajero: debe tener caja abierta
  final cajaDao = CajaDao(ref.watch(databaseProvider));
  final apertura = await cajaDao.aperturaActivaDe(user.uid);
  return apertura == null;
});
