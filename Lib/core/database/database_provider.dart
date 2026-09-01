import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// Provider global de la base de datos Drift.
/// NO usar singleton. Este provider permite mocking en tests.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});