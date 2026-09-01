import 'package:el_cuaderno_de_mario/core/services/client_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../../core/services/client_firebase_provider.dart';

/// Método de pago venezolano configurable por el admin.
class MetodoPago {
  final String id;
  final String nombre;
  final String simbolo;
  final bool activo;
  final bool esDivisa; // aplica IGTF
  final String datosPago;
  final String telefono;
  final String cedula;
  final String banco;
  final String qrUrl;
  final double? tasaPropia;

  const MetodoPago({
    required this.id,
    required this.nombre,
    required this.simbolo,
    this.activo = true,
    this.esDivisa = false,
    this.datosPago = '',
    this.telefono = '',
    this.cedula = '',
    this.banco = '',
    this.qrUrl = '',
    this.tasaPropia,
  });

  /// Defaults locales (fallback offline o si no existe la colección).
  static const List<MetodoPago> defaults = [
    MetodoPago(
        id: 'efectivo_usd',
        nombre: '💵 Efectivo USD',
        simbolo: '\$',
        esDivisa: true),
    MetodoPago(id: 'efectivo_bs', nombre: '💰 Efectivo Bs', simbolo: 'Bs'),
    MetodoPago(
        id: 'tarjeta_debito', nombre: '💳 Tarjeta débito', simbolo: 'Bs'),
    MetodoPago(
        id: 'tarjeta_credito', nombre: '💳 Tarjeta crédito', simbolo: 'Bs'),
    MetodoPago(id: 'pago_movil', nombre: '📱 Pago Móvil', simbolo: 'Bs'),
    MetodoPago(
        id: 'zelle',
        nombre: '💸 Zelle',
        simbolo: 'Z\$',
        activo: false,
        esDivisa: true),
    MetodoPago(
        id: 'binance',
        nombre: 'Binance',
        simbolo: '₿',
        activo: false,
        esDivisa: true),
  ];

  /// Tercera moneda por defecto (inactiva hasta que el admin la configure).
  static const MetodoPago terceraDefault = MetodoPago(
    id: 'tercera_moneda',
    nombre: '🌎 Tercera moneda',
    simbolo: 'COP',
    activo: false,
  );

  static List<MetodoPago> get defaultsActivos =>
      defaults.where((m) => m.activo).toList();

  /// Mapa para crear el seed en Firestore durante el registro del admin.
  Map<String, dynamic> toSeedMap() => {
        'nombre': nombre,
        'simbolo': simbolo,
        'activo': activo,
        'esDivisa': esDivisa,
        'datosPago': datosPago,
        'tasaPropia': tasaPropia,
      };

  factory MetodoPago.fromFirestore(String id, Map<String, dynamic> data) =>
      MetodoPago(
        id: id,
        nombre: data['nombre'] as String? ?? id,
        simbolo: data['simbolo'] as String? ?? '',
        activo: data['activo'] as bool? ?? true,
        esDivisa: data['esDivisa'] as bool? ?? false,
        datosPago: data['datosPago'] as String? ?? '',
        telefono: data['telefono'] as String? ?? '',
        cedula: data['cedula'] as String? ?? '',
        banco: data['banco'] as String? ?? '',
        qrUrl: data['qrUrl'] as String? ?? '',
        tasaPropia: (data['tasaPropia'] as num?)?.toDouble(),
      );
}

/// Lee metodos_pago del Firestore del cliente.
/// Solo retorna los activos. Fallback local si no hay colección o sin internet.
final metodosPagoProvider = FutureProvider<List<MetodoPago>>((ref) async {
  final clientFb = ref.watch(clientFirebaseProvider);

  if (!clientFb.isInitialized) {
    return MetodoPago.defaultsActivos;
  }

  try {
    final snap = await clientFb.firestore.collection('metodos_pago').get();

    if (snap.docs.isEmpty) return MetodoPago.defaultsActivos;

    final metodos = snap.docs
        .map((d) => MetodoPago.fromFirestore(d.id, d.data()))
        .where((m) => m.activo)
        .toList();

    return metodos.isEmpty ? MetodoPago.defaultsActivos : metodos;
  } catch (_) {
    // Sin internet o error: fallback local
    return MetodoPago.defaultsActivos;
  }
});

/// Todos los métodos (para Configuración), orden estable por id.
final metodosPagoAdminProvider = FutureProvider<List<MetodoPago>>((ref) async {
  final clientFb = ref.watch(clientFirebaseProvider);
  if (!clientFb.isInitialized) return const [];

  // Auto-repara clientes sin seed
  try {
    await asegurarSemillaMetodos();
  } catch (e) {
    Logger(printer: PrettyPrinter(methodCount: 0))
        .w('⚠️ No se pudo asegurar semilla de métodos: $e');
  }

  final snap = await clientFb.firestore.collection('metodos_pago').get();
  final lista =
      snap.docs.map((d) => MetodoPago.fromFirestore(d.id, d.data())).toList();
  lista.sort((a, b) => a.id.compareTo(b.id));
  return lista;
});

/// Crea los métodos por defecto si la colección está vacía (idempotente).
/// Auto-repara clientes registrados ANTES de que existiera el seed.
/// Crea los métodos que FALTEN en metodos_pago (idempotente por documento).
/// Auto-repara clientes pre-seed sin pisar lo que el admin ya configuró.
Future<void> asegurarSemillaMetodos() async {
  final logger = Logger(printer: PrettyPrinter(methodCount: 0));
  final clientFb = ClientFirebase();
  final snap = await clientFb.firestore.collection('metodos_pago').get();
  final existentes = snap.docs.map((d) => d.id).toSet();

  final col = clientFb.firestore.collection('metodos_pago');
  final batch = clientFb.firestore.batch();
  var creados = 0;

  for (final m in MetodoPago.defaults) {
    if (!existentes.contains(m.id)) {
      batch.set(col.doc(m.id), m.toSeedMap());
      creados++;
    }
  }
  if (!existentes.contains(MetodoPago.terceraDefault.id)) {
    batch.set(col.doc(MetodoPago.terceraDefault.id),
        MetodoPago.terceraDefault.toSeedMap());
    creados++;
  }

  if (creados == 0) return;
  await batch.commit();
  logger.i('💳 Semilla completada: $creados métodos creados');
}
