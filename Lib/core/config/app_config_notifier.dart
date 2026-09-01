import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/services/demo_data_seeder.dart';
import 'package:el_cuaderno_de_mario/core/services/demo_mode_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../database/app_database.dart';
import '../database/database_provider.dart';
import '../services/client_firebase_provider.dart';

class AppConfigState {
  final String plan;
  final bool cuentaActiva;
  final int fechaVencimientoEpoch;
  final String appNombre;
  final String appSlogan;
  final String? logoUrl;
  final String colorPrimario;
  final String colorSecundario;
  final String rif;
  final String direccion;
  final String telefono;
  final double tasaBcv;
  final bool usarTasaBcv;
  final double? tasaManual;
  final double ivaRate;
  final double igtfRate;
  final int timestampUltimaVerificacion;
  final bool isLoading;
  final String? error;
  final bool isOfflineMode;
  final bool isDemoMode;
  final int demoStartTimestamp;

  const AppConfigState({
    this.plan = 'cuaderno',
    this.cuentaActiva = true,
    this.fechaVencimientoEpoch = 0,
    this.appNombre = '',
    this.appSlogan = '',
    this.logoUrl,
    this.colorPrimario = '#1a5c2a',
    this.colorSecundario = '#ffd700',
    this.rif = '',
    this.direccion = '',
    this.telefono = '',
    this.tasaBcv = 1.0,
    this.usarTasaBcv = true,
    this.tasaManual,
    this.ivaRate = 0.16,
    this.igtfRate = 0.03,
    this.timestampUltimaVerificacion = 0,
    this.isLoading = false,
    this.error,
    this.isOfflineMode = false,
    this.isDemoMode = false,
    this.demoStartTimestamp = 0,
  });

  // ── PLAN Y PERSONALIZACIÓN ──────────────────────────────────
  bool get puedePersonalizar =>
      plan == 'cuaderno_calculadora' || plan == 'todos_juguetes';

  /// Nombre efectivo según plan. Plan gratis siempre muestra marca del producto.
  String get nombreEfectivo => puedePersonalizar && appNombre.isNotEmpty
      ? appNombre
      : 'El Cuaderno de Mario';

  String get sloganEfectivo => puedePersonalizar ? appSlogan : '';

  String? get logoUrlEfectivo => puedePersonalizar ? logoUrl : null;

  /// La suscripción pagada venció (fecha_vencimiento pasó).
  /// Activa el banner de "vencido" aunque n8n aún no haya bajado el plan.
  bool get estaVencido {
    if (fechaVencimientoEpoch == 0) return false;
    return DateTime.now().millisecondsSinceEpoch > fechaVencimientoEpoch;
  }

  /// True si el modo demo está activo y ya pasaron 24h
  bool get demoVencido {
    if (!isDemoMode || demoStartTimestamp == 0) return false;
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final transcurrido = Duration(milliseconds: ahora - demoStartTimestamp);
    return transcurrido >= const Duration(hours: 24);
  }

  /// Suspensión manual de Mario (activa=false). Bloqueo total.
  bool get estaSuspendido => !cuentaActiva;

  // ── TASA E IMPUESTOS ────────────────────────────────────────
  double get tasaEfectiva => usarTasaBcv ? tasaBcv : (tasaManual ?? tasaBcv);

  bool get isKillSwitchActive {
    if (timestampUltimaVerificacion == 0) return false;
    final diasSinConexion = DateTime.now()
        .difference(
          DateTime.fromMillisecondsSinceEpoch(timestampUltimaVerificacion),
        )
        .inDays;
    return diasSinConexion > 7;
  }

  AppConfigState copyWith({
    String? plan,
    bool? cuentaActiva,
    int? fechaVencimientoEpoch,
    String? appNombre,
    String? appSlogan,
    String? logoUrl,
    String? colorPrimario,
    String? colorSecundario,
    String? rif,
    String? direccion,
    String? telefono,
    double? tasaBcv,
    bool? usarTasaBcv,
    double? tasaManual,
    double? ivaRate,
    double? igtfRate,
    int? timestampUltimaVerificacion,
    bool? isLoading,
    String? error,
    bool? isOfflineMode,
    bool? isDemoMode,
    int? demoStartTimestamp,
  }) {
    return AppConfigState(
      plan: plan ?? this.plan,
      cuentaActiva: cuentaActiva ?? this.cuentaActiva,
      fechaVencimientoEpoch:
          fechaVencimientoEpoch ?? this.fechaVencimientoEpoch,
      appNombre: appNombre ?? this.appNombre,
      appSlogan: appSlogan ?? this.appSlogan,
      logoUrl: logoUrl ?? this.logoUrl,
      colorPrimario: colorPrimario ?? this.colorPrimario,
      colorSecundario: colorSecundario ?? this.colorSecundario,
      rif: rif ?? this.rif,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      tasaBcv: tasaBcv ?? this.tasaBcv,
      usarTasaBcv: usarTasaBcv ?? this.usarTasaBcv,
      tasaManual: tasaManual ?? this.tasaManual,
      ivaRate: ivaRate ?? this.ivaRate,
      igtfRate: igtfRate ?? this.igtfRate,
      timestampUltimaVerificacion:
          timestampUltimaVerificacion ?? this.timestampUltimaVerificacion,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      isDemoMode: isDemoMode ?? this.isDemoMode,
      demoStartTimestamp: demoStartTimestamp ?? this.demoStartTimestamp,
    );
  }
}

final appConfigProvider =
    NotifierProvider<AppConfigNotifier, AppConfigState>(AppConfigNotifier.new);

class AppConfigNotifier extends Notifier<AppConfigState> {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  AppConfigState build() {
    return const AppConfigState();
  }

  /// Carga desde Drift. Llamar desde main.dart después de Firebase.initializeApp().
  Future<void> loadFromCache() async {
    try {
      state = state.copyWith(isLoading: true);
      final db = ref.read(databaseProvider);
      final row =
          await (db.select(db.configuracionLocal)..limit(1)).getSingleOrNull();
      if (row != null) {
        state = AppConfigState(
          plan: row.plan,
          cuentaActiva: row.cuentaActiva,
          fechaVencimientoEpoch: row.fechaVencimientoEpoch,
          appNombre: row.appNombre,
          appSlogan: row.appSlogan,
          logoUrl: row.logoUrl,
          colorPrimario: row.colorPrimario,
          colorSecundario: row.colorSecundario,
          rif: row.rif,
          direccion: row.direccion,
          telefono: row.telefono,
          tasaBcv: row.tasaBcv,
          usarTasaBcv: row.usarTasaBcv,
          tasaManual: row.tasaManual,
          ivaRate: row.ivaRate,
          igtfRate: row.igtfRate,
          timestampUltimaVerificacion: row.timestampUltimaVerificacion,
          isDemoMode: row.isDemoMode,
          demoStartTimestamp: row.demoStartTimestamp,
          isLoading: false,
          isOfflineMode: true,
        );
        _logger.i('📦 Configuración cargada desde cache local');
      } else {
        state = state.copyWith(isLoading: false);
        _logger.w('⚠️ No hay configuración en cache local');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      _logger.e('❌ Error leyendo cache local: $e');
    }
  }

  /// Activa el modo demo y lo persiste en Drift
  Future<void> activarModoDemo(int timestamp) async {
    try {
      final db = ref.read(databaseProvider);
      final existente =
          await (db.select(db.configuracionLocal)..limit(1)).getSingleOrNull();

      if (existente == null) {
        await db.into(db.configuracionLocal).insert(
              ConfiguracionLocalCompanion.insert(
                isDemoMode: const Value(true),
                demoStartTimestamp: Value(timestamp),
                plan: const Value('todos_juguetes'),
                cuentaActiva: const Value(true),
                fechaVencimientoEpoch: const Value(0),
              ),
            );
      } else {
        await (db.update(db.configuracionLocal)
              ..where((t) => t.id.equals(existente.id)))
            .write(
          ConfiguracionLocalCompanion(
            isDemoMode: const Value(true),
            demoStartTimestamp: Value(timestamp),
          ),
        );
      }

      state = state.copyWith(
        isDemoMode: true,
        demoStartTimestamp: timestamp,
      );
      _logger.i('✅ Modo demo activado y persistido en Drift');
    } catch (e) {
      _logger.e('❌ Error activando modo demo: $e');
    }
  }

  /// Desactiva el modo demo tras activación exitosa.
  /// Limpia estado demo + datos sembrados en Drift.
  Future<void> desactivarModoDemo() async {
    try {
      final db = ref.read(databaseProvider);

      // 1. Limpiar datos demo de Drift (productos, clientes, ventas, etc.)
      final seeder = DemoDataSeeder();
      await seeder.limpiarDatosDemo(db);

      // 2. Limpiar flags de demo en Drift
      final existente =
          await (db.select(db.configuracionLocal)..limit(1)).getSingleOrNull();

      if (existente != null) {
        await (db.update(db.configuracionLocal)
              ..where((t) => t.id.equals(existente.id)))
            .write(
          const ConfiguracionLocalCompanion(
            isDemoMode: Value(false),
            demoStartTimestamp: Value(0),
          ),
        );
      }

      // 3. Limpiar timestamp de SharedPreferences
      final demoService = DemoModeService();
      await demoService.finalizarDemo();

      // 4. Actualizar estado en memoria
      state = state.copyWith(
        isDemoMode: false,
        demoStartTimestamp: 0,
      );

      _logger.i('🧹 Modo demo desactivado y datos limpiados');
    } catch (e) {
      _logger.e('❌ Error desactivando modo demo: $e');
    }
  }

  /// Sincroniza desde Firestore del cliente → Drift.
  /// Llamar DESPUÉS de activación/login exitoso.
  Future<void> syncFromRemote() async {
    final clientFb = ref.read(clientFirebaseProvider);
    if (!clientFb.isInitialized) {
      _logger.w('⚠️ ClientFirebase no inicializado, saltando sync remoto');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final doc = await clientFb.firestore
          .collection('configuracion')
          .doc('generales')
          .get();

      if (!doc.exists) {
        _logger.w('⚠️ Documento configuracion/generales no existe en remoto');
        state = state.copyWith(isLoading: false);
        return;
      }

      final data = doc.data()!;
      final now = DateTime.now().millisecondsSinceEpoch;

      final db = ref.read(databaseProvider);
      await db.into(db.configuracionLocal).insertOnConflictUpdate(
            ConfiguracionLocalCompanion.insert(
              plan: Value(state.plan), // plan viene del Maestro, no del cliente
              appNombre: Value(data['app_nombre'] as String? ?? ''),
              appSlogan: Value(data['app_slogan'] as String? ?? ''),
              logoUrl: Value(data['logo_url'] as String?),
              colorPrimario:
                  Value(data['color_primario'] as String? ?? '#1a5c2a'),
              colorSecundario:
                  Value(data['color_secundario'] as String? ?? '#ffd700'),
              rif: Value(data['rif'] as String? ?? ''),
              direccion: Value(data['direccion'] as String? ?? ''),
              telefono: Value(data['telefono'] as String? ?? ''),
              tasaBcv: Value((data['tasa_bcv'] as num?)?.toDouble() ?? 1.0),
              usarTasaBcv: Value(data['usarTasaBCV'] as bool? ?? true),
              tasaManual: Value((data['tasaManual'] as num?)?.toDouble()),
              ivaRate: Value((data['iva_rate'] as num?)?.toDouble() ?? 0.16),
              igtfRate: Value((data['igtf_rate'] as num?)?.toDouble() ?? 0.03),
              timestampUltimaVerificacion: Value(now),
            ),
          );

      state = AppConfigState(
        plan: state.plan,
        cuentaActiva: state.cuentaActiva,
        fechaVencimientoEpoch: state.fechaVencimientoEpoch,
        appNombre: data['app_nombre'] as String? ?? '',
        appSlogan: data['app_slogan'] as String? ?? '',
        logoUrl: data['logo_url'] as String?,
        colorPrimario: data['color_primario'] as String? ?? '#1a5c2a',
        colorSecundario: data['color_secundario'] as String? ?? '#ffd700',
        rif: data['rif'] as String? ?? '',
        direccion: data['direccion'] as String? ?? '',
        telefono: data['telefono'] as String? ?? '',
        tasaBcv: (data['tasa_bcv'] as num?)?.toDouble() ?? 1.0,
        usarTasaBcv: data['usarTasaBCV'] as bool? ?? true,
        tasaManual: (data['tasaManual'] as num?)?.toDouble(),
        ivaRate: (data['iva_rate'] as num?)?.toDouble() ?? 0.16,
        igtfRate: (data['igtf_rate'] as num?)?.toDouble() ?? 0.03,
        timestampUltimaVerificacion: now,
        isLoading: false,
        isOfflineMode: false,
      );

      _logger.i('✅ Configuración sincronizada desde Firestore');
    } catch (e) {
      _logger.e('❌ Error sincronizando configuración: $e');
      state = state.copyWith(
          isLoading: false, error: e.toString(), isOfflineMode: true);
    }
  }

  /// Actualiza el plan desde el Maestro. Llamar durante activación.
  void setPlan(String plan) {
    state = state.copyWith(plan: plan);
  }

  /// Guarda el estado de suscripción traído del Maestro (plan, activa, vencimiento).
  /// Se llama durante la activación y en futuras re-verificaciones periódicas.
  Future<void> updateSubscription({
    required String plan,
    required bool activa,
    required int fechaVencimientoEpoch,
  }) async {
    try {
      final db = ref.read(databaseProvider);

      // Upsert seguro: la tabla es de una sola fila lógica
      final existente =
          await (db.select(db.configuracionLocal)..limit(1)).getSingleOrNull();

      if (existente == null) {
        await db.into(db.configuracionLocal).insert(
              ConfiguracionLocalCompanion.insert(
                plan: Value(plan),
                cuentaActiva: Value(activa),
                fechaVencimientoEpoch: Value(fechaVencimientoEpoch),
              ),
            );
      } else {
        await (db.update(db.configuracionLocal)
              ..where((t) => t.id.equals(existente.id)))
            .write(
          ConfiguracionLocalCompanion(
            plan: Value(plan),
            cuentaActiva: Value(activa),
            fechaVencimientoEpoch: Value(fechaVencimientoEpoch),
          ),
        );
      }

      state = state.copyWith(
        plan: plan,
        cuentaActiva: activa,
        fechaVencimientoEpoch: fechaVencimientoEpoch,
      );
      _logger.i('💾 Suscripción actualizada: plan=$plan activa=$activa');
    } catch (e) {
      _logger.e('❌ Error guardando suscripción: $e');
    }
  }

  /// Actualiza tasa y timestamp (llamado desde SyncScheduler).
  void actualizarTasaYTimestamp(double nuevaTasa, int timestamp) {
    state = state.copyWith(
      tasaBcv: nuevaTasa,
      timestampUltimaVerificacion: timestamp,
      isOfflineMode: false,
    );
  }
}
