import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado de conexión global.
/// true = online, false = offline
final connectivityProvider = StreamProvider<bool>((ref) {
  final connectivity = Connectivity();
  final controller = StreamController<bool>();

  // Estado inicial
  connectivity.checkConnectivity().then((results) {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    if (!controller.isClosed) controller.add(isOnline);
  });

  // Cambios de conexión
  final subscription = connectivity.onConnectivityChanged.listen((results) {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    if (!controller.isClosed) controller.add(isOnline);
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});