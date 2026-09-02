import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/client_firebase_provider.dart';
import '../domain/user_profile.dart';

/// Perfil del usuario autenticado actual.
/// Escucha cambios de auth y lee el documento usuarios/{uid}.
final currentUserProvider = StreamProvider<UserProfile?>((ref) {
  final clientFb = ref.watch(clientFirebaseProvider);

  if (!clientFb.isInitialized) {
    return Stream.value(null);
  }

  return clientFb.auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    try {
      final doc = await clientFb.firestore
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;
      return UserProfile.fromFirestore(user.uid, doc.data()!);
    } catch (e) {
      return null;
    }
  });
});