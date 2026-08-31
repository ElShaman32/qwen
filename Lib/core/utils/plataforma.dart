import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// true solo en Android/iOS.
/// Windows usa escáner USB (emula teclado) y aún no tiene impresión térmica:
/// mobile_scanner y print_bluetooth_thermal no tienen implementación de escritorio.
bool esMovil() => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
