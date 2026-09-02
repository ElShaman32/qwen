import 'package:el_cuaderno_de_mario/core/services/client_firebase.dart';
import 'package:el_cuaderno_de_mario/core/services/session_service.dart';
import 'package:el_cuaderno_de_mario/core/services/subscription_service.dart';
import 'package:el_cuaderno_de_mario/core/services/sync_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';
import 'core/config/app_config_notifier.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

/// Punto de entrada de El Cuaderno de Mario.
/// Inicializa Firebase Maestro, carga cache, y envuelve la app en ProviderScope.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa datos de fecha para es_VE (fix LocaleDataException del DatePicker)
  await initializeDateFormatting();

  // 1. Inicializar Firebase MAESTRO (del desarrollador)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Inicializar Sentry para crash reporting
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.tracesSampleRate = 1.0;
      options.environment =
          const String.fromEnvironment('ENV', defaultValue: 'production');
    },
    appRunner: () async {
      final container = ProviderContainer();

      // 3. Restaurar Firebase del cliente si hay sesión previa
      final sessionService = SessionService();
      final credenciales = await sessionService.cargarCredencialesCliente();

      if (credenciales != null) {
        try {
          await ClientFirebase().initialize(
            name: credenciales.nombreApp,
            options: credenciales.opciones,
          );
          _logger.i('✅ Firebase del cliente restaurado desde sesión previa');
        } catch (e) {
          _logger.e('⚠️ No se pudo restaurar Firebase del cliente: $e');
        }
      }

      // 4. Cargar configuración desde Drift
      await container.read(appConfigProvider.notifier).loadFromCache();

      // 5. Activar servicios solo si hay sesión activa o demo activo
      final appConfig = container.read(appConfigProvider);
      final haySesion = credenciales != null;
      final demoActivo = appConfig.isDemoMode && !appConfig.demoVencido;

      if (haySesion || demoActivo) {
        // Activar verificación periódica de suscripción (solo si hay credenciales del negocio)
        if (haySesion) {
          container.read(subscriptionServiceProvider);
        }

        // Activar sincronización automática (solo si hay sesión o demo activo)
        container.read(syncSchedulerProvider);

        _logger.i('✅ Servicios activados: sesión=$haySesion, demo=$demoActivo');
      } else {
        _logger.i('⏸️ Servicios en pausa: sin sesión y sin demo activo');
      }

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const ElCuadernoDeMarioApp(),
        ),
      );
    },
  );
}

class ElCuadernoDeMarioApp extends ConsumerWidget {
  const ElCuadernoDeMarioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema dinámico whitelabel que reacciona a cambios de configuración
    final theme = AppTheme.fromConfig(ref.watch(appConfigProvider));

    // Router con protección de roles y flujo multi-tenant
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'El Cuaderno de Mario',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: router,
      // Localización venezolana para formatos de fecha/número
      locale: const Locale('es', 'VE'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'VE'),
        Locale('es'),
        Locale('en'),
      ],
    );
  }
}
