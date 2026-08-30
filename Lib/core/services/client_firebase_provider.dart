import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'client_firebase.dart';

/// Provider del wrapper ClientFirebase.
/// Expone la instancia singleton del servicio.
final clientFirebaseProvider = Provider<ClientFirebase>((ref) {
  return ClientFirebase();
});