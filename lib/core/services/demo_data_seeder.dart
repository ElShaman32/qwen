import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:el_cuaderno_de_mario/core/database/app_database.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Siembra datos de ejemplo para el modo demo de 24 horas.
/// Solo se ejecuta UNA VEZ al inicio (si no hay sesión previa).
class DemoDataSeeder {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));
  final _uuid = const Uuid();

  Future<void> sembrarDatosDemo(AppDatabase db) async {
    try {
      _logger.i('🌱 Sembrando datos de demostración...');
      final ahora = DateTime.now().millisecondsSinceEpoch;

      // ── 1. Configuración demo por defecto ─────────────────────
      await db.into(db.configuracionLocal).insertOnConflictUpdate(
            ConfiguracionLocalCompanion.insert(
              plan: const Value('todos_juguetes'),
              cuentaActiva: const Value(true),
              fechaVencimientoEpoch: const Value(0),
              appNombre: const Value('Bodega Demo'),
              appSlogan: const Value('Tu bodega de confianza'),
              colorPrimario: const Value('#641782'),
              colorSecundario: const Value('#000000'),
              rif: const Value('J-12345678-9'),
              direccion: const Value('Calle Principal, Caracas'),
              telefono: const Value('0412-1234567'),
              tasaBcv: const Value(842.50),
              usarTasaBcv: const Value(true),
              ivaRate: const Value(0.16),
              igtfRate: const Value(0.03),
              timestampUltimaVerificacion: Value(ahora),
              isDemoMode: const Value(true),
              demoStartTimestamp: Value(ahora),
            ),
          );

      // ── 2. Productos (15) ─────────────────────────────────────
      final productos = <ProductoCompanion>[
        // 5 normales
        _producto('Arroz Premium 1kg', '7501234567890', 1.50, 50.0, false),
        _producto('Aceite Vegetal 1L', '7501234567891', 2.00, 30.0, false),
        _producto('Azúcar Refinada 1kg', '7501234567892', 1.20, 40.0, false),
        _producto('Harina de Maíz 1kg', '7501234567893', 1.10, 60.0, false),
        _producto('Pasta Larga 500g', '7501234567894', 0.90, 100.0, false),
        // 3 a granel
        _producto('Queso Blanco', 'GRANEL001', 4.00, 5.5, true, unidad: 'kg'),
        _producto('Café Molido', 'GRANEL002', 6.00, 2.25, true, unidad: 'kg'),
        _producto('Caraotas Negras', 'GRANEL003', 1.80, 10.0, true,
            unidad: 'kg'),
        // 3 exentos de IVA
        _producto('Pan Francés (kg)', '7501234567895', 2.50, 20.0, false,
            exentoIva: true),
        _producto('Empanadas de Carne', '7501234567896', 1.00, 30.0, false,
            exentoIva: true),
        _producto('Hielo en Bolsa', '7501234567897', 1.50, 50.0, false,
            exentoIva: true),
        // 2 con fecha de vencimiento próxima
        _producto('Leche Entera 1L', '7501234567898', 1.80, 15.0, false,
            fechaVencimiento: DateTime.now().add(const Duration(days: 2))),
        _producto('Yogur Natural 500ml', '7501234567899', 2.20, 10.0, false,
            fechaVencimiento: DateTime.now().add(const Duration(days: 3))),
        // 2 con stock bajo (< stockMinimo=5)
        _producto('Detergente Líquido 1L', '7501234567900', 3.50, 3.0, false),
        _producto('Jabón de Baño', '7501234567901', 1.00, 2.0, false),
      ];

      for (final p in productos) {
        await db.into(db.producto).insertOnConflictUpdate(p);
      }

      // ── 3. Clientes (5) ───────────────────────────────────────
      final clientes = <ClienteCompanion>[
        _cliente('Juan Pérez', 'V-12.345.678', '0412-1111111', 5.00, 100.00),
        _cliente('María González', 'V-23.456.789', '0414-2222222', 15.50, null),
        _cliente(
            'Carlos Rodríguez', 'V-34.567.890', '0424-3333333', 0.0, 50.00),
        _cliente('Ana Martínez', 'V-45.678.901', '0416-4444444', 0.0, null),
        _cliente('Luis Hernández', 'V-56.789.012', '0426-5555555', 0.0, null),
      ];

      final clienteIds = <int>[];
      for (final c in clientes) {
        final id = await db.into(db.cliente).insertOnConflictUpdate(c);
        clienteIds.add(id);
      }

      // ── 4. Ventas (3) ─────────────────────────────────────────
      final hoy = DateTime.now();
      final ayer = hoy.subtract(const Duration(days: 1));

      // Venta 1: Hoy, múltiples métodos de pago
      await _crearVenta(
        db: db,
        fecha: hoy,
        numeroVenta: 1,
        totalUsd: 10.00,
        totalBs: 8420.00,
        tasa: 842.50,
        metodosPago: 'efectivo_usd,efectivo_bs',
        esFiado: false,
        clienteId: null,
      );

      // Venta 2: Ayer
      await _crearVenta(
        db: db,
        fecha: ayer,
        numeroVenta: 2,
        totalUsd: 5.00,
        totalBs: 4210.00,
        tasa: 842.50,
        metodosPago: 'efectivo_usd',
        esFiado: false,
        clienteId: null,
      );

      // Venta 3: Fiada (vinculada a primer cliente)
      await _crearVenta(
        db: db,
        fecha: hoy,
        numeroVenta: 3,
        totalUsd: 8.00,
        totalBs: 6740.00,
        tasa: 842.50,
        metodosPago: 'fiado',
        esFiado: true,
        clienteId: clienteIds.isNotEmpty ? clienteIds[0] : null,
      );

      _logger.i('✅ Datos de demostración sembrados exitosamente');
    } catch (e, s) {
      _logger.e('❌ Error sembrando datos demo: $e', stackTrace: s);
    }
  }

  // ── Helpers de construcción de Companions ────────────────────

  /// Construye un ProductoCompanion con los tipos correctos de Drift.
  /// Campos requeridos van SIN Value; opcionales/con default van CON Value.
  ProductoCompanion _producto(
    String nombre,
    String codigo,
    double precioUsd,
    double stock,
    bool esGranel, {
    String unidad = 'und',
    bool exentoIva = false,
    DateTime? fechaVencimiento,
    int stockMinimo = 5,
  }) {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    return ProductoCompanion.insert(
      // Campos REQUERIDOS → valor directo (sin Value)
      uuid: _uuid.v4(),
      nombre: nombre,
      precioUsd: precioUsd,
      fechaCreacion: ahora,
      fechaActualizacion: ahora,
      // Campos OPCIONALES → Value<T>
      codigo: Value(codigo),
      costoUsd: Value(precioUsd * 0.7),
      stock: Value(stock),
      esGranel: Value(esGranel),
      unidadMedida: Value(unidad),
      exentoIva: Value(exentoIva),
      fechaVencimiento: Value(fechaVencimiento?.millisecondsSinceEpoch),
      stockMinimo: Value(stockMinimo),
    );
  }

  /// Construye un ClienteCompanion con los tipos correctos de Drift.
  ClienteCompanion _cliente(
    String nombre,
    String cedula,
    String telefono,
    double saldoPendienteUsd,
    double? limiteCreditoUsd,
  ) {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    return ClienteCompanion.insert(
      // Campos REQUERIDOS → valor directo (sin Value)
      uuid: _uuid.v4(),
      nombre: nombre,
      fechaCreacion: ahora,
      fechaActualizacion: ahora,
      // Campos OPCIONALES → Value<T>
      cedula: Value(cedula),
      telefono: Value(telefono),
      saldoPendienteUsd: Value(saldoPendienteUsd),
      limiteCreditoUsd: Value(limiteCreditoUsd),
    );
  }

  /// Crea una venta demo con items y pagos simplificados.
  Future<void> _crearVenta({
    required AppDatabase db,
    required DateTime fecha,
    required int numeroVenta,
    required double totalUsd,
    required double totalBs,
    required double tasa,
    required String metodosPago,
    required bool esFiado,
    required int? clienteId,
  }) async {
    final ahora = DateTime.now().millisecondsSinceEpoch;
    final pagosJson = jsonEncode([
      {'metodo': metodosPago, 'montoUsd': totalUsd, 'montoBs': totalBs},
    ]);

    await db.into(db.venta).insert(
          VentaCompanion.insert(
            // Campos REQUERIDOS → valor directo (sin Value)
            uuid: _uuid.v4(),
            numeroVenta: numeroVenta,
            fecha: fecha.millisecondsSinceEpoch,
            itemsJson: '[]',
            pagosJson: pagosJson,
            totalUsd: totalUsd,
            totalBs: totalBs,
            tasaUsada: tasa,
            ivaBs: 0.0,
            igtfBs: 0.0,
            usuarioId: 'demo_user',
            usuarioNombre: 'Usuario Demo',
            fechaCreacion: ahora,
            fechaActualizacion: ahora,
            // Campos OPCIONALES → Value<T>
            exentoBs: const Value(0.0),
            esFiado: Value(esFiado),
            clienteId: Value(clienteId),
            anulada: const Value(false),
          ),
        );
  }

  /// Limpia TODOS los datos de negocio de Drift.
  /// Se llama al desactivar el modo demo para que el usuario
  /// empiece fresco con sus datos reales.
  Future<void> limpiarDatosDemo(AppDatabase db) async {
    try {
      _logger.i('🧹 Limpiando datos demo de Drift...');

      await db.transaction(() async {
        // Limpiar tablas de negocio (orden no importa, son independientes)
        await db.delete(db.producto).go();
        await db.delete(db.cliente).go();
        await db.delete(db.venta).go();
        await db.delete(db.pagoFiado).go();
        await db.delete(db.aperturaCaja).go();
        await db.delete(db.cierreCaja).go();
        await db.delete(db.retiroCaja).go();
        await db.delete(db.merma).go();
        await db.delete(db.auditoriaLog).go();
        await db.delete(db.gasto).go();
        await db.delete(db.notaCredito).go();
        await db.delete(db.categoria).go();
        await db.delete(db.proveedor).go();
        await db.delete(db.compra).go();
        await db.delete(db.compraItem).go();
        await db.delete(db.pagoProveedor).go();
        await db.delete(db.historialTasa).go();
        await db.delete(db.syncQueue).go();
      });

      _logger.i('✅ Datos demo limpiados de Drift');
    } catch (e, s) {
      _logger.e('❌ Error limpiando datos demo: $e', stackTrace: s);
    }
  }
}
