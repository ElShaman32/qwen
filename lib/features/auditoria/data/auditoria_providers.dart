import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import 'auditoria_dao.dart';

/// Lista en vivo de auditoría, filtrada por búsqueda.
/// Usa family para recibir el texto de búsqueda como parámetro.
final auditoriaListProvider =
    StreamProvider.family<List<AuditoriaLogData>, String>((ref, busqueda) {
  return ref.watch(auditoriaDaoProvider).observar(busqueda: busqueda);
});
