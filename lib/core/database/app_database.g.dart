// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ConfiguracionLocalTable extends ConfiguracionLocal
    with TableInfo<$ConfiguracionLocalTable, ConfiguracionLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
      'plan', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cuaderno'));
  static const VerificationMeta _cuentaActivaMeta =
      const VerificationMeta('cuentaActiva');
  @override
  late final GeneratedColumn<bool> cuentaActiva = GeneratedColumn<bool>(
      'cuenta_activa', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("cuenta_activa" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _fechaVencimientoEpochMeta =
      const VerificationMeta('fechaVencimientoEpoch');
  @override
  late final GeneratedColumn<int> fechaVencimientoEpoch = GeneratedColumn<int>(
      'fecha_vencimiento_epoch', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _appNombreMeta =
      const VerificationMeta('appNombre');
  @override
  late final GeneratedColumn<String> appNombre = GeneratedColumn<String>(
      'app_nombre', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _appSloganMeta =
      const VerificationMeta('appSlogan');
  @override
  late final GeneratedColumn<String> appSlogan = GeneratedColumn<String>(
      'app_slogan', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorPrimarioMeta =
      const VerificationMeta('colorPrimario');
  @override
  late final GeneratedColumn<String> colorPrimario = GeneratedColumn<String>(
      'color_primario', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#1a5c2a'));
  static const VerificationMeta _colorSecundarioMeta =
      const VerificationMeta('colorSecundario');
  @override
  late final GeneratedColumn<String> colorSecundario = GeneratedColumn<String>(
      'color_secundario', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#ffd700'));
  static const VerificationMeta _rifMeta = const VerificationMeta('rif');
  @override
  late final GeneratedColumn<String> rif = GeneratedColumn<String>(
      'rif', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _direccionMeta =
      const VerificationMeta('direccion');
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
      'direccion', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _tasaBcvMeta =
      const VerificationMeta('tasaBcv');
  @override
  late final GeneratedColumn<double> tasaBcv = GeneratedColumn<double>(
      'tasa_bcv', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _usarTasaBcvMeta =
      const VerificationMeta('usarTasaBcv');
  @override
  late final GeneratedColumn<bool> usarTasaBcv = GeneratedColumn<bool>(
      'usar_tasa_bcv', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("usar_tasa_bcv" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _tasaManualMeta =
      const VerificationMeta('tasaManual');
  @override
  late final GeneratedColumn<double> tasaManual = GeneratedColumn<double>(
      'tasa_manual', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ivaRateMeta =
      const VerificationMeta('ivaRate');
  @override
  late final GeneratedColumn<double> ivaRate = GeneratedColumn<double>(
      'iva_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.16));
  static const VerificationMeta _igtfRateMeta =
      const VerificationMeta('igtfRate');
  @override
  late final GeneratedColumn<double> igtfRate = GeneratedColumn<double>(
      'igtf_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.03));
  static const VerificationMeta _timestampUltimaVerificacionMeta =
      const VerificationMeta('timestampUltimaVerificacion');
  @override
  late final GeneratedColumn<int> timestampUltimaVerificacion =
      GeneratedColumn<int>('timestamp_ultima_verificacion', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _isDemoModeMeta =
      const VerificationMeta('isDemoMode');
  @override
  late final GeneratedColumn<bool> isDemoMode = GeneratedColumn<bool>(
      'is_demo_mode', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_demo_mode" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _demoStartTimestampMeta =
      const VerificationMeta('demoStartTimestamp');
  @override
  late final GeneratedColumn<int> demoStartTimestamp = GeneratedColumn<int>(
      'demo_start_timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _acceptedLegalMeta =
      const VerificationMeta('acceptedLegal');
  @override
  late final GeneratedColumn<bool> acceptedLegal = GeneratedColumn<bool>(
      'accepted_legal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("accepted_legal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _timestampUltimaVerificacionMaestroMeta =
      const VerificationMeta('timestampUltimaVerificacionMaestro');
  @override
  late final GeneratedColumn<int> timestampUltimaVerificacionMaestro =
      GeneratedColumn<int>(
          'timestamp_ultima_verificacion_maestro', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        plan,
        cuentaActiva,
        fechaVencimientoEpoch,
        appNombre,
        appSlogan,
        logoUrl,
        colorPrimario,
        colorSecundario,
        rif,
        direccion,
        telefono,
        tasaBcv,
        usarTasaBcv,
        tasaManual,
        ivaRate,
        igtfRate,
        timestampUltimaVerificacion,
        isDemoMode,
        demoStartTimestamp,
        acceptedLegal,
        timestampUltimaVerificacionMaestro
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion_local';
  @override
  VerificationContext validateIntegrity(
      Insertable<ConfiguracionLocalData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan')) {
      context.handle(
          _planMeta, plan.isAcceptableOrUnknown(data['plan']!, _planMeta));
    }
    if (data.containsKey('cuenta_activa')) {
      context.handle(
          _cuentaActivaMeta,
          cuentaActiva.isAcceptableOrUnknown(
              data['cuenta_activa']!, _cuentaActivaMeta));
    }
    if (data.containsKey('fecha_vencimiento_epoch')) {
      context.handle(
          _fechaVencimientoEpochMeta,
          fechaVencimientoEpoch.isAcceptableOrUnknown(
              data['fecha_vencimiento_epoch']!, _fechaVencimientoEpochMeta));
    }
    if (data.containsKey('app_nombre')) {
      context.handle(_appNombreMeta,
          appNombre.isAcceptableOrUnknown(data['app_nombre']!, _appNombreMeta));
    }
    if (data.containsKey('app_slogan')) {
      context.handle(_appSloganMeta,
          appSlogan.isAcceptableOrUnknown(data['app_slogan']!, _appSloganMeta));
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('color_primario')) {
      context.handle(
          _colorPrimarioMeta,
          colorPrimario.isAcceptableOrUnknown(
              data['color_primario']!, _colorPrimarioMeta));
    }
    if (data.containsKey('color_secundario')) {
      context.handle(
          _colorSecundarioMeta,
          colorSecundario.isAcceptableOrUnknown(
              data['color_secundario']!, _colorSecundarioMeta));
    }
    if (data.containsKey('rif')) {
      context.handle(
          _rifMeta, rif.isAcceptableOrUnknown(data['rif']!, _rifMeta));
    }
    if (data.containsKey('direccion')) {
      context.handle(_direccionMeta,
          direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta));
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('tasa_bcv')) {
      context.handle(_tasaBcvMeta,
          tasaBcv.isAcceptableOrUnknown(data['tasa_bcv']!, _tasaBcvMeta));
    }
    if (data.containsKey('usar_tasa_bcv')) {
      context.handle(
          _usarTasaBcvMeta,
          usarTasaBcv.isAcceptableOrUnknown(
              data['usar_tasa_bcv']!, _usarTasaBcvMeta));
    }
    if (data.containsKey('tasa_manual')) {
      context.handle(
          _tasaManualMeta,
          tasaManual.isAcceptableOrUnknown(
              data['tasa_manual']!, _tasaManualMeta));
    }
    if (data.containsKey('iva_rate')) {
      context.handle(_ivaRateMeta,
          ivaRate.isAcceptableOrUnknown(data['iva_rate']!, _ivaRateMeta));
    }
    if (data.containsKey('igtf_rate')) {
      context.handle(_igtfRateMeta,
          igtfRate.isAcceptableOrUnknown(data['igtf_rate']!, _igtfRateMeta));
    }
    if (data.containsKey('timestamp_ultima_verificacion')) {
      context.handle(
          _timestampUltimaVerificacionMeta,
          timestampUltimaVerificacion.isAcceptableOrUnknown(
              data['timestamp_ultima_verificacion']!,
              _timestampUltimaVerificacionMeta));
    }
    if (data.containsKey('is_demo_mode')) {
      context.handle(
          _isDemoModeMeta,
          isDemoMode.isAcceptableOrUnknown(
              data['is_demo_mode']!, _isDemoModeMeta));
    }
    if (data.containsKey('demo_start_timestamp')) {
      context.handle(
          _demoStartTimestampMeta,
          demoStartTimestamp.isAcceptableOrUnknown(
              data['demo_start_timestamp']!, _demoStartTimestampMeta));
    }
    if (data.containsKey('accepted_legal')) {
      context.handle(
          _acceptedLegalMeta,
          acceptedLegal.isAcceptableOrUnknown(
              data['accepted_legal']!, _acceptedLegalMeta));
    }
    if (data.containsKey('timestamp_ultima_verificacion_maestro')) {
      context.handle(
          _timestampUltimaVerificacionMaestroMeta,
          timestampUltimaVerificacionMaestro.isAcceptableOrUnknown(
              data['timestamp_ultima_verificacion_maestro']!,
              _timestampUltimaVerificacionMaestroMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracionLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionLocalData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      plan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan'])!,
      cuentaActiva: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cuenta_activa'])!,
      fechaVencimientoEpoch: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_vencimiento_epoch'])!,
      appNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_nombre'])!,
      appSlogan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_slogan'])!,
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      colorPrimario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_primario'])!,
      colorSecundario: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}color_secundario'])!,
      rif: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rif'])!,
      direccion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direccion'])!,
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono'])!,
      tasaBcv: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa_bcv'])!,
      usarTasaBcv: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}usar_tasa_bcv'])!,
      tasaManual: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa_manual']),
      ivaRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}iva_rate'])!,
      igtfRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}igtf_rate'])!,
      timestampUltimaVerificacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}timestamp_ultima_verificacion'])!,
      isDemoMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_demo_mode'])!,
      demoStartTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}demo_start_timestamp'])!,
      acceptedLegal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}accepted_legal'])!,
      timestampUltimaVerificacionMaestro: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}timestamp_ultima_verificacion_maestro'])!,
    );
  }

  @override
  $ConfiguracionLocalTable createAlias(String alias) {
    return $ConfiguracionLocalTable(attachedDatabase, alias);
  }
}

class ConfiguracionLocalData extends DataClass
    implements Insertable<ConfiguracionLocalData> {
  final int id;
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
  final bool isDemoMode;
  final int demoStartTimestamp;
  final bool acceptedLegal;
  final int timestampUltimaVerificacionMaestro;
  const ConfiguracionLocalData(
      {required this.id,
      required this.plan,
      required this.cuentaActiva,
      required this.fechaVencimientoEpoch,
      required this.appNombre,
      required this.appSlogan,
      this.logoUrl,
      required this.colorPrimario,
      required this.colorSecundario,
      required this.rif,
      required this.direccion,
      required this.telefono,
      required this.tasaBcv,
      required this.usarTasaBcv,
      this.tasaManual,
      required this.ivaRate,
      required this.igtfRate,
      required this.timestampUltimaVerificacion,
      required this.isDemoMode,
      required this.demoStartTimestamp,
      required this.acceptedLegal,
      required this.timestampUltimaVerificacionMaestro});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan'] = Variable<String>(plan);
    map['cuenta_activa'] = Variable<bool>(cuentaActiva);
    map['fecha_vencimiento_epoch'] = Variable<int>(fechaVencimientoEpoch);
    map['app_nombre'] = Variable<String>(appNombre);
    map['app_slogan'] = Variable<String>(appSlogan);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    map['color_primario'] = Variable<String>(colorPrimario);
    map['color_secundario'] = Variable<String>(colorSecundario);
    map['rif'] = Variable<String>(rif);
    map['direccion'] = Variable<String>(direccion);
    map['telefono'] = Variable<String>(telefono);
    map['tasa_bcv'] = Variable<double>(tasaBcv);
    map['usar_tasa_bcv'] = Variable<bool>(usarTasaBcv);
    if (!nullToAbsent || tasaManual != null) {
      map['tasa_manual'] = Variable<double>(tasaManual);
    }
    map['iva_rate'] = Variable<double>(ivaRate);
    map['igtf_rate'] = Variable<double>(igtfRate);
    map['timestamp_ultima_verificacion'] =
        Variable<int>(timestampUltimaVerificacion);
    map['is_demo_mode'] = Variable<bool>(isDemoMode);
    map['demo_start_timestamp'] = Variable<int>(demoStartTimestamp);
    map['accepted_legal'] = Variable<bool>(acceptedLegal);
    map['timestamp_ultima_verificacion_maestro'] =
        Variable<int>(timestampUltimaVerificacionMaestro);
    return map;
  }

  ConfiguracionLocalCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionLocalCompanion(
      id: Value(id),
      plan: Value(plan),
      cuentaActiva: Value(cuentaActiva),
      fechaVencimientoEpoch: Value(fechaVencimientoEpoch),
      appNombre: Value(appNombre),
      appSlogan: Value(appSlogan),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      colorPrimario: Value(colorPrimario),
      colorSecundario: Value(colorSecundario),
      rif: Value(rif),
      direccion: Value(direccion),
      telefono: Value(telefono),
      tasaBcv: Value(tasaBcv),
      usarTasaBcv: Value(usarTasaBcv),
      tasaManual: tasaManual == null && nullToAbsent
          ? const Value.absent()
          : Value(tasaManual),
      ivaRate: Value(ivaRate),
      igtfRate: Value(igtfRate),
      timestampUltimaVerificacion: Value(timestampUltimaVerificacion),
      isDemoMode: Value(isDemoMode),
      demoStartTimestamp: Value(demoStartTimestamp),
      acceptedLegal: Value(acceptedLegal),
      timestampUltimaVerificacionMaestro:
          Value(timestampUltimaVerificacionMaestro),
    );
  }

  factory ConfiguracionLocalData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionLocalData(
      id: serializer.fromJson<int>(json['id']),
      plan: serializer.fromJson<String>(json['plan']),
      cuentaActiva: serializer.fromJson<bool>(json['cuentaActiva']),
      fechaVencimientoEpoch:
          serializer.fromJson<int>(json['fechaVencimientoEpoch']),
      appNombre: serializer.fromJson<String>(json['appNombre']),
      appSlogan: serializer.fromJson<String>(json['appSlogan']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      colorPrimario: serializer.fromJson<String>(json['colorPrimario']),
      colorSecundario: serializer.fromJson<String>(json['colorSecundario']),
      rif: serializer.fromJson<String>(json['rif']),
      direccion: serializer.fromJson<String>(json['direccion']),
      telefono: serializer.fromJson<String>(json['telefono']),
      tasaBcv: serializer.fromJson<double>(json['tasaBcv']),
      usarTasaBcv: serializer.fromJson<bool>(json['usarTasaBcv']),
      tasaManual: serializer.fromJson<double?>(json['tasaManual']),
      ivaRate: serializer.fromJson<double>(json['ivaRate']),
      igtfRate: serializer.fromJson<double>(json['igtfRate']),
      timestampUltimaVerificacion:
          serializer.fromJson<int>(json['timestampUltimaVerificacion']),
      isDemoMode: serializer.fromJson<bool>(json['isDemoMode']),
      demoStartTimestamp: serializer.fromJson<int>(json['demoStartTimestamp']),
      acceptedLegal: serializer.fromJson<bool>(json['acceptedLegal']),
      timestampUltimaVerificacionMaestro:
          serializer.fromJson<int>(json['timestampUltimaVerificacionMaestro']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plan': serializer.toJson<String>(plan),
      'cuentaActiva': serializer.toJson<bool>(cuentaActiva),
      'fechaVencimientoEpoch': serializer.toJson<int>(fechaVencimientoEpoch),
      'appNombre': serializer.toJson<String>(appNombre),
      'appSlogan': serializer.toJson<String>(appSlogan),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'colorPrimario': serializer.toJson<String>(colorPrimario),
      'colorSecundario': serializer.toJson<String>(colorSecundario),
      'rif': serializer.toJson<String>(rif),
      'direccion': serializer.toJson<String>(direccion),
      'telefono': serializer.toJson<String>(telefono),
      'tasaBcv': serializer.toJson<double>(tasaBcv),
      'usarTasaBcv': serializer.toJson<bool>(usarTasaBcv),
      'tasaManual': serializer.toJson<double?>(tasaManual),
      'ivaRate': serializer.toJson<double>(ivaRate),
      'igtfRate': serializer.toJson<double>(igtfRate),
      'timestampUltimaVerificacion':
          serializer.toJson<int>(timestampUltimaVerificacion),
      'isDemoMode': serializer.toJson<bool>(isDemoMode),
      'demoStartTimestamp': serializer.toJson<int>(demoStartTimestamp),
      'acceptedLegal': serializer.toJson<bool>(acceptedLegal),
      'timestampUltimaVerificacionMaestro':
          serializer.toJson<int>(timestampUltimaVerificacionMaestro),
    };
  }

  ConfiguracionLocalData copyWith(
          {int? id,
          String? plan,
          bool? cuentaActiva,
          int? fechaVencimientoEpoch,
          String? appNombre,
          String? appSlogan,
          Value<String?> logoUrl = const Value.absent(),
          String? colorPrimario,
          String? colorSecundario,
          String? rif,
          String? direccion,
          String? telefono,
          double? tasaBcv,
          bool? usarTasaBcv,
          Value<double?> tasaManual = const Value.absent(),
          double? ivaRate,
          double? igtfRate,
          int? timestampUltimaVerificacion,
          bool? isDemoMode,
          int? demoStartTimestamp,
          bool? acceptedLegal,
          int? timestampUltimaVerificacionMaestro}) =>
      ConfiguracionLocalData(
        id: id ?? this.id,
        plan: plan ?? this.plan,
        cuentaActiva: cuentaActiva ?? this.cuentaActiva,
        fechaVencimientoEpoch:
            fechaVencimientoEpoch ?? this.fechaVencimientoEpoch,
        appNombre: appNombre ?? this.appNombre,
        appSlogan: appSlogan ?? this.appSlogan,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        colorPrimario: colorPrimario ?? this.colorPrimario,
        colorSecundario: colorSecundario ?? this.colorSecundario,
        rif: rif ?? this.rif,
        direccion: direccion ?? this.direccion,
        telefono: telefono ?? this.telefono,
        tasaBcv: tasaBcv ?? this.tasaBcv,
        usarTasaBcv: usarTasaBcv ?? this.usarTasaBcv,
        tasaManual: tasaManual.present ? tasaManual.value : this.tasaManual,
        ivaRate: ivaRate ?? this.ivaRate,
        igtfRate: igtfRate ?? this.igtfRate,
        timestampUltimaVerificacion:
            timestampUltimaVerificacion ?? this.timestampUltimaVerificacion,
        isDemoMode: isDemoMode ?? this.isDemoMode,
        demoStartTimestamp: demoStartTimestamp ?? this.demoStartTimestamp,
        acceptedLegal: acceptedLegal ?? this.acceptedLegal,
        timestampUltimaVerificacionMaestro:
            timestampUltimaVerificacionMaestro ??
                this.timestampUltimaVerificacionMaestro,
      );
  ConfiguracionLocalData copyWithCompanion(ConfiguracionLocalCompanion data) {
    return ConfiguracionLocalData(
      id: data.id.present ? data.id.value : this.id,
      plan: data.plan.present ? data.plan.value : this.plan,
      cuentaActiva: data.cuentaActiva.present
          ? data.cuentaActiva.value
          : this.cuentaActiva,
      fechaVencimientoEpoch: data.fechaVencimientoEpoch.present
          ? data.fechaVencimientoEpoch.value
          : this.fechaVencimientoEpoch,
      appNombre: data.appNombre.present ? data.appNombre.value : this.appNombre,
      appSlogan: data.appSlogan.present ? data.appSlogan.value : this.appSlogan,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      colorPrimario: data.colorPrimario.present
          ? data.colorPrimario.value
          : this.colorPrimario,
      colorSecundario: data.colorSecundario.present
          ? data.colorSecundario.value
          : this.colorSecundario,
      rif: data.rif.present ? data.rif.value : this.rif,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      tasaBcv: data.tasaBcv.present ? data.tasaBcv.value : this.tasaBcv,
      usarTasaBcv:
          data.usarTasaBcv.present ? data.usarTasaBcv.value : this.usarTasaBcv,
      tasaManual:
          data.tasaManual.present ? data.tasaManual.value : this.tasaManual,
      ivaRate: data.ivaRate.present ? data.ivaRate.value : this.ivaRate,
      igtfRate: data.igtfRate.present ? data.igtfRate.value : this.igtfRate,
      timestampUltimaVerificacion: data.timestampUltimaVerificacion.present
          ? data.timestampUltimaVerificacion.value
          : this.timestampUltimaVerificacion,
      isDemoMode:
          data.isDemoMode.present ? data.isDemoMode.value : this.isDemoMode,
      demoStartTimestamp: data.demoStartTimestamp.present
          ? data.demoStartTimestamp.value
          : this.demoStartTimestamp,
      acceptedLegal: data.acceptedLegal.present
          ? data.acceptedLegal.value
          : this.acceptedLegal,
      timestampUltimaVerificacionMaestro:
          data.timestampUltimaVerificacionMaestro.present
              ? data.timestampUltimaVerificacionMaestro.value
              : this.timestampUltimaVerificacionMaestro,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionLocalData(')
          ..write('id: $id, ')
          ..write('plan: $plan, ')
          ..write('cuentaActiva: $cuentaActiva, ')
          ..write('fechaVencimientoEpoch: $fechaVencimientoEpoch, ')
          ..write('appNombre: $appNombre, ')
          ..write('appSlogan: $appSlogan, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('colorPrimario: $colorPrimario, ')
          ..write('colorSecundario: $colorSecundario, ')
          ..write('rif: $rif, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('tasaBcv: $tasaBcv, ')
          ..write('usarTasaBcv: $usarTasaBcv, ')
          ..write('tasaManual: $tasaManual, ')
          ..write('ivaRate: $ivaRate, ')
          ..write('igtfRate: $igtfRate, ')
          ..write('timestampUltimaVerificacion: $timestampUltimaVerificacion, ')
          ..write('isDemoMode: $isDemoMode, ')
          ..write('demoStartTimestamp: $demoStartTimestamp, ')
          ..write('acceptedLegal: $acceptedLegal, ')
          ..write(
              'timestampUltimaVerificacionMaestro: $timestampUltimaVerificacionMaestro')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        plan,
        cuentaActiva,
        fechaVencimientoEpoch,
        appNombre,
        appSlogan,
        logoUrl,
        colorPrimario,
        colorSecundario,
        rif,
        direccion,
        telefono,
        tasaBcv,
        usarTasaBcv,
        tasaManual,
        ivaRate,
        igtfRate,
        timestampUltimaVerificacion,
        isDemoMode,
        demoStartTimestamp,
        acceptedLegal,
        timestampUltimaVerificacionMaestro
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionLocalData &&
          other.id == this.id &&
          other.plan == this.plan &&
          other.cuentaActiva == this.cuentaActiva &&
          other.fechaVencimientoEpoch == this.fechaVencimientoEpoch &&
          other.appNombre == this.appNombre &&
          other.appSlogan == this.appSlogan &&
          other.logoUrl == this.logoUrl &&
          other.colorPrimario == this.colorPrimario &&
          other.colorSecundario == this.colorSecundario &&
          other.rif == this.rif &&
          other.direccion == this.direccion &&
          other.telefono == this.telefono &&
          other.tasaBcv == this.tasaBcv &&
          other.usarTasaBcv == this.usarTasaBcv &&
          other.tasaManual == this.tasaManual &&
          other.ivaRate == this.ivaRate &&
          other.igtfRate == this.igtfRate &&
          other.timestampUltimaVerificacion ==
              this.timestampUltimaVerificacion &&
          other.isDemoMode == this.isDemoMode &&
          other.demoStartTimestamp == this.demoStartTimestamp &&
          other.acceptedLegal == this.acceptedLegal &&
          other.timestampUltimaVerificacionMaestro ==
              this.timestampUltimaVerificacionMaestro);
}

class ConfiguracionLocalCompanion
    extends UpdateCompanion<ConfiguracionLocalData> {
  final Value<int> id;
  final Value<String> plan;
  final Value<bool> cuentaActiva;
  final Value<int> fechaVencimientoEpoch;
  final Value<String> appNombre;
  final Value<String> appSlogan;
  final Value<String?> logoUrl;
  final Value<String> colorPrimario;
  final Value<String> colorSecundario;
  final Value<String> rif;
  final Value<String> direccion;
  final Value<String> telefono;
  final Value<double> tasaBcv;
  final Value<bool> usarTasaBcv;
  final Value<double?> tasaManual;
  final Value<double> ivaRate;
  final Value<double> igtfRate;
  final Value<int> timestampUltimaVerificacion;
  final Value<bool> isDemoMode;
  final Value<int> demoStartTimestamp;
  final Value<bool> acceptedLegal;
  final Value<int> timestampUltimaVerificacionMaestro;
  const ConfiguracionLocalCompanion({
    this.id = const Value.absent(),
    this.plan = const Value.absent(),
    this.cuentaActiva = const Value.absent(),
    this.fechaVencimientoEpoch = const Value.absent(),
    this.appNombre = const Value.absent(),
    this.appSlogan = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.colorPrimario = const Value.absent(),
    this.colorSecundario = const Value.absent(),
    this.rif = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
    this.tasaBcv = const Value.absent(),
    this.usarTasaBcv = const Value.absent(),
    this.tasaManual = const Value.absent(),
    this.ivaRate = const Value.absent(),
    this.igtfRate = const Value.absent(),
    this.timestampUltimaVerificacion = const Value.absent(),
    this.isDemoMode = const Value.absent(),
    this.demoStartTimestamp = const Value.absent(),
    this.acceptedLegal = const Value.absent(),
    this.timestampUltimaVerificacionMaestro = const Value.absent(),
  });
  ConfiguracionLocalCompanion.insert({
    this.id = const Value.absent(),
    this.plan = const Value.absent(),
    this.cuentaActiva = const Value.absent(),
    this.fechaVencimientoEpoch = const Value.absent(),
    this.appNombre = const Value.absent(),
    this.appSlogan = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.colorPrimario = const Value.absent(),
    this.colorSecundario = const Value.absent(),
    this.rif = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
    this.tasaBcv = const Value.absent(),
    this.usarTasaBcv = const Value.absent(),
    this.tasaManual = const Value.absent(),
    this.ivaRate = const Value.absent(),
    this.igtfRate = const Value.absent(),
    this.timestampUltimaVerificacion = const Value.absent(),
    this.isDemoMode = const Value.absent(),
    this.demoStartTimestamp = const Value.absent(),
    this.acceptedLegal = const Value.absent(),
    this.timestampUltimaVerificacionMaestro = const Value.absent(),
  });
  static Insertable<ConfiguracionLocalData> custom({
    Expression<int>? id,
    Expression<String>? plan,
    Expression<bool>? cuentaActiva,
    Expression<int>? fechaVencimientoEpoch,
    Expression<String>? appNombre,
    Expression<String>? appSlogan,
    Expression<String>? logoUrl,
    Expression<String>? colorPrimario,
    Expression<String>? colorSecundario,
    Expression<String>? rif,
    Expression<String>? direccion,
    Expression<String>? telefono,
    Expression<double>? tasaBcv,
    Expression<bool>? usarTasaBcv,
    Expression<double>? tasaManual,
    Expression<double>? ivaRate,
    Expression<double>? igtfRate,
    Expression<int>? timestampUltimaVerificacion,
    Expression<bool>? isDemoMode,
    Expression<int>? demoStartTimestamp,
    Expression<bool>? acceptedLegal,
    Expression<int>? timestampUltimaVerificacionMaestro,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plan != null) 'plan': plan,
      if (cuentaActiva != null) 'cuenta_activa': cuentaActiva,
      if (fechaVencimientoEpoch != null)
        'fecha_vencimiento_epoch': fechaVencimientoEpoch,
      if (appNombre != null) 'app_nombre': appNombre,
      if (appSlogan != null) 'app_slogan': appSlogan,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (colorPrimario != null) 'color_primario': colorPrimario,
      if (colorSecundario != null) 'color_secundario': colorSecundario,
      if (rif != null) 'rif': rif,
      if (direccion != null) 'direccion': direccion,
      if (telefono != null) 'telefono': telefono,
      if (tasaBcv != null) 'tasa_bcv': tasaBcv,
      if (usarTasaBcv != null) 'usar_tasa_bcv': usarTasaBcv,
      if (tasaManual != null) 'tasa_manual': tasaManual,
      if (ivaRate != null) 'iva_rate': ivaRate,
      if (igtfRate != null) 'igtf_rate': igtfRate,
      if (timestampUltimaVerificacion != null)
        'timestamp_ultima_verificacion': timestampUltimaVerificacion,
      if (isDemoMode != null) 'is_demo_mode': isDemoMode,
      if (demoStartTimestamp != null)
        'demo_start_timestamp': demoStartTimestamp,
      if (acceptedLegal != null) 'accepted_legal': acceptedLegal,
      if (timestampUltimaVerificacionMaestro != null)
        'timestamp_ultima_verificacion_maestro':
            timestampUltimaVerificacionMaestro,
    });
  }

  ConfiguracionLocalCompanion copyWith(
      {Value<int>? id,
      Value<String>? plan,
      Value<bool>? cuentaActiva,
      Value<int>? fechaVencimientoEpoch,
      Value<String>? appNombre,
      Value<String>? appSlogan,
      Value<String?>? logoUrl,
      Value<String>? colorPrimario,
      Value<String>? colorSecundario,
      Value<String>? rif,
      Value<String>? direccion,
      Value<String>? telefono,
      Value<double>? tasaBcv,
      Value<bool>? usarTasaBcv,
      Value<double?>? tasaManual,
      Value<double>? ivaRate,
      Value<double>? igtfRate,
      Value<int>? timestampUltimaVerificacion,
      Value<bool>? isDemoMode,
      Value<int>? demoStartTimestamp,
      Value<bool>? acceptedLegal,
      Value<int>? timestampUltimaVerificacionMaestro}) {
    return ConfiguracionLocalCompanion(
      id: id ?? this.id,
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
      isDemoMode: isDemoMode ?? this.isDemoMode,
      demoStartTimestamp: demoStartTimestamp ?? this.demoStartTimestamp,
      acceptedLegal: acceptedLegal ?? this.acceptedLegal,
      timestampUltimaVerificacionMaestro: timestampUltimaVerificacionMaestro ??
          this.timestampUltimaVerificacionMaestro,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (cuentaActiva.present) {
      map['cuenta_activa'] = Variable<bool>(cuentaActiva.value);
    }
    if (fechaVencimientoEpoch.present) {
      map['fecha_vencimiento_epoch'] =
          Variable<int>(fechaVencimientoEpoch.value);
    }
    if (appNombre.present) {
      map['app_nombre'] = Variable<String>(appNombre.value);
    }
    if (appSlogan.present) {
      map['app_slogan'] = Variable<String>(appSlogan.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (colorPrimario.present) {
      map['color_primario'] = Variable<String>(colorPrimario.value);
    }
    if (colorSecundario.present) {
      map['color_secundario'] = Variable<String>(colorSecundario.value);
    }
    if (rif.present) {
      map['rif'] = Variable<String>(rif.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (tasaBcv.present) {
      map['tasa_bcv'] = Variable<double>(tasaBcv.value);
    }
    if (usarTasaBcv.present) {
      map['usar_tasa_bcv'] = Variable<bool>(usarTasaBcv.value);
    }
    if (tasaManual.present) {
      map['tasa_manual'] = Variable<double>(tasaManual.value);
    }
    if (ivaRate.present) {
      map['iva_rate'] = Variable<double>(ivaRate.value);
    }
    if (igtfRate.present) {
      map['igtf_rate'] = Variable<double>(igtfRate.value);
    }
    if (timestampUltimaVerificacion.present) {
      map['timestamp_ultima_verificacion'] =
          Variable<int>(timestampUltimaVerificacion.value);
    }
    if (isDemoMode.present) {
      map['is_demo_mode'] = Variable<bool>(isDemoMode.value);
    }
    if (demoStartTimestamp.present) {
      map['demo_start_timestamp'] = Variable<int>(demoStartTimestamp.value);
    }
    if (acceptedLegal.present) {
      map['accepted_legal'] = Variable<bool>(acceptedLegal.value);
    }
    if (timestampUltimaVerificacionMaestro.present) {
      map['timestamp_ultima_verificacion_maestro'] =
          Variable<int>(timestampUltimaVerificacionMaestro.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionLocalCompanion(')
          ..write('id: $id, ')
          ..write('plan: $plan, ')
          ..write('cuentaActiva: $cuentaActiva, ')
          ..write('fechaVencimientoEpoch: $fechaVencimientoEpoch, ')
          ..write('appNombre: $appNombre, ')
          ..write('appSlogan: $appSlogan, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('colorPrimario: $colorPrimario, ')
          ..write('colorSecundario: $colorSecundario, ')
          ..write('rif: $rif, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('tasaBcv: $tasaBcv, ')
          ..write('usarTasaBcv: $usarTasaBcv, ')
          ..write('tasaManual: $tasaManual, ')
          ..write('ivaRate: $ivaRate, ')
          ..write('igtfRate: $igtfRate, ')
          ..write('timestampUltimaVerificacion: $timestampUltimaVerificacion, ')
          ..write('isDemoMode: $isDemoMode, ')
          ..write('demoStartTimestamp: $demoStartTimestamp, ')
          ..write('acceptedLegal: $acceptedLegal, ')
          ..write(
              'timestampUltimaVerificacionMaestro: $timestampUltimaVerificacionMaestro')
          ..write(')'))
        .toString();
  }
}

class $HistorialTasaTable extends HistorialTasa
    with TableInfo<$HistorialTasaTable, HistorialTasaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistorialTasaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tasaMeta = const VerificationMeta('tasa');
  @override
  late final GeneratedColumn<double> tasa = GeneratedColumn<double>(
      'tasa', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fuenteMeta = const VerificationMeta('fuente');
  @override
  late final GeneratedColumn<String> fuente = GeneratedColumn<String>(
      'fuente', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('manual'));
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, tasa, fuente, fecha];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historial_tasa';
  @override
  VerificationContext validateIntegrity(Insertable<HistorialTasaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tasa')) {
      context.handle(
          _tasaMeta, tasa.isAcceptableOrUnknown(data['tasa']!, _tasaMeta));
    } else if (isInserting) {
      context.missing(_tasaMeta);
    }
    if (data.containsKey('fuente')) {
      context.handle(_fuenteMeta,
          fuente.isAcceptableOrUnknown(data['fuente']!, _fuenteMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistorialTasaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistorialTasaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tasa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa'])!,
      fuente: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fuente'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
    );
  }

  @override
  $HistorialTasaTable createAlias(String alias) {
    return $HistorialTasaTable(attachedDatabase, alias);
  }
}

class HistorialTasaData extends DataClass
    implements Insertable<HistorialTasaData> {
  final int id;
  final double tasa;
  final String fuente;
  final DateTime fecha;
  const HistorialTasaData(
      {required this.id,
      required this.tasa,
      required this.fuente,
      required this.fecha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tasa'] = Variable<double>(tasa);
    map['fuente'] = Variable<String>(fuente);
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  HistorialTasaCompanion toCompanion(bool nullToAbsent) {
    return HistorialTasaCompanion(
      id: Value(id),
      tasa: Value(tasa),
      fuente: Value(fuente),
      fecha: Value(fecha),
    );
  }

  factory HistorialTasaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistorialTasaData(
      id: serializer.fromJson<int>(json['id']),
      tasa: serializer.fromJson<double>(json['tasa']),
      fuente: serializer.fromJson<String>(json['fuente']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tasa': serializer.toJson<double>(tasa),
      'fuente': serializer.toJson<String>(fuente),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  HistorialTasaData copyWith(
          {int? id, double? tasa, String? fuente, DateTime? fecha}) =>
      HistorialTasaData(
        id: id ?? this.id,
        tasa: tasa ?? this.tasa,
        fuente: fuente ?? this.fuente,
        fecha: fecha ?? this.fecha,
      );
  HistorialTasaData copyWithCompanion(HistorialTasaCompanion data) {
    return HistorialTasaData(
      id: data.id.present ? data.id.value : this.id,
      tasa: data.tasa.present ? data.tasa.value : this.tasa,
      fuente: data.fuente.present ? data.fuente.value : this.fuente,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistorialTasaData(')
          ..write('id: $id, ')
          ..write('tasa: $tasa, ')
          ..write('fuente: $fuente, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tasa, fuente, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistorialTasaData &&
          other.id == this.id &&
          other.tasa == this.tasa &&
          other.fuente == this.fuente &&
          other.fecha == this.fecha);
}

class HistorialTasaCompanion extends UpdateCompanion<HistorialTasaData> {
  final Value<int> id;
  final Value<double> tasa;
  final Value<String> fuente;
  final Value<DateTime> fecha;
  const HistorialTasaCompanion({
    this.id = const Value.absent(),
    this.tasa = const Value.absent(),
    this.fuente = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  HistorialTasaCompanion.insert({
    this.id = const Value.absent(),
    required double tasa,
    this.fuente = const Value.absent(),
    this.fecha = const Value.absent(),
  }) : tasa = Value(tasa);
  static Insertable<HistorialTasaData> custom({
    Expression<int>? id,
    Expression<double>? tasa,
    Expression<String>? fuente,
    Expression<DateTime>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tasa != null) 'tasa': tasa,
      if (fuente != null) 'fuente': fuente,
      if (fecha != null) 'fecha': fecha,
    });
  }

  HistorialTasaCompanion copyWith(
      {Value<int>? id,
      Value<double>? tasa,
      Value<String>? fuente,
      Value<DateTime>? fecha}) {
    return HistorialTasaCompanion(
      id: id ?? this.id,
      tasa: tasa ?? this.tasa,
      fuente: fuente ?? this.fuente,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tasa.present) {
      map['tasa'] = Variable<double>(tasa.value);
    }
    if (fuente.present) {
      map['fuente'] = Variable<String>(fuente.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistorialTasaCompanion(')
          ..write('id: $id, ')
          ..write('tasa: $tasa, ')
          ..write('fuente: $fuente, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $ProductoTable extends Producto
    with TableInfo<$ProductoTable, ProductoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoriaMeta =
      const VerificationMeta('categoria');
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
      'categoria', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _proveedorUuidMeta =
      const VerificationMeta('proveedorUuid');
  @override
  late final GeneratedColumn<String> proveedorUuid = GeneratedColumn<String>(
      'proveedor_uuid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _precioUsdMeta =
      const VerificationMeta('precioUsd');
  @override
  late final GeneratedColumn<double> precioUsd = GeneratedColumn<double>(
      'precio_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costoUsdMeta =
      const VerificationMeta('costoUsd');
  @override
  late final GeneratedColumn<double> costoUsd = GeneratedColumn<double>(
      'costo_usd', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _precioMayorMeta =
      const VerificationMeta('precioMayor');
  @override
  late final GeneratedColumn<double> precioMayor = GeneratedColumn<double>(
      'precio_mayor', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<double> stock = GeneratedColumn<double>(
      'stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _exentoIvaMeta =
      const VerificationMeta('exentoIva');
  @override
  late final GeneratedColumn<bool> exentoIva = GeneratedColumn<bool>(
      'exento_iva', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("exento_iva" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _esGranelMeta =
      const VerificationMeta('esGranel');
  @override
  late final GeneratedColumn<bool> esGranel = GeneratedColumn<bool>(
      'es_granel', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("es_granel" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _unidadMedidaMeta =
      const VerificationMeta('unidadMedida');
  @override
  late final GeneratedColumn<String> unidadMedida = GeneratedColumn<String>(
      'unidad_medida', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaVencimientoMeta =
      const VerificationMeta('fechaVencimiento');
  @override
  late final GeneratedColumn<int> fechaVencimiento = GeneratedColumn<int>(
      'fecha_vencimiento', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _stockMinimoMeta =
      const VerificationMeta('stockMinimo');
  @override
  late final GeneratedColumn<int> stockMinimo = GeneratedColumn<int>(
      'stock_minimo', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        nombre,
        codigo,
        categoria,
        proveedorUuid,
        precioUsd,
        costoUsd,
        precioMayor,
        stock,
        exentoIva,
        esGranel,
        unidadMedida,
        fechaVencimiento,
        stockMinimo,
        activo,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'producto';
  @override
  VerificationContext validateIntegrity(Insertable<ProductoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    }
    if (data.containsKey('categoria')) {
      context.handle(_categoriaMeta,
          categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta));
    }
    if (data.containsKey('proveedor_uuid')) {
      context.handle(
          _proveedorUuidMeta,
          proveedorUuid.isAcceptableOrUnknown(
              data['proveedor_uuid']!, _proveedorUuidMeta));
    }
    if (data.containsKey('precio_usd')) {
      context.handle(_precioUsdMeta,
          precioUsd.isAcceptableOrUnknown(data['precio_usd']!, _precioUsdMeta));
    } else if (isInserting) {
      context.missing(_precioUsdMeta);
    }
    if (data.containsKey('costo_usd')) {
      context.handle(_costoUsdMeta,
          costoUsd.isAcceptableOrUnknown(data['costo_usd']!, _costoUsdMeta));
    }
    if (data.containsKey('precio_mayor')) {
      context.handle(
          _precioMayorMeta,
          precioMayor.isAcceptableOrUnknown(
              data['precio_mayor']!, _precioMayorMeta));
    }
    if (data.containsKey('stock')) {
      context.handle(
          _stockMeta, stock.isAcceptableOrUnknown(data['stock']!, _stockMeta));
    }
    if (data.containsKey('exento_iva')) {
      context.handle(_exentoIvaMeta,
          exentoIva.isAcceptableOrUnknown(data['exento_iva']!, _exentoIvaMeta));
    }
    if (data.containsKey('es_granel')) {
      context.handle(_esGranelMeta,
          esGranel.isAcceptableOrUnknown(data['es_granel']!, _esGranelMeta));
    }
    if (data.containsKey('unidad_medida')) {
      context.handle(
          _unidadMedidaMeta,
          unidadMedida.isAcceptableOrUnknown(
              data['unidad_medida']!, _unidadMedidaMeta));
    }
    if (data.containsKey('fecha_vencimiento')) {
      context.handle(
          _fechaVencimientoMeta,
          fechaVencimiento.isAcceptableOrUnknown(
              data['fecha_vencimiento']!, _fechaVencimientoMeta));
    }
    if (data.containsKey('stock_minimo')) {
      context.handle(
          _stockMinimoMeta,
          stockMinimo.isAcceptableOrUnknown(
              data['stock_minimo']!, _stockMinimoMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo']),
      categoria: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria']),
      proveedorUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}proveedor_uuid']),
      precioUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio_usd'])!,
      costoUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}costo_usd'])!,
      precioMayor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio_mayor']),
      stock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock'])!,
      exentoIva: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}exento_iva'])!,
      esGranel: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}es_granel'])!,
      unidadMedida: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidad_medida']),
      fechaVencimiento: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_vencimiento']),
      stockMinimo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_minimo'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $ProductoTable createAlias(String alias) {
    return $ProductoTable(attachedDatabase, alias);
  }
}

class ProductoData extends DataClass implements Insertable<ProductoData> {
  final int id;

  /// UUID para sincronización con Firestore.
  final String uuid;
  final String nombre;

  /// Código de barras o código interno. Nullable.
  final String? codigo;
  final String? categoria;

  /// UUID del proveedor habitual (enlace para reposición/alertas). Nullable.
  final String? proveedorUuid;

  /// Precio en USD (precio FINAL, tax inclusive según Decisiones.md).
  final double precioUsd;

  /// Costo de reposición en USD (para calcular ganancias).
  final double costoUsd;

  /// Precio por mayor (opcional, Plan Cuaderno y Calculadora+).
  final double? precioMayor;

  /// Stock en double para soportar granel (15.5 kg).
  final double stock;

  /// Producto exento de IVA (alimentos de cesta básica).
  final bool exentoIva;

  /// Si es producto a granel (queso, carne, etc.).
  final bool esGranel;

  /// Unidad de medida si es granel: kg, g, lb.
  final String? unidadMedida;

  /// Fecha de vencimiento como epoch ms. Nullable.
  final int? fechaVencimiento;

  /// Stock mínimo para alertas.
  final int stockMinimo;

  /// Soft delete: si es false, no aparece en POS pero se conserva el historial.
  final bool activo;

  /// Epoch de creación.
  final int fechaCreacion;

  /// Epoch de última actualización (para sync con Firestore).
  final int fechaActualizacion;
  const ProductoData(
      {required this.id,
      required this.uuid,
      required this.nombre,
      this.codigo,
      this.categoria,
      this.proveedorUuid,
      required this.precioUsd,
      required this.costoUsd,
      this.precioMayor,
      required this.stock,
      required this.exentoIva,
      required this.esGranel,
      this.unidadMedida,
      this.fechaVencimiento,
      required this.stockMinimo,
      required this.activo,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    if (!nullToAbsent || proveedorUuid != null) {
      map['proveedor_uuid'] = Variable<String>(proveedorUuid);
    }
    map['precio_usd'] = Variable<double>(precioUsd);
    map['costo_usd'] = Variable<double>(costoUsd);
    if (!nullToAbsent || precioMayor != null) {
      map['precio_mayor'] = Variable<double>(precioMayor);
    }
    map['stock'] = Variable<double>(stock);
    map['exento_iva'] = Variable<bool>(exentoIva);
    map['es_granel'] = Variable<bool>(esGranel);
    if (!nullToAbsent || unidadMedida != null) {
      map['unidad_medida'] = Variable<String>(unidadMedida);
    }
    if (!nullToAbsent || fechaVencimiento != null) {
      map['fecha_vencimiento'] = Variable<int>(fechaVencimiento);
    }
    map['stock_minimo'] = Variable<int>(stockMinimo);
    map['activo'] = Variable<bool>(activo);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  ProductoCompanion toCompanion(bool nullToAbsent) {
    return ProductoCompanion(
      id: Value(id),
      uuid: Value(uuid),
      nombre: Value(nombre),
      codigo:
          codigo == null && nullToAbsent ? const Value.absent() : Value(codigo),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      proveedorUuid: proveedorUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorUuid),
      precioUsd: Value(precioUsd),
      costoUsd: Value(costoUsd),
      precioMayor: precioMayor == null && nullToAbsent
          ? const Value.absent()
          : Value(precioMayor),
      stock: Value(stock),
      exentoIva: Value(exentoIva),
      esGranel: Value(esGranel),
      unidadMedida: unidadMedida == null && nullToAbsent
          ? const Value.absent()
          : Value(unidadMedida),
      fechaVencimiento: fechaVencimiento == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaVencimiento),
      stockMinimo: Value(stockMinimo),
      activo: Value(activo),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory ProductoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductoData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      proveedorUuid: serializer.fromJson<String?>(json['proveedorUuid']),
      precioUsd: serializer.fromJson<double>(json['precioUsd']),
      costoUsd: serializer.fromJson<double>(json['costoUsd']),
      precioMayor: serializer.fromJson<double?>(json['precioMayor']),
      stock: serializer.fromJson<double>(json['stock']),
      exentoIva: serializer.fromJson<bool>(json['exentoIva']),
      esGranel: serializer.fromJson<bool>(json['esGranel']),
      unidadMedida: serializer.fromJson<String?>(json['unidadMedida']),
      fechaVencimiento: serializer.fromJson<int?>(json['fechaVencimiento']),
      stockMinimo: serializer.fromJson<int>(json['stockMinimo']),
      activo: serializer.fromJson<bool>(json['activo']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String?>(codigo),
      'categoria': serializer.toJson<String?>(categoria),
      'proveedorUuid': serializer.toJson<String?>(proveedorUuid),
      'precioUsd': serializer.toJson<double>(precioUsd),
      'costoUsd': serializer.toJson<double>(costoUsd),
      'precioMayor': serializer.toJson<double?>(precioMayor),
      'stock': serializer.toJson<double>(stock),
      'exentoIva': serializer.toJson<bool>(exentoIva),
      'esGranel': serializer.toJson<bool>(esGranel),
      'unidadMedida': serializer.toJson<String?>(unidadMedida),
      'fechaVencimiento': serializer.toJson<int?>(fechaVencimiento),
      'stockMinimo': serializer.toJson<int>(stockMinimo),
      'activo': serializer.toJson<bool>(activo),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  ProductoData copyWith(
          {int? id,
          String? uuid,
          String? nombre,
          Value<String?> codigo = const Value.absent(),
          Value<String?> categoria = const Value.absent(),
          Value<String?> proveedorUuid = const Value.absent(),
          double? precioUsd,
          double? costoUsd,
          Value<double?> precioMayor = const Value.absent(),
          double? stock,
          bool? exentoIva,
          bool? esGranel,
          Value<String?> unidadMedida = const Value.absent(),
          Value<int?> fechaVencimiento = const Value.absent(),
          int? stockMinimo,
          bool? activo,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      ProductoData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        nombre: nombre ?? this.nombre,
        codigo: codigo.present ? codigo.value : this.codigo,
        categoria: categoria.present ? categoria.value : this.categoria,
        proveedorUuid:
            proveedorUuid.present ? proveedorUuid.value : this.proveedorUuid,
        precioUsd: precioUsd ?? this.precioUsd,
        costoUsd: costoUsd ?? this.costoUsd,
        precioMayor: precioMayor.present ? precioMayor.value : this.precioMayor,
        stock: stock ?? this.stock,
        exentoIva: exentoIva ?? this.exentoIva,
        esGranel: esGranel ?? this.esGranel,
        unidadMedida:
            unidadMedida.present ? unidadMedida.value : this.unidadMedida,
        fechaVencimiento: fechaVencimiento.present
            ? fechaVencimiento.value
            : this.fechaVencimiento,
        stockMinimo: stockMinimo ?? this.stockMinimo,
        activo: activo ?? this.activo,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  ProductoData copyWithCompanion(ProductoCompanion data) {
    return ProductoData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      proveedorUuid: data.proveedorUuid.present
          ? data.proveedorUuid.value
          : this.proveedorUuid,
      precioUsd: data.precioUsd.present ? data.precioUsd.value : this.precioUsd,
      costoUsd: data.costoUsd.present ? data.costoUsd.value : this.costoUsd,
      precioMayor:
          data.precioMayor.present ? data.precioMayor.value : this.precioMayor,
      stock: data.stock.present ? data.stock.value : this.stock,
      exentoIva: data.exentoIva.present ? data.exentoIva.value : this.exentoIva,
      esGranel: data.esGranel.present ? data.esGranel.value : this.esGranel,
      unidadMedida: data.unidadMedida.present
          ? data.unidadMedida.value
          : this.unidadMedida,
      fechaVencimiento: data.fechaVencimiento.present
          ? data.fechaVencimiento.value
          : this.fechaVencimiento,
      stockMinimo:
          data.stockMinimo.present ? data.stockMinimo.value : this.stockMinimo,
      activo: data.activo.present ? data.activo.value : this.activo,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductoData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('categoria: $categoria, ')
          ..write('proveedorUuid: $proveedorUuid, ')
          ..write('precioUsd: $precioUsd, ')
          ..write('costoUsd: $costoUsd, ')
          ..write('precioMayor: $precioMayor, ')
          ..write('stock: $stock, ')
          ..write('exentoIva: $exentoIva, ')
          ..write('esGranel: $esGranel, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('activo: $activo, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      nombre,
      codigo,
      categoria,
      proveedorUuid,
      precioUsd,
      costoUsd,
      precioMayor,
      stock,
      exentoIva,
      esGranel,
      unidadMedida,
      fechaVencimiento,
      stockMinimo,
      activo,
      fechaCreacion,
      fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductoData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.categoria == this.categoria &&
          other.proveedorUuid == this.proveedorUuid &&
          other.precioUsd == this.precioUsd &&
          other.costoUsd == this.costoUsd &&
          other.precioMayor == this.precioMayor &&
          other.stock == this.stock &&
          other.exentoIva == this.exentoIva &&
          other.esGranel == this.esGranel &&
          other.unidadMedida == this.unidadMedida &&
          other.fechaVencimiento == this.fechaVencimiento &&
          other.stockMinimo == this.stockMinimo &&
          other.activo == this.activo &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class ProductoCompanion extends UpdateCompanion<ProductoData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> nombre;
  final Value<String?> codigo;
  final Value<String?> categoria;
  final Value<String?> proveedorUuid;
  final Value<double> precioUsd;
  final Value<double> costoUsd;
  final Value<double?> precioMayor;
  final Value<double> stock;
  final Value<bool> exentoIva;
  final Value<bool> esGranel;
  final Value<String?> unidadMedida;
  final Value<int?> fechaVencimiento;
  final Value<int> stockMinimo;
  final Value<bool> activo;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const ProductoCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.categoria = const Value.absent(),
    this.proveedorUuid = const Value.absent(),
    this.precioUsd = const Value.absent(),
    this.costoUsd = const Value.absent(),
    this.precioMayor = const Value.absent(),
    this.stock = const Value.absent(),
    this.exentoIva = const Value.absent(),
    this.esGranel = const Value.absent(),
    this.unidadMedida = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  ProductoCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String nombre,
    this.codigo = const Value.absent(),
    this.categoria = const Value.absent(),
    this.proveedorUuid = const Value.absent(),
    required double precioUsd,
    this.costoUsd = const Value.absent(),
    this.precioMayor = const Value.absent(),
    this.stock = const Value.absent(),
    this.exentoIva = const Value.absent(),
    this.esGranel = const Value.absent(),
    this.unidadMedida = const Value.absent(),
    this.fechaVencimiento = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.activo = const Value.absent(),
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        nombre = Value(nombre),
        precioUsd = Value(precioUsd),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<ProductoData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<String>? categoria,
    Expression<String>? proveedorUuid,
    Expression<double>? precioUsd,
    Expression<double>? costoUsd,
    Expression<double>? precioMayor,
    Expression<double>? stock,
    Expression<bool>? exentoIva,
    Expression<bool>? esGranel,
    Expression<String>? unidadMedida,
    Expression<int>? fechaVencimiento,
    Expression<int>? stockMinimo,
    Expression<bool>? activo,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (categoria != null) 'categoria': categoria,
      if (proveedorUuid != null) 'proveedor_uuid': proveedorUuid,
      if (precioUsd != null) 'precio_usd': precioUsd,
      if (costoUsd != null) 'costo_usd': costoUsd,
      if (precioMayor != null) 'precio_mayor': precioMayor,
      if (stock != null) 'stock': stock,
      if (exentoIva != null) 'exento_iva': exentoIva,
      if (esGranel != null) 'es_granel': esGranel,
      if (unidadMedida != null) 'unidad_medida': unidadMedida,
      if (fechaVencimiento != null) 'fecha_vencimiento': fechaVencimiento,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
      if (activo != null) 'activo': activo,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  ProductoCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? nombre,
      Value<String?>? codigo,
      Value<String?>? categoria,
      Value<String?>? proveedorUuid,
      Value<double>? precioUsd,
      Value<double>? costoUsd,
      Value<double?>? precioMayor,
      Value<double>? stock,
      Value<bool>? exentoIva,
      Value<bool>? esGranel,
      Value<String?>? unidadMedida,
      Value<int?>? fechaVencimiento,
      Value<int>? stockMinimo,
      Value<bool>? activo,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return ProductoCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      categoria: categoria ?? this.categoria,
      proveedorUuid: proveedorUuid ?? this.proveedorUuid,
      precioUsd: precioUsd ?? this.precioUsd,
      costoUsd: costoUsd ?? this.costoUsd,
      precioMayor: precioMayor ?? this.precioMayor,
      stock: stock ?? this.stock,
      exentoIva: exentoIva ?? this.exentoIva,
      esGranel: esGranel ?? this.esGranel,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      activo: activo ?? this.activo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (proveedorUuid.present) {
      map['proveedor_uuid'] = Variable<String>(proveedorUuid.value);
    }
    if (precioUsd.present) {
      map['precio_usd'] = Variable<double>(precioUsd.value);
    }
    if (costoUsd.present) {
      map['costo_usd'] = Variable<double>(costoUsd.value);
    }
    if (precioMayor.present) {
      map['precio_mayor'] = Variable<double>(precioMayor.value);
    }
    if (stock.present) {
      map['stock'] = Variable<double>(stock.value);
    }
    if (exentoIva.present) {
      map['exento_iva'] = Variable<bool>(exentoIva.value);
    }
    if (esGranel.present) {
      map['es_granel'] = Variable<bool>(esGranel.value);
    }
    if (unidadMedida.present) {
      map['unidad_medida'] = Variable<String>(unidadMedida.value);
    }
    if (fechaVencimiento.present) {
      map['fecha_vencimiento'] = Variable<int>(fechaVencimiento.value);
    }
    if (stockMinimo.present) {
      map['stock_minimo'] = Variable<int>(stockMinimo.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductoCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('categoria: $categoria, ')
          ..write('proveedorUuid: $proveedorUuid, ')
          ..write('precioUsd: $precioUsd, ')
          ..write('costoUsd: $costoUsd, ')
          ..write('precioMayor: $precioMayor, ')
          ..write('stock: $stock, ')
          ..write('exentoIva: $exentoIva, ')
          ..write('esGranel: $esGranel, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('fechaVencimiento: $fechaVencimiento, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('activo: $activo, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $VentaTable extends Venta with TableInfo<$VentaTable, VentaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _numeroVentaMeta =
      const VerificationMeta('numeroVenta');
  @override
  late final GeneratedColumn<int> numeroVenta = GeneratedColumn<int>(
      'numero_venta', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pagosJsonMeta =
      const VerificationMeta('pagosJson');
  @override
  late final GeneratedColumn<String> pagosJson = GeneratedColumn<String>(
      'pagos_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalUsdMeta =
      const VerificationMeta('totalUsd');
  @override
  late final GeneratedColumn<double> totalUsd = GeneratedColumn<double>(
      'total_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalBsMeta =
      const VerificationMeta('totalBs');
  @override
  late final GeneratedColumn<double> totalBs = GeneratedColumn<double>(
      'total_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tasaUsadaMeta =
      const VerificationMeta('tasaUsada');
  @override
  late final GeneratedColumn<double> tasaUsada = GeneratedColumn<double>(
      'tasa_usada', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ivaBsMeta = const VerificationMeta('ivaBs');
  @override
  late final GeneratedColumn<double> ivaBs = GeneratedColumn<double>(
      'iva_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _igtfBsMeta = const VerificationMeta('igtfBs');
  @override
  late final GeneratedColumn<double> igtfBs = GeneratedColumn<double>(
      'igtf_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _exentoBsMeta =
      const VerificationMeta('exentoBs');
  @override
  late final GeneratedColumn<double> exentoBs = GeneratedColumn<double>(
      'exento_bs', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _esFiadoMeta =
      const VerificationMeta('esFiado');
  @override
  late final GeneratedColumn<bool> esFiado = GeneratedColumn<bool>(
      'es_fiado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("es_fiado" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _clienteIdMeta =
      const VerificationMeta('clienteId');
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
      'cliente_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _anuladaMeta =
      const VerificationMeta('anulada');
  @override
  late final GeneratedColumn<bool> anulada = GeneratedColumn<bool>(
      'anulada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("anulada" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _motivoAnulacionMeta =
      const VerificationMeta('motivoAnulacion');
  @override
  late final GeneratedColumn<String> motivoAnulacion = GeneratedColumn<String>(
      'motivo_anulacion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        numeroVenta,
        fecha,
        itemsJson,
        pagosJson,
        totalUsd,
        totalBs,
        tasaUsada,
        ivaBs,
        igtfBs,
        exentoBs,
        esFiado,
        clienteId,
        anulada,
        motivoAnulacion,
        usuarioId,
        usuarioNombre,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'venta';
  @override
  VerificationContext validateIntegrity(Insertable<VentaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('numero_venta')) {
      context.handle(
          _numeroVentaMeta,
          numeroVenta.isAcceptableOrUnknown(
              data['numero_venta']!, _numeroVentaMeta));
    } else if (isInserting) {
      context.missing(_numeroVentaMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('pagos_json')) {
      context.handle(_pagosJsonMeta,
          pagosJson.isAcceptableOrUnknown(data['pagos_json']!, _pagosJsonMeta));
    } else if (isInserting) {
      context.missing(_pagosJsonMeta);
    }
    if (data.containsKey('total_usd')) {
      context.handle(_totalUsdMeta,
          totalUsd.isAcceptableOrUnknown(data['total_usd']!, _totalUsdMeta));
    } else if (isInserting) {
      context.missing(_totalUsdMeta);
    }
    if (data.containsKey('total_bs')) {
      context.handle(_totalBsMeta,
          totalBs.isAcceptableOrUnknown(data['total_bs']!, _totalBsMeta));
    } else if (isInserting) {
      context.missing(_totalBsMeta);
    }
    if (data.containsKey('tasa_usada')) {
      context.handle(_tasaUsadaMeta,
          tasaUsada.isAcceptableOrUnknown(data['tasa_usada']!, _tasaUsadaMeta));
    } else if (isInserting) {
      context.missing(_tasaUsadaMeta);
    }
    if (data.containsKey('iva_bs')) {
      context.handle(
          _ivaBsMeta, ivaBs.isAcceptableOrUnknown(data['iva_bs']!, _ivaBsMeta));
    } else if (isInserting) {
      context.missing(_ivaBsMeta);
    }
    if (data.containsKey('igtf_bs')) {
      context.handle(_igtfBsMeta,
          igtfBs.isAcceptableOrUnknown(data['igtf_bs']!, _igtfBsMeta));
    } else if (isInserting) {
      context.missing(_igtfBsMeta);
    }
    if (data.containsKey('exento_bs')) {
      context.handle(_exentoBsMeta,
          exentoBs.isAcceptableOrUnknown(data['exento_bs']!, _exentoBsMeta));
    }
    if (data.containsKey('es_fiado')) {
      context.handle(_esFiadoMeta,
          esFiado.isAcceptableOrUnknown(data['es_fiado']!, _esFiadoMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(_clienteIdMeta,
          clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta));
    }
    if (data.containsKey('anulada')) {
      context.handle(_anuladaMeta,
          anulada.isAcceptableOrUnknown(data['anulada']!, _anuladaMeta));
    }
    if (data.containsKey('motivo_anulacion')) {
      context.handle(
          _motivoAnulacionMeta,
          motivoAnulacion.isAcceptableOrUnknown(
              data['motivo_anulacion']!, _motivoAnulacionMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VentaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      numeroVenta: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero_venta'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      pagosJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pagos_json'])!,
      totalUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_usd'])!,
      totalBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_bs'])!,
      tasaUsada: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa_usada'])!,
      ivaBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}iva_bs'])!,
      igtfBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}igtf_bs'])!,
      exentoBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exento_bs'])!,
      esFiado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}es_fiado'])!,
      clienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cliente_id']),
      anulada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}anulada'])!,
      motivoAnulacion: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}motivo_anulacion']),
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $VentaTable createAlias(String alias) {
    return $VentaTable(attachedDatabase, alias);
  }
}

class VentaData extends DataClass implements Insertable<VentaData> {
  final int id;
  final String uuid;

  /// Secuencial por negocio para el ticket (Venta #123).
  final int numeroVenta;

  /// Epoch de la venta.
  final int fecha;

  /// Lista de ItemVenta serializada.
  final String itemsJson;

  /// Lista de Pago serializada.
  final String pagosJson;
  final double totalUsd;
  final double totalBs;

  /// Tasa usada al momento de la venta (auditoría).
  final double tasaUsada;

  /// Desglose de impuestos (ticket).
  final double ivaBs;
  final double igtfBs;

  /// Monto exento de IVA en Bs (para ticket y reportes).
  final double exentoBs;
  final bool esFiado;
  final int? clienteId;
  final bool anulada;
  final String? motivoAnulacion;
  final String usuarioId;
  final String usuarioNombre;
  final int fechaCreacion;
  final int fechaActualizacion;
  const VentaData(
      {required this.id,
      required this.uuid,
      required this.numeroVenta,
      required this.fecha,
      required this.itemsJson,
      required this.pagosJson,
      required this.totalUsd,
      required this.totalBs,
      required this.tasaUsada,
      required this.ivaBs,
      required this.igtfBs,
      required this.exentoBs,
      required this.esFiado,
      this.clienteId,
      required this.anulada,
      this.motivoAnulacion,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['numero_venta'] = Variable<int>(numeroVenta);
    map['fecha'] = Variable<int>(fecha);
    map['items_json'] = Variable<String>(itemsJson);
    map['pagos_json'] = Variable<String>(pagosJson);
    map['total_usd'] = Variable<double>(totalUsd);
    map['total_bs'] = Variable<double>(totalBs);
    map['tasa_usada'] = Variable<double>(tasaUsada);
    map['iva_bs'] = Variable<double>(ivaBs);
    map['igtf_bs'] = Variable<double>(igtfBs);
    map['exento_bs'] = Variable<double>(exentoBs);
    map['es_fiado'] = Variable<bool>(esFiado);
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<int>(clienteId);
    }
    map['anulada'] = Variable<bool>(anulada);
    if (!nullToAbsent || motivoAnulacion != null) {
      map['motivo_anulacion'] = Variable<String>(motivoAnulacion);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  VentaCompanion toCompanion(bool nullToAbsent) {
    return VentaCompanion(
      id: Value(id),
      uuid: Value(uuid),
      numeroVenta: Value(numeroVenta),
      fecha: Value(fecha),
      itemsJson: Value(itemsJson),
      pagosJson: Value(pagosJson),
      totalUsd: Value(totalUsd),
      totalBs: Value(totalBs),
      tasaUsada: Value(tasaUsada),
      ivaBs: Value(ivaBs),
      igtfBs: Value(igtfBs),
      exentoBs: Value(exentoBs),
      esFiado: Value(esFiado),
      clienteId: clienteId == null && nullToAbsent
          ? const Value.absent()
          : Value(clienteId),
      anulada: Value(anulada),
      motivoAnulacion: motivoAnulacion == null && nullToAbsent
          ? const Value.absent()
          : Value(motivoAnulacion),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory VentaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentaData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      numeroVenta: serializer.fromJson<int>(json['numeroVenta']),
      fecha: serializer.fromJson<int>(json['fecha']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      pagosJson: serializer.fromJson<String>(json['pagosJson']),
      totalUsd: serializer.fromJson<double>(json['totalUsd']),
      totalBs: serializer.fromJson<double>(json['totalBs']),
      tasaUsada: serializer.fromJson<double>(json['tasaUsada']),
      ivaBs: serializer.fromJson<double>(json['ivaBs']),
      igtfBs: serializer.fromJson<double>(json['igtfBs']),
      exentoBs: serializer.fromJson<double>(json['exentoBs']),
      esFiado: serializer.fromJson<bool>(json['esFiado']),
      clienteId: serializer.fromJson<int?>(json['clienteId']),
      anulada: serializer.fromJson<bool>(json['anulada']),
      motivoAnulacion: serializer.fromJson<String?>(json['motivoAnulacion']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'numeroVenta': serializer.toJson<int>(numeroVenta),
      'fecha': serializer.toJson<int>(fecha),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'pagosJson': serializer.toJson<String>(pagosJson),
      'totalUsd': serializer.toJson<double>(totalUsd),
      'totalBs': serializer.toJson<double>(totalBs),
      'tasaUsada': serializer.toJson<double>(tasaUsada),
      'ivaBs': serializer.toJson<double>(ivaBs),
      'igtfBs': serializer.toJson<double>(igtfBs),
      'exentoBs': serializer.toJson<double>(exentoBs),
      'esFiado': serializer.toJson<bool>(esFiado),
      'clienteId': serializer.toJson<int?>(clienteId),
      'anulada': serializer.toJson<bool>(anulada),
      'motivoAnulacion': serializer.toJson<String?>(motivoAnulacion),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  VentaData copyWith(
          {int? id,
          String? uuid,
          int? numeroVenta,
          int? fecha,
          String? itemsJson,
          String? pagosJson,
          double? totalUsd,
          double? totalBs,
          double? tasaUsada,
          double? ivaBs,
          double? igtfBs,
          double? exentoBs,
          bool? esFiado,
          Value<int?> clienteId = const Value.absent(),
          bool? anulada,
          Value<String?> motivoAnulacion = const Value.absent(),
          String? usuarioId,
          String? usuarioNombre,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      VentaData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        numeroVenta: numeroVenta ?? this.numeroVenta,
        fecha: fecha ?? this.fecha,
        itemsJson: itemsJson ?? this.itemsJson,
        pagosJson: pagosJson ?? this.pagosJson,
        totalUsd: totalUsd ?? this.totalUsd,
        totalBs: totalBs ?? this.totalBs,
        tasaUsada: tasaUsada ?? this.tasaUsada,
        ivaBs: ivaBs ?? this.ivaBs,
        igtfBs: igtfBs ?? this.igtfBs,
        exentoBs: exentoBs ?? this.exentoBs,
        esFiado: esFiado ?? this.esFiado,
        clienteId: clienteId.present ? clienteId.value : this.clienteId,
        anulada: anulada ?? this.anulada,
        motivoAnulacion: motivoAnulacion.present
            ? motivoAnulacion.value
            : this.motivoAnulacion,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  VentaData copyWithCompanion(VentaCompanion data) {
    return VentaData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      numeroVenta:
          data.numeroVenta.present ? data.numeroVenta.value : this.numeroVenta,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      pagosJson: data.pagosJson.present ? data.pagosJson.value : this.pagosJson,
      totalUsd: data.totalUsd.present ? data.totalUsd.value : this.totalUsd,
      totalBs: data.totalBs.present ? data.totalBs.value : this.totalBs,
      tasaUsada: data.tasaUsada.present ? data.tasaUsada.value : this.tasaUsada,
      ivaBs: data.ivaBs.present ? data.ivaBs.value : this.ivaBs,
      igtfBs: data.igtfBs.present ? data.igtfBs.value : this.igtfBs,
      exentoBs: data.exentoBs.present ? data.exentoBs.value : this.exentoBs,
      esFiado: data.esFiado.present ? data.esFiado.value : this.esFiado,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      anulada: data.anulada.present ? data.anulada.value : this.anulada,
      motivoAnulacion: data.motivoAnulacion.present
          ? data.motivoAnulacion.value
          : this.motivoAnulacion,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentaData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('numeroVenta: $numeroVenta, ')
          ..write('fecha: $fecha, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('pagosJson: $pagosJson, ')
          ..write('totalUsd: $totalUsd, ')
          ..write('totalBs: $totalBs, ')
          ..write('tasaUsada: $tasaUsada, ')
          ..write('ivaBs: $ivaBs, ')
          ..write('igtfBs: $igtfBs, ')
          ..write('exentoBs: $exentoBs, ')
          ..write('esFiado: $esFiado, ')
          ..write('clienteId: $clienteId, ')
          ..write('anulada: $anulada, ')
          ..write('motivoAnulacion: $motivoAnulacion, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      numeroVenta,
      fecha,
      itemsJson,
      pagosJson,
      totalUsd,
      totalBs,
      tasaUsada,
      ivaBs,
      igtfBs,
      exentoBs,
      esFiado,
      clienteId,
      anulada,
      motivoAnulacion,
      usuarioId,
      usuarioNombre,
      fechaCreacion,
      fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentaData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.numeroVenta == this.numeroVenta &&
          other.fecha == this.fecha &&
          other.itemsJson == this.itemsJson &&
          other.pagosJson == this.pagosJson &&
          other.totalUsd == this.totalUsd &&
          other.totalBs == this.totalBs &&
          other.tasaUsada == this.tasaUsada &&
          other.ivaBs == this.ivaBs &&
          other.igtfBs == this.igtfBs &&
          other.exentoBs == this.exentoBs &&
          other.esFiado == this.esFiado &&
          other.clienteId == this.clienteId &&
          other.anulada == this.anulada &&
          other.motivoAnulacion == this.motivoAnulacion &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class VentaCompanion extends UpdateCompanion<VentaData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> numeroVenta;
  final Value<int> fecha;
  final Value<String> itemsJson;
  final Value<String> pagosJson;
  final Value<double> totalUsd;
  final Value<double> totalBs;
  final Value<double> tasaUsada;
  final Value<double> ivaBs;
  final Value<double> igtfBs;
  final Value<double> exentoBs;
  final Value<bool> esFiado;
  final Value<int?> clienteId;
  final Value<bool> anulada;
  final Value<String?> motivoAnulacion;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const VentaCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.numeroVenta = const Value.absent(),
    this.fecha = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.pagosJson = const Value.absent(),
    this.totalUsd = const Value.absent(),
    this.totalBs = const Value.absent(),
    this.tasaUsada = const Value.absent(),
    this.ivaBs = const Value.absent(),
    this.igtfBs = const Value.absent(),
    this.exentoBs = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.anulada = const Value.absent(),
    this.motivoAnulacion = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  VentaCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int numeroVenta,
    required int fecha,
    required String itemsJson,
    required String pagosJson,
    required double totalUsd,
    required double totalBs,
    required double tasaUsada,
    required double ivaBs,
    required double igtfBs,
    this.exentoBs = const Value.absent(),
    this.esFiado = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.anulada = const Value.absent(),
    this.motivoAnulacion = const Value.absent(),
    required String usuarioId,
    required String usuarioNombre,
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        numeroVenta = Value(numeroVenta),
        fecha = Value(fecha),
        itemsJson = Value(itemsJson),
        pagosJson = Value(pagosJson),
        totalUsd = Value(totalUsd),
        totalBs = Value(totalBs),
        tasaUsada = Value(tasaUsada),
        ivaBs = Value(ivaBs),
        igtfBs = Value(igtfBs),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<VentaData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? numeroVenta,
    Expression<int>? fecha,
    Expression<String>? itemsJson,
    Expression<String>? pagosJson,
    Expression<double>? totalUsd,
    Expression<double>? totalBs,
    Expression<double>? tasaUsada,
    Expression<double>? ivaBs,
    Expression<double>? igtfBs,
    Expression<double>? exentoBs,
    Expression<bool>? esFiado,
    Expression<int>? clienteId,
    Expression<bool>? anulada,
    Expression<String>? motivoAnulacion,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (numeroVenta != null) 'numero_venta': numeroVenta,
      if (fecha != null) 'fecha': fecha,
      if (itemsJson != null) 'items_json': itemsJson,
      if (pagosJson != null) 'pagos_json': pagosJson,
      if (totalUsd != null) 'total_usd': totalUsd,
      if (totalBs != null) 'total_bs': totalBs,
      if (tasaUsada != null) 'tasa_usada': tasaUsada,
      if (ivaBs != null) 'iva_bs': ivaBs,
      if (igtfBs != null) 'igtf_bs': igtfBs,
      if (exentoBs != null) 'exento_bs': exentoBs,
      if (esFiado != null) 'es_fiado': esFiado,
      if (clienteId != null) 'cliente_id': clienteId,
      if (anulada != null) 'anulada': anulada,
      if (motivoAnulacion != null) 'motivo_anulacion': motivoAnulacion,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  VentaCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? numeroVenta,
      Value<int>? fecha,
      Value<String>? itemsJson,
      Value<String>? pagosJson,
      Value<double>? totalUsd,
      Value<double>? totalBs,
      Value<double>? tasaUsada,
      Value<double>? ivaBs,
      Value<double>? igtfBs,
      Value<double>? exentoBs,
      Value<bool>? esFiado,
      Value<int?>? clienteId,
      Value<bool>? anulada,
      Value<String?>? motivoAnulacion,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return VentaCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      numeroVenta: numeroVenta ?? this.numeroVenta,
      fecha: fecha ?? this.fecha,
      itemsJson: itemsJson ?? this.itemsJson,
      pagosJson: pagosJson ?? this.pagosJson,
      totalUsd: totalUsd ?? this.totalUsd,
      totalBs: totalBs ?? this.totalBs,
      tasaUsada: tasaUsada ?? this.tasaUsada,
      ivaBs: ivaBs ?? this.ivaBs,
      igtfBs: igtfBs ?? this.igtfBs,
      exentoBs: exentoBs ?? this.exentoBs,
      esFiado: esFiado ?? this.esFiado,
      clienteId: clienteId ?? this.clienteId,
      anulada: anulada ?? this.anulada,
      motivoAnulacion: motivoAnulacion ?? this.motivoAnulacion,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (numeroVenta.present) {
      map['numero_venta'] = Variable<int>(numeroVenta.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (pagosJson.present) {
      map['pagos_json'] = Variable<String>(pagosJson.value);
    }
    if (totalUsd.present) {
      map['total_usd'] = Variable<double>(totalUsd.value);
    }
    if (totalBs.present) {
      map['total_bs'] = Variable<double>(totalBs.value);
    }
    if (tasaUsada.present) {
      map['tasa_usada'] = Variable<double>(tasaUsada.value);
    }
    if (ivaBs.present) {
      map['iva_bs'] = Variable<double>(ivaBs.value);
    }
    if (igtfBs.present) {
      map['igtf_bs'] = Variable<double>(igtfBs.value);
    }
    if (exentoBs.present) {
      map['exento_bs'] = Variable<double>(exentoBs.value);
    }
    if (esFiado.present) {
      map['es_fiado'] = Variable<bool>(esFiado.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (anulada.present) {
      map['anulada'] = Variable<bool>(anulada.value);
    }
    if (motivoAnulacion.present) {
      map['motivo_anulacion'] = Variable<String>(motivoAnulacion.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentaCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('numeroVenta: $numeroVenta, ')
          ..write('fecha: $fecha, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('pagosJson: $pagosJson, ')
          ..write('totalUsd: $totalUsd, ')
          ..write('totalBs: $totalBs, ')
          ..write('tasaUsada: $tasaUsada, ')
          ..write('ivaBs: $ivaBs, ')
          ..write('igtfBs: $igtfBs, ')
          ..write('exentoBs: $exentoBs, ')
          ..write('esFiado: $esFiado, ')
          ..write('clienteId: $clienteId, ')
          ..write('anulada: $anulada, ')
          ..write('motivoAnulacion: $motivoAnulacion, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $ClienteTable extends Cliente with TableInfo<$ClienteTable, ClienteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClienteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cedulaMeta = const VerificationMeta('cedula');
  @override
  late final GeneratedColumn<String> cedula = GeneratedColumn<String>(
      'cedula', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _saldoPendienteUsdMeta =
      const VerificationMeta('saldoPendienteUsd');
  @override
  late final GeneratedColumn<double> saldoPendienteUsd =
      GeneratedColumn<double>('saldo_pendiente_usd', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _limiteCreditoUsdMeta =
      const VerificationMeta('limiteCreditoUsd');
  @override
  late final GeneratedColumn<double> limiteCreditoUsd = GeneratedColumn<double>(
      'limite_credito_usd', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        nombre,
        cedula,
        telefono,
        saldoPendienteUsd,
        limiteCreditoUsd,
        activo,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cliente';
  @override
  VerificationContext validateIntegrity(Insertable<ClienteData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('cedula')) {
      context.handle(_cedulaMeta,
          cedula.isAcceptableOrUnknown(data['cedula']!, _cedulaMeta));
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('saldo_pendiente_usd')) {
      context.handle(
          _saldoPendienteUsdMeta,
          saldoPendienteUsd.isAcceptableOrUnknown(
              data['saldo_pendiente_usd']!, _saldoPendienteUsdMeta));
    }
    if (data.containsKey('limite_credito_usd')) {
      context.handle(
          _limiteCreditoUsdMeta,
          limiteCreditoUsd.isAcceptableOrUnknown(
              data['limite_credito_usd']!, _limiteCreditoUsdMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClienteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      cedula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cedula']),
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono']),
      saldoPendienteUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}saldo_pendiente_usd'])!,
      limiteCreditoUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}limite_credito_usd']),
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $ClienteTable createAlias(String alias) {
    return $ClienteTable(attachedDatabase, alias);
  }
}

class ClienteData extends DataClass implements Insertable<ClienteData> {
  final int id;
  final String uuid;
  final String nombre;
  final String? cedula;
  final String? telefono;

  /// Saldo pendiente en USD (fuente de verdad; Bs se calcula con tasa actual).
  final double saldoPendienteUsd;

  /// Límite de crédito (Plan Todos los Juguetes).
  final double? limiteCreditoUsd;
  final bool activo;
  final int fechaCreacion;
  final int fechaActualizacion;
  const ClienteData(
      {required this.id,
      required this.uuid,
      required this.nombre,
      this.cedula,
      this.telefono,
      required this.saldoPendienteUsd,
      this.limiteCreditoUsd,
      required this.activo,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || cedula != null) {
      map['cedula'] = Variable<String>(cedula);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    map['saldo_pendiente_usd'] = Variable<double>(saldoPendienteUsd);
    if (!nullToAbsent || limiteCreditoUsd != null) {
      map['limite_credito_usd'] = Variable<double>(limiteCreditoUsd);
    }
    map['activo'] = Variable<bool>(activo);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  ClienteCompanion toCompanion(bool nullToAbsent) {
    return ClienteCompanion(
      id: Value(id),
      uuid: Value(uuid),
      nombre: Value(nombre),
      cedula:
          cedula == null && nullToAbsent ? const Value.absent() : Value(cedula),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      saldoPendienteUsd: Value(saldoPendienteUsd),
      limiteCreditoUsd: limiteCreditoUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(limiteCreditoUsd),
      activo: Value(activo),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory ClienteData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nombre: serializer.fromJson<String>(json['nombre']),
      cedula: serializer.fromJson<String?>(json['cedula']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      saldoPendienteUsd: serializer.fromJson<double>(json['saldoPendienteUsd']),
      limiteCreditoUsd: serializer.fromJson<double?>(json['limiteCreditoUsd']),
      activo: serializer.fromJson<bool>(json['activo']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'nombre': serializer.toJson<String>(nombre),
      'cedula': serializer.toJson<String?>(cedula),
      'telefono': serializer.toJson<String?>(telefono),
      'saldoPendienteUsd': serializer.toJson<double>(saldoPendienteUsd),
      'limiteCreditoUsd': serializer.toJson<double?>(limiteCreditoUsd),
      'activo': serializer.toJson<bool>(activo),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  ClienteData copyWith(
          {int? id,
          String? uuid,
          String? nombre,
          Value<String?> cedula = const Value.absent(),
          Value<String?> telefono = const Value.absent(),
          double? saldoPendienteUsd,
          Value<double?> limiteCreditoUsd = const Value.absent(),
          bool? activo,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      ClienteData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        nombre: nombre ?? this.nombre,
        cedula: cedula.present ? cedula.value : this.cedula,
        telefono: telefono.present ? telefono.value : this.telefono,
        saldoPendienteUsd: saldoPendienteUsd ?? this.saldoPendienteUsd,
        limiteCreditoUsd: limiteCreditoUsd.present
            ? limiteCreditoUsd.value
            : this.limiteCreditoUsd,
        activo: activo ?? this.activo,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  ClienteData copyWithCompanion(ClienteCompanion data) {
    return ClienteData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      cedula: data.cedula.present ? data.cedula.value : this.cedula,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      saldoPendienteUsd: data.saldoPendienteUsd.present
          ? data.saldoPendienteUsd.value
          : this.saldoPendienteUsd,
      limiteCreditoUsd: data.limiteCreditoUsd.present
          ? data.limiteCreditoUsd.value
          : this.limiteCreditoUsd,
      activo: data.activo.present ? data.activo.value : this.activo,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('cedula: $cedula, ')
          ..write('telefono: $telefono, ')
          ..write('saldoPendienteUsd: $saldoPendienteUsd, ')
          ..write('limiteCreditoUsd: $limiteCreditoUsd, ')
          ..write('activo: $activo, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      nombre,
      cedula,
      telefono,
      saldoPendienteUsd,
      limiteCreditoUsd,
      activo,
      fechaCreacion,
      fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.nombre == this.nombre &&
          other.cedula == this.cedula &&
          other.telefono == this.telefono &&
          other.saldoPendienteUsd == this.saldoPendienteUsd &&
          other.limiteCreditoUsd == this.limiteCreditoUsd &&
          other.activo == this.activo &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class ClienteCompanion extends UpdateCompanion<ClienteData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> nombre;
  final Value<String?> cedula;
  final Value<String?> telefono;
  final Value<double> saldoPendienteUsd;
  final Value<double?> limiteCreditoUsd;
  final Value<bool> activo;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const ClienteCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nombre = const Value.absent(),
    this.cedula = const Value.absent(),
    this.telefono = const Value.absent(),
    this.saldoPendienteUsd = const Value.absent(),
    this.limiteCreditoUsd = const Value.absent(),
    this.activo = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  ClienteCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String nombre,
    this.cedula = const Value.absent(),
    this.telefono = const Value.absent(),
    this.saldoPendienteUsd = const Value.absent(),
    this.limiteCreditoUsd = const Value.absent(),
    this.activo = const Value.absent(),
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        nombre = Value(nombre),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<ClienteData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? nombre,
    Expression<String>? cedula,
    Expression<String>? telefono,
    Expression<double>? saldoPendienteUsd,
    Expression<double>? limiteCreditoUsd,
    Expression<bool>? activo,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (nombre != null) 'nombre': nombre,
      if (cedula != null) 'cedula': cedula,
      if (telefono != null) 'telefono': telefono,
      if (saldoPendienteUsd != null) 'saldo_pendiente_usd': saldoPendienteUsd,
      if (limiteCreditoUsd != null) 'limite_credito_usd': limiteCreditoUsd,
      if (activo != null) 'activo': activo,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  ClienteCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? nombre,
      Value<String?>? cedula,
      Value<String?>? telefono,
      Value<double>? saldoPendienteUsd,
      Value<double?>? limiteCreditoUsd,
      Value<bool>? activo,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return ClienteCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      telefono: telefono ?? this.telefono,
      saldoPendienteUsd: saldoPendienteUsd ?? this.saldoPendienteUsd,
      limiteCreditoUsd: limiteCreditoUsd ?? this.limiteCreditoUsd,
      activo: activo ?? this.activo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (cedula.present) {
      map['cedula'] = Variable<String>(cedula.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (saldoPendienteUsd.present) {
      map['saldo_pendiente_usd'] = Variable<double>(saldoPendienteUsd.value);
    }
    if (limiteCreditoUsd.present) {
      map['limite_credito_usd'] = Variable<double>(limiteCreditoUsd.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClienteCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('cedula: $cedula, ')
          ..write('telefono: $telefono, ')
          ..write('saldoPendienteUsd: $saldoPendienteUsd, ')
          ..write('limiteCreditoUsd: $limiteCreditoUsd, ')
          ..write('activo: $activo, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $PagoFiadoTable extends PagoFiado
    with TableInfo<$PagoFiadoTable, PagoFiadoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagoFiadoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _clienteIdMeta =
      const VerificationMeta('clienteId');
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
      'cliente_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ventaIdMeta =
      const VerificationMeta('ventaId');
  @override
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
      'venta_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoUsdMeta =
      const VerificationMeta('montoUsd');
  @override
  late final GeneratedColumn<double> montoUsd = GeneratedColumn<double>(
      'monto_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _montoBsMeta =
      const VerificationMeta('montoBs');
  @override
  late final GeneratedColumn<double> montoBs = GeneratedColumn<double>(
      'monto_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tasaMeta = const VerificationMeta('tasa');
  @override
  late final GeneratedColumn<double> tasa = GeneratedColumn<double>(
      'tasa', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
      'nota', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        clienteId,
        ventaId,
        tipo,
        montoUsd,
        montoBs,
        tasa,
        nota,
        usuarioId,
        usuarioNombre,
        fecha
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pago_fiado';
  @override
  VerificationContext validateIntegrity(Insertable<PagoFiadoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(_clienteIdMeta,
          clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta));
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('venta_id')) {
      context.handle(_ventaIdMeta,
          ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta));
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('monto_usd')) {
      context.handle(_montoUsdMeta,
          montoUsd.isAcceptableOrUnknown(data['monto_usd']!, _montoUsdMeta));
    } else if (isInserting) {
      context.missing(_montoUsdMeta);
    }
    if (data.containsKey('monto_bs')) {
      context.handle(_montoBsMeta,
          montoBs.isAcceptableOrUnknown(data['monto_bs']!, _montoBsMeta));
    } else if (isInserting) {
      context.missing(_montoBsMeta);
    }
    if (data.containsKey('tasa')) {
      context.handle(
          _tasaMeta, tasa.isAcceptableOrUnknown(data['tasa']!, _tasaMeta));
    } else if (isInserting) {
      context.missing(_tasaMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
          _notaMeta, nota.isAcceptableOrUnknown(data['nota']!, _notaMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PagoFiadoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PagoFiadoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      clienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cliente_id'])!,
      ventaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}venta_id']),
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      montoUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_usd'])!,
      montoBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_bs'])!,
      tasa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa'])!,
      nota: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nota']),
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
    );
  }

  @override
  $PagoFiadoTable createAlias(String alias) {
    return $PagoFiadoTable(attachedDatabase, alias);
  }
}

class PagoFiadoData extends DataClass implements Insertable<PagoFiadoData> {
  final int id;
  final String uuid;
  final int clienteId;

  /// Venta que originó el fiado (null en abonos manuales).
  final int? ventaId;
  final String tipo;
  final double montoUsd;
  final double montoBs;
  final double tasa;
  final String? nota;
  final String usuarioId;
  final String usuarioNombre;
  final int fecha;
  const PagoFiadoData(
      {required this.id,
      required this.uuid,
      required this.clienteId,
      this.ventaId,
      required this.tipo,
      required this.montoUsd,
      required this.montoBs,
      required this.tasa,
      this.nota,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fecha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['cliente_id'] = Variable<int>(clienteId);
    if (!nullToAbsent || ventaId != null) {
      map['venta_id'] = Variable<int>(ventaId);
    }
    map['tipo'] = Variable<String>(tipo);
    map['monto_usd'] = Variable<double>(montoUsd);
    map['monto_bs'] = Variable<double>(montoBs);
    map['tasa'] = Variable<double>(tasa);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha'] = Variable<int>(fecha);
    return map;
  }

  PagoFiadoCompanion toCompanion(bool nullToAbsent) {
    return PagoFiadoCompanion(
      id: Value(id),
      uuid: Value(uuid),
      clienteId: Value(clienteId),
      ventaId: ventaId == null && nullToAbsent
          ? const Value.absent()
          : Value(ventaId),
      tipo: Value(tipo),
      montoUsd: Value(montoUsd),
      montoBs: Value(montoBs),
      tasa: Value(tasa),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fecha: Value(fecha),
    );
  }

  factory PagoFiadoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PagoFiadoData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      ventaId: serializer.fromJson<int?>(json['ventaId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      montoUsd: serializer.fromJson<double>(json['montoUsd']),
      montoBs: serializer.fromJson<double>(json['montoBs']),
      tasa: serializer.fromJson<double>(json['tasa']),
      nota: serializer.fromJson<String?>(json['nota']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fecha: serializer.fromJson<int>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'clienteId': serializer.toJson<int>(clienteId),
      'ventaId': serializer.toJson<int?>(ventaId),
      'tipo': serializer.toJson<String>(tipo),
      'montoUsd': serializer.toJson<double>(montoUsd),
      'montoBs': serializer.toJson<double>(montoBs),
      'tasa': serializer.toJson<double>(tasa),
      'nota': serializer.toJson<String?>(nota),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fecha': serializer.toJson<int>(fecha),
    };
  }

  PagoFiadoData copyWith(
          {int? id,
          String? uuid,
          int? clienteId,
          Value<int?> ventaId = const Value.absent(),
          String? tipo,
          double? montoUsd,
          double? montoBs,
          double? tasa,
          Value<String?> nota = const Value.absent(),
          String? usuarioId,
          String? usuarioNombre,
          int? fecha}) =>
      PagoFiadoData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        clienteId: clienteId ?? this.clienteId,
        ventaId: ventaId.present ? ventaId.value : this.ventaId,
        tipo: tipo ?? this.tipo,
        montoUsd: montoUsd ?? this.montoUsd,
        montoBs: montoBs ?? this.montoBs,
        tasa: tasa ?? this.tasa,
        nota: nota.present ? nota.value : this.nota,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fecha: fecha ?? this.fecha,
      );
  PagoFiadoData copyWithCompanion(PagoFiadoCompanion data) {
    return PagoFiadoData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      montoUsd: data.montoUsd.present ? data.montoUsd.value : this.montoUsd,
      montoBs: data.montoBs.present ? data.montoBs.value : this.montoBs,
      tasa: data.tasa.present ? data.tasa.value : this.tasa,
      nota: data.nota.present ? data.nota.value : this.nota,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PagoFiadoData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipo: $tipo, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('montoBs: $montoBs, ')
          ..write('tasa: $tasa, ')
          ..write('nota: $nota, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, clienteId, ventaId, tipo, montoUsd,
      montoBs, tasa, nota, usuarioId, usuarioNombre, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PagoFiadoData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.clienteId == this.clienteId &&
          other.ventaId == this.ventaId &&
          other.tipo == this.tipo &&
          other.montoUsd == this.montoUsd &&
          other.montoBs == this.montoBs &&
          other.tasa == this.tasa &&
          other.nota == this.nota &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fecha == this.fecha);
}

class PagoFiadoCompanion extends UpdateCompanion<PagoFiadoData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> clienteId;
  final Value<int?> ventaId;
  final Value<String> tipo;
  final Value<double> montoUsd;
  final Value<double> montoBs;
  final Value<double> tasa;
  final Value<String?> nota;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fecha;
  const PagoFiadoCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.montoUsd = const Value.absent(),
    this.montoBs = const Value.absent(),
    this.tasa = const Value.absent(),
    this.nota = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  PagoFiadoCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int clienteId,
    this.ventaId = const Value.absent(),
    required String tipo,
    required double montoUsd,
    required double montoBs,
    required double tasa,
    this.nota = const Value.absent(),
    required String usuarioId,
    required String usuarioNombre,
    required int fecha,
  })  : uuid = Value(uuid),
        clienteId = Value(clienteId),
        tipo = Value(tipo),
        montoUsd = Value(montoUsd),
        montoBs = Value(montoBs),
        tasa = Value(tasa),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fecha = Value(fecha);
  static Insertable<PagoFiadoData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? clienteId,
    Expression<int>? ventaId,
    Expression<String>? tipo,
    Expression<double>? montoUsd,
    Expression<double>? montoBs,
    Expression<double>? tasa,
    Expression<String>? nota,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (clienteId != null) 'cliente_id': clienteId,
      if (ventaId != null) 'venta_id': ventaId,
      if (tipo != null) 'tipo': tipo,
      if (montoUsd != null) 'monto_usd': montoUsd,
      if (montoBs != null) 'monto_bs': montoBs,
      if (tasa != null) 'tasa': tasa,
      if (nota != null) 'nota': nota,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fecha != null) 'fecha': fecha,
    });
  }

  PagoFiadoCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? clienteId,
      Value<int?>? ventaId,
      Value<String>? tipo,
      Value<double>? montoUsd,
      Value<double>? montoBs,
      Value<double>? tasa,
      Value<String?>? nota,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fecha}) {
    return PagoFiadoCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      clienteId: clienteId ?? this.clienteId,
      ventaId: ventaId ?? this.ventaId,
      tipo: tipo ?? this.tipo,
      montoUsd: montoUsd ?? this.montoUsd,
      montoBs: montoBs ?? this.montoBs,
      tasa: tasa ?? this.tasa,
      nota: nota ?? this.nota,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (montoUsd.present) {
      map['monto_usd'] = Variable<double>(montoUsd.value);
    }
    if (montoBs.present) {
      map['monto_bs'] = Variable<double>(montoBs.value);
    }
    if (tasa.present) {
      map['tasa'] = Variable<double>(tasa.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagoFiadoCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipo: $tipo, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('montoBs: $montoBs, ')
          ..write('tasa: $tasa, ')
          ..write('nota: $nota, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $AperturaCajaTable extends AperturaCaja
    with TableInfo<$AperturaCajaTable, AperturaCajaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AperturaCajaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoInicialBsMeta =
      const VerificationMeta('montoInicialBs');
  @override
  late final GeneratedColumn<double> montoInicialBs = GeneratedColumn<double>(
      'monto_inicial_bs', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _montoInicialUsdMeta =
      const VerificationMeta('montoInicialUsd');
  @override
  late final GeneratedColumn<double> montoInicialUsd = GeneratedColumn<double>(
      'monto_inicial_usd', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _novedadMeta =
      const VerificationMeta('novedad');
  @override
  late final GeneratedColumn<String> novedad = GeneratedColumn<String>(
      'novedad', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cerradaMeta =
      const VerificationMeta('cerrada');
  @override
  late final GeneratedColumn<bool> cerrada = GeneratedColumn<bool>(
      'cerrada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cerrada" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaCierreMeta =
      const VerificationMeta('fechaCierre');
  @override
  late final GeneratedColumn<int> fechaCierre = GeneratedColumn<int>(
      'fecha_cierre', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        usuarioId,
        usuarioNombre,
        montoInicialBs,
        montoInicialUsd,
        novedad,
        cerrada,
        fecha,
        fechaCierre
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'apertura_caja';
  @override
  VerificationContext validateIntegrity(Insertable<AperturaCajaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('monto_inicial_bs')) {
      context.handle(
          _montoInicialBsMeta,
          montoInicialBs.isAcceptableOrUnknown(
              data['monto_inicial_bs']!, _montoInicialBsMeta));
    }
    if (data.containsKey('monto_inicial_usd')) {
      context.handle(
          _montoInicialUsdMeta,
          montoInicialUsd.isAcceptableOrUnknown(
              data['monto_inicial_usd']!, _montoInicialUsdMeta));
    }
    if (data.containsKey('novedad')) {
      context.handle(_novedadMeta,
          novedad.isAcceptableOrUnknown(data['novedad']!, _novedadMeta));
    }
    if (data.containsKey('cerrada')) {
      context.handle(_cerradaMeta,
          cerrada.isAcceptableOrUnknown(data['cerrada']!, _cerradaMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('fecha_cierre')) {
      context.handle(
          _fechaCierreMeta,
          fechaCierre.isAcceptableOrUnknown(
              data['fecha_cierre']!, _fechaCierreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AperturaCajaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AperturaCajaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      montoInicialBs: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}monto_inicial_bs'])!,
      montoInicialUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}monto_inicial_usd'])!,
      novedad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}novedad']),
      cerrada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cerrada'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
      fechaCierre: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_cierre']),
    );
  }

  @override
  $AperturaCajaTable createAlias(String alias) {
    return $AperturaCajaTable(attachedDatabase, alias);
  }
}

class AperturaCajaData extends DataClass
    implements Insertable<AperturaCajaData> {
  final int id;
  final String uuid;
  final String usuarioId;
  final String usuarioNombre;

  /// Efectivo inicial en el cajón (Bs y $ por separado).
  final double montoInicialBs;
  final double montoInicialUsd;

  /// Novedad reportada al abrir (ej: "recibí de cajera anterior").
  final String? novedad;
  final bool cerrada;
  final int fecha;
  final int? fechaCierre;
  const AperturaCajaData(
      {required this.id,
      required this.uuid,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.montoInicialBs,
      required this.montoInicialUsd,
      this.novedad,
      required this.cerrada,
      required this.fecha,
      this.fechaCierre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['monto_inicial_bs'] = Variable<double>(montoInicialBs);
    map['monto_inicial_usd'] = Variable<double>(montoInicialUsd);
    if (!nullToAbsent || novedad != null) {
      map['novedad'] = Variable<String>(novedad);
    }
    map['cerrada'] = Variable<bool>(cerrada);
    map['fecha'] = Variable<int>(fecha);
    if (!nullToAbsent || fechaCierre != null) {
      map['fecha_cierre'] = Variable<int>(fechaCierre);
    }
    return map;
  }

  AperturaCajaCompanion toCompanion(bool nullToAbsent) {
    return AperturaCajaCompanion(
      id: Value(id),
      uuid: Value(uuid),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      montoInicialBs: Value(montoInicialBs),
      montoInicialUsd: Value(montoInicialUsd),
      novedad: novedad == null && nullToAbsent
          ? const Value.absent()
          : Value(novedad),
      cerrada: Value(cerrada),
      fecha: Value(fecha),
      fechaCierre: fechaCierre == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCierre),
    );
  }

  factory AperturaCajaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AperturaCajaData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      montoInicialBs: serializer.fromJson<double>(json['montoInicialBs']),
      montoInicialUsd: serializer.fromJson<double>(json['montoInicialUsd']),
      novedad: serializer.fromJson<String?>(json['novedad']),
      cerrada: serializer.fromJson<bool>(json['cerrada']),
      fecha: serializer.fromJson<int>(json['fecha']),
      fechaCierre: serializer.fromJson<int?>(json['fechaCierre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'montoInicialBs': serializer.toJson<double>(montoInicialBs),
      'montoInicialUsd': serializer.toJson<double>(montoInicialUsd),
      'novedad': serializer.toJson<String?>(novedad),
      'cerrada': serializer.toJson<bool>(cerrada),
      'fecha': serializer.toJson<int>(fecha),
      'fechaCierre': serializer.toJson<int?>(fechaCierre),
    };
  }

  AperturaCajaData copyWith(
          {int? id,
          String? uuid,
          String? usuarioId,
          String? usuarioNombre,
          double? montoInicialBs,
          double? montoInicialUsd,
          Value<String?> novedad = const Value.absent(),
          bool? cerrada,
          int? fecha,
          Value<int?> fechaCierre = const Value.absent()}) =>
      AperturaCajaData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        montoInicialBs: montoInicialBs ?? this.montoInicialBs,
        montoInicialUsd: montoInicialUsd ?? this.montoInicialUsd,
        novedad: novedad.present ? novedad.value : this.novedad,
        cerrada: cerrada ?? this.cerrada,
        fecha: fecha ?? this.fecha,
        fechaCierre: fechaCierre.present ? fechaCierre.value : this.fechaCierre,
      );
  AperturaCajaData copyWithCompanion(AperturaCajaCompanion data) {
    return AperturaCajaData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      montoInicialBs: data.montoInicialBs.present
          ? data.montoInicialBs.value
          : this.montoInicialBs,
      montoInicialUsd: data.montoInicialUsd.present
          ? data.montoInicialUsd.value
          : this.montoInicialUsd,
      novedad: data.novedad.present ? data.novedad.value : this.novedad,
      cerrada: data.cerrada.present ? data.cerrada.value : this.cerrada,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      fechaCierre:
          data.fechaCierre.present ? data.fechaCierre.value : this.fechaCierre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AperturaCajaData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('montoInicialBs: $montoInicialBs, ')
          ..write('montoInicialUsd: $montoInicialUsd, ')
          ..write('novedad: $novedad, ')
          ..write('cerrada: $cerrada, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, usuarioId, usuarioNombre,
      montoInicialBs, montoInicialUsd, novedad, cerrada, fecha, fechaCierre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AperturaCajaData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.montoInicialBs == this.montoInicialBs &&
          other.montoInicialUsd == this.montoInicialUsd &&
          other.novedad == this.novedad &&
          other.cerrada == this.cerrada &&
          other.fecha == this.fecha &&
          other.fechaCierre == this.fechaCierre);
}

class AperturaCajaCompanion extends UpdateCompanion<AperturaCajaData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<double> montoInicialBs;
  final Value<double> montoInicialUsd;
  final Value<String?> novedad;
  final Value<bool> cerrada;
  final Value<int> fecha;
  final Value<int?> fechaCierre;
  const AperturaCajaCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.montoInicialBs = const Value.absent(),
    this.montoInicialUsd = const Value.absent(),
    this.novedad = const Value.absent(),
    this.cerrada = const Value.absent(),
    this.fecha = const Value.absent(),
    this.fechaCierre = const Value.absent(),
  });
  AperturaCajaCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String usuarioId,
    required String usuarioNombre,
    this.montoInicialBs = const Value.absent(),
    this.montoInicialUsd = const Value.absent(),
    this.novedad = const Value.absent(),
    this.cerrada = const Value.absent(),
    required int fecha,
    this.fechaCierre = const Value.absent(),
  })  : uuid = Value(uuid),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fecha = Value(fecha);
  static Insertable<AperturaCajaData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<double>? montoInicialBs,
    Expression<double>? montoInicialUsd,
    Expression<String>? novedad,
    Expression<bool>? cerrada,
    Expression<int>? fecha,
    Expression<int>? fechaCierre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (montoInicialBs != null) 'monto_inicial_bs': montoInicialBs,
      if (montoInicialUsd != null) 'monto_inicial_usd': montoInicialUsd,
      if (novedad != null) 'novedad': novedad,
      if (cerrada != null) 'cerrada': cerrada,
      if (fecha != null) 'fecha': fecha,
      if (fechaCierre != null) 'fecha_cierre': fechaCierre,
    });
  }

  AperturaCajaCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<double>? montoInicialBs,
      Value<double>? montoInicialUsd,
      Value<String?>? novedad,
      Value<bool>? cerrada,
      Value<int>? fecha,
      Value<int?>? fechaCierre}) {
    return AperturaCajaCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      montoInicialBs: montoInicialBs ?? this.montoInicialBs,
      montoInicialUsd: montoInicialUsd ?? this.montoInicialUsd,
      novedad: novedad ?? this.novedad,
      cerrada: cerrada ?? this.cerrada,
      fecha: fecha ?? this.fecha,
      fechaCierre: fechaCierre ?? this.fechaCierre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (montoInicialBs.present) {
      map['monto_inicial_bs'] = Variable<double>(montoInicialBs.value);
    }
    if (montoInicialUsd.present) {
      map['monto_inicial_usd'] = Variable<double>(montoInicialUsd.value);
    }
    if (novedad.present) {
      map['novedad'] = Variable<String>(novedad.value);
    }
    if (cerrada.present) {
      map['cerrada'] = Variable<bool>(cerrada.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    if (fechaCierre.present) {
      map['fecha_cierre'] = Variable<int>(fechaCierre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AperturaCajaCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('montoInicialBs: $montoInicialBs, ')
          ..write('montoInicialUsd: $montoInicialUsd, ')
          ..write('novedad: $novedad, ')
          ..write('cerrada: $cerrada, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }
}

class $CierreCajaTable extends CierreCaja
    with TableInfo<$CierreCajaTable, CierreCajaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CierreCajaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _aperturaIdMeta =
      const VerificationMeta('aperturaId');
  @override
  late final GeneratedColumn<int> aperturaId = GeneratedColumn<int>(
      'apertura_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoEsperadoBsMeta =
      const VerificationMeta('montoEsperadoBs');
  @override
  late final GeneratedColumn<double> montoEsperadoBs = GeneratedColumn<double>(
      'monto_esperado_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _montoRealBsMeta =
      const VerificationMeta('montoRealBs');
  @override
  late final GeneratedColumn<double> montoRealBs = GeneratedColumn<double>(
      'monto_real_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _diferenciaBsMeta =
      const VerificationMeta('diferenciaBs');
  @override
  late final GeneratedColumn<double> diferenciaBs = GeneratedColumn<double>(
      'diferencia_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _resumenJsonMeta =
      const VerificationMeta('resumenJson');
  @override
  late final GeneratedColumn<String> resumenJson = GeneratedColumn<String>(
      'resumen_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
      'nota', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        aperturaId,
        usuarioId,
        usuarioNombre,
        montoEsperadoBs,
        montoRealBs,
        diferenciaBs,
        resumenJson,
        nota,
        fecha
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cierre_caja';
  @override
  VerificationContext validateIntegrity(Insertable<CierreCajaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('apertura_id')) {
      context.handle(
          _aperturaIdMeta,
          aperturaId.isAcceptableOrUnknown(
              data['apertura_id']!, _aperturaIdMeta));
    } else if (isInserting) {
      context.missing(_aperturaIdMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('monto_esperado_bs')) {
      context.handle(
          _montoEsperadoBsMeta,
          montoEsperadoBs.isAcceptableOrUnknown(
              data['monto_esperado_bs']!, _montoEsperadoBsMeta));
    } else if (isInserting) {
      context.missing(_montoEsperadoBsMeta);
    }
    if (data.containsKey('monto_real_bs')) {
      context.handle(
          _montoRealBsMeta,
          montoRealBs.isAcceptableOrUnknown(
              data['monto_real_bs']!, _montoRealBsMeta));
    } else if (isInserting) {
      context.missing(_montoRealBsMeta);
    }
    if (data.containsKey('diferencia_bs')) {
      context.handle(
          _diferenciaBsMeta,
          diferenciaBs.isAcceptableOrUnknown(
              data['diferencia_bs']!, _diferenciaBsMeta));
    } else if (isInserting) {
      context.missing(_diferenciaBsMeta);
    }
    if (data.containsKey('resumen_json')) {
      context.handle(
          _resumenJsonMeta,
          resumenJson.isAcceptableOrUnknown(
              data['resumen_json']!, _resumenJsonMeta));
    } else if (isInserting) {
      context.missing(_resumenJsonMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
          _notaMeta, nota.isAcceptableOrUnknown(data['nota']!, _notaMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CierreCajaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CierreCajaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      aperturaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}apertura_id'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      montoEsperadoBs: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}monto_esperado_bs'])!,
      montoRealBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_real_bs'])!,
      diferenciaBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}diferencia_bs'])!,
      resumenJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}resumen_json'])!,
      nota: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nota']),
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
    );
  }

  @override
  $CierreCajaTable createAlias(String alias) {
    return $CierreCajaTable(attachedDatabase, alias);
  }
}

class CierreCajaData extends DataClass implements Insertable<CierreCajaData> {
  final int id;
  final String uuid;
  final int aperturaId;
  final String usuarioId;
  final String usuarioNombre;

  /// Efectivo Bs esperado según ventas - retiros + apertura.
  final double montoEsperadoBs;

  /// Efectivo Bs contado por el cajero.
  final double montoRealBs;

  /// real - esperado (positivo sobra, negativo falta).
  final double diferenciaBs;

  /// Resumen por método de pago serializado.
  final String resumenJson;
  final String? nota;
  final int fecha;
  const CierreCajaData(
      {required this.id,
      required this.uuid,
      required this.aperturaId,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.montoEsperadoBs,
      required this.montoRealBs,
      required this.diferenciaBs,
      required this.resumenJson,
      this.nota,
      required this.fecha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['apertura_id'] = Variable<int>(aperturaId);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['monto_esperado_bs'] = Variable<double>(montoEsperadoBs);
    map['monto_real_bs'] = Variable<double>(montoRealBs);
    map['diferencia_bs'] = Variable<double>(diferenciaBs);
    map['resumen_json'] = Variable<String>(resumenJson);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    map['fecha'] = Variable<int>(fecha);
    return map;
  }

  CierreCajaCompanion toCompanion(bool nullToAbsent) {
    return CierreCajaCompanion(
      id: Value(id),
      uuid: Value(uuid),
      aperturaId: Value(aperturaId),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      montoEsperadoBs: Value(montoEsperadoBs),
      montoRealBs: Value(montoRealBs),
      diferenciaBs: Value(diferenciaBs),
      resumenJson: Value(resumenJson),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      fecha: Value(fecha),
    );
  }

  factory CierreCajaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CierreCajaData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      aperturaId: serializer.fromJson<int>(json['aperturaId']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      montoEsperadoBs: serializer.fromJson<double>(json['montoEsperadoBs']),
      montoRealBs: serializer.fromJson<double>(json['montoRealBs']),
      diferenciaBs: serializer.fromJson<double>(json['diferenciaBs']),
      resumenJson: serializer.fromJson<String>(json['resumenJson']),
      nota: serializer.fromJson<String?>(json['nota']),
      fecha: serializer.fromJson<int>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'aperturaId': serializer.toJson<int>(aperturaId),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'montoEsperadoBs': serializer.toJson<double>(montoEsperadoBs),
      'montoRealBs': serializer.toJson<double>(montoRealBs),
      'diferenciaBs': serializer.toJson<double>(diferenciaBs),
      'resumenJson': serializer.toJson<String>(resumenJson),
      'nota': serializer.toJson<String?>(nota),
      'fecha': serializer.toJson<int>(fecha),
    };
  }

  CierreCajaData copyWith(
          {int? id,
          String? uuid,
          int? aperturaId,
          String? usuarioId,
          String? usuarioNombre,
          double? montoEsperadoBs,
          double? montoRealBs,
          double? diferenciaBs,
          String? resumenJson,
          Value<String?> nota = const Value.absent(),
          int? fecha}) =>
      CierreCajaData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        aperturaId: aperturaId ?? this.aperturaId,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        montoEsperadoBs: montoEsperadoBs ?? this.montoEsperadoBs,
        montoRealBs: montoRealBs ?? this.montoRealBs,
        diferenciaBs: diferenciaBs ?? this.diferenciaBs,
        resumenJson: resumenJson ?? this.resumenJson,
        nota: nota.present ? nota.value : this.nota,
        fecha: fecha ?? this.fecha,
      );
  CierreCajaData copyWithCompanion(CierreCajaCompanion data) {
    return CierreCajaData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      aperturaId:
          data.aperturaId.present ? data.aperturaId.value : this.aperturaId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      montoEsperadoBs: data.montoEsperadoBs.present
          ? data.montoEsperadoBs.value
          : this.montoEsperadoBs,
      montoRealBs:
          data.montoRealBs.present ? data.montoRealBs.value : this.montoRealBs,
      diferenciaBs: data.diferenciaBs.present
          ? data.diferenciaBs.value
          : this.diferenciaBs,
      resumenJson:
          data.resumenJson.present ? data.resumenJson.value : this.resumenJson,
      nota: data.nota.present ? data.nota.value : this.nota,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CierreCajaData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('aperturaId: $aperturaId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('montoEsperadoBs: $montoEsperadoBs, ')
          ..write('montoRealBs: $montoRealBs, ')
          ..write('diferenciaBs: $diferenciaBs, ')
          ..write('resumenJson: $resumenJson, ')
          ..write('nota: $nota, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      aperturaId,
      usuarioId,
      usuarioNombre,
      montoEsperadoBs,
      montoRealBs,
      diferenciaBs,
      resumenJson,
      nota,
      fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CierreCajaData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.aperturaId == this.aperturaId &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.montoEsperadoBs == this.montoEsperadoBs &&
          other.montoRealBs == this.montoRealBs &&
          other.diferenciaBs == this.diferenciaBs &&
          other.resumenJson == this.resumenJson &&
          other.nota == this.nota &&
          other.fecha == this.fecha);
}

class CierreCajaCompanion extends UpdateCompanion<CierreCajaData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> aperturaId;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<double> montoEsperadoBs;
  final Value<double> montoRealBs;
  final Value<double> diferenciaBs;
  final Value<String> resumenJson;
  final Value<String?> nota;
  final Value<int> fecha;
  const CierreCajaCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.aperturaId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.montoEsperadoBs = const Value.absent(),
    this.montoRealBs = const Value.absent(),
    this.diferenciaBs = const Value.absent(),
    this.resumenJson = const Value.absent(),
    this.nota = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  CierreCajaCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int aperturaId,
    required String usuarioId,
    required String usuarioNombre,
    required double montoEsperadoBs,
    required double montoRealBs,
    required double diferenciaBs,
    required String resumenJson,
    this.nota = const Value.absent(),
    required int fecha,
  })  : uuid = Value(uuid),
        aperturaId = Value(aperturaId),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        montoEsperadoBs = Value(montoEsperadoBs),
        montoRealBs = Value(montoRealBs),
        diferenciaBs = Value(diferenciaBs),
        resumenJson = Value(resumenJson),
        fecha = Value(fecha);
  static Insertable<CierreCajaData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? aperturaId,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<double>? montoEsperadoBs,
    Expression<double>? montoRealBs,
    Expression<double>? diferenciaBs,
    Expression<String>? resumenJson,
    Expression<String>? nota,
    Expression<int>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (aperturaId != null) 'apertura_id': aperturaId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (montoEsperadoBs != null) 'monto_esperado_bs': montoEsperadoBs,
      if (montoRealBs != null) 'monto_real_bs': montoRealBs,
      if (diferenciaBs != null) 'diferencia_bs': diferenciaBs,
      if (resumenJson != null) 'resumen_json': resumenJson,
      if (nota != null) 'nota': nota,
      if (fecha != null) 'fecha': fecha,
    });
  }

  CierreCajaCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? aperturaId,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<double>? montoEsperadoBs,
      Value<double>? montoRealBs,
      Value<double>? diferenciaBs,
      Value<String>? resumenJson,
      Value<String?>? nota,
      Value<int>? fecha}) {
    return CierreCajaCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      aperturaId: aperturaId ?? this.aperturaId,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      montoEsperadoBs: montoEsperadoBs ?? this.montoEsperadoBs,
      montoRealBs: montoRealBs ?? this.montoRealBs,
      diferenciaBs: diferenciaBs ?? this.diferenciaBs,
      resumenJson: resumenJson ?? this.resumenJson,
      nota: nota ?? this.nota,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (aperturaId.present) {
      map['apertura_id'] = Variable<int>(aperturaId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (montoEsperadoBs.present) {
      map['monto_esperado_bs'] = Variable<double>(montoEsperadoBs.value);
    }
    if (montoRealBs.present) {
      map['monto_real_bs'] = Variable<double>(montoRealBs.value);
    }
    if (diferenciaBs.present) {
      map['diferencia_bs'] = Variable<double>(diferenciaBs.value);
    }
    if (resumenJson.present) {
      map['resumen_json'] = Variable<String>(resumenJson.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CierreCajaCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('aperturaId: $aperturaId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('montoEsperadoBs: $montoEsperadoBs, ')
          ..write('montoRealBs: $montoRealBs, ')
          ..write('diferenciaBs: $diferenciaBs, ')
          ..write('resumenJson: $resumenJson, ')
          ..write('nota: $nota, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $RetiroCajaTable extends RetiroCaja
    with TableInfo<$RetiroCajaTable, RetiroCajaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RetiroCajaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _aperturaIdMeta =
      const VerificationMeta('aperturaId');
  @override
  late final GeneratedColumn<int> aperturaId = GeneratedColumn<int>(
      'apertura_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoBsMeta =
      const VerificationMeta('montoBs');
  @override
  late final GeneratedColumn<double> montoBs = GeneratedColumn<double>(
      'monto_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
      'motivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, aperturaId, usuarioId, usuarioNombre, montoBs, motivo, fecha];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'retiro_caja';
  @override
  VerificationContext validateIntegrity(Insertable<RetiroCajaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('apertura_id')) {
      context.handle(
          _aperturaIdMeta,
          aperturaId.isAcceptableOrUnknown(
              data['apertura_id']!, _aperturaIdMeta));
    } else if (isInserting) {
      context.missing(_aperturaIdMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('monto_bs')) {
      context.handle(_montoBsMeta,
          montoBs.isAcceptableOrUnknown(data['monto_bs']!, _montoBsMeta));
    } else if (isInserting) {
      context.missing(_montoBsMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(_motivoMeta,
          motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta));
    } else if (isInserting) {
      context.missing(_motivoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RetiroCajaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RetiroCajaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      aperturaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}apertura_id'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      montoBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_bs'])!,
      motivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motivo'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
    );
  }

  @override
  $RetiroCajaTable createAlias(String alias) {
    return $RetiroCajaTable(attachedDatabase, alias);
  }
}

class RetiroCajaData extends DataClass implements Insertable<RetiroCajaData> {
  final int id;
  final String uuid;
  final int aperturaId;
  final String usuarioId;
  final String usuarioNombre;
  final double montoBs;
  final String motivo;
  final int fecha;
  const RetiroCajaData(
      {required this.id,
      required this.uuid,
      required this.aperturaId,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.montoBs,
      required this.motivo,
      required this.fecha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['apertura_id'] = Variable<int>(aperturaId);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['monto_bs'] = Variable<double>(montoBs);
    map['motivo'] = Variable<String>(motivo);
    map['fecha'] = Variable<int>(fecha);
    return map;
  }

  RetiroCajaCompanion toCompanion(bool nullToAbsent) {
    return RetiroCajaCompanion(
      id: Value(id),
      uuid: Value(uuid),
      aperturaId: Value(aperturaId),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      montoBs: Value(montoBs),
      motivo: Value(motivo),
      fecha: Value(fecha),
    );
  }

  factory RetiroCajaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RetiroCajaData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      aperturaId: serializer.fromJson<int>(json['aperturaId']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      montoBs: serializer.fromJson<double>(json['montoBs']),
      motivo: serializer.fromJson<String>(json['motivo']),
      fecha: serializer.fromJson<int>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'aperturaId': serializer.toJson<int>(aperturaId),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'montoBs': serializer.toJson<double>(montoBs),
      'motivo': serializer.toJson<String>(motivo),
      'fecha': serializer.toJson<int>(fecha),
    };
  }

  RetiroCajaData copyWith(
          {int? id,
          String? uuid,
          int? aperturaId,
          String? usuarioId,
          String? usuarioNombre,
          double? montoBs,
          String? motivo,
          int? fecha}) =>
      RetiroCajaData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        aperturaId: aperturaId ?? this.aperturaId,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        montoBs: montoBs ?? this.montoBs,
        motivo: motivo ?? this.motivo,
        fecha: fecha ?? this.fecha,
      );
  RetiroCajaData copyWithCompanion(RetiroCajaCompanion data) {
    return RetiroCajaData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      aperturaId:
          data.aperturaId.present ? data.aperturaId.value : this.aperturaId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      montoBs: data.montoBs.present ? data.montoBs.value : this.montoBs,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RetiroCajaData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('aperturaId: $aperturaId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('montoBs: $montoBs, ')
          ..write('motivo: $motivo, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, uuid, aperturaId, usuarioId, usuarioNombre, montoBs, motivo, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RetiroCajaData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.aperturaId == this.aperturaId &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.montoBs == this.montoBs &&
          other.motivo == this.motivo &&
          other.fecha == this.fecha);
}

class RetiroCajaCompanion extends UpdateCompanion<RetiroCajaData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> aperturaId;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<double> montoBs;
  final Value<String> motivo;
  final Value<int> fecha;
  const RetiroCajaCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.aperturaId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.montoBs = const Value.absent(),
    this.motivo = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  RetiroCajaCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int aperturaId,
    required String usuarioId,
    required String usuarioNombre,
    required double montoBs,
    required String motivo,
    required int fecha,
  })  : uuid = Value(uuid),
        aperturaId = Value(aperturaId),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        montoBs = Value(montoBs),
        motivo = Value(motivo),
        fecha = Value(fecha);
  static Insertable<RetiroCajaData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? aperturaId,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<double>? montoBs,
    Expression<String>? motivo,
    Expression<int>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (aperturaId != null) 'apertura_id': aperturaId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (montoBs != null) 'monto_bs': montoBs,
      if (motivo != null) 'motivo': motivo,
      if (fecha != null) 'fecha': fecha,
    });
  }

  RetiroCajaCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? aperturaId,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<double>? montoBs,
      Value<String>? motivo,
      Value<int>? fecha}) {
    return RetiroCajaCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      aperturaId: aperturaId ?? this.aperturaId,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      montoBs: montoBs ?? this.montoBs,
      motivo: motivo ?? this.motivo,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (aperturaId.present) {
      map['apertura_id'] = Variable<int>(aperturaId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (montoBs.present) {
      map['monto_bs'] = Variable<double>(montoBs.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RetiroCajaCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('aperturaId: $aperturaId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('montoBs: $montoBs, ')
          ..write('motivo: $motivo, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $MermaTable extends Merma with TableInfo<$MermaTable, MermaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MermaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _productoNombreMeta =
      const VerificationMeta('productoNombre');
  @override
  late final GeneratedColumn<String> productoNombre = GeneratedColumn<String>(
      'producto_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
      'unidad', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
      'motivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
      'nota', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _costoUsdMeta =
      const VerificationMeta('costoUsd');
  @override
  late final GeneratedColumn<double> costoUsd = GeneratedColumn<double>(
      'costo_usd', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        productoId,
        productoNombre,
        cantidad,
        unidad,
        motivo,
        nota,
        costoUsd,
        usuarioId,
        usuarioNombre,
        fecha
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merma';
  @override
  VerificationContext validateIntegrity(Insertable<MermaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('producto_nombre')) {
      context.handle(
          _productoNombreMeta,
          productoNombre.isAcceptableOrUnknown(
              data['producto_nombre']!, _productoNombreMeta));
    } else if (isInserting) {
      context.missing(_productoNombreMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(_unidadMeta,
          unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta));
    } else if (isInserting) {
      context.missing(_unidadMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(_motivoMeta,
          motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta));
    } else if (isInserting) {
      context.missing(_motivoMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
          _notaMeta, nota.isAcceptableOrUnknown(data['nota']!, _notaMeta));
    }
    if (data.containsKey('costo_usd')) {
      context.handle(_costoUsdMeta,
          costoUsd.isAcceptableOrUnknown(data['costo_usd']!, _costoUsdMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MermaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MermaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      productoNombre: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}producto_nombre'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      unidad: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unidad'])!,
      motivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motivo'])!,
      nota: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nota']),
      costoUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}costo_usd'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
    );
  }

  @override
  $MermaTable createAlias(String alias) {
    return $MermaTable(attachedDatabase, alias);
  }
}

class MermaData extends DataClass implements Insertable<MermaData> {
  final int id;
  final String uuid;
  final int productoId;

  /// Snapshot para el reporte aunque el producto se elimine.
  final String productoNombre;
  final double cantidad;

  /// und / kg / g / lb (heredado del producto).
  final String unidad;

  /// vencido | danado | robo | otro
  final String motivo;
  final String? nota;

  /// Pérdida en $ (costoUsd × cantidad) al momento de registrar.
  final double costoUsd;
  final String usuarioId;
  final String usuarioNombre;
  final int fecha;
  const MermaData(
      {required this.id,
      required this.uuid,
      required this.productoId,
      required this.productoNombre,
      required this.cantidad,
      required this.unidad,
      required this.motivo,
      this.nota,
      required this.costoUsd,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fecha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['producto_id'] = Variable<int>(productoId);
    map['producto_nombre'] = Variable<String>(productoNombre);
    map['cantidad'] = Variable<double>(cantidad);
    map['unidad'] = Variable<String>(unidad);
    map['motivo'] = Variable<String>(motivo);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    map['costo_usd'] = Variable<double>(costoUsd);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha'] = Variable<int>(fecha);
    return map;
  }

  MermaCompanion toCompanion(bool nullToAbsent) {
    return MermaCompanion(
      id: Value(id),
      uuid: Value(uuid),
      productoId: Value(productoId),
      productoNombre: Value(productoNombre),
      cantidad: Value(cantidad),
      unidad: Value(unidad),
      motivo: Value(motivo),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      costoUsd: Value(costoUsd),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fecha: Value(fecha),
    );
  }

  factory MermaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MermaData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      productoId: serializer.fromJson<int>(json['productoId']),
      productoNombre: serializer.fromJson<String>(json['productoNombre']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      unidad: serializer.fromJson<String>(json['unidad']),
      motivo: serializer.fromJson<String>(json['motivo']),
      nota: serializer.fromJson<String?>(json['nota']),
      costoUsd: serializer.fromJson<double>(json['costoUsd']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fecha: serializer.fromJson<int>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'productoId': serializer.toJson<int>(productoId),
      'productoNombre': serializer.toJson<String>(productoNombre),
      'cantidad': serializer.toJson<double>(cantidad),
      'unidad': serializer.toJson<String>(unidad),
      'motivo': serializer.toJson<String>(motivo),
      'nota': serializer.toJson<String?>(nota),
      'costoUsd': serializer.toJson<double>(costoUsd),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fecha': serializer.toJson<int>(fecha),
    };
  }

  MermaData copyWith(
          {int? id,
          String? uuid,
          int? productoId,
          String? productoNombre,
          double? cantidad,
          String? unidad,
          String? motivo,
          Value<String?> nota = const Value.absent(),
          double? costoUsd,
          String? usuarioId,
          String? usuarioNombre,
          int? fecha}) =>
      MermaData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        productoId: productoId ?? this.productoId,
        productoNombre: productoNombre ?? this.productoNombre,
        cantidad: cantidad ?? this.cantidad,
        unidad: unidad ?? this.unidad,
        motivo: motivo ?? this.motivo,
        nota: nota.present ? nota.value : this.nota,
        costoUsd: costoUsd ?? this.costoUsd,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fecha: fecha ?? this.fecha,
      );
  MermaData copyWithCompanion(MermaCompanion data) {
    return MermaData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      productoNombre: data.productoNombre.present
          ? data.productoNombre.value
          : this.productoNombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      nota: data.nota.present ? data.nota.value : this.nota,
      costoUsd: data.costoUsd.present ? data.costoUsd.value : this.costoUsd,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MermaData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('productoId: $productoId, ')
          ..write('productoNombre: $productoNombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('motivo: $motivo, ')
          ..write('nota: $nota, ')
          ..write('costoUsd: $costoUsd, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      productoId,
      productoNombre,
      cantidad,
      unidad,
      motivo,
      nota,
      costoUsd,
      usuarioId,
      usuarioNombre,
      fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MermaData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.productoId == this.productoId &&
          other.productoNombre == this.productoNombre &&
          other.cantidad == this.cantidad &&
          other.unidad == this.unidad &&
          other.motivo == this.motivo &&
          other.nota == this.nota &&
          other.costoUsd == this.costoUsd &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fecha == this.fecha);
}

class MermaCompanion extends UpdateCompanion<MermaData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> productoId;
  final Value<String> productoNombre;
  final Value<double> cantidad;
  final Value<String> unidad;
  final Value<String> motivo;
  final Value<String?> nota;
  final Value<double> costoUsd;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fecha;
  const MermaCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.productoId = const Value.absent(),
    this.productoNombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.unidad = const Value.absent(),
    this.motivo = const Value.absent(),
    this.nota = const Value.absent(),
    this.costoUsd = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  MermaCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int productoId,
    required String productoNombre,
    required double cantidad,
    required String unidad,
    required String motivo,
    this.nota = const Value.absent(),
    this.costoUsd = const Value.absent(),
    required String usuarioId,
    required String usuarioNombre,
    required int fecha,
  })  : uuid = Value(uuid),
        productoId = Value(productoId),
        productoNombre = Value(productoNombre),
        cantidad = Value(cantidad),
        unidad = Value(unidad),
        motivo = Value(motivo),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fecha = Value(fecha);
  static Insertable<MermaData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? productoId,
    Expression<String>? productoNombre,
    Expression<double>? cantidad,
    Expression<String>? unidad,
    Expression<String>? motivo,
    Expression<String>? nota,
    Expression<double>? costoUsd,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (productoId != null) 'producto_id': productoId,
      if (productoNombre != null) 'producto_nombre': productoNombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (unidad != null) 'unidad': unidad,
      if (motivo != null) 'motivo': motivo,
      if (nota != null) 'nota': nota,
      if (costoUsd != null) 'costo_usd': costoUsd,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fecha != null) 'fecha': fecha,
    });
  }

  MermaCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? productoId,
      Value<String>? productoNombre,
      Value<double>? cantidad,
      Value<String>? unidad,
      Value<String>? motivo,
      Value<String?>? nota,
      Value<double>? costoUsd,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fecha}) {
    return MermaCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      productoId: productoId ?? this.productoId,
      productoNombre: productoNombre ?? this.productoNombre,
      cantidad: cantidad ?? this.cantidad,
      unidad: unidad ?? this.unidad,
      motivo: motivo ?? this.motivo,
      nota: nota ?? this.nota,
      costoUsd: costoUsd ?? this.costoUsd,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (productoNombre.present) {
      map['producto_nombre'] = Variable<String>(productoNombre.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (costoUsd.present) {
      map['costo_usd'] = Variable<double>(costoUsd.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MermaCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('productoId: $productoId, ')
          ..write('productoNombre: $productoNombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('unidad: $unidad, ')
          ..write('motivo: $motivo, ')
          ..write('nota: $nota, ')
          ..write('costoUsd: $costoUsd, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $AuditoriaLogTable extends AuditoriaLog
    with TableInfo<$AuditoriaLogTable, AuditoriaLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditoriaLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accionMeta = const VerificationMeta('accion');
  @override
  late final GeneratedColumn<String> accion = GeneratedColumn<String>(
      'accion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detallesMeta =
      const VerificationMeta('detalles');
  @override
  late final GeneratedColumn<String> detalles = GeneratedColumn<String>(
      'detalles', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, usuarioId, usuarioNombre, accion, detalles, fecha];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auditoria_log';
  @override
  VerificationContext validateIntegrity(Insertable<AuditoriaLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('accion')) {
      context.handle(_accionMeta,
          accion.isAcceptableOrUnknown(data['accion']!, _accionMeta));
    } else if (isInserting) {
      context.missing(_accionMeta);
    }
    if (data.containsKey('detalles')) {
      context.handle(_detallesMeta,
          detalles.isAcceptableOrUnknown(data['detalles']!, _detallesMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditoriaLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditoriaLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      accion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}accion'])!,
      detalles: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detalles']),
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
    );
  }

  @override
  $AuditoriaLogTable createAlias(String alias) {
    return $AuditoriaLogTable(attachedDatabase, alias);
  }
}

class AuditoriaLogData extends DataClass
    implements Insertable<AuditoriaLogData> {
  final int id;
  final String uuid;

  /// Snapshot del usuario que hizo la acción (por si se elimina después).
  final String usuarioId;
  final String usuarioNombre;

  /// Código de acción: venta_anulada, producto_creado, caja_apertura, etc.
  final String accion;

  /// Detalles opcionales (ej: motivo de anulación, ID del producto).
  final String? detalles;

  /// Epoch en milisegundos (igual que Merma para consistencia).
  final int fecha;
  const AuditoriaLogData(
      {required this.id,
      required this.uuid,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.accion,
      this.detalles,
      required this.fecha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['accion'] = Variable<String>(accion);
    if (!nullToAbsent || detalles != null) {
      map['detalles'] = Variable<String>(detalles);
    }
    map['fecha'] = Variable<int>(fecha);
    return map;
  }

  AuditoriaLogCompanion toCompanion(bool nullToAbsent) {
    return AuditoriaLogCompanion(
      id: Value(id),
      uuid: Value(uuid),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      accion: Value(accion),
      detalles: detalles == null && nullToAbsent
          ? const Value.absent()
          : Value(detalles),
      fecha: Value(fecha),
    );
  }

  factory AuditoriaLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditoriaLogData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      accion: serializer.fromJson<String>(json['accion']),
      detalles: serializer.fromJson<String?>(json['detalles']),
      fecha: serializer.fromJson<int>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'accion': serializer.toJson<String>(accion),
      'detalles': serializer.toJson<String?>(detalles),
      'fecha': serializer.toJson<int>(fecha),
    };
  }

  AuditoriaLogData copyWith(
          {int? id,
          String? uuid,
          String? usuarioId,
          String? usuarioNombre,
          String? accion,
          Value<String?> detalles = const Value.absent(),
          int? fecha}) =>
      AuditoriaLogData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        accion: accion ?? this.accion,
        detalles: detalles.present ? detalles.value : this.detalles,
        fecha: fecha ?? this.fecha,
      );
  AuditoriaLogData copyWithCompanion(AuditoriaLogCompanion data) {
    return AuditoriaLogData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      accion: data.accion.present ? data.accion.value : this.accion,
      detalles: data.detalles.present ? data.detalles.value : this.detalles,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditoriaLogData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('accion: $accion, ')
          ..write('detalles: $detalles, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, usuarioId, usuarioNombre, accion, detalles, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditoriaLogData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.accion == this.accion &&
          other.detalles == this.detalles &&
          other.fecha == this.fecha);
}

class AuditoriaLogCompanion extends UpdateCompanion<AuditoriaLogData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<String> accion;
  final Value<String?> detalles;
  final Value<int> fecha;
  const AuditoriaLogCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.accion = const Value.absent(),
    this.detalles = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  AuditoriaLogCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String usuarioId,
    required String usuarioNombre,
    required String accion,
    this.detalles = const Value.absent(),
    required int fecha,
  })  : uuid = Value(uuid),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        accion = Value(accion),
        fecha = Value(fecha);
  static Insertable<AuditoriaLogData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<String>? accion,
    Expression<String>? detalles,
    Expression<int>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (accion != null) 'accion': accion,
      if (detalles != null) 'detalles': detalles,
      if (fecha != null) 'fecha': fecha,
    });
  }

  AuditoriaLogCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<String>? accion,
      Value<String?>? detalles,
      Value<int>? fecha}) {
    return AuditoriaLogCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      accion: accion ?? this.accion,
      detalles: detalles ?? this.detalles,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (accion.present) {
      map['accion'] = Variable<String>(accion.value);
    }
    if (detalles.present) {
      map['detalles'] = Variable<String>(detalles.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditoriaLogCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('accion: $accion, ')
          ..write('detalles: $detalles, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _coleccionMeta =
      const VerificationMeta('coleccion');
  @override
  late final GeneratedColumn<String> coleccion = GeneratedColumn<String>(
      'coleccion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _docIdMeta = const VerificationMeta('docId');
  @override
  late final GeneratedColumn<String> docId = GeneratedColumn<String>(
      'doc_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operacionMeta =
      const VerificationMeta('operacion');
  @override
  late final GeneratedColumn<String> operacion = GeneratedColumn<String>(
      'operacion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _intentosMeta =
      const VerificationMeta('intentos');
  @override
  late final GeneratedColumn<int> intentos = GeneratedColumn<int>(
      'intentos', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, coleccion, docId, operacion, payload, timestamp, intentos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('coleccion')) {
      context.handle(_coleccionMeta,
          coleccion.isAcceptableOrUnknown(data['coleccion']!, _coleccionMeta));
    } else if (isInserting) {
      context.missing(_coleccionMeta);
    }
    if (data.containsKey('doc_id')) {
      context.handle(
          _docIdMeta, docId.isAcceptableOrUnknown(data['doc_id']!, _docIdMeta));
    } else if (isInserting) {
      context.missing(_docIdMeta);
    }
    if (data.containsKey('operacion')) {
      context.handle(_operacionMeta,
          operacion.isAcceptableOrUnknown(data['operacion']!, _operacionMeta));
    } else if (isInserting) {
      context.missing(_operacionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('intentos')) {
      context.handle(_intentosMeta,
          intentos.isAcceptableOrUnknown(data['intentos']!, _intentosMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      coleccion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coleccion'])!,
      docId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}doc_id'])!,
      operacion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operacion'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      intentos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}intentos'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;

  /// Colección destino: inventario, ventas, clientes, pagos_fiados,
  /// caja/aperturas, caja/cierres, caja/retiros, merma
  final String coleccion;

  /// uuid del registro local (ID del documento en Firestore)
  final String docId;

  /// set | update | delete
  final String operacion;

  /// JSON con el payload a escribir en Firestore
  final String payload;

  /// Epoch ms de cuándo se encoló (para procesar en orden)
  final int timestamp;

  /// Reintentos fallidos (para diagnóstico)
  final int intentos;
  const SyncQueueData(
      {required this.id,
      required this.coleccion,
      required this.docId,
      required this.operacion,
      required this.payload,
      required this.timestamp,
      required this.intentos});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['coleccion'] = Variable<String>(coleccion);
    map['doc_id'] = Variable<String>(docId);
    map['operacion'] = Variable<String>(operacion);
    map['payload'] = Variable<String>(payload);
    map['timestamp'] = Variable<int>(timestamp);
    map['intentos'] = Variable<int>(intentos);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      coleccion: Value(coleccion),
      docId: Value(docId),
      operacion: Value(operacion),
      payload: Value(payload),
      timestamp: Value(timestamp),
      intentos: Value(intentos),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      coleccion: serializer.fromJson<String>(json['coleccion']),
      docId: serializer.fromJson<String>(json['docId']),
      operacion: serializer.fromJson<String>(json['operacion']),
      payload: serializer.fromJson<String>(json['payload']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      intentos: serializer.fromJson<int>(json['intentos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'coleccion': serializer.toJson<String>(coleccion),
      'docId': serializer.toJson<String>(docId),
      'operacion': serializer.toJson<String>(operacion),
      'payload': serializer.toJson<String>(payload),
      'timestamp': serializer.toJson<int>(timestamp),
      'intentos': serializer.toJson<int>(intentos),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? coleccion,
          String? docId,
          String? operacion,
          String? payload,
          int? timestamp,
          int? intentos}) =>
      SyncQueueData(
        id: id ?? this.id,
        coleccion: coleccion ?? this.coleccion,
        docId: docId ?? this.docId,
        operacion: operacion ?? this.operacion,
        payload: payload ?? this.payload,
        timestamp: timestamp ?? this.timestamp,
        intentos: intentos ?? this.intentos,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      coleccion: data.coleccion.present ? data.coleccion.value : this.coleccion,
      docId: data.docId.present ? data.docId.value : this.docId,
      operacion: data.operacion.present ? data.operacion.value : this.operacion,
      payload: data.payload.present ? data.payload.value : this.payload,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      intentos: data.intentos.present ? data.intentos.value : this.intentos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('coleccion: $coleccion, ')
          ..write('docId: $docId, ')
          ..write('operacion: $operacion, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp, ')
          ..write('intentos: $intentos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, coleccion, docId, operacion, payload, timestamp, intentos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.coleccion == this.coleccion &&
          other.docId == this.docId &&
          other.operacion == this.operacion &&
          other.payload == this.payload &&
          other.timestamp == this.timestamp &&
          other.intentos == this.intentos);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> coleccion;
  final Value<String> docId;
  final Value<String> operacion;
  final Value<String> payload;
  final Value<int> timestamp;
  final Value<int> intentos;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.coleccion = const Value.absent(),
    this.docId = const Value.absent(),
    this.operacion = const Value.absent(),
    this.payload = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.intentos = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String coleccion,
    required String docId,
    required String operacion,
    required String payload,
    required int timestamp,
    this.intentos = const Value.absent(),
  })  : coleccion = Value(coleccion),
        docId = Value(docId),
        operacion = Value(operacion),
        payload = Value(payload),
        timestamp = Value(timestamp);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? coleccion,
    Expression<String>? docId,
    Expression<String>? operacion,
    Expression<String>? payload,
    Expression<int>? timestamp,
    Expression<int>? intentos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (coleccion != null) 'coleccion': coleccion,
      if (docId != null) 'doc_id': docId,
      if (operacion != null) 'operacion': operacion,
      if (payload != null) 'payload': payload,
      if (timestamp != null) 'timestamp': timestamp,
      if (intentos != null) 'intentos': intentos,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? coleccion,
      Value<String>? docId,
      Value<String>? operacion,
      Value<String>? payload,
      Value<int>? timestamp,
      Value<int>? intentos}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      coleccion: coleccion ?? this.coleccion,
      docId: docId ?? this.docId,
      operacion: operacion ?? this.operacion,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      intentos: intentos ?? this.intentos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (coleccion.present) {
      map['coleccion'] = Variable<String>(coleccion.value);
    }
    if (docId.present) {
      map['doc_id'] = Variable<String>(docId.value);
    }
    if (operacion.present) {
      map['operacion'] = Variable<String>(operacion.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (intentos.present) {
      map['intentos'] = Variable<int>(intentos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('coleccion: $coleccion, ')
          ..write('docId: $docId, ')
          ..write('operacion: $operacion, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp, ')
          ..write('intentos: $intentos')
          ..write(')'))
        .toString();
  }
}

class $GastoTable extends Gasto with TableInfo<$GastoTable, GastoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GastoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _categoriaMeta =
      const VerificationMeta('categoria');
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
      'categoria', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoUsdMeta =
      const VerificationMeta('montoUsd');
  @override
  late final GeneratedColumn<double> montoUsd = GeneratedColumn<double>(
      'monto_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tasaMeta = const VerificationMeta('tasa');
  @override
  late final GeneratedColumn<double> tasa = GeneratedColumn<double>(
      'tasa', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        categoria,
        descripcion,
        montoUsd,
        tasa,
        fecha,
        usuarioId,
        usuarioNombre,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gasto';
  @override
  VerificationContext validateIntegrity(Insertable<GastoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(_categoriaMeta,
          categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta));
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('monto_usd')) {
      context.handle(_montoUsdMeta,
          montoUsd.isAcceptableOrUnknown(data['monto_usd']!, _montoUsdMeta));
    } else if (isInserting) {
      context.missing(_montoUsdMeta);
    }
    if (data.containsKey('tasa')) {
      context.handle(
          _tasaMeta, tasa.isAcceptableOrUnknown(data['tasa']!, _tasaMeta));
    } else if (isInserting) {
      context.missing(_tasaMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GastoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GastoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      categoria: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      montoUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_usd'])!,
      tasa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $GastoTable createAlias(String alias) {
    return $GastoTable(attachedDatabase, alias);
  }
}

class GastoData extends DataClass implements Insertable<GastoData> {
  final int id;
  final String uuid;
  final String categoria;
  final String descripcion;
  final double montoUsd;
  final double tasa;
  final int fecha;
  final String usuarioId;
  final String usuarioNombre;
  final int fechaCreacion;
  final int fechaActualizacion;
  const GastoData(
      {required this.id,
      required this.uuid,
      required this.categoria,
      required this.descripcion,
      required this.montoUsd,
      required this.tasa,
      required this.fecha,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['categoria'] = Variable<String>(categoria);
    map['descripcion'] = Variable<String>(descripcion);
    map['monto_usd'] = Variable<double>(montoUsd);
    map['tasa'] = Variable<double>(tasa);
    map['fecha'] = Variable<int>(fecha);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  GastoCompanion toCompanion(bool nullToAbsent) {
    return GastoCompanion(
      id: Value(id),
      uuid: Value(uuid),
      categoria: Value(categoria),
      descripcion: Value(descripcion),
      montoUsd: Value(montoUsd),
      tasa: Value(tasa),
      fecha: Value(fecha),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory GastoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GastoData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      categoria: serializer.fromJson<String>(json['categoria']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      montoUsd: serializer.fromJson<double>(json['montoUsd']),
      tasa: serializer.fromJson<double>(json['tasa']),
      fecha: serializer.fromJson<int>(json['fecha']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'categoria': serializer.toJson<String>(categoria),
      'descripcion': serializer.toJson<String>(descripcion),
      'montoUsd': serializer.toJson<double>(montoUsd),
      'tasa': serializer.toJson<double>(tasa),
      'fecha': serializer.toJson<int>(fecha),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  GastoData copyWith(
          {int? id,
          String? uuid,
          String? categoria,
          String? descripcion,
          double? montoUsd,
          double? tasa,
          int? fecha,
          String? usuarioId,
          String? usuarioNombre,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      GastoData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        categoria: categoria ?? this.categoria,
        descripcion: descripcion ?? this.descripcion,
        montoUsd: montoUsd ?? this.montoUsd,
        tasa: tasa ?? this.tasa,
        fecha: fecha ?? this.fecha,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  GastoData copyWithCompanion(GastoCompanion data) {
    return GastoData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      montoUsd: data.montoUsd.present ? data.montoUsd.value : this.montoUsd,
      tasa: data.tasa.present ? data.tasa.value : this.tasa,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GastoData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('categoria: $categoria, ')
          ..write('descripcion: $descripcion, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('tasa: $tasa, ')
          ..write('fecha: $fecha, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, categoria, descripcion, montoUsd,
      tasa, fecha, usuarioId, usuarioNombre, fechaCreacion, fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GastoData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.categoria == this.categoria &&
          other.descripcion == this.descripcion &&
          other.montoUsd == this.montoUsd &&
          other.tasa == this.tasa &&
          other.fecha == this.fecha &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class GastoCompanion extends UpdateCompanion<GastoData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> categoria;
  final Value<String> descripcion;
  final Value<double> montoUsd;
  final Value<double> tasa;
  final Value<int> fecha;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const GastoCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.categoria = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.montoUsd = const Value.absent(),
    this.tasa = const Value.absent(),
    this.fecha = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  GastoCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String categoria,
    required String descripcion,
    required double montoUsd,
    required double tasa,
    required int fecha,
    required String usuarioId,
    required String usuarioNombre,
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        categoria = Value(categoria),
        descripcion = Value(descripcion),
        montoUsd = Value(montoUsd),
        tasa = Value(tasa),
        fecha = Value(fecha),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<GastoData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? categoria,
    Expression<String>? descripcion,
    Expression<double>? montoUsd,
    Expression<double>? tasa,
    Expression<int>? fecha,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (categoria != null) 'categoria': categoria,
      if (descripcion != null) 'descripcion': descripcion,
      if (montoUsd != null) 'monto_usd': montoUsd,
      if (tasa != null) 'tasa': tasa,
      if (fecha != null) 'fecha': fecha,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  GastoCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? categoria,
      Value<String>? descripcion,
      Value<double>? montoUsd,
      Value<double>? tasa,
      Value<int>? fecha,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return GastoCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      montoUsd: montoUsd ?? this.montoUsd,
      tasa: tasa ?? this.tasa,
      fecha: fecha ?? this.fecha,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (montoUsd.present) {
      map['monto_usd'] = Variable<double>(montoUsd.value);
    }
    if (tasa.present) {
      map['tasa'] = Variable<double>(tasa.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GastoCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('categoria: $categoria, ')
          ..write('descripcion: $descripcion, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('tasa: $tasa, ')
          ..write('fecha: $fecha, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $NotaCreditoTable extends NotaCredito
    with TableInfo<$NotaCreditoTable, NotaCreditoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotaCreditoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _ventaUuidMeta =
      const VerificationMeta('ventaUuid');
  @override
  late final GeneratedColumn<String> ventaUuid = GeneratedColumn<String>(
      'venta_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ventaNumeroMeta =
      const VerificationMeta('ventaNumero');
  @override
  late final GeneratedColumn<int> ventaNumero = GeneratedColumn<int>(
      'venta_numero', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoUsdMeta =
      const VerificationMeta('montoUsd');
  @override
  late final GeneratedColumn<double> montoUsd = GeneratedColumn<double>(
      'monto_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _montoBsMeta =
      const VerificationMeta('montoBs');
  @override
  late final GeneratedColumn<double> montoBs = GeneratedColumn<double>(
      'monto_bs', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tasaMeta = const VerificationMeta('tasa');
  @override
  late final GeneratedColumn<double> tasa = GeneratedColumn<double>(
      'tasa', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  @override
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
      'motivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        ventaUuid,
        ventaNumero,
        tipo,
        itemsJson,
        montoUsd,
        montoBs,
        tasa,
        motivo,
        usuarioId,
        usuarioNombre,
        fecha,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nota_credito';
  @override
  VerificationContext validateIntegrity(Insertable<NotaCreditoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('venta_uuid')) {
      context.handle(_ventaUuidMeta,
          ventaUuid.isAcceptableOrUnknown(data['venta_uuid']!, _ventaUuidMeta));
    } else if (isInserting) {
      context.missing(_ventaUuidMeta);
    }
    if (data.containsKey('venta_numero')) {
      context.handle(
          _ventaNumeroMeta,
          ventaNumero.isAcceptableOrUnknown(
              data['venta_numero']!, _ventaNumeroMeta));
    } else if (isInserting) {
      context.missing(_ventaNumeroMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('monto_usd')) {
      context.handle(_montoUsdMeta,
          montoUsd.isAcceptableOrUnknown(data['monto_usd']!, _montoUsdMeta));
    } else if (isInserting) {
      context.missing(_montoUsdMeta);
    }
    if (data.containsKey('monto_bs')) {
      context.handle(_montoBsMeta,
          montoBs.isAcceptableOrUnknown(data['monto_bs']!, _montoBsMeta));
    } else if (isInserting) {
      context.missing(_montoBsMeta);
    }
    if (data.containsKey('tasa')) {
      context.handle(
          _tasaMeta, tasa.isAcceptableOrUnknown(data['tasa']!, _tasaMeta));
    } else if (isInserting) {
      context.missing(_tasaMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(_motivoMeta,
          motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta));
    } else if (isInserting) {
      context.missing(_motivoMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotaCreditoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotaCreditoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      ventaUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}venta_uuid'])!,
      ventaNumero: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}venta_numero'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      montoUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_usd'])!,
      montoBs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_bs'])!,
      tasa: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tasa'])!,
      motivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}motivo'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $NotaCreditoTable createAlias(String alias) {
    return $NotaCreditoTable(attachedDatabase, alias);
  }
}

class NotaCreditoData extends DataClass implements Insertable<NotaCreditoData> {
  final int id;
  final String uuid;
  final String ventaUuid;
  final int ventaNumero;
  final String tipo;
  final String itemsJson;
  final double montoUsd;
  final double montoBs;
  final double tasa;
  final String motivo;
  final String usuarioId;
  final String usuarioNombre;
  final int fecha;
  final int fechaCreacion;
  final int fechaActualizacion;
  const NotaCreditoData(
      {required this.id,
      required this.uuid,
      required this.ventaUuid,
      required this.ventaNumero,
      required this.tipo,
      required this.itemsJson,
      required this.montoUsd,
      required this.montoBs,
      required this.tasa,
      required this.motivo,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fecha,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['venta_uuid'] = Variable<String>(ventaUuid);
    map['venta_numero'] = Variable<int>(ventaNumero);
    map['tipo'] = Variable<String>(tipo);
    map['items_json'] = Variable<String>(itemsJson);
    map['monto_usd'] = Variable<double>(montoUsd);
    map['monto_bs'] = Variable<double>(montoBs);
    map['tasa'] = Variable<double>(tasa);
    map['motivo'] = Variable<String>(motivo);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha'] = Variable<int>(fecha);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  NotaCreditoCompanion toCompanion(bool nullToAbsent) {
    return NotaCreditoCompanion(
      id: Value(id),
      uuid: Value(uuid),
      ventaUuid: Value(ventaUuid),
      ventaNumero: Value(ventaNumero),
      tipo: Value(tipo),
      itemsJson: Value(itemsJson),
      montoUsd: Value(montoUsd),
      montoBs: Value(montoBs),
      tasa: Value(tasa),
      motivo: Value(motivo),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fecha: Value(fecha),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory NotaCreditoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotaCreditoData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      ventaUuid: serializer.fromJson<String>(json['ventaUuid']),
      ventaNumero: serializer.fromJson<int>(json['ventaNumero']),
      tipo: serializer.fromJson<String>(json['tipo']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      montoUsd: serializer.fromJson<double>(json['montoUsd']),
      montoBs: serializer.fromJson<double>(json['montoBs']),
      tasa: serializer.fromJson<double>(json['tasa']),
      motivo: serializer.fromJson<String>(json['motivo']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fecha: serializer.fromJson<int>(json['fecha']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'ventaUuid': serializer.toJson<String>(ventaUuid),
      'ventaNumero': serializer.toJson<int>(ventaNumero),
      'tipo': serializer.toJson<String>(tipo),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'montoUsd': serializer.toJson<double>(montoUsd),
      'montoBs': serializer.toJson<double>(montoBs),
      'tasa': serializer.toJson<double>(tasa),
      'motivo': serializer.toJson<String>(motivo),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fecha': serializer.toJson<int>(fecha),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  NotaCreditoData copyWith(
          {int? id,
          String? uuid,
          String? ventaUuid,
          int? ventaNumero,
          String? tipo,
          String? itemsJson,
          double? montoUsd,
          double? montoBs,
          double? tasa,
          String? motivo,
          String? usuarioId,
          String? usuarioNombre,
          int? fecha,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      NotaCreditoData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        ventaUuid: ventaUuid ?? this.ventaUuid,
        ventaNumero: ventaNumero ?? this.ventaNumero,
        tipo: tipo ?? this.tipo,
        itemsJson: itemsJson ?? this.itemsJson,
        montoUsd: montoUsd ?? this.montoUsd,
        montoBs: montoBs ?? this.montoBs,
        tasa: tasa ?? this.tasa,
        motivo: motivo ?? this.motivo,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fecha: fecha ?? this.fecha,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  NotaCreditoData copyWithCompanion(NotaCreditoCompanion data) {
    return NotaCreditoData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      ventaUuid: data.ventaUuid.present ? data.ventaUuid.value : this.ventaUuid,
      ventaNumero:
          data.ventaNumero.present ? data.ventaNumero.value : this.ventaNumero,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      montoUsd: data.montoUsd.present ? data.montoUsd.value : this.montoUsd,
      montoBs: data.montoBs.present ? data.montoBs.value : this.montoBs,
      tasa: data.tasa.present ? data.tasa.value : this.tasa,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotaCreditoData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('ventaUuid: $ventaUuid, ')
          ..write('ventaNumero: $ventaNumero, ')
          ..write('tipo: $tipo, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('montoBs: $montoBs, ')
          ..write('tasa: $tasa, ')
          ..write('motivo: $motivo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      ventaUuid,
      ventaNumero,
      tipo,
      itemsJson,
      montoUsd,
      montoBs,
      tasa,
      motivo,
      usuarioId,
      usuarioNombre,
      fecha,
      fechaCreacion,
      fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotaCreditoData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.ventaUuid == this.ventaUuid &&
          other.ventaNumero == this.ventaNumero &&
          other.tipo == this.tipo &&
          other.itemsJson == this.itemsJson &&
          other.montoUsd == this.montoUsd &&
          other.montoBs == this.montoBs &&
          other.tasa == this.tasa &&
          other.motivo == this.motivo &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fecha == this.fecha &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class NotaCreditoCompanion extends UpdateCompanion<NotaCreditoData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> ventaUuid;
  final Value<int> ventaNumero;
  final Value<String> tipo;
  final Value<String> itemsJson;
  final Value<double> montoUsd;
  final Value<double> montoBs;
  final Value<double> tasa;
  final Value<String> motivo;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fecha;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const NotaCreditoCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.ventaUuid = const Value.absent(),
    this.ventaNumero = const Value.absent(),
    this.tipo = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.montoUsd = const Value.absent(),
    this.montoBs = const Value.absent(),
    this.tasa = const Value.absent(),
    this.motivo = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fecha = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  NotaCreditoCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String ventaUuid,
    required int ventaNumero,
    required String tipo,
    required String itemsJson,
    required double montoUsd,
    required double montoBs,
    required double tasa,
    required String motivo,
    required String usuarioId,
    required String usuarioNombre,
    required int fecha,
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        ventaUuid = Value(ventaUuid),
        ventaNumero = Value(ventaNumero),
        tipo = Value(tipo),
        itemsJson = Value(itemsJson),
        montoUsd = Value(montoUsd),
        montoBs = Value(montoBs),
        tasa = Value(tasa),
        motivo = Value(motivo),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fecha = Value(fecha),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<NotaCreditoData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? ventaUuid,
    Expression<int>? ventaNumero,
    Expression<String>? tipo,
    Expression<String>? itemsJson,
    Expression<double>? montoUsd,
    Expression<double>? montoBs,
    Expression<double>? tasa,
    Expression<String>? motivo,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fecha,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (ventaUuid != null) 'venta_uuid': ventaUuid,
      if (ventaNumero != null) 'venta_numero': ventaNumero,
      if (tipo != null) 'tipo': tipo,
      if (itemsJson != null) 'items_json': itemsJson,
      if (montoUsd != null) 'monto_usd': montoUsd,
      if (montoBs != null) 'monto_bs': montoBs,
      if (tasa != null) 'tasa': tasa,
      if (motivo != null) 'motivo': motivo,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fecha != null) 'fecha': fecha,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  NotaCreditoCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? ventaUuid,
      Value<int>? ventaNumero,
      Value<String>? tipo,
      Value<String>? itemsJson,
      Value<double>? montoUsd,
      Value<double>? montoBs,
      Value<double>? tasa,
      Value<String>? motivo,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fecha,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return NotaCreditoCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ventaUuid: ventaUuid ?? this.ventaUuid,
      ventaNumero: ventaNumero ?? this.ventaNumero,
      tipo: tipo ?? this.tipo,
      itemsJson: itemsJson ?? this.itemsJson,
      montoUsd: montoUsd ?? this.montoUsd,
      montoBs: montoBs ?? this.montoBs,
      tasa: tasa ?? this.tasa,
      motivo: motivo ?? this.motivo,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fecha: fecha ?? this.fecha,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (ventaUuid.present) {
      map['venta_uuid'] = Variable<String>(ventaUuid.value);
    }
    if (ventaNumero.present) {
      map['venta_numero'] = Variable<int>(ventaNumero.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (montoUsd.present) {
      map['monto_usd'] = Variable<double>(montoUsd.value);
    }
    if (montoBs.present) {
      map['monto_bs'] = Variable<double>(montoBs.value);
    }
    if (tasa.present) {
      map['tasa'] = Variable<double>(tasa.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotaCreditoCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('ventaUuid: $ventaUuid, ')
          ..write('ventaNumero: $ventaNumero, ')
          ..write('tipo: $tipo, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('montoBs: $montoBs, ')
          ..write('tasa: $tasa, ')
          ..write('motivo: $motivo, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $CategoriaTable extends Categoria
    with TableInfo<$CategoriaTable, CategoriaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
      'orden', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        nombre,
        orden,
        usuarioId,
        usuarioNombre,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categoria';
  @override
  VerificationContext validateIntegrity(Insertable<CategoriaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('orden')) {
      context.handle(
          _ordenMeta, orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta));
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      orden: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orden'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $CategoriaTable createAlias(String alias) {
    return $CategoriaTable(attachedDatabase, alias);
  }
}

class CategoriaData extends DataClass implements Insertable<CategoriaData> {
  final int id;
  final String uuid;
  final String nombre;
  final int orden;
  final String usuarioId;
  final String usuarioNombre;
  final int fechaCreacion;
  final int fechaActualizacion;
  const CategoriaData(
      {required this.id,
      required this.uuid,
      required this.nombre,
      required this.orden,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['nombre'] = Variable<String>(nombre);
    map['orden'] = Variable<int>(orden);
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  CategoriaCompanion toCompanion(bool nullToAbsent) {
    return CategoriaCompanion(
      id: Value(id),
      uuid: Value(uuid),
      nombre: Value(nombre),
      orden: Value(orden),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory CategoriaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriaData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nombre: serializer.fromJson<String>(json['nombre']),
      orden: serializer.fromJson<int>(json['orden']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'nombre': serializer.toJson<String>(nombre),
      'orden': serializer.toJson<int>(orden),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  CategoriaData copyWith(
          {int? id,
          String? uuid,
          String? nombre,
          int? orden,
          String? usuarioId,
          String? usuarioNombre,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      CategoriaData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        nombre: nombre ?? this.nombre,
        orden: orden ?? this.orden,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  CategoriaData copyWithCompanion(CategoriaCompanion data) {
    return CategoriaData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      orden: data.orden.present ? data.orden.value : this.orden,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('orden: $orden, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, nombre, orden, usuarioId,
      usuarioNombre, fechaCreacion, fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriaData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.nombre == this.nombre &&
          other.orden == this.orden &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class CategoriaCompanion extends UpdateCompanion<CategoriaData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> nombre;
  final Value<int> orden;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const CategoriaCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nombre = const Value.absent(),
    this.orden = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  CategoriaCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String nombre,
    required int orden,
    required String usuarioId,
    required String usuarioNombre,
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        nombre = Value(nombre),
        orden = Value(orden),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<CategoriaData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? nombre,
    Expression<int>? orden,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (nombre != null) 'nombre': nombre,
      if (orden != null) 'orden': orden,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  CategoriaCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? nombre,
      Value<int>? orden,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return CategoriaCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nombre: nombre ?? this.nombre,
      orden: orden ?? this.orden,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('orden: $orden, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $ProveedorTable extends Proveedor
    with TableInfo<$ProveedorTable, ProveedorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProveedorTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rifMeta = const VerificationMeta('rif');
  @override
  late final GeneratedColumn<String> rif = GeneratedColumn<String>(
      'rif', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _correoMeta = const VerificationMeta('correo');
  @override
  late final GeneratedColumn<String> correo = GeneratedColumn<String>(
      'correo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _direccionMeta =
      const VerificationMeta('direccion');
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
      'direccion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactoMeta =
      const VerificationMeta('contacto');
  @override
  late final GeneratedColumn<String> contacto = GeneratedColumn<String>(
      'contacto', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _saldoPendienteUsdMeta =
      const VerificationMeta('saldoPendienteUsd');
  @override
  late final GeneratedColumn<double> saldoPendienteUsd =
      GeneratedColumn<double>('saldo_pendiente_usd', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
      'notas', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        nombre,
        rif,
        telefono,
        correo,
        direccion,
        contacto,
        saldoPendienteUsd,
        notas,
        usuarioId,
        usuarioNombre,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedor';
  @override
  VerificationContext validateIntegrity(Insertable<ProveedorData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('rif')) {
      context.handle(
          _rifMeta, rif.isAcceptableOrUnknown(data['rif']!, _rifMeta));
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('correo')) {
      context.handle(_correoMeta,
          correo.isAcceptableOrUnknown(data['correo']!, _correoMeta));
    }
    if (data.containsKey('direccion')) {
      context.handle(_direccionMeta,
          direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta));
    }
    if (data.containsKey('contacto')) {
      context.handle(_contactoMeta,
          contacto.isAcceptableOrUnknown(data['contacto']!, _contactoMeta));
    }
    if (data.containsKey('saldo_pendiente_usd')) {
      context.handle(
          _saldoPendienteUsdMeta,
          saldoPendienteUsd.isAcceptableOrUnknown(
              data['saldo_pendiente_usd']!, _saldoPendienteUsdMeta));
    }
    if (data.containsKey('notas')) {
      context.handle(
          _notasMeta, notas.isAcceptableOrUnknown(data['notas']!, _notasMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProveedorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProveedorData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      rif: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rif']),
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono']),
      correo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}correo']),
      direccion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direccion']),
      contacto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contacto']),
      saldoPendienteUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}saldo_pendiente_usd'])!,
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $ProveedorTable createAlias(String alias) {
    return $ProveedorTable(attachedDatabase, alias);
  }
}

class ProveedorData extends DataClass implements Insertable<ProveedorData> {
  final int id;
  final String uuid;
  final String nombre;
  final String? rif;
  final String? telefono;
  final String? correo;
  final String? direccion;
  final String? contacto;
  final double saldoPendienteUsd;
  final String? notas;
  final String usuarioId;
  final String usuarioNombre;
  final int fechaCreacion;
  final int fechaActualizacion;
  const ProveedorData(
      {required this.id,
      required this.uuid,
      required this.nombre,
      this.rif,
      this.telefono,
      this.correo,
      this.direccion,
      this.contacto,
      required this.saldoPendienteUsd,
      this.notas,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || rif != null) {
      map['rif'] = Variable<String>(rif);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || correo != null) {
      map['correo'] = Variable<String>(correo);
    }
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || contacto != null) {
      map['contacto'] = Variable<String>(contacto);
    }
    map['saldo_pendiente_usd'] = Variable<double>(saldoPendienteUsd);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  ProveedorCompanion toCompanion(bool nullToAbsent) {
    return ProveedorCompanion(
      id: Value(id),
      uuid: Value(uuid),
      nombre: Value(nombre),
      rif: rif == null && nullToAbsent ? const Value.absent() : Value(rif),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      correo:
          correo == null && nullToAbsent ? const Value.absent() : Value(correo),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      contacto: contacto == null && nullToAbsent
          ? const Value.absent()
          : Value(contacto),
      saldoPendienteUsd: Value(saldoPendienteUsd),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory ProveedorData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProveedorData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      nombre: serializer.fromJson<String>(json['nombre']),
      rif: serializer.fromJson<String?>(json['rif']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      correo: serializer.fromJson<String?>(json['correo']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      contacto: serializer.fromJson<String?>(json['contacto']),
      saldoPendienteUsd: serializer.fromJson<double>(json['saldoPendienteUsd']),
      notas: serializer.fromJson<String?>(json['notas']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'nombre': serializer.toJson<String>(nombre),
      'rif': serializer.toJson<String?>(rif),
      'telefono': serializer.toJson<String?>(telefono),
      'correo': serializer.toJson<String?>(correo),
      'direccion': serializer.toJson<String?>(direccion),
      'contacto': serializer.toJson<String?>(contacto),
      'saldoPendienteUsd': serializer.toJson<double>(saldoPendienteUsd),
      'notas': serializer.toJson<String?>(notas),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  ProveedorData copyWith(
          {int? id,
          String? uuid,
          String? nombre,
          Value<String?> rif = const Value.absent(),
          Value<String?> telefono = const Value.absent(),
          Value<String?> correo = const Value.absent(),
          Value<String?> direccion = const Value.absent(),
          Value<String?> contacto = const Value.absent(),
          double? saldoPendienteUsd,
          Value<String?> notas = const Value.absent(),
          String? usuarioId,
          String? usuarioNombre,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      ProveedorData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        nombre: nombre ?? this.nombre,
        rif: rif.present ? rif.value : this.rif,
        telefono: telefono.present ? telefono.value : this.telefono,
        correo: correo.present ? correo.value : this.correo,
        direccion: direccion.present ? direccion.value : this.direccion,
        contacto: contacto.present ? contacto.value : this.contacto,
        saldoPendienteUsd: saldoPendienteUsd ?? this.saldoPendienteUsd,
        notas: notas.present ? notas.value : this.notas,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  ProveedorData copyWithCompanion(ProveedorCompanion data) {
    return ProveedorData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      rif: data.rif.present ? data.rif.value : this.rif,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      correo: data.correo.present ? data.correo.value : this.correo,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      contacto: data.contacto.present ? data.contacto.value : this.contacto,
      saldoPendienteUsd: data.saldoPendienteUsd.present
          ? data.saldoPendienteUsd.value
          : this.saldoPendienteUsd,
      notas: data.notas.present ? data.notas.value : this.notas,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProveedorData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('rif: $rif, ')
          ..write('telefono: $telefono, ')
          ..write('correo: $correo, ')
          ..write('direccion: $direccion, ')
          ..write('contacto: $contacto, ')
          ..write('saldoPendienteUsd: $saldoPendienteUsd, ')
          ..write('notas: $notas, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      nombre,
      rif,
      telefono,
      correo,
      direccion,
      contacto,
      saldoPendienteUsd,
      notas,
      usuarioId,
      usuarioNombre,
      fechaCreacion,
      fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProveedorData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.nombre == this.nombre &&
          other.rif == this.rif &&
          other.telefono == this.telefono &&
          other.correo == this.correo &&
          other.direccion == this.direccion &&
          other.contacto == this.contacto &&
          other.saldoPendienteUsd == this.saldoPendienteUsd &&
          other.notas == this.notas &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class ProveedorCompanion extends UpdateCompanion<ProveedorData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> nombre;
  final Value<String?> rif;
  final Value<String?> telefono;
  final Value<String?> correo;
  final Value<String?> direccion;
  final Value<String?> contacto;
  final Value<double> saldoPendienteUsd;
  final Value<String?> notas;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const ProveedorCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.nombre = const Value.absent(),
    this.rif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.correo = const Value.absent(),
    this.direccion = const Value.absent(),
    this.contacto = const Value.absent(),
    this.saldoPendienteUsd = const Value.absent(),
    this.notas = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  ProveedorCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String nombre,
    this.rif = const Value.absent(),
    this.telefono = const Value.absent(),
    this.correo = const Value.absent(),
    this.direccion = const Value.absent(),
    this.contacto = const Value.absent(),
    this.saldoPendienteUsd = const Value.absent(),
    this.notas = const Value.absent(),
    required String usuarioId,
    required String usuarioNombre,
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        nombre = Value(nombre),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<ProveedorData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? nombre,
    Expression<String>? rif,
    Expression<String>? telefono,
    Expression<String>? correo,
    Expression<String>? direccion,
    Expression<String>? contacto,
    Expression<double>? saldoPendienteUsd,
    Expression<String>? notas,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (nombre != null) 'nombre': nombre,
      if (rif != null) 'rif': rif,
      if (telefono != null) 'telefono': telefono,
      if (correo != null) 'correo': correo,
      if (direccion != null) 'direccion': direccion,
      if (contacto != null) 'contacto': contacto,
      if (saldoPendienteUsd != null) 'saldo_pendiente_usd': saldoPendienteUsd,
      if (notas != null) 'notas': notas,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  ProveedorCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? nombre,
      Value<String?>? rif,
      Value<String?>? telefono,
      Value<String?>? correo,
      Value<String?>? direccion,
      Value<String?>? contacto,
      Value<double>? saldoPendienteUsd,
      Value<String?>? notas,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return ProveedorCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nombre: nombre ?? this.nombre,
      rif: rif ?? this.rif,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      direccion: direccion ?? this.direccion,
      contacto: contacto ?? this.contacto,
      saldoPendienteUsd: saldoPendienteUsd ?? this.saldoPendienteUsd,
      notas: notas ?? this.notas,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (rif.present) {
      map['rif'] = Variable<String>(rif.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (correo.present) {
      map['correo'] = Variable<String>(correo.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (contacto.present) {
      map['contacto'] = Variable<String>(contacto.value);
    }
    if (saldoPendienteUsd.present) {
      map['saldo_pendiente_usd'] = Variable<double>(saldoPendienteUsd.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProveedorCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('nombre: $nombre, ')
          ..write('rif: $rif, ')
          ..write('telefono: $telefono, ')
          ..write('correo: $correo, ')
          ..write('direccion: $direccion, ')
          ..write('contacto: $contacto, ')
          ..write('saldoPendienteUsd: $saldoPendienteUsd, ')
          ..write('notas: $notas, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $CompraTable extends Compra with TableInfo<$CompraTable, CompraData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompraTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _proveedorUuidMeta =
      const VerificationMeta('proveedorUuid');
  @override
  late final GeneratedColumn<String> proveedorUuid = GeneratedColumn<String>(
      'proveedor_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _proveedorNombreMeta =
      const VerificationMeta('proveedorNombre');
  @override
  late final GeneratedColumn<String> proveedorNombre = GeneratedColumn<String>(
      'proveedor_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numeroFacturaMeta =
      const VerificationMeta('numeroFactura');
  @override
  late final GeneratedColumn<String> numeroFactura = GeneratedColumn<String>(
      'numero_factura', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalUsdMeta =
      const VerificationMeta('totalUsd');
  @override
  late final GeneratedColumn<double> totalUsd = GeneratedColumn<double>(
      'total_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metodoPagoMeta =
      const VerificationMeta('metodoPago');
  @override
  late final GeneratedColumn<String> metodoPago = GeneratedColumn<String>(
      'metodo_pago', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pagadoUsdMeta =
      const VerificationMeta('pagadoUsd');
  @override
  late final GeneratedColumn<double> pagadoUsd = GeneratedColumn<double>(
      'pagado_usd', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _afectaSaldoMeta =
      const VerificationMeta('afectaSaldo');
  @override
  late final GeneratedColumn<bool> afectaSaldo = GeneratedColumn<bool>(
      'afecta_saldo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("afecta_saldo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
      'notas', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        proveedorUuid,
        proveedorNombre,
        numeroFactura,
        totalUsd,
        itemsJson,
        metodoPago,
        pagadoUsd,
        afectaSaldo,
        notas,
        usuarioId,
        usuarioNombre,
        fecha,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compra';
  @override
  VerificationContext validateIntegrity(Insertable<CompraData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('proveedor_uuid')) {
      context.handle(
          _proveedorUuidMeta,
          proveedorUuid.isAcceptableOrUnknown(
              data['proveedor_uuid']!, _proveedorUuidMeta));
    } else if (isInserting) {
      context.missing(_proveedorUuidMeta);
    }
    if (data.containsKey('proveedor_nombre')) {
      context.handle(
          _proveedorNombreMeta,
          proveedorNombre.isAcceptableOrUnknown(
              data['proveedor_nombre']!, _proveedorNombreMeta));
    } else if (isInserting) {
      context.missing(_proveedorNombreMeta);
    }
    if (data.containsKey('numero_factura')) {
      context.handle(
          _numeroFacturaMeta,
          numeroFactura.isAcceptableOrUnknown(
              data['numero_factura']!, _numeroFacturaMeta));
    }
    if (data.containsKey('total_usd')) {
      context.handle(_totalUsdMeta,
          totalUsd.isAcceptableOrUnknown(data['total_usd']!, _totalUsdMeta));
    } else if (isInserting) {
      context.missing(_totalUsdMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('metodo_pago')) {
      context.handle(
          _metodoPagoMeta,
          metodoPago.isAcceptableOrUnknown(
              data['metodo_pago']!, _metodoPagoMeta));
    } else if (isInserting) {
      context.missing(_metodoPagoMeta);
    }
    if (data.containsKey('pagado_usd')) {
      context.handle(_pagadoUsdMeta,
          pagadoUsd.isAcceptableOrUnknown(data['pagado_usd']!, _pagadoUsdMeta));
    }
    if (data.containsKey('afecta_saldo')) {
      context.handle(
          _afectaSaldoMeta,
          afectaSaldo.isAcceptableOrUnknown(
              data['afecta_saldo']!, _afectaSaldoMeta));
    }
    if (data.containsKey('notas')) {
      context.handle(
          _notasMeta, notas.isAcceptableOrUnknown(data['notas']!, _notasMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompraData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompraData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      proveedorUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}proveedor_uuid'])!,
      proveedorNombre: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}proveedor_nombre'])!,
      numeroFactura: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero_factura']),
      totalUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_usd'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      metodoPago: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metodo_pago'])!,
      pagadoUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pagado_usd'])!,
      afectaSaldo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}afecta_saldo'])!,
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $CompraTable createAlias(String alias) {
    return $CompraTable(attachedDatabase, alias);
  }
}

class CompraData extends DataClass implements Insertable<CompraData> {
  final int id;
  final String uuid;
  final String proveedorUuid;
  final String proveedorNombre;
  final String? numeroFactura;
  final double totalUsd;
  final String itemsJson;
  final String metodoPago;
  final double pagadoUsd;
  final bool afectaSaldo;
  final String? notas;
  final String usuarioId;
  final String usuarioNombre;
  final int fecha;
  final int fechaCreacion;
  final int fechaActualizacion;
  const CompraData(
      {required this.id,
      required this.uuid,
      required this.proveedorUuid,
      required this.proveedorNombre,
      this.numeroFactura,
      required this.totalUsd,
      required this.itemsJson,
      required this.metodoPago,
      required this.pagadoUsd,
      required this.afectaSaldo,
      this.notas,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fecha,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['proveedor_uuid'] = Variable<String>(proveedorUuid);
    map['proveedor_nombre'] = Variable<String>(proveedorNombre);
    if (!nullToAbsent || numeroFactura != null) {
      map['numero_factura'] = Variable<String>(numeroFactura);
    }
    map['total_usd'] = Variable<double>(totalUsd);
    map['items_json'] = Variable<String>(itemsJson);
    map['metodo_pago'] = Variable<String>(metodoPago);
    map['pagado_usd'] = Variable<double>(pagadoUsd);
    map['afecta_saldo'] = Variable<bool>(afectaSaldo);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha'] = Variable<int>(fecha);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  CompraCompanion toCompanion(bool nullToAbsent) {
    return CompraCompanion(
      id: Value(id),
      uuid: Value(uuid),
      proveedorUuid: Value(proveedorUuid),
      proveedorNombre: Value(proveedorNombre),
      numeroFactura: numeroFactura == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroFactura),
      totalUsd: Value(totalUsd),
      itemsJson: Value(itemsJson),
      metodoPago: Value(metodoPago),
      pagadoUsd: Value(pagadoUsd),
      afectaSaldo: Value(afectaSaldo),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fecha: Value(fecha),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory CompraData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompraData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      proveedorUuid: serializer.fromJson<String>(json['proveedorUuid']),
      proveedorNombre: serializer.fromJson<String>(json['proveedorNombre']),
      numeroFactura: serializer.fromJson<String?>(json['numeroFactura']),
      totalUsd: serializer.fromJson<double>(json['totalUsd']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      metodoPago: serializer.fromJson<String>(json['metodoPago']),
      pagadoUsd: serializer.fromJson<double>(json['pagadoUsd']),
      afectaSaldo: serializer.fromJson<bool>(json['afectaSaldo']),
      notas: serializer.fromJson<String?>(json['notas']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fecha: serializer.fromJson<int>(json['fecha']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'proveedorUuid': serializer.toJson<String>(proveedorUuid),
      'proveedorNombre': serializer.toJson<String>(proveedorNombre),
      'numeroFactura': serializer.toJson<String?>(numeroFactura),
      'totalUsd': serializer.toJson<double>(totalUsd),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'metodoPago': serializer.toJson<String>(metodoPago),
      'pagadoUsd': serializer.toJson<double>(pagadoUsd),
      'afectaSaldo': serializer.toJson<bool>(afectaSaldo),
      'notas': serializer.toJson<String?>(notas),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fecha': serializer.toJson<int>(fecha),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  CompraData copyWith(
          {int? id,
          String? uuid,
          String? proveedorUuid,
          String? proveedorNombre,
          Value<String?> numeroFactura = const Value.absent(),
          double? totalUsd,
          String? itemsJson,
          String? metodoPago,
          double? pagadoUsd,
          bool? afectaSaldo,
          Value<String?> notas = const Value.absent(),
          String? usuarioId,
          String? usuarioNombre,
          int? fecha,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      CompraData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        proveedorUuid: proveedorUuid ?? this.proveedorUuid,
        proveedorNombre: proveedorNombre ?? this.proveedorNombre,
        numeroFactura:
            numeroFactura.present ? numeroFactura.value : this.numeroFactura,
        totalUsd: totalUsd ?? this.totalUsd,
        itemsJson: itemsJson ?? this.itemsJson,
        metodoPago: metodoPago ?? this.metodoPago,
        pagadoUsd: pagadoUsd ?? this.pagadoUsd,
        afectaSaldo: afectaSaldo ?? this.afectaSaldo,
        notas: notas.present ? notas.value : this.notas,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fecha: fecha ?? this.fecha,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  CompraData copyWithCompanion(CompraCompanion data) {
    return CompraData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      proveedorUuid: data.proveedorUuid.present
          ? data.proveedorUuid.value
          : this.proveedorUuid,
      proveedorNombre: data.proveedorNombre.present
          ? data.proveedorNombre.value
          : this.proveedorNombre,
      numeroFactura: data.numeroFactura.present
          ? data.numeroFactura.value
          : this.numeroFactura,
      totalUsd: data.totalUsd.present ? data.totalUsd.value : this.totalUsd,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      metodoPago:
          data.metodoPago.present ? data.metodoPago.value : this.metodoPago,
      pagadoUsd: data.pagadoUsd.present ? data.pagadoUsd.value : this.pagadoUsd,
      afectaSaldo:
          data.afectaSaldo.present ? data.afectaSaldo.value : this.afectaSaldo,
      notas: data.notas.present ? data.notas.value : this.notas,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompraData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('proveedorUuid: $proveedorUuid, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('totalUsd: $totalUsd, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('pagadoUsd: $pagadoUsd, ')
          ..write('afectaSaldo: $afectaSaldo, ')
          ..write('notas: $notas, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      proveedorUuid,
      proveedorNombre,
      numeroFactura,
      totalUsd,
      itemsJson,
      metodoPago,
      pagadoUsd,
      afectaSaldo,
      notas,
      usuarioId,
      usuarioNombre,
      fecha,
      fechaCreacion,
      fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompraData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.proveedorUuid == this.proveedorUuid &&
          other.proveedorNombre == this.proveedorNombre &&
          other.numeroFactura == this.numeroFactura &&
          other.totalUsd == this.totalUsd &&
          other.itemsJson == this.itemsJson &&
          other.metodoPago == this.metodoPago &&
          other.pagadoUsd == this.pagadoUsd &&
          other.afectaSaldo == this.afectaSaldo &&
          other.notas == this.notas &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fecha == this.fecha &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class CompraCompanion extends UpdateCompanion<CompraData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> proveedorUuid;
  final Value<String> proveedorNombre;
  final Value<String?> numeroFactura;
  final Value<double> totalUsd;
  final Value<String> itemsJson;
  final Value<String> metodoPago;
  final Value<double> pagadoUsd;
  final Value<bool> afectaSaldo;
  final Value<String?> notas;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fecha;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const CompraCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.proveedorUuid = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.numeroFactura = const Value.absent(),
    this.totalUsd = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.pagadoUsd = const Value.absent(),
    this.afectaSaldo = const Value.absent(),
    this.notas = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fecha = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  CompraCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String proveedorUuid,
    required String proveedorNombre,
    this.numeroFactura = const Value.absent(),
    required double totalUsd,
    required String itemsJson,
    required String metodoPago,
    this.pagadoUsd = const Value.absent(),
    this.afectaSaldo = const Value.absent(),
    this.notas = const Value.absent(),
    required String usuarioId,
    required String usuarioNombre,
    required int fecha,
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        proveedorUuid = Value(proveedorUuid),
        proveedorNombre = Value(proveedorNombre),
        totalUsd = Value(totalUsd),
        itemsJson = Value(itemsJson),
        metodoPago = Value(metodoPago),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fecha = Value(fecha),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<CompraData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? proveedorUuid,
    Expression<String>? proveedorNombre,
    Expression<String>? numeroFactura,
    Expression<double>? totalUsd,
    Expression<String>? itemsJson,
    Expression<String>? metodoPago,
    Expression<double>? pagadoUsd,
    Expression<bool>? afectaSaldo,
    Expression<String>? notas,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fecha,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (proveedorUuid != null) 'proveedor_uuid': proveedorUuid,
      if (proveedorNombre != null) 'proveedor_nombre': proveedorNombre,
      if (numeroFactura != null) 'numero_factura': numeroFactura,
      if (totalUsd != null) 'total_usd': totalUsd,
      if (itemsJson != null) 'items_json': itemsJson,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      if (pagadoUsd != null) 'pagado_usd': pagadoUsd,
      if (afectaSaldo != null) 'afecta_saldo': afectaSaldo,
      if (notas != null) 'notas': notas,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fecha != null) 'fecha': fecha,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  CompraCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? proveedorUuid,
      Value<String>? proveedorNombre,
      Value<String?>? numeroFactura,
      Value<double>? totalUsd,
      Value<String>? itemsJson,
      Value<String>? metodoPago,
      Value<double>? pagadoUsd,
      Value<bool>? afectaSaldo,
      Value<String?>? notas,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fecha,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return CompraCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      proveedorUuid: proveedorUuid ?? this.proveedorUuid,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      totalUsd: totalUsd ?? this.totalUsd,
      itemsJson: itemsJson ?? this.itemsJson,
      metodoPago: metodoPago ?? this.metodoPago,
      pagadoUsd: pagadoUsd ?? this.pagadoUsd,
      afectaSaldo: afectaSaldo ?? this.afectaSaldo,
      notas: notas ?? this.notas,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fecha: fecha ?? this.fecha,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (proveedorUuid.present) {
      map['proveedor_uuid'] = Variable<String>(proveedorUuid.value);
    }
    if (proveedorNombre.present) {
      map['proveedor_nombre'] = Variable<String>(proveedorNombre.value);
    }
    if (numeroFactura.present) {
      map['numero_factura'] = Variable<String>(numeroFactura.value);
    }
    if (totalUsd.present) {
      map['total_usd'] = Variable<double>(totalUsd.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (metodoPago.present) {
      map['metodo_pago'] = Variable<String>(metodoPago.value);
    }
    if (pagadoUsd.present) {
      map['pagado_usd'] = Variable<double>(pagadoUsd.value);
    }
    if (afectaSaldo.present) {
      map['afecta_saldo'] = Variable<bool>(afectaSaldo.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompraCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('proveedorUuid: $proveedorUuid, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('numeroFactura: $numeroFactura, ')
          ..write('totalUsd: $totalUsd, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('pagadoUsd: $pagadoUsd, ')
          ..write('afectaSaldo: $afectaSaldo, ')
          ..write('notas: $notas, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

class $CompraItemTable extends CompraItem
    with TableInfo<$CompraItemTable, CompraItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompraItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _compraUuidMeta =
      const VerificationMeta('compraUuid');
  @override
  late final GeneratedColumn<String> compraUuid = GeneratedColumn<String>(
      'compra_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productoIdMeta =
      const VerificationMeta('productoId');
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
      'producto_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _productoNombreMeta =
      const VerificationMeta('productoNombre');
  @override
  late final GeneratedColumn<String> productoNombre = GeneratedColumn<String>(
      'producto_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costoUnitarioUsdMeta =
      const VerificationMeta('costoUnitarioUsd');
  @override
  late final GeneratedColumn<double> costoUnitarioUsd = GeneratedColumn<double>(
      'costo_unitario_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _subtotalUsdMeta =
      const VerificationMeta('subtotalUsd');
  @override
  late final GeneratedColumn<double> subtotalUsd = GeneratedColumn<double>(
      'subtotal_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        compraUuid,
        productoId,
        productoNombre,
        cantidad,
        costoUnitarioUsd,
        subtotalUsd
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compra_item';
  @override
  VerificationContext validateIntegrity(Insertable<CompraItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('compra_uuid')) {
      context.handle(
          _compraUuidMeta,
          compraUuid.isAcceptableOrUnknown(
              data['compra_uuid']!, _compraUuidMeta));
    } else if (isInserting) {
      context.missing(_compraUuidMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
          _productoIdMeta,
          productoId.isAcceptableOrUnknown(
              data['producto_id']!, _productoIdMeta));
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('producto_nombre')) {
      context.handle(
          _productoNombreMeta,
          productoNombre.isAcceptableOrUnknown(
              data['producto_nombre']!, _productoNombreMeta));
    } else if (isInserting) {
      context.missing(_productoNombreMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('costo_unitario_usd')) {
      context.handle(
          _costoUnitarioUsdMeta,
          costoUnitarioUsd.isAcceptableOrUnknown(
              data['costo_unitario_usd']!, _costoUnitarioUsdMeta));
    } else if (isInserting) {
      context.missing(_costoUnitarioUsdMeta);
    }
    if (data.containsKey('subtotal_usd')) {
      context.handle(
          _subtotalUsdMeta,
          subtotalUsd.isAcceptableOrUnknown(
              data['subtotal_usd']!, _subtotalUsdMeta));
    } else if (isInserting) {
      context.missing(_subtotalUsdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompraItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompraItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      compraUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}compra_uuid'])!,
      productoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}producto_id'])!,
      productoNombre: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}producto_nombre'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cantidad'])!,
      costoUnitarioUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}costo_unitario_usd'])!,
      subtotalUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal_usd'])!,
    );
  }

  @override
  $CompraItemTable createAlias(String alias) {
    return $CompraItemTable(attachedDatabase, alias);
  }
}

class CompraItemData extends DataClass implements Insertable<CompraItemData> {
  final int id;
  final String compraUuid;
  final int productoId;
  final String productoNombre;
  final double cantidad;
  final double costoUnitarioUsd;
  final double subtotalUsd;
  const CompraItemData(
      {required this.id,
      required this.compraUuid,
      required this.productoId,
      required this.productoNombre,
      required this.cantidad,
      required this.costoUnitarioUsd,
      required this.subtotalUsd});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['compra_uuid'] = Variable<String>(compraUuid);
    map['producto_id'] = Variable<int>(productoId);
    map['producto_nombre'] = Variable<String>(productoNombre);
    map['cantidad'] = Variable<double>(cantidad);
    map['costo_unitario_usd'] = Variable<double>(costoUnitarioUsd);
    map['subtotal_usd'] = Variable<double>(subtotalUsd);
    return map;
  }

  CompraItemCompanion toCompanion(bool nullToAbsent) {
    return CompraItemCompanion(
      id: Value(id),
      compraUuid: Value(compraUuid),
      productoId: Value(productoId),
      productoNombre: Value(productoNombre),
      cantidad: Value(cantidad),
      costoUnitarioUsd: Value(costoUnitarioUsd),
      subtotalUsd: Value(subtotalUsd),
    );
  }

  factory CompraItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompraItemData(
      id: serializer.fromJson<int>(json['id']),
      compraUuid: serializer.fromJson<String>(json['compraUuid']),
      productoId: serializer.fromJson<int>(json['productoId']),
      productoNombre: serializer.fromJson<String>(json['productoNombre']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      costoUnitarioUsd: serializer.fromJson<double>(json['costoUnitarioUsd']),
      subtotalUsd: serializer.fromJson<double>(json['subtotalUsd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'compraUuid': serializer.toJson<String>(compraUuid),
      'productoId': serializer.toJson<int>(productoId),
      'productoNombre': serializer.toJson<String>(productoNombre),
      'cantidad': serializer.toJson<double>(cantidad),
      'costoUnitarioUsd': serializer.toJson<double>(costoUnitarioUsd),
      'subtotalUsd': serializer.toJson<double>(subtotalUsd),
    };
  }

  CompraItemData copyWith(
          {int? id,
          String? compraUuid,
          int? productoId,
          String? productoNombre,
          double? cantidad,
          double? costoUnitarioUsd,
          double? subtotalUsd}) =>
      CompraItemData(
        id: id ?? this.id,
        compraUuid: compraUuid ?? this.compraUuid,
        productoId: productoId ?? this.productoId,
        productoNombre: productoNombre ?? this.productoNombre,
        cantidad: cantidad ?? this.cantidad,
        costoUnitarioUsd: costoUnitarioUsd ?? this.costoUnitarioUsd,
        subtotalUsd: subtotalUsd ?? this.subtotalUsd,
      );
  CompraItemData copyWithCompanion(CompraItemCompanion data) {
    return CompraItemData(
      id: data.id.present ? data.id.value : this.id,
      compraUuid:
          data.compraUuid.present ? data.compraUuid.value : this.compraUuid,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      productoNombre: data.productoNombre.present
          ? data.productoNombre.value
          : this.productoNombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      costoUnitarioUsd: data.costoUnitarioUsd.present
          ? data.costoUnitarioUsd.value
          : this.costoUnitarioUsd,
      subtotalUsd:
          data.subtotalUsd.present ? data.subtotalUsd.value : this.subtotalUsd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompraItemData(')
          ..write('id: $id, ')
          ..write('compraUuid: $compraUuid, ')
          ..write('productoId: $productoId, ')
          ..write('productoNombre: $productoNombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitarioUsd: $costoUnitarioUsd, ')
          ..write('subtotalUsd: $subtotalUsd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, compraUuid, productoId, productoNombre,
      cantidad, costoUnitarioUsd, subtotalUsd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompraItemData &&
          other.id == this.id &&
          other.compraUuid == this.compraUuid &&
          other.productoId == this.productoId &&
          other.productoNombre == this.productoNombre &&
          other.cantidad == this.cantidad &&
          other.costoUnitarioUsd == this.costoUnitarioUsd &&
          other.subtotalUsd == this.subtotalUsd);
}

class CompraItemCompanion extends UpdateCompanion<CompraItemData> {
  final Value<int> id;
  final Value<String> compraUuid;
  final Value<int> productoId;
  final Value<String> productoNombre;
  final Value<double> cantidad;
  final Value<double> costoUnitarioUsd;
  final Value<double> subtotalUsd;
  const CompraItemCompanion({
    this.id = const Value.absent(),
    this.compraUuid = const Value.absent(),
    this.productoId = const Value.absent(),
    this.productoNombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.costoUnitarioUsd = const Value.absent(),
    this.subtotalUsd = const Value.absent(),
  });
  CompraItemCompanion.insert({
    this.id = const Value.absent(),
    required String compraUuid,
    required int productoId,
    required String productoNombre,
    required double cantidad,
    required double costoUnitarioUsd,
    required double subtotalUsd,
  })  : compraUuid = Value(compraUuid),
        productoId = Value(productoId),
        productoNombre = Value(productoNombre),
        cantidad = Value(cantidad),
        costoUnitarioUsd = Value(costoUnitarioUsd),
        subtotalUsd = Value(subtotalUsd);
  static Insertable<CompraItemData> custom({
    Expression<int>? id,
    Expression<String>? compraUuid,
    Expression<int>? productoId,
    Expression<String>? productoNombre,
    Expression<double>? cantidad,
    Expression<double>? costoUnitarioUsd,
    Expression<double>? subtotalUsd,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (compraUuid != null) 'compra_uuid': compraUuid,
      if (productoId != null) 'producto_id': productoId,
      if (productoNombre != null) 'producto_nombre': productoNombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (costoUnitarioUsd != null) 'costo_unitario_usd': costoUnitarioUsd,
      if (subtotalUsd != null) 'subtotal_usd': subtotalUsd,
    });
  }

  CompraItemCompanion copyWith(
      {Value<int>? id,
      Value<String>? compraUuid,
      Value<int>? productoId,
      Value<String>? productoNombre,
      Value<double>? cantidad,
      Value<double>? costoUnitarioUsd,
      Value<double>? subtotalUsd}) {
    return CompraItemCompanion(
      id: id ?? this.id,
      compraUuid: compraUuid ?? this.compraUuid,
      productoId: productoId ?? this.productoId,
      productoNombre: productoNombre ?? this.productoNombre,
      cantidad: cantidad ?? this.cantidad,
      costoUnitarioUsd: costoUnitarioUsd ?? this.costoUnitarioUsd,
      subtotalUsd: subtotalUsd ?? this.subtotalUsd,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (compraUuid.present) {
      map['compra_uuid'] = Variable<String>(compraUuid.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (productoNombre.present) {
      map['producto_nombre'] = Variable<String>(productoNombre.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (costoUnitarioUsd.present) {
      map['costo_unitario_usd'] = Variable<double>(costoUnitarioUsd.value);
    }
    if (subtotalUsd.present) {
      map['subtotal_usd'] = Variable<double>(subtotalUsd.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompraItemCompanion(')
          ..write('id: $id, ')
          ..write('compraUuid: $compraUuid, ')
          ..write('productoId: $productoId, ')
          ..write('productoNombre: $productoNombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitarioUsd: $costoUnitarioUsd, ')
          ..write('subtotalUsd: $subtotalUsd')
          ..write(')'))
        .toString();
  }
}

class $PagoProveedorTable extends PagoProveedor
    with TableInfo<$PagoProveedorTable, PagoProveedorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagoProveedorTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _proveedorUuidMeta =
      const VerificationMeta('proveedorUuid');
  @override
  late final GeneratedColumn<String> proveedorUuid = GeneratedColumn<String>(
      'proveedor_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _proveedorNombreMeta =
      const VerificationMeta('proveedorNombre');
  @override
  late final GeneratedColumn<String> proveedorNombre = GeneratedColumn<String>(
      'proveedor_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _montoUsdMeta =
      const VerificationMeta('montoUsd');
  @override
  late final GeneratedColumn<double> montoUsd = GeneratedColumn<double>(
      'monto_usd', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _metodoPagoMeta =
      const VerificationMeta('metodoPago');
  @override
  late final GeneratedColumn<String> metodoPago = GeneratedColumn<String>(
      'metodo_pago', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenciaMeta =
      const VerificationMeta('referencia');
  @override
  late final GeneratedColumn<String> referencia = GeneratedColumn<String>(
      'referencia', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
      'notas', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<String> usuarioId = GeneratedColumn<String>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usuarioNombreMeta =
      const VerificationMeta('usuarioNombre');
  @override
  late final GeneratedColumn<String> usuarioNombre = GeneratedColumn<String>(
      'usuario_nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<int> fecha = GeneratedColumn<int>(
      'fecha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaCreacionMeta =
      const VerificationMeta('fechaCreacion');
  @override
  late final GeneratedColumn<int> fechaCreacion = GeneratedColumn<int>(
      'fecha_creacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaActualizacionMeta =
      const VerificationMeta('fechaActualizacion');
  @override
  late final GeneratedColumn<int> fechaActualizacion = GeneratedColumn<int>(
      'fecha_actualizacion', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        proveedorUuid,
        proveedorNombre,
        montoUsd,
        metodoPago,
        referencia,
        notas,
        usuarioId,
        usuarioNombre,
        fecha,
        fechaCreacion,
        fechaActualizacion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pago_proveedor';
  @override
  VerificationContext validateIntegrity(Insertable<PagoProveedorData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('proveedor_uuid')) {
      context.handle(
          _proveedorUuidMeta,
          proveedorUuid.isAcceptableOrUnknown(
              data['proveedor_uuid']!, _proveedorUuidMeta));
    } else if (isInserting) {
      context.missing(_proveedorUuidMeta);
    }
    if (data.containsKey('proveedor_nombre')) {
      context.handle(
          _proveedorNombreMeta,
          proveedorNombre.isAcceptableOrUnknown(
              data['proveedor_nombre']!, _proveedorNombreMeta));
    } else if (isInserting) {
      context.missing(_proveedorNombreMeta);
    }
    if (data.containsKey('monto_usd')) {
      context.handle(_montoUsdMeta,
          montoUsd.isAcceptableOrUnknown(data['monto_usd']!, _montoUsdMeta));
    } else if (isInserting) {
      context.missing(_montoUsdMeta);
    }
    if (data.containsKey('metodo_pago')) {
      context.handle(
          _metodoPagoMeta,
          metodoPago.isAcceptableOrUnknown(
              data['metodo_pago']!, _metodoPagoMeta));
    } else if (isInserting) {
      context.missing(_metodoPagoMeta);
    }
    if (data.containsKey('referencia')) {
      context.handle(
          _referenciaMeta,
          referencia.isAcceptableOrUnknown(
              data['referencia']!, _referenciaMeta));
    }
    if (data.containsKey('notas')) {
      context.handle(
          _notasMeta, notas.isAcceptableOrUnknown(data['notas']!, _notasMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('usuario_nombre')) {
      context.handle(
          _usuarioNombreMeta,
          usuarioNombre.isAcceptableOrUnknown(
              data['usuario_nombre']!, _usuarioNombreMeta));
    } else if (isInserting) {
      context.missing(_usuarioNombreMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('fecha_creacion')) {
      context.handle(
          _fechaCreacionMeta,
          fechaCreacion.isAcceptableOrUnknown(
              data['fecha_creacion']!, _fechaCreacionMeta));
    } else if (isInserting) {
      context.missing(_fechaCreacionMeta);
    }
    if (data.containsKey('fecha_actualizacion')) {
      context.handle(
          _fechaActualizacionMeta,
          fechaActualizacion.isAcceptableOrUnknown(
              data['fecha_actualizacion']!, _fechaActualizacionMeta));
    } else if (isInserting) {
      context.missing(_fechaActualizacionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PagoProveedorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PagoProveedorData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      proveedorUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}proveedor_uuid'])!,
      proveedorNombre: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}proveedor_nombre'])!,
      montoUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_usd'])!,
      metodoPago: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metodo_pago'])!,
      referencia: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}referencia']),
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_id'])!,
      usuarioNombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}usuario_nombre'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha'])!,
      fechaCreacion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_creacion'])!,
      fechaActualizacion: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}fecha_actualizacion'])!,
    );
  }

  @override
  $PagoProveedorTable createAlias(String alias) {
    return $PagoProveedorTable(attachedDatabase, alias);
  }
}

class PagoProveedorData extends DataClass
    implements Insertable<PagoProveedorData> {
  final int id;
  final String uuid;
  final String proveedorUuid;
  final String proveedorNombre;
  final double montoUsd;
  final String metodoPago;
  final String? referencia;
  final String? notas;
  final String usuarioId;
  final String usuarioNombre;
  final int fecha;
  final int fechaCreacion;
  final int fechaActualizacion;
  const PagoProveedorData(
      {required this.id,
      required this.uuid,
      required this.proveedorUuid,
      required this.proveedorNombre,
      required this.montoUsd,
      required this.metodoPago,
      this.referencia,
      this.notas,
      required this.usuarioId,
      required this.usuarioNombre,
      required this.fecha,
      required this.fechaCreacion,
      required this.fechaActualizacion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['proveedor_uuid'] = Variable<String>(proveedorUuid);
    map['proveedor_nombre'] = Variable<String>(proveedorNombre);
    map['monto_usd'] = Variable<double>(montoUsd);
    map['metodo_pago'] = Variable<String>(metodoPago);
    if (!nullToAbsent || referencia != null) {
      map['referencia'] = Variable<String>(referencia);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['usuario_id'] = Variable<String>(usuarioId);
    map['usuario_nombre'] = Variable<String>(usuarioNombre);
    map['fecha'] = Variable<int>(fecha);
    map['fecha_creacion'] = Variable<int>(fechaCreacion);
    map['fecha_actualizacion'] = Variable<int>(fechaActualizacion);
    return map;
  }

  PagoProveedorCompanion toCompanion(bool nullToAbsent) {
    return PagoProveedorCompanion(
      id: Value(id),
      uuid: Value(uuid),
      proveedorUuid: Value(proveedorUuid),
      proveedorNombre: Value(proveedorNombre),
      montoUsd: Value(montoUsd),
      metodoPago: Value(metodoPago),
      referencia: referencia == null && nullToAbsent
          ? const Value.absent()
          : Value(referencia),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
      usuarioId: Value(usuarioId),
      usuarioNombre: Value(usuarioNombre),
      fecha: Value(fecha),
      fechaCreacion: Value(fechaCreacion),
      fechaActualizacion: Value(fechaActualizacion),
    );
  }

  factory PagoProveedorData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PagoProveedorData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      proveedorUuid: serializer.fromJson<String>(json['proveedorUuid']),
      proveedorNombre: serializer.fromJson<String>(json['proveedorNombre']),
      montoUsd: serializer.fromJson<double>(json['montoUsd']),
      metodoPago: serializer.fromJson<String>(json['metodoPago']),
      referencia: serializer.fromJson<String?>(json['referencia']),
      notas: serializer.fromJson<String?>(json['notas']),
      usuarioId: serializer.fromJson<String>(json['usuarioId']),
      usuarioNombre: serializer.fromJson<String>(json['usuarioNombre']),
      fecha: serializer.fromJson<int>(json['fecha']),
      fechaCreacion: serializer.fromJson<int>(json['fechaCreacion']),
      fechaActualizacion: serializer.fromJson<int>(json['fechaActualizacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'proveedorUuid': serializer.toJson<String>(proveedorUuid),
      'proveedorNombre': serializer.toJson<String>(proveedorNombre),
      'montoUsd': serializer.toJson<double>(montoUsd),
      'metodoPago': serializer.toJson<String>(metodoPago),
      'referencia': serializer.toJson<String?>(referencia),
      'notas': serializer.toJson<String?>(notas),
      'usuarioId': serializer.toJson<String>(usuarioId),
      'usuarioNombre': serializer.toJson<String>(usuarioNombre),
      'fecha': serializer.toJson<int>(fecha),
      'fechaCreacion': serializer.toJson<int>(fechaCreacion),
      'fechaActualizacion': serializer.toJson<int>(fechaActualizacion),
    };
  }

  PagoProveedorData copyWith(
          {int? id,
          String? uuid,
          String? proveedorUuid,
          String? proveedorNombre,
          double? montoUsd,
          String? metodoPago,
          Value<String?> referencia = const Value.absent(),
          Value<String?> notas = const Value.absent(),
          String? usuarioId,
          String? usuarioNombre,
          int? fecha,
          int? fechaCreacion,
          int? fechaActualizacion}) =>
      PagoProveedorData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        proveedorUuid: proveedorUuid ?? this.proveedorUuid,
        proveedorNombre: proveedorNombre ?? this.proveedorNombre,
        montoUsd: montoUsd ?? this.montoUsd,
        metodoPago: metodoPago ?? this.metodoPago,
        referencia: referencia.present ? referencia.value : this.referencia,
        notas: notas.present ? notas.value : this.notas,
        usuarioId: usuarioId ?? this.usuarioId,
        usuarioNombre: usuarioNombre ?? this.usuarioNombre,
        fecha: fecha ?? this.fecha,
        fechaCreacion: fechaCreacion ?? this.fechaCreacion,
        fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      );
  PagoProveedorData copyWithCompanion(PagoProveedorCompanion data) {
    return PagoProveedorData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      proveedorUuid: data.proveedorUuid.present
          ? data.proveedorUuid.value
          : this.proveedorUuid,
      proveedorNombre: data.proveedorNombre.present
          ? data.proveedorNombre.value
          : this.proveedorNombre,
      montoUsd: data.montoUsd.present ? data.montoUsd.value : this.montoUsd,
      metodoPago:
          data.metodoPago.present ? data.metodoPago.value : this.metodoPago,
      referencia:
          data.referencia.present ? data.referencia.value : this.referencia,
      notas: data.notas.present ? data.notas.value : this.notas,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      usuarioNombre: data.usuarioNombre.present
          ? data.usuarioNombre.value
          : this.usuarioNombre,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      fechaCreacion: data.fechaCreacion.present
          ? data.fechaCreacion.value
          : this.fechaCreacion,
      fechaActualizacion: data.fechaActualizacion.present
          ? data.fechaActualizacion.value
          : this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PagoProveedorData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('proveedorUuid: $proveedorUuid, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('referencia: $referencia, ')
          ..write('notas: $notas, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      proveedorUuid,
      proveedorNombre,
      montoUsd,
      metodoPago,
      referencia,
      notas,
      usuarioId,
      usuarioNombre,
      fecha,
      fechaCreacion,
      fechaActualizacion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PagoProveedorData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.proveedorUuid == this.proveedorUuid &&
          other.proveedorNombre == this.proveedorNombre &&
          other.montoUsd == this.montoUsd &&
          other.metodoPago == this.metodoPago &&
          other.referencia == this.referencia &&
          other.notas == this.notas &&
          other.usuarioId == this.usuarioId &&
          other.usuarioNombre == this.usuarioNombre &&
          other.fecha == this.fecha &&
          other.fechaCreacion == this.fechaCreacion &&
          other.fechaActualizacion == this.fechaActualizacion);
}

class PagoProveedorCompanion extends UpdateCompanion<PagoProveedorData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> proveedorUuid;
  final Value<String> proveedorNombre;
  final Value<double> montoUsd;
  final Value<String> metodoPago;
  final Value<String?> referencia;
  final Value<String?> notas;
  final Value<String> usuarioId;
  final Value<String> usuarioNombre;
  final Value<int> fecha;
  final Value<int> fechaCreacion;
  final Value<int> fechaActualizacion;
  const PagoProveedorCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.proveedorUuid = const Value.absent(),
    this.proveedorNombre = const Value.absent(),
    this.montoUsd = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.referencia = const Value.absent(),
    this.notas = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.usuarioNombre = const Value.absent(),
    this.fecha = const Value.absent(),
    this.fechaCreacion = const Value.absent(),
    this.fechaActualizacion = const Value.absent(),
  });
  PagoProveedorCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String proveedorUuid,
    required String proveedorNombre,
    required double montoUsd,
    required String metodoPago,
    this.referencia = const Value.absent(),
    this.notas = const Value.absent(),
    required String usuarioId,
    required String usuarioNombre,
    required int fecha,
    required int fechaCreacion,
    required int fechaActualizacion,
  })  : uuid = Value(uuid),
        proveedorUuid = Value(proveedorUuid),
        proveedorNombre = Value(proveedorNombre),
        montoUsd = Value(montoUsd),
        metodoPago = Value(metodoPago),
        usuarioId = Value(usuarioId),
        usuarioNombre = Value(usuarioNombre),
        fecha = Value(fecha),
        fechaCreacion = Value(fechaCreacion),
        fechaActualizacion = Value(fechaActualizacion);
  static Insertable<PagoProveedorData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? proveedorUuid,
    Expression<String>? proveedorNombre,
    Expression<double>? montoUsd,
    Expression<String>? metodoPago,
    Expression<String>? referencia,
    Expression<String>? notas,
    Expression<String>? usuarioId,
    Expression<String>? usuarioNombre,
    Expression<int>? fecha,
    Expression<int>? fechaCreacion,
    Expression<int>? fechaActualizacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (proveedorUuid != null) 'proveedor_uuid': proveedorUuid,
      if (proveedorNombre != null) 'proveedor_nombre': proveedorNombre,
      if (montoUsd != null) 'monto_usd': montoUsd,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      if (referencia != null) 'referencia': referencia,
      if (notas != null) 'notas': notas,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (usuarioNombre != null) 'usuario_nombre': usuarioNombre,
      if (fecha != null) 'fecha': fecha,
      if (fechaCreacion != null) 'fecha_creacion': fechaCreacion,
      if (fechaActualizacion != null) 'fecha_actualizacion': fechaActualizacion,
    });
  }

  PagoProveedorCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? proveedorUuid,
      Value<String>? proveedorNombre,
      Value<double>? montoUsd,
      Value<String>? metodoPago,
      Value<String?>? referencia,
      Value<String?>? notas,
      Value<String>? usuarioId,
      Value<String>? usuarioNombre,
      Value<int>? fecha,
      Value<int>? fechaCreacion,
      Value<int>? fechaActualizacion}) {
    return PagoProveedorCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      proveedorUuid: proveedorUuid ?? this.proveedorUuid,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      montoUsd: montoUsd ?? this.montoUsd,
      metodoPago: metodoPago ?? this.metodoPago,
      referencia: referencia ?? this.referencia,
      notas: notas ?? this.notas,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      fecha: fecha ?? this.fecha,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (proveedorUuid.present) {
      map['proveedor_uuid'] = Variable<String>(proveedorUuid.value);
    }
    if (proveedorNombre.present) {
      map['proveedor_nombre'] = Variable<String>(proveedorNombre.value);
    }
    if (montoUsd.present) {
      map['monto_usd'] = Variable<double>(montoUsd.value);
    }
    if (metodoPago.present) {
      map['metodo_pago'] = Variable<String>(metodoPago.value);
    }
    if (referencia.present) {
      map['referencia'] = Variable<String>(referencia.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<String>(usuarioId.value);
    }
    if (usuarioNombre.present) {
      map['usuario_nombre'] = Variable<String>(usuarioNombre.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<int>(fecha.value);
    }
    if (fechaCreacion.present) {
      map['fecha_creacion'] = Variable<int>(fechaCreacion.value);
    }
    if (fechaActualizacion.present) {
      map['fecha_actualizacion'] = Variable<int>(fechaActualizacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagoProveedorCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('proveedorUuid: $proveedorUuid, ')
          ..write('proveedorNombre: $proveedorNombre, ')
          ..write('montoUsd: $montoUsd, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('referencia: $referencia, ')
          ..write('notas: $notas, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('usuarioNombre: $usuarioNombre, ')
          ..write('fecha: $fecha, ')
          ..write('fechaCreacion: $fechaCreacion, ')
          ..write('fechaActualizacion: $fechaActualizacion')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConfiguracionLocalTable configuracionLocal =
      $ConfiguracionLocalTable(this);
  late final $HistorialTasaTable historialTasa = $HistorialTasaTable(this);
  late final $ProductoTable producto = $ProductoTable(this);
  late final $VentaTable venta = $VentaTable(this);
  late final $ClienteTable cliente = $ClienteTable(this);
  late final $PagoFiadoTable pagoFiado = $PagoFiadoTable(this);
  late final $AperturaCajaTable aperturaCaja = $AperturaCajaTable(this);
  late final $CierreCajaTable cierreCaja = $CierreCajaTable(this);
  late final $RetiroCajaTable retiroCaja = $RetiroCajaTable(this);
  late final $MermaTable merma = $MermaTable(this);
  late final $AuditoriaLogTable auditoriaLog = $AuditoriaLogTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $GastoTable gasto = $GastoTable(this);
  late final $NotaCreditoTable notaCredito = $NotaCreditoTable(this);
  late final $CategoriaTable categoria = $CategoriaTable(this);
  late final $ProveedorTable proveedor = $ProveedorTable(this);
  late final $CompraTable compra = $CompraTable(this);
  late final $CompraItemTable compraItem = $CompraItemTable(this);
  late final $PagoProveedorTable pagoProveedor = $PagoProveedorTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        configuracionLocal,
        historialTasa,
        producto,
        venta,
        cliente,
        pagoFiado,
        aperturaCaja,
        cierreCaja,
        retiroCaja,
        merma,
        auditoriaLog,
        syncQueue,
        gasto,
        notaCredito,
        categoria,
        proveedor,
        compra,
        compraItem,
        pagoProveedor
      ];
}

typedef $$ConfiguracionLocalTableCreateCompanionBuilder
    = ConfiguracionLocalCompanion Function({
  Value<int> id,
  Value<String> plan,
  Value<bool> cuentaActiva,
  Value<int> fechaVencimientoEpoch,
  Value<String> appNombre,
  Value<String> appSlogan,
  Value<String?> logoUrl,
  Value<String> colorPrimario,
  Value<String> colorSecundario,
  Value<String> rif,
  Value<String> direccion,
  Value<String> telefono,
  Value<double> tasaBcv,
  Value<bool> usarTasaBcv,
  Value<double?> tasaManual,
  Value<double> ivaRate,
  Value<double> igtfRate,
  Value<int> timestampUltimaVerificacion,
  Value<bool> isDemoMode,
  Value<int> demoStartTimestamp,
  Value<bool> acceptedLegal,
  Value<int> timestampUltimaVerificacionMaestro,
});
typedef $$ConfiguracionLocalTableUpdateCompanionBuilder
    = ConfiguracionLocalCompanion Function({
  Value<int> id,
  Value<String> plan,
  Value<bool> cuentaActiva,
  Value<int> fechaVencimientoEpoch,
  Value<String> appNombre,
  Value<String> appSlogan,
  Value<String?> logoUrl,
  Value<String> colorPrimario,
  Value<String> colorSecundario,
  Value<String> rif,
  Value<String> direccion,
  Value<String> telefono,
  Value<double> tasaBcv,
  Value<bool> usarTasaBcv,
  Value<double?> tasaManual,
  Value<double> ivaRate,
  Value<double> igtfRate,
  Value<int> timestampUltimaVerificacion,
  Value<bool> isDemoMode,
  Value<int> demoStartTimestamp,
  Value<bool> acceptedLegal,
  Value<int> timestampUltimaVerificacionMaestro,
});

class $$ConfiguracionLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracionLocalTable> {
  $$ConfiguracionLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cuentaActiva => $composableBuilder(
      column: $table.cuentaActiva, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaVencimientoEpoch => $composableBuilder(
      column: $table.fechaVencimientoEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appNombre => $composableBuilder(
      column: $table.appNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appSlogan => $composableBuilder(
      column: $table.appSlogan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorPrimario => $composableBuilder(
      column: $table.colorPrimario, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorSecundario => $composableBuilder(
      column: $table.colorSecundario,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rif => $composableBuilder(
      column: $table.rif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasaBcv => $composableBuilder(
      column: $table.tasaBcv, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get usarTasaBcv => $composableBuilder(
      column: $table.usarTasaBcv, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasaManual => $composableBuilder(
      column: $table.tasaManual, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ivaRate => $composableBuilder(
      column: $table.ivaRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get igtfRate => $composableBuilder(
      column: $table.igtfRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestampUltimaVerificacion => $composableBuilder(
      column: $table.timestampUltimaVerificacion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDemoMode => $composableBuilder(
      column: $table.isDemoMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get demoStartTimestamp => $composableBuilder(
      column: $table.demoStartTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get acceptedLegal => $composableBuilder(
      column: $table.acceptedLegal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestampUltimaVerificacionMaestro =>
      $composableBuilder(
          column: $table.timestampUltimaVerificacionMaestro,
          builder: (column) => ColumnFilters(column));
}

class $$ConfiguracionLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracionLocalTable> {
  $$ConfiguracionLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cuentaActiva => $composableBuilder(
      column: $table.cuentaActiva,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaVencimientoEpoch => $composableBuilder(
      column: $table.fechaVencimientoEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appNombre => $composableBuilder(
      column: $table.appNombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appSlogan => $composableBuilder(
      column: $table.appSlogan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorPrimario => $composableBuilder(
      column: $table.colorPrimario,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorSecundario => $composableBuilder(
      column: $table.colorSecundario,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rif => $composableBuilder(
      column: $table.rif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasaBcv => $composableBuilder(
      column: $table.tasaBcv, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get usarTasaBcv => $composableBuilder(
      column: $table.usarTasaBcv, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasaManual => $composableBuilder(
      column: $table.tasaManual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ivaRate => $composableBuilder(
      column: $table.ivaRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get igtfRate => $composableBuilder(
      column: $table.igtfRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestampUltimaVerificacion => $composableBuilder(
      column: $table.timestampUltimaVerificacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDemoMode => $composableBuilder(
      column: $table.isDemoMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get demoStartTimestamp => $composableBuilder(
      column: $table.demoStartTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get acceptedLegal => $composableBuilder(
      column: $table.acceptedLegal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestampUltimaVerificacionMaestro =>
      $composableBuilder(
          column: $table.timestampUltimaVerificacionMaestro,
          builder: (column) => ColumnOrderings(column));
}

class $$ConfiguracionLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracionLocalTable> {
  $$ConfiguracionLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<bool> get cuentaActiva => $composableBuilder(
      column: $table.cuentaActiva, builder: (column) => column);

  GeneratedColumn<int> get fechaVencimientoEpoch => $composableBuilder(
      column: $table.fechaVencimientoEpoch, builder: (column) => column);

  GeneratedColumn<String> get appNombre =>
      $composableBuilder(column: $table.appNombre, builder: (column) => column);

  GeneratedColumn<String> get appSlogan =>
      $composableBuilder(column: $table.appSlogan, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get colorPrimario => $composableBuilder(
      column: $table.colorPrimario, builder: (column) => column);

  GeneratedColumn<String> get colorSecundario => $composableBuilder(
      column: $table.colorSecundario, builder: (column) => column);

  GeneratedColumn<String> get rif =>
      $composableBuilder(column: $table.rif, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<double> get tasaBcv =>
      $composableBuilder(column: $table.tasaBcv, builder: (column) => column);

  GeneratedColumn<bool> get usarTasaBcv => $composableBuilder(
      column: $table.usarTasaBcv, builder: (column) => column);

  GeneratedColumn<double> get tasaManual => $composableBuilder(
      column: $table.tasaManual, builder: (column) => column);

  GeneratedColumn<double> get ivaRate =>
      $composableBuilder(column: $table.ivaRate, builder: (column) => column);

  GeneratedColumn<double> get igtfRate =>
      $composableBuilder(column: $table.igtfRate, builder: (column) => column);

  GeneratedColumn<int> get timestampUltimaVerificacion => $composableBuilder(
      column: $table.timestampUltimaVerificacion, builder: (column) => column);

  GeneratedColumn<bool> get isDemoMode => $composableBuilder(
      column: $table.isDemoMode, builder: (column) => column);

  GeneratedColumn<int> get demoStartTimestamp => $composableBuilder(
      column: $table.demoStartTimestamp, builder: (column) => column);

  GeneratedColumn<bool> get acceptedLegal => $composableBuilder(
      column: $table.acceptedLegal, builder: (column) => column);

  GeneratedColumn<int> get timestampUltimaVerificacionMaestro =>
      $composableBuilder(
          column: $table.timestampUltimaVerificacionMaestro,
          builder: (column) => column);
}

class $$ConfiguracionLocalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConfiguracionLocalTable,
    ConfiguracionLocalData,
    $$ConfiguracionLocalTableFilterComposer,
    $$ConfiguracionLocalTableOrderingComposer,
    $$ConfiguracionLocalTableAnnotationComposer,
    $$ConfiguracionLocalTableCreateCompanionBuilder,
    $$ConfiguracionLocalTableUpdateCompanionBuilder,
    (
      ConfiguracionLocalData,
      BaseReferences<_$AppDatabase, $ConfiguracionLocalTable,
          ConfiguracionLocalData>
    ),
    ConfiguracionLocalData,
    PrefetchHooks Function()> {
  $$ConfiguracionLocalTableTableManager(
      _$AppDatabase db, $ConfiguracionLocalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracionLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracionLocalTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> plan = const Value.absent(),
            Value<bool> cuentaActiva = const Value.absent(),
            Value<int> fechaVencimientoEpoch = const Value.absent(),
            Value<String> appNombre = const Value.absent(),
            Value<String> appSlogan = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<String> colorPrimario = const Value.absent(),
            Value<String> colorSecundario = const Value.absent(),
            Value<String> rif = const Value.absent(),
            Value<String> direccion = const Value.absent(),
            Value<String> telefono = const Value.absent(),
            Value<double> tasaBcv = const Value.absent(),
            Value<bool> usarTasaBcv = const Value.absent(),
            Value<double?> tasaManual = const Value.absent(),
            Value<double> ivaRate = const Value.absent(),
            Value<double> igtfRate = const Value.absent(),
            Value<int> timestampUltimaVerificacion = const Value.absent(),
            Value<bool> isDemoMode = const Value.absent(),
            Value<int> demoStartTimestamp = const Value.absent(),
            Value<bool> acceptedLegal = const Value.absent(),
            Value<int> timestampUltimaVerificacionMaestro =
                const Value.absent(),
          }) =>
              ConfiguracionLocalCompanion(
            id: id,
            plan: plan,
            cuentaActiva: cuentaActiva,
            fechaVencimientoEpoch: fechaVencimientoEpoch,
            appNombre: appNombre,
            appSlogan: appSlogan,
            logoUrl: logoUrl,
            colorPrimario: colorPrimario,
            colorSecundario: colorSecundario,
            rif: rif,
            direccion: direccion,
            telefono: telefono,
            tasaBcv: tasaBcv,
            usarTasaBcv: usarTasaBcv,
            tasaManual: tasaManual,
            ivaRate: ivaRate,
            igtfRate: igtfRate,
            timestampUltimaVerificacion: timestampUltimaVerificacion,
            isDemoMode: isDemoMode,
            demoStartTimestamp: demoStartTimestamp,
            acceptedLegal: acceptedLegal,
            timestampUltimaVerificacionMaestro:
                timestampUltimaVerificacionMaestro,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> plan = const Value.absent(),
            Value<bool> cuentaActiva = const Value.absent(),
            Value<int> fechaVencimientoEpoch = const Value.absent(),
            Value<String> appNombre = const Value.absent(),
            Value<String> appSlogan = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<String> colorPrimario = const Value.absent(),
            Value<String> colorSecundario = const Value.absent(),
            Value<String> rif = const Value.absent(),
            Value<String> direccion = const Value.absent(),
            Value<String> telefono = const Value.absent(),
            Value<double> tasaBcv = const Value.absent(),
            Value<bool> usarTasaBcv = const Value.absent(),
            Value<double?> tasaManual = const Value.absent(),
            Value<double> ivaRate = const Value.absent(),
            Value<double> igtfRate = const Value.absent(),
            Value<int> timestampUltimaVerificacion = const Value.absent(),
            Value<bool> isDemoMode = const Value.absent(),
            Value<int> demoStartTimestamp = const Value.absent(),
            Value<bool> acceptedLegal = const Value.absent(),
            Value<int> timestampUltimaVerificacionMaestro =
                const Value.absent(),
          }) =>
              ConfiguracionLocalCompanion.insert(
            id: id,
            plan: plan,
            cuentaActiva: cuentaActiva,
            fechaVencimientoEpoch: fechaVencimientoEpoch,
            appNombre: appNombre,
            appSlogan: appSlogan,
            logoUrl: logoUrl,
            colorPrimario: colorPrimario,
            colorSecundario: colorSecundario,
            rif: rif,
            direccion: direccion,
            telefono: telefono,
            tasaBcv: tasaBcv,
            usarTasaBcv: usarTasaBcv,
            tasaManual: tasaManual,
            ivaRate: ivaRate,
            igtfRate: igtfRate,
            timestampUltimaVerificacion: timestampUltimaVerificacion,
            isDemoMode: isDemoMode,
            demoStartTimestamp: demoStartTimestamp,
            acceptedLegal: acceptedLegal,
            timestampUltimaVerificacionMaestro:
                timestampUltimaVerificacionMaestro,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConfiguracionLocalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConfiguracionLocalTable,
    ConfiguracionLocalData,
    $$ConfiguracionLocalTableFilterComposer,
    $$ConfiguracionLocalTableOrderingComposer,
    $$ConfiguracionLocalTableAnnotationComposer,
    $$ConfiguracionLocalTableCreateCompanionBuilder,
    $$ConfiguracionLocalTableUpdateCompanionBuilder,
    (
      ConfiguracionLocalData,
      BaseReferences<_$AppDatabase, $ConfiguracionLocalTable,
          ConfiguracionLocalData>
    ),
    ConfiguracionLocalData,
    PrefetchHooks Function()>;
typedef $$HistorialTasaTableCreateCompanionBuilder = HistorialTasaCompanion
    Function({
  Value<int> id,
  required double tasa,
  Value<String> fuente,
  Value<DateTime> fecha,
});
typedef $$HistorialTasaTableUpdateCompanionBuilder = HistorialTasaCompanion
    Function({
  Value<int> id,
  Value<double> tasa,
  Value<String> fuente,
  Value<DateTime> fecha,
});

class $$HistorialTasaTableFilterComposer
    extends Composer<_$AppDatabase, $HistorialTasaTable> {
  $$HistorialTasaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fuente => $composableBuilder(
      column: $table.fuente, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));
}

class $$HistorialTasaTableOrderingComposer
    extends Composer<_$AppDatabase, $HistorialTasaTable> {
  $$HistorialTasaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fuente => $composableBuilder(
      column: $table.fuente, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));
}

class $$HistorialTasaTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistorialTasaTable> {
  $$HistorialTasaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get tasa =>
      $composableBuilder(column: $table.tasa, builder: (column) => column);

  GeneratedColumn<String> get fuente =>
      $composableBuilder(column: $table.fuente, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);
}

class $$HistorialTasaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HistorialTasaTable,
    HistorialTasaData,
    $$HistorialTasaTableFilterComposer,
    $$HistorialTasaTableOrderingComposer,
    $$HistorialTasaTableAnnotationComposer,
    $$HistorialTasaTableCreateCompanionBuilder,
    $$HistorialTasaTableUpdateCompanionBuilder,
    (
      HistorialTasaData,
      BaseReferences<_$AppDatabase, $HistorialTasaTable, HistorialTasaData>
    ),
    HistorialTasaData,
    PrefetchHooks Function()> {
  $$HistorialTasaTableTableManager(_$AppDatabase db, $HistorialTasaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistorialTasaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistorialTasaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistorialTasaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> tasa = const Value.absent(),
            Value<String> fuente = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
          }) =>
              HistorialTasaCompanion(
            id: id,
            tasa: tasa,
            fuente: fuente,
            fecha: fecha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double tasa,
            Value<String> fuente = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
          }) =>
              HistorialTasaCompanion.insert(
            id: id,
            tasa: tasa,
            fuente: fuente,
            fecha: fecha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HistorialTasaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HistorialTasaTable,
    HistorialTasaData,
    $$HistorialTasaTableFilterComposer,
    $$HistorialTasaTableOrderingComposer,
    $$HistorialTasaTableAnnotationComposer,
    $$HistorialTasaTableCreateCompanionBuilder,
    $$HistorialTasaTableUpdateCompanionBuilder,
    (
      HistorialTasaData,
      BaseReferences<_$AppDatabase, $HistorialTasaTable, HistorialTasaData>
    ),
    HistorialTasaData,
    PrefetchHooks Function()>;
typedef $$ProductoTableCreateCompanionBuilder = ProductoCompanion Function({
  Value<int> id,
  required String uuid,
  required String nombre,
  Value<String?> codigo,
  Value<String?> categoria,
  Value<String?> proveedorUuid,
  required double precioUsd,
  Value<double> costoUsd,
  Value<double?> precioMayor,
  Value<double> stock,
  Value<bool> exentoIva,
  Value<bool> esGranel,
  Value<String?> unidadMedida,
  Value<int?> fechaVencimiento,
  Value<int> stockMinimo,
  Value<bool> activo,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$ProductoTableUpdateCompanionBuilder = ProductoCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> nombre,
  Value<String?> codigo,
  Value<String?> categoria,
  Value<String?> proveedorUuid,
  Value<double> precioUsd,
  Value<double> costoUsd,
  Value<double?> precioMayor,
  Value<double> stock,
  Value<bool> exentoIva,
  Value<bool> esGranel,
  Value<String?> unidadMedida,
  Value<int?> fechaVencimiento,
  Value<int> stockMinimo,
  Value<bool> activo,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$ProductoTableFilterComposer
    extends Composer<_$AppDatabase, $ProductoTable> {
  $$ProductoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioUsd => $composableBuilder(
      column: $table.precioUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costoUsd => $composableBuilder(
      column: $table.costoUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioMayor => $composableBuilder(
      column: $table.precioMayor, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get exentoIva => $composableBuilder(
      column: $table.exentoIva, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get esGranel => $composableBuilder(
      column: $table.esGranel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unidadMedida => $composableBuilder(
      column: $table.unidadMedida, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaVencimiento => $composableBuilder(
      column: $table.fechaVencimiento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$ProductoTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductoTable> {
  $$ProductoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioUsd => $composableBuilder(
      column: $table.precioUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costoUsd => $composableBuilder(
      column: $table.costoUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioMayor => $composableBuilder(
      column: $table.precioMayor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get exentoIva => $composableBuilder(
      column: $table.exentoIva, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get esGranel => $composableBuilder(
      column: $table.esGranel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unidadMedida => $composableBuilder(
      column: $table.unidadMedida,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaVencimiento => $composableBuilder(
      column: $table.fechaVencimiento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductoTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductoTable> {
  $$ProductoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid, builder: (column) => column);

  GeneratedColumn<double> get precioUsd =>
      $composableBuilder(column: $table.precioUsd, builder: (column) => column);

  GeneratedColumn<double> get costoUsd =>
      $composableBuilder(column: $table.costoUsd, builder: (column) => column);

  GeneratedColumn<double> get precioMayor => $composableBuilder(
      column: $table.precioMayor, builder: (column) => column);

  GeneratedColumn<double> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<bool> get exentoIva =>
      $composableBuilder(column: $table.exentoIva, builder: (column) => column);

  GeneratedColumn<bool> get esGranel =>
      $composableBuilder(column: $table.esGranel, builder: (column) => column);

  GeneratedColumn<String> get unidadMedida => $composableBuilder(
      column: $table.unidadMedida, builder: (column) => column);

  GeneratedColumn<int> get fechaVencimiento => $composableBuilder(
      column: $table.fechaVencimiento, builder: (column) => column);

  GeneratedColumn<int> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$ProductoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductoTable,
    ProductoData,
    $$ProductoTableFilterComposer,
    $$ProductoTableOrderingComposer,
    $$ProductoTableAnnotationComposer,
    $$ProductoTableCreateCompanionBuilder,
    $$ProductoTableUpdateCompanionBuilder,
    (ProductoData, BaseReferences<_$AppDatabase, $ProductoTable, ProductoData>),
    ProductoData,
    PrefetchHooks Function()> {
  $$ProductoTableTableManager(_$AppDatabase db, $ProductoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> codigo = const Value.absent(),
            Value<String?> categoria = const Value.absent(),
            Value<String?> proveedorUuid = const Value.absent(),
            Value<double> precioUsd = const Value.absent(),
            Value<double> costoUsd = const Value.absent(),
            Value<double?> precioMayor = const Value.absent(),
            Value<double> stock = const Value.absent(),
            Value<bool> exentoIva = const Value.absent(),
            Value<bool> esGranel = const Value.absent(),
            Value<String?> unidadMedida = const Value.absent(),
            Value<int?> fechaVencimiento = const Value.absent(),
            Value<int> stockMinimo = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              ProductoCompanion(
            id: id,
            uuid: uuid,
            nombre: nombre,
            codigo: codigo,
            categoria: categoria,
            proveedorUuid: proveedorUuid,
            precioUsd: precioUsd,
            costoUsd: costoUsd,
            precioMayor: precioMayor,
            stock: stock,
            exentoIva: exentoIva,
            esGranel: esGranel,
            unidadMedida: unidadMedida,
            fechaVencimiento: fechaVencimiento,
            stockMinimo: stockMinimo,
            activo: activo,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String nombre,
            Value<String?> codigo = const Value.absent(),
            Value<String?> categoria = const Value.absent(),
            Value<String?> proveedorUuid = const Value.absent(),
            required double precioUsd,
            Value<double> costoUsd = const Value.absent(),
            Value<double?> precioMayor = const Value.absent(),
            Value<double> stock = const Value.absent(),
            Value<bool> exentoIva = const Value.absent(),
            Value<bool> esGranel = const Value.absent(),
            Value<String?> unidadMedida = const Value.absent(),
            Value<int?> fechaVencimiento = const Value.absent(),
            Value<int> stockMinimo = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              ProductoCompanion.insert(
            id: id,
            uuid: uuid,
            nombre: nombre,
            codigo: codigo,
            categoria: categoria,
            proveedorUuid: proveedorUuid,
            precioUsd: precioUsd,
            costoUsd: costoUsd,
            precioMayor: precioMayor,
            stock: stock,
            exentoIva: exentoIva,
            esGranel: esGranel,
            unidadMedida: unidadMedida,
            fechaVencimiento: fechaVencimiento,
            stockMinimo: stockMinimo,
            activo: activo,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductoTable,
    ProductoData,
    $$ProductoTableFilterComposer,
    $$ProductoTableOrderingComposer,
    $$ProductoTableAnnotationComposer,
    $$ProductoTableCreateCompanionBuilder,
    $$ProductoTableUpdateCompanionBuilder,
    (ProductoData, BaseReferences<_$AppDatabase, $ProductoTable, ProductoData>),
    ProductoData,
    PrefetchHooks Function()>;
typedef $$VentaTableCreateCompanionBuilder = VentaCompanion Function({
  Value<int> id,
  required String uuid,
  required int numeroVenta,
  required int fecha,
  required String itemsJson,
  required String pagosJson,
  required double totalUsd,
  required double totalBs,
  required double tasaUsada,
  required double ivaBs,
  required double igtfBs,
  Value<double> exentoBs,
  Value<bool> esFiado,
  Value<int?> clienteId,
  Value<bool> anulada,
  Value<String?> motivoAnulacion,
  required String usuarioId,
  required String usuarioNombre,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$VentaTableUpdateCompanionBuilder = VentaCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> numeroVenta,
  Value<int> fecha,
  Value<String> itemsJson,
  Value<String> pagosJson,
  Value<double> totalUsd,
  Value<double> totalBs,
  Value<double> tasaUsada,
  Value<double> ivaBs,
  Value<double> igtfBs,
  Value<double> exentoBs,
  Value<bool> esFiado,
  Value<int?> clienteId,
  Value<bool> anulada,
  Value<String?> motivoAnulacion,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$VentaTableFilterComposer extends Composer<_$AppDatabase, $VentaTable> {
  $$VentaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numeroVenta => $composableBuilder(
      column: $table.numeroVenta, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pagosJson => $composableBuilder(
      column: $table.pagosJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalUsd => $composableBuilder(
      column: $table.totalUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalBs => $composableBuilder(
      column: $table.totalBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasaUsada => $composableBuilder(
      column: $table.tasaUsada, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ivaBs => $composableBuilder(
      column: $table.ivaBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get igtfBs => $composableBuilder(
      column: $table.igtfBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exentoBs => $composableBuilder(
      column: $table.exentoBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get esFiado => $composableBuilder(
      column: $table.esFiado, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clienteId => $composableBuilder(
      column: $table.clienteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get anulada => $composableBuilder(
      column: $table.anulada, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motivoAnulacion => $composableBuilder(
      column: $table.motivoAnulacion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$VentaTableOrderingComposer
    extends Composer<_$AppDatabase, $VentaTable> {
  $$VentaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numeroVenta => $composableBuilder(
      column: $table.numeroVenta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pagosJson => $composableBuilder(
      column: $table.pagosJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalUsd => $composableBuilder(
      column: $table.totalUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalBs => $composableBuilder(
      column: $table.totalBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasaUsada => $composableBuilder(
      column: $table.tasaUsada, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ivaBs => $composableBuilder(
      column: $table.ivaBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get igtfBs => $composableBuilder(
      column: $table.igtfBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exentoBs => $composableBuilder(
      column: $table.exentoBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get esFiado => $composableBuilder(
      column: $table.esFiado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clienteId => $composableBuilder(
      column: $table.clienteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get anulada => $composableBuilder(
      column: $table.anulada, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motivoAnulacion => $composableBuilder(
      column: $table.motivoAnulacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$VentaTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentaTable> {
  $$VentaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get numeroVenta => $composableBuilder(
      column: $table.numeroVenta, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<String> get pagosJson =>
      $composableBuilder(column: $table.pagosJson, builder: (column) => column);

  GeneratedColumn<double> get totalUsd =>
      $composableBuilder(column: $table.totalUsd, builder: (column) => column);

  GeneratedColumn<double> get totalBs =>
      $composableBuilder(column: $table.totalBs, builder: (column) => column);

  GeneratedColumn<double> get tasaUsada =>
      $composableBuilder(column: $table.tasaUsada, builder: (column) => column);

  GeneratedColumn<double> get ivaBs =>
      $composableBuilder(column: $table.ivaBs, builder: (column) => column);

  GeneratedColumn<double> get igtfBs =>
      $composableBuilder(column: $table.igtfBs, builder: (column) => column);

  GeneratedColumn<double> get exentoBs =>
      $composableBuilder(column: $table.exentoBs, builder: (column) => column);

  GeneratedColumn<bool> get esFiado =>
      $composableBuilder(column: $table.esFiado, builder: (column) => column);

  GeneratedColumn<int> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<bool> get anulada =>
      $composableBuilder(column: $table.anulada, builder: (column) => column);

  GeneratedColumn<String> get motivoAnulacion => $composableBuilder(
      column: $table.motivoAnulacion, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$VentaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VentaTable,
    VentaData,
    $$VentaTableFilterComposer,
    $$VentaTableOrderingComposer,
    $$VentaTableAnnotationComposer,
    $$VentaTableCreateCompanionBuilder,
    $$VentaTableUpdateCompanionBuilder,
    (VentaData, BaseReferences<_$AppDatabase, $VentaTable, VentaData>),
    VentaData,
    PrefetchHooks Function()> {
  $$VentaTableTableManager(_$AppDatabase db, $VentaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> numeroVenta = const Value.absent(),
            Value<int> fecha = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<String> pagosJson = const Value.absent(),
            Value<double> totalUsd = const Value.absent(),
            Value<double> totalBs = const Value.absent(),
            Value<double> tasaUsada = const Value.absent(),
            Value<double> ivaBs = const Value.absent(),
            Value<double> igtfBs = const Value.absent(),
            Value<double> exentoBs = const Value.absent(),
            Value<bool> esFiado = const Value.absent(),
            Value<int?> clienteId = const Value.absent(),
            Value<bool> anulada = const Value.absent(),
            Value<String?> motivoAnulacion = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              VentaCompanion(
            id: id,
            uuid: uuid,
            numeroVenta: numeroVenta,
            fecha: fecha,
            itemsJson: itemsJson,
            pagosJson: pagosJson,
            totalUsd: totalUsd,
            totalBs: totalBs,
            tasaUsada: tasaUsada,
            ivaBs: ivaBs,
            igtfBs: igtfBs,
            exentoBs: exentoBs,
            esFiado: esFiado,
            clienteId: clienteId,
            anulada: anulada,
            motivoAnulacion: motivoAnulacion,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required int numeroVenta,
            required int fecha,
            required String itemsJson,
            required String pagosJson,
            required double totalUsd,
            required double totalBs,
            required double tasaUsada,
            required double ivaBs,
            required double igtfBs,
            Value<double> exentoBs = const Value.absent(),
            Value<bool> esFiado = const Value.absent(),
            Value<int?> clienteId = const Value.absent(),
            Value<bool> anulada = const Value.absent(),
            Value<String?> motivoAnulacion = const Value.absent(),
            required String usuarioId,
            required String usuarioNombre,
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              VentaCompanion.insert(
            id: id,
            uuid: uuid,
            numeroVenta: numeroVenta,
            fecha: fecha,
            itemsJson: itemsJson,
            pagosJson: pagosJson,
            totalUsd: totalUsd,
            totalBs: totalBs,
            tasaUsada: tasaUsada,
            ivaBs: ivaBs,
            igtfBs: igtfBs,
            exentoBs: exentoBs,
            esFiado: esFiado,
            clienteId: clienteId,
            anulada: anulada,
            motivoAnulacion: motivoAnulacion,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VentaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VentaTable,
    VentaData,
    $$VentaTableFilterComposer,
    $$VentaTableOrderingComposer,
    $$VentaTableAnnotationComposer,
    $$VentaTableCreateCompanionBuilder,
    $$VentaTableUpdateCompanionBuilder,
    (VentaData, BaseReferences<_$AppDatabase, $VentaTable, VentaData>),
    VentaData,
    PrefetchHooks Function()>;
typedef $$ClienteTableCreateCompanionBuilder = ClienteCompanion Function({
  Value<int> id,
  required String uuid,
  required String nombre,
  Value<String?> cedula,
  Value<String?> telefono,
  Value<double> saldoPendienteUsd,
  Value<double?> limiteCreditoUsd,
  Value<bool> activo,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$ClienteTableUpdateCompanionBuilder = ClienteCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> nombre,
  Value<String?> cedula,
  Value<String?> telefono,
  Value<double> saldoPendienteUsd,
  Value<double?> limiteCreditoUsd,
  Value<bool> activo,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$ClienteTableFilterComposer
    extends Composer<_$AppDatabase, $ClienteTable> {
  $$ClienteTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cedula => $composableBuilder(
      column: $table.cedula, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get saldoPendienteUsd => $composableBuilder(
      column: $table.saldoPendienteUsd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get limiteCreditoUsd => $composableBuilder(
      column: $table.limiteCreditoUsd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$ClienteTableOrderingComposer
    extends Composer<_$AppDatabase, $ClienteTable> {
  $$ClienteTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cedula => $composableBuilder(
      column: $table.cedula, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get saldoPendienteUsd => $composableBuilder(
      column: $table.saldoPendienteUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get limiteCreditoUsd => $composableBuilder(
      column: $table.limiteCreditoUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$ClienteTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClienteTable> {
  $$ClienteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get cedula =>
      $composableBuilder(column: $table.cedula, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<double> get saldoPendienteUsd => $composableBuilder(
      column: $table.saldoPendienteUsd, builder: (column) => column);

  GeneratedColumn<double> get limiteCreditoUsd => $composableBuilder(
      column: $table.limiteCreditoUsd, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$ClienteTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClienteTable,
    ClienteData,
    $$ClienteTableFilterComposer,
    $$ClienteTableOrderingComposer,
    $$ClienteTableAnnotationComposer,
    $$ClienteTableCreateCompanionBuilder,
    $$ClienteTableUpdateCompanionBuilder,
    (ClienteData, BaseReferences<_$AppDatabase, $ClienteTable, ClienteData>),
    ClienteData,
    PrefetchHooks Function()> {
  $$ClienteTableTableManager(_$AppDatabase db, $ClienteTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClienteTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClienteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClienteTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> cedula = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<double> saldoPendienteUsd = const Value.absent(),
            Value<double?> limiteCreditoUsd = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              ClienteCompanion(
            id: id,
            uuid: uuid,
            nombre: nombre,
            cedula: cedula,
            telefono: telefono,
            saldoPendienteUsd: saldoPendienteUsd,
            limiteCreditoUsd: limiteCreditoUsd,
            activo: activo,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String nombre,
            Value<String?> cedula = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<double> saldoPendienteUsd = const Value.absent(),
            Value<double?> limiteCreditoUsd = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              ClienteCompanion.insert(
            id: id,
            uuid: uuid,
            nombre: nombre,
            cedula: cedula,
            telefono: telefono,
            saldoPendienteUsd: saldoPendienteUsd,
            limiteCreditoUsd: limiteCreditoUsd,
            activo: activo,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClienteTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClienteTable,
    ClienteData,
    $$ClienteTableFilterComposer,
    $$ClienteTableOrderingComposer,
    $$ClienteTableAnnotationComposer,
    $$ClienteTableCreateCompanionBuilder,
    $$ClienteTableUpdateCompanionBuilder,
    (ClienteData, BaseReferences<_$AppDatabase, $ClienteTable, ClienteData>),
    ClienteData,
    PrefetchHooks Function()>;
typedef $$PagoFiadoTableCreateCompanionBuilder = PagoFiadoCompanion Function({
  Value<int> id,
  required String uuid,
  required int clienteId,
  Value<int?> ventaId,
  required String tipo,
  required double montoUsd,
  required double montoBs,
  required double tasa,
  Value<String?> nota,
  required String usuarioId,
  required String usuarioNombre,
  required int fecha,
});
typedef $$PagoFiadoTableUpdateCompanionBuilder = PagoFiadoCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> clienteId,
  Value<int?> ventaId,
  Value<String> tipo,
  Value<double> montoUsd,
  Value<double> montoBs,
  Value<double> tasa,
  Value<String?> nota,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fecha,
});

class $$PagoFiadoTableFilterComposer
    extends Composer<_$AppDatabase, $PagoFiadoTable> {
  $$PagoFiadoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clienteId => $composableBuilder(
      column: $table.clienteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ventaId => $composableBuilder(
      column: $table.ventaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoBs => $composableBuilder(
      column: $table.montoBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));
}

class $$PagoFiadoTableOrderingComposer
    extends Composer<_$AppDatabase, $PagoFiadoTable> {
  $$PagoFiadoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clienteId => $composableBuilder(
      column: $table.clienteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ventaId => $composableBuilder(
      column: $table.ventaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoBs => $composableBuilder(
      column: $table.montoBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));
}

class $$PagoFiadoTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagoFiadoTable> {
  $$PagoFiadoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<int> get ventaId =>
      $composableBuilder(column: $table.ventaId, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get montoUsd =>
      $composableBuilder(column: $table.montoUsd, builder: (column) => column);

  GeneratedColumn<double> get montoBs =>
      $composableBuilder(column: $table.montoBs, builder: (column) => column);

  GeneratedColumn<double> get tasa =>
      $composableBuilder(column: $table.tasa, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);
}

class $$PagoFiadoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PagoFiadoTable,
    PagoFiadoData,
    $$PagoFiadoTableFilterComposer,
    $$PagoFiadoTableOrderingComposer,
    $$PagoFiadoTableAnnotationComposer,
    $$PagoFiadoTableCreateCompanionBuilder,
    $$PagoFiadoTableUpdateCompanionBuilder,
    (
      PagoFiadoData,
      BaseReferences<_$AppDatabase, $PagoFiadoTable, PagoFiadoData>
    ),
    PagoFiadoData,
    PrefetchHooks Function()> {
  $$PagoFiadoTableTableManager(_$AppDatabase db, $PagoFiadoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagoFiadoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagoFiadoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagoFiadoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> clienteId = const Value.absent(),
            Value<int?> ventaId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<double> montoUsd = const Value.absent(),
            Value<double> montoBs = const Value.absent(),
            Value<double> tasa = const Value.absent(),
            Value<String?> nota = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fecha = const Value.absent(),
          }) =>
              PagoFiadoCompanion(
            id: id,
            uuid: uuid,
            clienteId: clienteId,
            ventaId: ventaId,
            tipo: tipo,
            montoUsd: montoUsd,
            montoBs: montoBs,
            tasa: tasa,
            nota: nota,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required int clienteId,
            Value<int?> ventaId = const Value.absent(),
            required String tipo,
            required double montoUsd,
            required double montoBs,
            required double tasa,
            Value<String?> nota = const Value.absent(),
            required String usuarioId,
            required String usuarioNombre,
            required int fecha,
          }) =>
              PagoFiadoCompanion.insert(
            id: id,
            uuid: uuid,
            clienteId: clienteId,
            ventaId: ventaId,
            tipo: tipo,
            montoUsd: montoUsd,
            montoBs: montoBs,
            tasa: tasa,
            nota: nota,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PagoFiadoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PagoFiadoTable,
    PagoFiadoData,
    $$PagoFiadoTableFilterComposer,
    $$PagoFiadoTableOrderingComposer,
    $$PagoFiadoTableAnnotationComposer,
    $$PagoFiadoTableCreateCompanionBuilder,
    $$PagoFiadoTableUpdateCompanionBuilder,
    (
      PagoFiadoData,
      BaseReferences<_$AppDatabase, $PagoFiadoTable, PagoFiadoData>
    ),
    PagoFiadoData,
    PrefetchHooks Function()>;
typedef $$AperturaCajaTableCreateCompanionBuilder = AperturaCajaCompanion
    Function({
  Value<int> id,
  required String uuid,
  required String usuarioId,
  required String usuarioNombre,
  Value<double> montoInicialBs,
  Value<double> montoInicialUsd,
  Value<String?> novedad,
  Value<bool> cerrada,
  required int fecha,
  Value<int?> fechaCierre,
});
typedef $$AperturaCajaTableUpdateCompanionBuilder = AperturaCajaCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<double> montoInicialBs,
  Value<double> montoInicialUsd,
  Value<String?> novedad,
  Value<bool> cerrada,
  Value<int> fecha,
  Value<int?> fechaCierre,
});

class $$AperturaCajaTableFilterComposer
    extends Composer<_$AppDatabase, $AperturaCajaTable> {
  $$AperturaCajaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoInicialBs => $composableBuilder(
      column: $table.montoInicialBs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoInicialUsd => $composableBuilder(
      column: $table.montoInicialUsd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get novedad => $composableBuilder(
      column: $table.novedad, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cerrada => $composableBuilder(
      column: $table.cerrada, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCierre => $composableBuilder(
      column: $table.fechaCierre, builder: (column) => ColumnFilters(column));
}

class $$AperturaCajaTableOrderingComposer
    extends Composer<_$AppDatabase, $AperturaCajaTable> {
  $$AperturaCajaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoInicialBs => $composableBuilder(
      column: $table.montoInicialBs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoInicialUsd => $composableBuilder(
      column: $table.montoInicialUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get novedad => $composableBuilder(
      column: $table.novedad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cerrada => $composableBuilder(
      column: $table.cerrada, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCierre => $composableBuilder(
      column: $table.fechaCierre, builder: (column) => ColumnOrderings(column));
}

class $$AperturaCajaTableAnnotationComposer
    extends Composer<_$AppDatabase, $AperturaCajaTable> {
  $$AperturaCajaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<double> get montoInicialBs => $composableBuilder(
      column: $table.montoInicialBs, builder: (column) => column);

  GeneratedColumn<double> get montoInicialUsd => $composableBuilder(
      column: $table.montoInicialUsd, builder: (column) => column);

  GeneratedColumn<String> get novedad =>
      $composableBuilder(column: $table.novedad, builder: (column) => column);

  GeneratedColumn<bool> get cerrada =>
      $composableBuilder(column: $table.cerrada, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get fechaCierre => $composableBuilder(
      column: $table.fechaCierre, builder: (column) => column);
}

class $$AperturaCajaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AperturaCajaTable,
    AperturaCajaData,
    $$AperturaCajaTableFilterComposer,
    $$AperturaCajaTableOrderingComposer,
    $$AperturaCajaTableAnnotationComposer,
    $$AperturaCajaTableCreateCompanionBuilder,
    $$AperturaCajaTableUpdateCompanionBuilder,
    (
      AperturaCajaData,
      BaseReferences<_$AppDatabase, $AperturaCajaTable, AperturaCajaData>
    ),
    AperturaCajaData,
    PrefetchHooks Function()> {
  $$AperturaCajaTableTableManager(_$AppDatabase db, $AperturaCajaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AperturaCajaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AperturaCajaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AperturaCajaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<double> montoInicialBs = const Value.absent(),
            Value<double> montoInicialUsd = const Value.absent(),
            Value<String?> novedad = const Value.absent(),
            Value<bool> cerrada = const Value.absent(),
            Value<int> fecha = const Value.absent(),
            Value<int?> fechaCierre = const Value.absent(),
          }) =>
              AperturaCajaCompanion(
            id: id,
            uuid: uuid,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            montoInicialBs: montoInicialBs,
            montoInicialUsd: montoInicialUsd,
            novedad: novedad,
            cerrada: cerrada,
            fecha: fecha,
            fechaCierre: fechaCierre,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String usuarioId,
            required String usuarioNombre,
            Value<double> montoInicialBs = const Value.absent(),
            Value<double> montoInicialUsd = const Value.absent(),
            Value<String?> novedad = const Value.absent(),
            Value<bool> cerrada = const Value.absent(),
            required int fecha,
            Value<int?> fechaCierre = const Value.absent(),
          }) =>
              AperturaCajaCompanion.insert(
            id: id,
            uuid: uuid,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            montoInicialBs: montoInicialBs,
            montoInicialUsd: montoInicialUsd,
            novedad: novedad,
            cerrada: cerrada,
            fecha: fecha,
            fechaCierre: fechaCierre,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AperturaCajaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AperturaCajaTable,
    AperturaCajaData,
    $$AperturaCajaTableFilterComposer,
    $$AperturaCajaTableOrderingComposer,
    $$AperturaCajaTableAnnotationComposer,
    $$AperturaCajaTableCreateCompanionBuilder,
    $$AperturaCajaTableUpdateCompanionBuilder,
    (
      AperturaCajaData,
      BaseReferences<_$AppDatabase, $AperturaCajaTable, AperturaCajaData>
    ),
    AperturaCajaData,
    PrefetchHooks Function()>;
typedef $$CierreCajaTableCreateCompanionBuilder = CierreCajaCompanion Function({
  Value<int> id,
  required String uuid,
  required int aperturaId,
  required String usuarioId,
  required String usuarioNombre,
  required double montoEsperadoBs,
  required double montoRealBs,
  required double diferenciaBs,
  required String resumenJson,
  Value<String?> nota,
  required int fecha,
});
typedef $$CierreCajaTableUpdateCompanionBuilder = CierreCajaCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> aperturaId,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<double> montoEsperadoBs,
  Value<double> montoRealBs,
  Value<double> diferenciaBs,
  Value<String> resumenJson,
  Value<String?> nota,
  Value<int> fecha,
});

class $$CierreCajaTableFilterComposer
    extends Composer<_$AppDatabase, $CierreCajaTable> {
  $$CierreCajaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aperturaId => $composableBuilder(
      column: $table.aperturaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoEsperadoBs => $composableBuilder(
      column: $table.montoEsperadoBs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoRealBs => $composableBuilder(
      column: $table.montoRealBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get diferenciaBs => $composableBuilder(
      column: $table.diferenciaBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get resumenJson => $composableBuilder(
      column: $table.resumenJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));
}

class $$CierreCajaTableOrderingComposer
    extends Composer<_$AppDatabase, $CierreCajaTable> {
  $$CierreCajaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aperturaId => $composableBuilder(
      column: $table.aperturaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoEsperadoBs => $composableBuilder(
      column: $table.montoEsperadoBs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoRealBs => $composableBuilder(
      column: $table.montoRealBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get diferenciaBs => $composableBuilder(
      column: $table.diferenciaBs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get resumenJson => $composableBuilder(
      column: $table.resumenJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));
}

class $$CierreCajaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CierreCajaTable> {
  $$CierreCajaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get aperturaId => $composableBuilder(
      column: $table.aperturaId, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<double> get montoEsperadoBs => $composableBuilder(
      column: $table.montoEsperadoBs, builder: (column) => column);

  GeneratedColumn<double> get montoRealBs => $composableBuilder(
      column: $table.montoRealBs, builder: (column) => column);

  GeneratedColumn<double> get diferenciaBs => $composableBuilder(
      column: $table.diferenciaBs, builder: (column) => column);

  GeneratedColumn<String> get resumenJson => $composableBuilder(
      column: $table.resumenJson, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);
}

class $$CierreCajaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CierreCajaTable,
    CierreCajaData,
    $$CierreCajaTableFilterComposer,
    $$CierreCajaTableOrderingComposer,
    $$CierreCajaTableAnnotationComposer,
    $$CierreCajaTableCreateCompanionBuilder,
    $$CierreCajaTableUpdateCompanionBuilder,
    (
      CierreCajaData,
      BaseReferences<_$AppDatabase, $CierreCajaTable, CierreCajaData>
    ),
    CierreCajaData,
    PrefetchHooks Function()> {
  $$CierreCajaTableTableManager(_$AppDatabase db, $CierreCajaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CierreCajaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CierreCajaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CierreCajaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> aperturaId = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<double> montoEsperadoBs = const Value.absent(),
            Value<double> montoRealBs = const Value.absent(),
            Value<double> diferenciaBs = const Value.absent(),
            Value<String> resumenJson = const Value.absent(),
            Value<String?> nota = const Value.absent(),
            Value<int> fecha = const Value.absent(),
          }) =>
              CierreCajaCompanion(
            id: id,
            uuid: uuid,
            aperturaId: aperturaId,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            montoEsperadoBs: montoEsperadoBs,
            montoRealBs: montoRealBs,
            diferenciaBs: diferenciaBs,
            resumenJson: resumenJson,
            nota: nota,
            fecha: fecha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required int aperturaId,
            required String usuarioId,
            required String usuarioNombre,
            required double montoEsperadoBs,
            required double montoRealBs,
            required double diferenciaBs,
            required String resumenJson,
            Value<String?> nota = const Value.absent(),
            required int fecha,
          }) =>
              CierreCajaCompanion.insert(
            id: id,
            uuid: uuid,
            aperturaId: aperturaId,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            montoEsperadoBs: montoEsperadoBs,
            montoRealBs: montoRealBs,
            diferenciaBs: diferenciaBs,
            resumenJson: resumenJson,
            nota: nota,
            fecha: fecha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CierreCajaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CierreCajaTable,
    CierreCajaData,
    $$CierreCajaTableFilterComposer,
    $$CierreCajaTableOrderingComposer,
    $$CierreCajaTableAnnotationComposer,
    $$CierreCajaTableCreateCompanionBuilder,
    $$CierreCajaTableUpdateCompanionBuilder,
    (
      CierreCajaData,
      BaseReferences<_$AppDatabase, $CierreCajaTable, CierreCajaData>
    ),
    CierreCajaData,
    PrefetchHooks Function()>;
typedef $$RetiroCajaTableCreateCompanionBuilder = RetiroCajaCompanion Function({
  Value<int> id,
  required String uuid,
  required int aperturaId,
  required String usuarioId,
  required String usuarioNombre,
  required double montoBs,
  required String motivo,
  required int fecha,
});
typedef $$RetiroCajaTableUpdateCompanionBuilder = RetiroCajaCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> aperturaId,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<double> montoBs,
  Value<String> motivo,
  Value<int> fecha,
});

class $$RetiroCajaTableFilterComposer
    extends Composer<_$AppDatabase, $RetiroCajaTable> {
  $$RetiroCajaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get aperturaId => $composableBuilder(
      column: $table.aperturaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoBs => $composableBuilder(
      column: $table.montoBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));
}

class $$RetiroCajaTableOrderingComposer
    extends Composer<_$AppDatabase, $RetiroCajaTable> {
  $$RetiroCajaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get aperturaId => $composableBuilder(
      column: $table.aperturaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoBs => $composableBuilder(
      column: $table.montoBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));
}

class $$RetiroCajaTableAnnotationComposer
    extends Composer<_$AppDatabase, $RetiroCajaTable> {
  $$RetiroCajaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get aperturaId => $composableBuilder(
      column: $table.aperturaId, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<double> get montoBs =>
      $composableBuilder(column: $table.montoBs, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);
}

class $$RetiroCajaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RetiroCajaTable,
    RetiroCajaData,
    $$RetiroCajaTableFilterComposer,
    $$RetiroCajaTableOrderingComposer,
    $$RetiroCajaTableAnnotationComposer,
    $$RetiroCajaTableCreateCompanionBuilder,
    $$RetiroCajaTableUpdateCompanionBuilder,
    (
      RetiroCajaData,
      BaseReferences<_$AppDatabase, $RetiroCajaTable, RetiroCajaData>
    ),
    RetiroCajaData,
    PrefetchHooks Function()> {
  $$RetiroCajaTableTableManager(_$AppDatabase db, $RetiroCajaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RetiroCajaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RetiroCajaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RetiroCajaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> aperturaId = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<double> montoBs = const Value.absent(),
            Value<String> motivo = const Value.absent(),
            Value<int> fecha = const Value.absent(),
          }) =>
              RetiroCajaCompanion(
            id: id,
            uuid: uuid,
            aperturaId: aperturaId,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            montoBs: montoBs,
            motivo: motivo,
            fecha: fecha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required int aperturaId,
            required String usuarioId,
            required String usuarioNombre,
            required double montoBs,
            required String motivo,
            required int fecha,
          }) =>
              RetiroCajaCompanion.insert(
            id: id,
            uuid: uuid,
            aperturaId: aperturaId,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            montoBs: montoBs,
            motivo: motivo,
            fecha: fecha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RetiroCajaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RetiroCajaTable,
    RetiroCajaData,
    $$RetiroCajaTableFilterComposer,
    $$RetiroCajaTableOrderingComposer,
    $$RetiroCajaTableAnnotationComposer,
    $$RetiroCajaTableCreateCompanionBuilder,
    $$RetiroCajaTableUpdateCompanionBuilder,
    (
      RetiroCajaData,
      BaseReferences<_$AppDatabase, $RetiroCajaTable, RetiroCajaData>
    ),
    RetiroCajaData,
    PrefetchHooks Function()>;
typedef $$MermaTableCreateCompanionBuilder = MermaCompanion Function({
  Value<int> id,
  required String uuid,
  required int productoId,
  required String productoNombre,
  required double cantidad,
  required String unidad,
  required String motivo,
  Value<String?> nota,
  Value<double> costoUsd,
  required String usuarioId,
  required String usuarioNombre,
  required int fecha,
});
typedef $$MermaTableUpdateCompanionBuilder = MermaCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> productoId,
  Value<String> productoNombre,
  Value<double> cantidad,
  Value<String> unidad,
  Value<String> motivo,
  Value<String?> nota,
  Value<double> costoUsd,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fecha,
});

class $$MermaTableFilterComposer extends Composer<_$AppDatabase, $MermaTable> {
  $$MermaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productoNombre => $composableBuilder(
      column: $table.productoNombre,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costoUsd => $composableBuilder(
      column: $table.costoUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));
}

class $$MermaTableOrderingComposer
    extends Composer<_$AppDatabase, $MermaTable> {
  $$MermaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productoNombre => $composableBuilder(
      column: $table.productoNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unidad => $composableBuilder(
      column: $table.unidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costoUsd => $composableBuilder(
      column: $table.costoUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));
}

class $$MermaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MermaTable> {
  $$MermaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<String> get productoNombre => $composableBuilder(
      column: $table.productoNombre, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<double> get costoUsd =>
      $composableBuilder(column: $table.costoUsd, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);
}

class $$MermaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MermaTable,
    MermaData,
    $$MermaTableFilterComposer,
    $$MermaTableOrderingComposer,
    $$MermaTableAnnotationComposer,
    $$MermaTableCreateCompanionBuilder,
    $$MermaTableUpdateCompanionBuilder,
    (MermaData, BaseReferences<_$AppDatabase, $MermaTable, MermaData>),
    MermaData,
    PrefetchHooks Function()> {
  $$MermaTableTableManager(_$AppDatabase db, $MermaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MermaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MermaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MermaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<String> productoNombre = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<String> unidad = const Value.absent(),
            Value<String> motivo = const Value.absent(),
            Value<String?> nota = const Value.absent(),
            Value<double> costoUsd = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fecha = const Value.absent(),
          }) =>
              MermaCompanion(
            id: id,
            uuid: uuid,
            productoId: productoId,
            productoNombre: productoNombre,
            cantidad: cantidad,
            unidad: unidad,
            motivo: motivo,
            nota: nota,
            costoUsd: costoUsd,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required int productoId,
            required String productoNombre,
            required double cantidad,
            required String unidad,
            required String motivo,
            Value<String?> nota = const Value.absent(),
            Value<double> costoUsd = const Value.absent(),
            required String usuarioId,
            required String usuarioNombre,
            required int fecha,
          }) =>
              MermaCompanion.insert(
            id: id,
            uuid: uuid,
            productoId: productoId,
            productoNombre: productoNombre,
            cantidad: cantidad,
            unidad: unidad,
            motivo: motivo,
            nota: nota,
            costoUsd: costoUsd,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MermaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MermaTable,
    MermaData,
    $$MermaTableFilterComposer,
    $$MermaTableOrderingComposer,
    $$MermaTableAnnotationComposer,
    $$MermaTableCreateCompanionBuilder,
    $$MermaTableUpdateCompanionBuilder,
    (MermaData, BaseReferences<_$AppDatabase, $MermaTable, MermaData>),
    MermaData,
    PrefetchHooks Function()>;
typedef $$AuditoriaLogTableCreateCompanionBuilder = AuditoriaLogCompanion
    Function({
  Value<int> id,
  required String uuid,
  required String usuarioId,
  required String usuarioNombre,
  required String accion,
  Value<String?> detalles,
  required int fecha,
});
typedef $$AuditoriaLogTableUpdateCompanionBuilder = AuditoriaLogCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<String> accion,
  Value<String?> detalles,
  Value<int> fecha,
});

class $$AuditoriaLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditoriaLogTable> {
  $$AuditoriaLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accion => $composableBuilder(
      column: $table.accion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detalles => $composableBuilder(
      column: $table.detalles, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));
}

class $$AuditoriaLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditoriaLogTable> {
  $$AuditoriaLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accion => $composableBuilder(
      column: $table.accion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detalles => $composableBuilder(
      column: $table.detalles, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));
}

class $$AuditoriaLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditoriaLogTable> {
  $$AuditoriaLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<String> get accion =>
      $composableBuilder(column: $table.accion, builder: (column) => column);

  GeneratedColumn<String> get detalles =>
      $composableBuilder(column: $table.detalles, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);
}

class $$AuditoriaLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditoriaLogTable,
    AuditoriaLogData,
    $$AuditoriaLogTableFilterComposer,
    $$AuditoriaLogTableOrderingComposer,
    $$AuditoriaLogTableAnnotationComposer,
    $$AuditoriaLogTableCreateCompanionBuilder,
    $$AuditoriaLogTableUpdateCompanionBuilder,
    (
      AuditoriaLogData,
      BaseReferences<_$AppDatabase, $AuditoriaLogTable, AuditoriaLogData>
    ),
    AuditoriaLogData,
    PrefetchHooks Function()> {
  $$AuditoriaLogTableTableManager(_$AppDatabase db, $AuditoriaLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditoriaLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditoriaLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditoriaLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<String> accion = const Value.absent(),
            Value<String?> detalles = const Value.absent(),
            Value<int> fecha = const Value.absent(),
          }) =>
              AuditoriaLogCompanion(
            id: id,
            uuid: uuid,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            accion: accion,
            detalles: detalles,
            fecha: fecha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String usuarioId,
            required String usuarioNombre,
            required String accion,
            Value<String?> detalles = const Value.absent(),
            required int fecha,
          }) =>
              AuditoriaLogCompanion.insert(
            id: id,
            uuid: uuid,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            accion: accion,
            detalles: detalles,
            fecha: fecha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditoriaLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditoriaLogTable,
    AuditoriaLogData,
    $$AuditoriaLogTableFilterComposer,
    $$AuditoriaLogTableOrderingComposer,
    $$AuditoriaLogTableAnnotationComposer,
    $$AuditoriaLogTableCreateCompanionBuilder,
    $$AuditoriaLogTableUpdateCompanionBuilder,
    (
      AuditoriaLogData,
      BaseReferences<_$AppDatabase, $AuditoriaLogTable, AuditoriaLogData>
    ),
    AuditoriaLogData,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String coleccion,
  required String docId,
  required String operacion,
  required String payload,
  required int timestamp,
  Value<int> intentos,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> coleccion,
  Value<String> docId,
  Value<String> operacion,
  Value<String> payload,
  Value<int> timestamp,
  Value<int> intentos,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coleccion => $composableBuilder(
      column: $table.coleccion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get docId => $composableBuilder(
      column: $table.docId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operacion => $composableBuilder(
      column: $table.operacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intentos => $composableBuilder(
      column: $table.intentos, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coleccion => $composableBuilder(
      column: $table.coleccion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get docId => $composableBuilder(
      column: $table.docId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operacion => $composableBuilder(
      column: $table.operacion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intentos => $composableBuilder(
      column: $table.intentos, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get coleccion =>
      $composableBuilder(column: $table.coleccion, builder: (column) => column);

  GeneratedColumn<String> get docId =>
      $composableBuilder(column: $table.docId, builder: (column) => column);

  GeneratedColumn<String> get operacion =>
      $composableBuilder(column: $table.operacion, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get intentos =>
      $composableBuilder(column: $table.intentos, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> coleccion = const Value.absent(),
            Value<String> docId = const Value.absent(),
            Value<String> operacion = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<int> intentos = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            coleccion: coleccion,
            docId: docId,
            operacion: operacion,
            payload: payload,
            timestamp: timestamp,
            intentos: intentos,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String coleccion,
            required String docId,
            required String operacion,
            required String payload,
            required int timestamp,
            Value<int> intentos = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            coleccion: coleccion,
            docId: docId,
            operacion: operacion,
            payload: payload,
            timestamp: timestamp,
            intentos: intentos,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;
typedef $$GastoTableCreateCompanionBuilder = GastoCompanion Function({
  Value<int> id,
  required String uuid,
  required String categoria,
  required String descripcion,
  required double montoUsd,
  required double tasa,
  required int fecha,
  required String usuarioId,
  required String usuarioNombre,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$GastoTableUpdateCompanionBuilder = GastoCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> categoria,
  Value<String> descripcion,
  Value<double> montoUsd,
  Value<double> tasa,
  Value<int> fecha,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$GastoTableFilterComposer extends Composer<_$AppDatabase, $GastoTable> {
  $$GastoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$GastoTableOrderingComposer
    extends Composer<_$AppDatabase, $GastoTable> {
  $$GastoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$GastoTableAnnotationComposer
    extends Composer<_$AppDatabase, $GastoTable> {
  $$GastoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<double> get montoUsd =>
      $composableBuilder(column: $table.montoUsd, builder: (column) => column);

  GeneratedColumn<double> get tasa =>
      $composableBuilder(column: $table.tasa, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$GastoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GastoTable,
    GastoData,
    $$GastoTableFilterComposer,
    $$GastoTableOrderingComposer,
    $$GastoTableAnnotationComposer,
    $$GastoTableCreateCompanionBuilder,
    $$GastoTableUpdateCompanionBuilder,
    (GastoData, BaseReferences<_$AppDatabase, $GastoTable, GastoData>),
    GastoData,
    PrefetchHooks Function()> {
  $$GastoTableTableManager(_$AppDatabase db, $GastoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GastoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GastoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GastoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> categoria = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<double> montoUsd = const Value.absent(),
            Value<double> tasa = const Value.absent(),
            Value<int> fecha = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              GastoCompanion(
            id: id,
            uuid: uuid,
            categoria: categoria,
            descripcion: descripcion,
            montoUsd: montoUsd,
            tasa: tasa,
            fecha: fecha,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String categoria,
            required String descripcion,
            required double montoUsd,
            required double tasa,
            required int fecha,
            required String usuarioId,
            required String usuarioNombre,
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              GastoCompanion.insert(
            id: id,
            uuid: uuid,
            categoria: categoria,
            descripcion: descripcion,
            montoUsd: montoUsd,
            tasa: tasa,
            fecha: fecha,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GastoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GastoTable,
    GastoData,
    $$GastoTableFilterComposer,
    $$GastoTableOrderingComposer,
    $$GastoTableAnnotationComposer,
    $$GastoTableCreateCompanionBuilder,
    $$GastoTableUpdateCompanionBuilder,
    (GastoData, BaseReferences<_$AppDatabase, $GastoTable, GastoData>),
    GastoData,
    PrefetchHooks Function()>;
typedef $$NotaCreditoTableCreateCompanionBuilder = NotaCreditoCompanion
    Function({
  Value<int> id,
  required String uuid,
  required String ventaUuid,
  required int ventaNumero,
  required String tipo,
  required String itemsJson,
  required double montoUsd,
  required double montoBs,
  required double tasa,
  required String motivo,
  required String usuarioId,
  required String usuarioNombre,
  required int fecha,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$NotaCreditoTableUpdateCompanionBuilder = NotaCreditoCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> ventaUuid,
  Value<int> ventaNumero,
  Value<String> tipo,
  Value<String> itemsJson,
  Value<double> montoUsd,
  Value<double> montoBs,
  Value<double> tasa,
  Value<String> motivo,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fecha,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$NotaCreditoTableFilterComposer
    extends Composer<_$AppDatabase, $NotaCreditoTable> {
  $$NotaCreditoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ventaUuid => $composableBuilder(
      column: $table.ventaUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ventaNumero => $composableBuilder(
      column: $table.ventaNumero, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoBs => $composableBuilder(
      column: $table.montoBs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$NotaCreditoTableOrderingComposer
    extends Composer<_$AppDatabase, $NotaCreditoTable> {
  $$NotaCreditoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ventaUuid => $composableBuilder(
      column: $table.ventaUuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ventaNumero => $composableBuilder(
      column: $table.ventaNumero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoBs => $composableBuilder(
      column: $table.montoBs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tasa => $composableBuilder(
      column: $table.tasa, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motivo => $composableBuilder(
      column: $table.motivo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$NotaCreditoTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotaCreditoTable> {
  $$NotaCreditoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get ventaUuid =>
      $composableBuilder(column: $table.ventaUuid, builder: (column) => column);

  GeneratedColumn<int> get ventaNumero => $composableBuilder(
      column: $table.ventaNumero, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<double> get montoUsd =>
      $composableBuilder(column: $table.montoUsd, builder: (column) => column);

  GeneratedColumn<double> get montoBs =>
      $composableBuilder(column: $table.montoBs, builder: (column) => column);

  GeneratedColumn<double> get tasa =>
      $composableBuilder(column: $table.tasa, builder: (column) => column);

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$NotaCreditoTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotaCreditoTable,
    NotaCreditoData,
    $$NotaCreditoTableFilterComposer,
    $$NotaCreditoTableOrderingComposer,
    $$NotaCreditoTableAnnotationComposer,
    $$NotaCreditoTableCreateCompanionBuilder,
    $$NotaCreditoTableUpdateCompanionBuilder,
    (
      NotaCreditoData,
      BaseReferences<_$AppDatabase, $NotaCreditoTable, NotaCreditoData>
    ),
    NotaCreditoData,
    PrefetchHooks Function()> {
  $$NotaCreditoTableTableManager(_$AppDatabase db, $NotaCreditoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotaCreditoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotaCreditoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotaCreditoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> ventaUuid = const Value.absent(),
            Value<int> ventaNumero = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<double> montoUsd = const Value.absent(),
            Value<double> montoBs = const Value.absent(),
            Value<double> tasa = const Value.absent(),
            Value<String> motivo = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fecha = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              NotaCreditoCompanion(
            id: id,
            uuid: uuid,
            ventaUuid: ventaUuid,
            ventaNumero: ventaNumero,
            tipo: tipo,
            itemsJson: itemsJson,
            montoUsd: montoUsd,
            montoBs: montoBs,
            tasa: tasa,
            motivo: motivo,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String ventaUuid,
            required int ventaNumero,
            required String tipo,
            required String itemsJson,
            required double montoUsd,
            required double montoBs,
            required double tasa,
            required String motivo,
            required String usuarioId,
            required String usuarioNombre,
            required int fecha,
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              NotaCreditoCompanion.insert(
            id: id,
            uuid: uuid,
            ventaUuid: ventaUuid,
            ventaNumero: ventaNumero,
            tipo: tipo,
            itemsJson: itemsJson,
            montoUsd: montoUsd,
            montoBs: montoBs,
            tasa: tasa,
            motivo: motivo,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotaCreditoTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotaCreditoTable,
    NotaCreditoData,
    $$NotaCreditoTableFilterComposer,
    $$NotaCreditoTableOrderingComposer,
    $$NotaCreditoTableAnnotationComposer,
    $$NotaCreditoTableCreateCompanionBuilder,
    $$NotaCreditoTableUpdateCompanionBuilder,
    (
      NotaCreditoData,
      BaseReferences<_$AppDatabase, $NotaCreditoTable, NotaCreditoData>
    ),
    NotaCreditoData,
    PrefetchHooks Function()>;
typedef $$CategoriaTableCreateCompanionBuilder = CategoriaCompanion Function({
  Value<int> id,
  required String uuid,
  required String nombre,
  required int orden,
  required String usuarioId,
  required String usuarioNombre,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$CategoriaTableUpdateCompanionBuilder = CategoriaCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> nombre,
  Value<int> orden,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$CategoriaTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriaTable> {
  $$CategoriaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orden => $composableBuilder(
      column: $table.orden, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$CategoriaTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriaTable> {
  $$CategoriaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orden => $composableBuilder(
      column: $table.orden, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$CategoriaTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriaTable> {
  $$CategoriaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$CategoriaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriaTable,
    CategoriaData,
    $$CategoriaTableFilterComposer,
    $$CategoriaTableOrderingComposer,
    $$CategoriaTableAnnotationComposer,
    $$CategoriaTableCreateCompanionBuilder,
    $$CategoriaTableUpdateCompanionBuilder,
    (
      CategoriaData,
      BaseReferences<_$AppDatabase, $CategoriaTable, CategoriaData>
    ),
    CategoriaData,
    PrefetchHooks Function()> {
  $$CategoriaTableTableManager(_$AppDatabase db, $CategoriaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> orden = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              CategoriaCompanion(
            id: id,
            uuid: uuid,
            nombre: nombre,
            orden: orden,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String nombre,
            required int orden,
            required String usuarioId,
            required String usuarioNombre,
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              CategoriaCompanion.insert(
            id: id,
            uuid: uuid,
            nombre: nombre,
            orden: orden,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriaTable,
    CategoriaData,
    $$CategoriaTableFilterComposer,
    $$CategoriaTableOrderingComposer,
    $$CategoriaTableAnnotationComposer,
    $$CategoriaTableCreateCompanionBuilder,
    $$CategoriaTableUpdateCompanionBuilder,
    (
      CategoriaData,
      BaseReferences<_$AppDatabase, $CategoriaTable, CategoriaData>
    ),
    CategoriaData,
    PrefetchHooks Function()>;
typedef $$ProveedorTableCreateCompanionBuilder = ProveedorCompanion Function({
  Value<int> id,
  required String uuid,
  required String nombre,
  Value<String?> rif,
  Value<String?> telefono,
  Value<String?> correo,
  Value<String?> direccion,
  Value<String?> contacto,
  Value<double> saldoPendienteUsd,
  Value<String?> notas,
  required String usuarioId,
  required String usuarioNombre,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$ProveedorTableUpdateCompanionBuilder = ProveedorCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> nombre,
  Value<String?> rif,
  Value<String?> telefono,
  Value<String?> correo,
  Value<String?> direccion,
  Value<String?> contacto,
  Value<double> saldoPendienteUsd,
  Value<String?> notas,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$ProveedorTableFilterComposer
    extends Composer<_$AppDatabase, $ProveedorTable> {
  $$ProveedorTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rif => $composableBuilder(
      column: $table.rif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get correo => $composableBuilder(
      column: $table.correo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contacto => $composableBuilder(
      column: $table.contacto, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get saldoPendienteUsd => $composableBuilder(
      column: $table.saldoPendienteUsd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$ProveedorTableOrderingComposer
    extends Composer<_$AppDatabase, $ProveedorTable> {
  $$ProveedorTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rif => $composableBuilder(
      column: $table.rif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get correo => $composableBuilder(
      column: $table.correo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contacto => $composableBuilder(
      column: $table.contacto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get saldoPendienteUsd => $composableBuilder(
      column: $table.saldoPendienteUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$ProveedorTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProveedorTable> {
  $$ProveedorTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get rif =>
      $composableBuilder(column: $table.rif, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get correo =>
      $composableBuilder(column: $table.correo, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get contacto =>
      $composableBuilder(column: $table.contacto, builder: (column) => column);

  GeneratedColumn<double> get saldoPendienteUsd => $composableBuilder(
      column: $table.saldoPendienteUsd, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$ProveedorTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProveedorTable,
    ProveedorData,
    $$ProveedorTableFilterComposer,
    $$ProveedorTableOrderingComposer,
    $$ProveedorTableAnnotationComposer,
    $$ProveedorTableCreateCompanionBuilder,
    $$ProveedorTableUpdateCompanionBuilder,
    (
      ProveedorData,
      BaseReferences<_$AppDatabase, $ProveedorTable, ProveedorData>
    ),
    ProveedorData,
    PrefetchHooks Function()> {
  $$ProveedorTableTableManager(_$AppDatabase db, $ProveedorTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProveedorTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProveedorTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProveedorTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> rif = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String?> correo = const Value.absent(),
            Value<String?> direccion = const Value.absent(),
            Value<String?> contacto = const Value.absent(),
            Value<double> saldoPendienteUsd = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              ProveedorCompanion(
            id: id,
            uuid: uuid,
            nombre: nombre,
            rif: rif,
            telefono: telefono,
            correo: correo,
            direccion: direccion,
            contacto: contacto,
            saldoPendienteUsd: saldoPendienteUsd,
            notas: notas,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String nombre,
            Value<String?> rif = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String?> correo = const Value.absent(),
            Value<String?> direccion = const Value.absent(),
            Value<String?> contacto = const Value.absent(),
            Value<double> saldoPendienteUsd = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            required String usuarioId,
            required String usuarioNombre,
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              ProveedorCompanion.insert(
            id: id,
            uuid: uuid,
            nombre: nombre,
            rif: rif,
            telefono: telefono,
            correo: correo,
            direccion: direccion,
            contacto: contacto,
            saldoPendienteUsd: saldoPendienteUsd,
            notas: notas,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProveedorTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProveedorTable,
    ProveedorData,
    $$ProveedorTableFilterComposer,
    $$ProveedorTableOrderingComposer,
    $$ProveedorTableAnnotationComposer,
    $$ProveedorTableCreateCompanionBuilder,
    $$ProveedorTableUpdateCompanionBuilder,
    (
      ProveedorData,
      BaseReferences<_$AppDatabase, $ProveedorTable, ProveedorData>
    ),
    ProveedorData,
    PrefetchHooks Function()>;
typedef $$CompraTableCreateCompanionBuilder = CompraCompanion Function({
  Value<int> id,
  required String uuid,
  required String proveedorUuid,
  required String proveedorNombre,
  Value<String?> numeroFactura,
  required double totalUsd,
  required String itemsJson,
  required String metodoPago,
  Value<double> pagadoUsd,
  Value<bool> afectaSaldo,
  Value<String?> notas,
  required String usuarioId,
  required String usuarioNombre,
  required int fecha,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$CompraTableUpdateCompanionBuilder = CompraCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> proveedorUuid,
  Value<String> proveedorNombre,
  Value<String?> numeroFactura,
  Value<double> totalUsd,
  Value<String> itemsJson,
  Value<String> metodoPago,
  Value<double> pagadoUsd,
  Value<bool> afectaSaldo,
  Value<String?> notas,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fecha,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$CompraTableFilterComposer
    extends Composer<_$AppDatabase, $CompraTable> {
  $$CompraTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proveedorNombre => $composableBuilder(
      column: $table.proveedorNombre,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroFactura => $composableBuilder(
      column: $table.numeroFactura, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalUsd => $composableBuilder(
      column: $table.totalUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pagadoUsd => $composableBuilder(
      column: $table.pagadoUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get afectaSaldo => $composableBuilder(
      column: $table.afectaSaldo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$CompraTableOrderingComposer
    extends Composer<_$AppDatabase, $CompraTable> {
  $$CompraTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proveedorNombre => $composableBuilder(
      column: $table.proveedorNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroFactura => $composableBuilder(
      column: $table.numeroFactura,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalUsd => $composableBuilder(
      column: $table.totalUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pagadoUsd => $composableBuilder(
      column: $table.pagadoUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get afectaSaldo => $composableBuilder(
      column: $table.afectaSaldo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$CompraTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompraTable> {
  $$CompraTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid, builder: (column) => column);

  GeneratedColumn<String> get proveedorNombre => $composableBuilder(
      column: $table.proveedorNombre, builder: (column) => column);

  GeneratedColumn<String> get numeroFactura => $composableBuilder(
      column: $table.numeroFactura, builder: (column) => column);

  GeneratedColumn<double> get totalUsd =>
      $composableBuilder(column: $table.totalUsd, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => column);

  GeneratedColumn<double> get pagadoUsd =>
      $composableBuilder(column: $table.pagadoUsd, builder: (column) => column);

  GeneratedColumn<bool> get afectaSaldo => $composableBuilder(
      column: $table.afectaSaldo, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$CompraTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompraTable,
    CompraData,
    $$CompraTableFilterComposer,
    $$CompraTableOrderingComposer,
    $$CompraTableAnnotationComposer,
    $$CompraTableCreateCompanionBuilder,
    $$CompraTableUpdateCompanionBuilder,
    (CompraData, BaseReferences<_$AppDatabase, $CompraTable, CompraData>),
    CompraData,
    PrefetchHooks Function()> {
  $$CompraTableTableManager(_$AppDatabase db, $CompraTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompraTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompraTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompraTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> proveedorUuid = const Value.absent(),
            Value<String> proveedorNombre = const Value.absent(),
            Value<String?> numeroFactura = const Value.absent(),
            Value<double> totalUsd = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<String> metodoPago = const Value.absent(),
            Value<double> pagadoUsd = const Value.absent(),
            Value<bool> afectaSaldo = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fecha = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              CompraCompanion(
            id: id,
            uuid: uuid,
            proveedorUuid: proveedorUuid,
            proveedorNombre: proveedorNombre,
            numeroFactura: numeroFactura,
            totalUsd: totalUsd,
            itemsJson: itemsJson,
            metodoPago: metodoPago,
            pagadoUsd: pagadoUsd,
            afectaSaldo: afectaSaldo,
            notas: notas,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String proveedorUuid,
            required String proveedorNombre,
            Value<String?> numeroFactura = const Value.absent(),
            required double totalUsd,
            required String itemsJson,
            required String metodoPago,
            Value<double> pagadoUsd = const Value.absent(),
            Value<bool> afectaSaldo = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            required String usuarioId,
            required String usuarioNombre,
            required int fecha,
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              CompraCompanion.insert(
            id: id,
            uuid: uuid,
            proveedorUuid: proveedorUuid,
            proveedorNombre: proveedorNombre,
            numeroFactura: numeroFactura,
            totalUsd: totalUsd,
            itemsJson: itemsJson,
            metodoPago: metodoPago,
            pagadoUsd: pagadoUsd,
            afectaSaldo: afectaSaldo,
            notas: notas,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompraTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CompraTable,
    CompraData,
    $$CompraTableFilterComposer,
    $$CompraTableOrderingComposer,
    $$CompraTableAnnotationComposer,
    $$CompraTableCreateCompanionBuilder,
    $$CompraTableUpdateCompanionBuilder,
    (CompraData, BaseReferences<_$AppDatabase, $CompraTable, CompraData>),
    CompraData,
    PrefetchHooks Function()>;
typedef $$CompraItemTableCreateCompanionBuilder = CompraItemCompanion Function({
  Value<int> id,
  required String compraUuid,
  required int productoId,
  required String productoNombre,
  required double cantidad,
  required double costoUnitarioUsd,
  required double subtotalUsd,
});
typedef $$CompraItemTableUpdateCompanionBuilder = CompraItemCompanion Function({
  Value<int> id,
  Value<String> compraUuid,
  Value<int> productoId,
  Value<String> productoNombre,
  Value<double> cantidad,
  Value<double> costoUnitarioUsd,
  Value<double> subtotalUsd,
});

class $$CompraItemTableFilterComposer
    extends Composer<_$AppDatabase, $CompraItemTable> {
  $$CompraItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get compraUuid => $composableBuilder(
      column: $table.compraUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productoNombre => $composableBuilder(
      column: $table.productoNombre,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costoUnitarioUsd => $composableBuilder(
      column: $table.costoUnitarioUsd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotalUsd => $composableBuilder(
      column: $table.subtotalUsd, builder: (column) => ColumnFilters(column));
}

class $$CompraItemTableOrderingComposer
    extends Composer<_$AppDatabase, $CompraItemTable> {
  $$CompraItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get compraUuid => $composableBuilder(
      column: $table.compraUuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productoNombre => $composableBuilder(
      column: $table.productoNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costoUnitarioUsd => $composableBuilder(
      column: $table.costoUnitarioUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotalUsd => $composableBuilder(
      column: $table.subtotalUsd, builder: (column) => ColumnOrderings(column));
}

class $$CompraItemTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompraItemTable> {
  $$CompraItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get compraUuid => $composableBuilder(
      column: $table.compraUuid, builder: (column) => column);

  GeneratedColumn<int> get productoId => $composableBuilder(
      column: $table.productoId, builder: (column) => column);

  GeneratedColumn<String> get productoNombre => $composableBuilder(
      column: $table.productoNombre, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get costoUnitarioUsd => $composableBuilder(
      column: $table.costoUnitarioUsd, builder: (column) => column);

  GeneratedColumn<double> get subtotalUsd => $composableBuilder(
      column: $table.subtotalUsd, builder: (column) => column);
}

class $$CompraItemTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompraItemTable,
    CompraItemData,
    $$CompraItemTableFilterComposer,
    $$CompraItemTableOrderingComposer,
    $$CompraItemTableAnnotationComposer,
    $$CompraItemTableCreateCompanionBuilder,
    $$CompraItemTableUpdateCompanionBuilder,
    (
      CompraItemData,
      BaseReferences<_$AppDatabase, $CompraItemTable, CompraItemData>
    ),
    CompraItemData,
    PrefetchHooks Function()> {
  $$CompraItemTableTableManager(_$AppDatabase db, $CompraItemTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompraItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompraItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompraItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> compraUuid = const Value.absent(),
            Value<int> productoId = const Value.absent(),
            Value<String> productoNombre = const Value.absent(),
            Value<double> cantidad = const Value.absent(),
            Value<double> costoUnitarioUsd = const Value.absent(),
            Value<double> subtotalUsd = const Value.absent(),
          }) =>
              CompraItemCompanion(
            id: id,
            compraUuid: compraUuid,
            productoId: productoId,
            productoNombre: productoNombre,
            cantidad: cantidad,
            costoUnitarioUsd: costoUnitarioUsd,
            subtotalUsd: subtotalUsd,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String compraUuid,
            required int productoId,
            required String productoNombre,
            required double cantidad,
            required double costoUnitarioUsd,
            required double subtotalUsd,
          }) =>
              CompraItemCompanion.insert(
            id: id,
            compraUuid: compraUuid,
            productoId: productoId,
            productoNombre: productoNombre,
            cantidad: cantidad,
            costoUnitarioUsd: costoUnitarioUsd,
            subtotalUsd: subtotalUsd,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompraItemTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CompraItemTable,
    CompraItemData,
    $$CompraItemTableFilterComposer,
    $$CompraItemTableOrderingComposer,
    $$CompraItemTableAnnotationComposer,
    $$CompraItemTableCreateCompanionBuilder,
    $$CompraItemTableUpdateCompanionBuilder,
    (
      CompraItemData,
      BaseReferences<_$AppDatabase, $CompraItemTable, CompraItemData>
    ),
    CompraItemData,
    PrefetchHooks Function()>;
typedef $$PagoProveedorTableCreateCompanionBuilder = PagoProveedorCompanion
    Function({
  Value<int> id,
  required String uuid,
  required String proveedorUuid,
  required String proveedorNombre,
  required double montoUsd,
  required String metodoPago,
  Value<String?> referencia,
  Value<String?> notas,
  required String usuarioId,
  required String usuarioNombre,
  required int fecha,
  required int fechaCreacion,
  required int fechaActualizacion,
});
typedef $$PagoProveedorTableUpdateCompanionBuilder = PagoProveedorCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> proveedorUuid,
  Value<String> proveedorNombre,
  Value<double> montoUsd,
  Value<String> metodoPago,
  Value<String?> referencia,
  Value<String?> notas,
  Value<String> usuarioId,
  Value<String> usuarioNombre,
  Value<int> fecha,
  Value<int> fechaCreacion,
  Value<int> fechaActualizacion,
});

class $$PagoProveedorTableFilterComposer
    extends Composer<_$AppDatabase, $PagoProveedorTable> {
  $$PagoProveedorTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get proveedorNombre => $composableBuilder(
      column: $table.proveedorNombre,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referencia => $composableBuilder(
      column: $table.referencia, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnFilters(column));
}

class $$PagoProveedorTableOrderingComposer
    extends Composer<_$AppDatabase, $PagoProveedorTable> {
  $$PagoProveedorTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get proveedorNombre => $composableBuilder(
      column: $table.proveedorNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoUsd => $composableBuilder(
      column: $table.montoUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referencia => $composableBuilder(
      column: $table.referencia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioId => $composableBuilder(
      column: $table.usuarioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion,
      builder: (column) => ColumnOrderings(column));
}

class $$PagoProveedorTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagoProveedorTable> {
  $$PagoProveedorTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get proveedorUuid => $composableBuilder(
      column: $table.proveedorUuid, builder: (column) => column);

  GeneratedColumn<String> get proveedorNombre => $composableBuilder(
      column: $table.proveedorNombre, builder: (column) => column);

  GeneratedColumn<double> get montoUsd =>
      $composableBuilder(column: $table.montoUsd, builder: (column) => column);

  GeneratedColumn<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => column);

  GeneratedColumn<String> get referencia => $composableBuilder(
      column: $table.referencia, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get usuarioId =>
      $composableBuilder(column: $table.usuarioId, builder: (column) => column);

  GeneratedColumn<String> get usuarioNombre => $composableBuilder(
      column: $table.usuarioNombre, builder: (column) => column);

  GeneratedColumn<int> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get fechaCreacion => $composableBuilder(
      column: $table.fechaCreacion, builder: (column) => column);

  GeneratedColumn<int> get fechaActualizacion => $composableBuilder(
      column: $table.fechaActualizacion, builder: (column) => column);
}

class $$PagoProveedorTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PagoProveedorTable,
    PagoProveedorData,
    $$PagoProveedorTableFilterComposer,
    $$PagoProveedorTableOrderingComposer,
    $$PagoProveedorTableAnnotationComposer,
    $$PagoProveedorTableCreateCompanionBuilder,
    $$PagoProveedorTableUpdateCompanionBuilder,
    (
      PagoProveedorData,
      BaseReferences<_$AppDatabase, $PagoProveedorTable, PagoProveedorData>
    ),
    PagoProveedorData,
    PrefetchHooks Function()> {
  $$PagoProveedorTableTableManager(_$AppDatabase db, $PagoProveedorTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagoProveedorTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagoProveedorTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagoProveedorTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> proveedorUuid = const Value.absent(),
            Value<String> proveedorNombre = const Value.absent(),
            Value<double> montoUsd = const Value.absent(),
            Value<String> metodoPago = const Value.absent(),
            Value<String?> referencia = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<String> usuarioId = const Value.absent(),
            Value<String> usuarioNombre = const Value.absent(),
            Value<int> fecha = const Value.absent(),
            Value<int> fechaCreacion = const Value.absent(),
            Value<int> fechaActualizacion = const Value.absent(),
          }) =>
              PagoProveedorCompanion(
            id: id,
            uuid: uuid,
            proveedorUuid: proveedorUuid,
            proveedorNombre: proveedorNombre,
            montoUsd: montoUsd,
            metodoPago: metodoPago,
            referencia: referencia,
            notas: notas,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String proveedorUuid,
            required String proveedorNombre,
            required double montoUsd,
            required String metodoPago,
            Value<String?> referencia = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            required String usuarioId,
            required String usuarioNombre,
            required int fecha,
            required int fechaCreacion,
            required int fechaActualizacion,
          }) =>
              PagoProveedorCompanion.insert(
            id: id,
            uuid: uuid,
            proveedorUuid: proveedorUuid,
            proveedorNombre: proveedorNombre,
            montoUsd: montoUsd,
            metodoPago: metodoPago,
            referencia: referencia,
            notas: notas,
            usuarioId: usuarioId,
            usuarioNombre: usuarioNombre,
            fecha: fecha,
            fechaCreacion: fechaCreacion,
            fechaActualizacion: fechaActualizacion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PagoProveedorTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PagoProveedorTable,
    PagoProveedorData,
    $$PagoProveedorTableFilterComposer,
    $$PagoProveedorTableOrderingComposer,
    $$PagoProveedorTableAnnotationComposer,
    $$PagoProveedorTableCreateCompanionBuilder,
    $$PagoProveedorTableUpdateCompanionBuilder,
    (
      PagoProveedorData,
      BaseReferences<_$AppDatabase, $PagoProveedorTable, PagoProveedorData>
    ),
    PagoProveedorData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConfiguracionLocalTableTableManager get configuracionLocal =>
      $$ConfiguracionLocalTableTableManager(_db, _db.configuracionLocal);
  $$HistorialTasaTableTableManager get historialTasa =>
      $$HistorialTasaTableTableManager(_db, _db.historialTasa);
  $$ProductoTableTableManager get producto =>
      $$ProductoTableTableManager(_db, _db.producto);
  $$VentaTableTableManager get venta =>
      $$VentaTableTableManager(_db, _db.venta);
  $$ClienteTableTableManager get cliente =>
      $$ClienteTableTableManager(_db, _db.cliente);
  $$PagoFiadoTableTableManager get pagoFiado =>
      $$PagoFiadoTableTableManager(_db, _db.pagoFiado);
  $$AperturaCajaTableTableManager get aperturaCaja =>
      $$AperturaCajaTableTableManager(_db, _db.aperturaCaja);
  $$CierreCajaTableTableManager get cierreCaja =>
      $$CierreCajaTableTableManager(_db, _db.cierreCaja);
  $$RetiroCajaTableTableManager get retiroCaja =>
      $$RetiroCajaTableTableManager(_db, _db.retiroCaja);
  $$MermaTableTableManager get merma =>
      $$MermaTableTableManager(_db, _db.merma);
  $$AuditoriaLogTableTableManager get auditoriaLog =>
      $$AuditoriaLogTableTableManager(_db, _db.auditoriaLog);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$GastoTableTableManager get gasto =>
      $$GastoTableTableManager(_db, _db.gasto);
  $$NotaCreditoTableTableManager get notaCredito =>
      $$NotaCreditoTableTableManager(_db, _db.notaCredito);
  $$CategoriaTableTableManager get categoria =>
      $$CategoriaTableTableManager(_db, _db.categoria);
  $$ProveedorTableTableManager get proveedor =>
      $$ProveedorTableTableManager(_db, _db.proveedor);
  $$CompraTableTableManager get compra =>
      $$CompraTableTableManager(_db, _db.compra);
  $$CompraItemTableTableManager get compraItem =>
      $$CompraItemTableTableManager(_db, _db.compraItem);
  $$PagoProveedorTableTableManager get pagoProveedor =>
      $$PagoProveedorTableTableManager(_db, _db.pagoProveedor);
}
