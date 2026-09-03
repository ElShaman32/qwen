import 'package:el_cuaderno_de_mario/core/database/app_database.dart';
import 'package:el_cuaderno_de_mario/features/auditoria/presentation/movimientos_screen.dart';
import 'package:el_cuaderno_de_mario/features/caja/presentation/caja_screen.dart';
import 'package:el_cuaderno_de_mario/features/configuracion/presentation/metodos_pago_screen.dart';
import 'package:el_cuaderno_de_mario/features/configuracion/presentation/configuracion_screen.dart';
import 'package:el_cuaderno_de_mario/features/configuracion/presentation/datos_bodega_screen.dart';
import 'package:el_cuaderno_de_mario/features/configuracion/presentation/identidad_screen.dart';
import 'package:el_cuaderno_de_mario/features/configuracion/presentation/impuestos_screen.dart';
import 'package:el_cuaderno_de_mario/features/configuracion/presentation/printer_config_screen.dart';
import 'package:el_cuaderno_de_mario/features/contabilidad/presentation/contabilidad_screen.dart';
import 'package:el_cuaderno_de_mario/features/demo_lead/presentation/lead_form_screen.dart';
import 'package:el_cuaderno_de_mario/features/inventario/presentation/categorias_screen.dart';
import 'package:el_cuaderno_de_mario/features/merma/presentation/merma_screen.dart';
import 'package:el_cuaderno_de_mario/features/onboarding/presentation/legal_screen.dart';
import 'package:el_cuaderno_de_mario/features/onboarding/presentation/onboarding_screens.dart';
import 'package:el_cuaderno_de_mario/features/onboarding/presentation/video_screen.dart';
import 'package:el_cuaderno_de_mario/features/proveedores/presentation/proveedor_detail_screen.dart';
import 'package:el_cuaderno_de_mario/features/proveedores/presentation/proveedor_form_screen.dart';
import 'package:el_cuaderno_de_mario/features/proveedores/presentation/proveedores_screen.dart';
import 'package:el_cuaderno_de_mario/features/reportes/presentation/historial_tasas_screen.dart';
import 'package:el_cuaderno_de_mario/features/reportes/presentation/reporte_cajero_screen.dart';
import 'package:el_cuaderno_de_mario/features/reportes/presentation/reportes_screen.dart';
import 'package:el_cuaderno_de_mario/features/rrhh/presentation/rrhh_screen.dart';
import 'package:el_cuaderno_de_mario/features/ventas/presentation/devolucion_screen.dart';
import 'package:el_cuaderno_de_mario/features/ventas/presentation/ventas_historial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../config/app_config_notifier.dart';
import '../services/client_firebase_provider.dart';
import '../services/negocio_service.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/activacion/presentation/activacion_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/registro_admin_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/home/presentation/dashboard_screen.dart';
import '../../features/home/presentation/suspension_screen.dart';
import '../../features/inventario/presentation/inventario_screen.dart';
import '../../features/inventario/presentation/producto_form_screen.dart';
import '../../features/ventas/presentation/ventas_screen.dart';
import '../../features/ventas/presentation/carrito_screen.dart';
import '../../features/ventas/presentation/cobro_screen.dart';
import '../../features/ventas/presentation/post_venta_screen.dart';
import '../../features/clientes/presentation/clientes_screen.dart';
import '../../features/clientes/presentation/cliente_form_screen.dart';
import '../../features/clientes/presentation/cliente_detail_screen.dart';
import 'package:logger/logger.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

/// Provider del GoRouter con protección de roles y flujo multi-tenant.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      final appConfig = ref.read(appConfigProvider);
      final clientFb = ref.read(clientFirebaseProvider);

      final location = state.matchedLocation;
      final isSplash = location == AppRoutes.splash;
      final isActivacion = location == AppRoutes.activacion;
      final isLogin = location == AppRoutes.login;
      final isRegistro = location == AppRoutes.registroAdmin;
      final isSuspension = location == AppRoutes.suspension;
      final isLeadForm = location == AppRoutes.leadForm;
      final isOnboarding = location.startsWith('/onboarding');

      // ── PROTECCIÓN ANTI-LOOP: Si está en onboarding, quedarse ahí ──
      // El onboarding es un flujo auto-contenido hasta que acepta términos.
      if (isOnboarding) {
        // Si ya aceptó términos mientras está en onboarding → salir a activación
        if (appConfig.yaAceptoTerminos) {
          return AppRoutes.activacion;
        }
        // Si no ha aceptado, permitir que siga en el onboarding
        return null;
      }

      // 0. PRIORIDAD MÁXIMA: Términos legales no aceptados → onboarding
      // (Solo si NO está ya en onboarding ni en splash)
      if (!appConfig.yaAceptoTerminos && !isSplash) {
        return AppRoutes.onboardingVideo;
      }

      // 1. Suspensión manual (activa=false) → bloquear todo
      if (appConfig.estaSuspendido) {
        return isSuspension ? null : AppRoutes.suspension;
      }

      // 2. Kill switch activo → bloquear en splash
      if (appConfig.isKillSwitchActive) {
        return isSplash ? null : AppRoutes.splash;
      }

// 3. MODO DEMO VENCIDO → limpiar datos demo + bloquear TODO excepto Activación
      if (appConfig.isDemoMode && appConfig.demoVencido) {
        // Limpiar datos demo si aún no se han limpiado
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            await ref.read(appConfigProvider.notifier).desactivarModoDemo();
            _logger.i('🧹 Datos demo limpiados automáticamente al vencer');
          } catch (e) {
            _logger.e('❌ Error limpiando datos demo al vencer: $e');
          }
        });

        if (!isActivacion) {
          return AppRoutes.activacion;
        }
        return null;
      }

// 4. MODO DEMO ACTIVO → permitir acceso sin sesión Firebase
      if (appConfig.isDemoMode && !appConfig.demoVencido) {
        if (isSplash) return null;
        if (isActivacion) return null;
        if (isLeadForm) return null;
        // PERMITIR ir a login/registro desde demo (usuario puede tener cuenta real)
        if (isLogin || isRegistro) return null;
        // Suspensión no aplica en demo
        if (isSuspension) return AppRoutes.home;
        return null;
      }

      // 5. El Splash controla su propia salida
      if (isSplash) return null;

      // 6. Verificar sesión activa en Firebase del Cliente
      final haySesion =
          clientFb.isInitialized && clientFb.auth.currentUser != null;

      // 7. Si hay sesión y va a pantallas de auth → home
      if (haySesion &&
          (isActivacion || isLogin || isRegistro || isSuspension)) {
        return AppRoutes.home;
      }

      // 8. Si NO hay sesión y va a ruta protegida → login
      // IMPORTANTE: NO interceptar si está en onboarding (ya manejado arriba)
      if (!haySesion &&
          !isActivacion &&
          !isLogin &&
          !isRegistro &&
          !isLeadForm) {
        return AppRoutes.login;
      }

      return null;
    },
    routes: [
      // ── Pre-login ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.activacion,
        builder: (context, state) => const ActivacionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registroAdmin,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final negocio = extra?['negocio'] as NegocioInfo?;

          if (negocio == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(AppRoutes.activacion);
            });
            return const SizedBox.shrink();
          }

          return RegistroAdminScreen(negocio: negocio);
        },
      ),
      GoRoute(
        path: AppRoutes.suspension,
        builder: (context, state) => const SuspensionScreen(),
      ),
      // Después de la ruta /suspension, agregar:
      GoRoute(
        path: AppRoutes.leadForm,
        builder: (context, state) => const LeadFormScreen(),
      ),

      // ── Onboarding (pre-login, marca del producto) ──────────────
      GoRoute(
        path: AppRoutes.onboardingVideo,
        builder: (context, state) => const VideoScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingScreens,
        builder: (context, state) => const OnboardingScreens(),
      ),
      GoRoute(
        path: AppRoutes.onboardingLegal,
        builder: (context, state) => const LegalScreen(),
      ),

      // ── Shell post-login ─────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.ventas,
            builder: (context, state) => const VentasScreen(),
          ),
          GoRoute(
            path: AppRoutes.inventario,
            builder: (context, state) => const InventarioScreen(),
          ),
          GoRoute(
            path: AppRoutes.caja,
            builder: (context, state) => const CajaScreen(),
          ),
          GoRoute(
            path: AppRoutes.clientes,
            builder: (context, state) => const ClientesScreen(),
          ),
          GoRoute(
            path: AppRoutes.reportes,
            builder: (context, state) => const ReportesScreen(),
          ),
          GoRoute(
            path: AppRoutes.configuracion,
            builder: (context, state) => const ConfiguracionScreen(),
          ),
          GoRoute(
            path: AppRoutes.rrhh,
            builder: (context, state) => const RrhhScreen(),
          ),
          GoRoute(
            path: AppRoutes.proveedores,
            builder: (context, state) => const ProveedoresScreen(),
          ),
          GoRoute(
            path: AppRoutes.movimientos,
            builder: (context, state) => const MovimientosScreen(),
          ),
          GoRoute(
            path: AppRoutes.contabilidad,
            builder: (context, state) => const ContabilidadScreen(),
          ),
          GoRoute(
            path: AppRoutes.merma,
            builder: (context, state) => const MermaScreen(),
          ),
        ],
      ),

      // ── Rutas push (fuera del shell, pantalla completa) ─────
      // Inventario
      GoRoute(
        path: AppRoutes.inventarioNuevo,
        builder: (context, state) => const ProductoFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.inventarioEditar,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return ProductoFormScreen(productoId: id);
        },
      ),

      // Ventas
      GoRoute(
        path: AppRoutes.ventasCarrito,
        builder: (context, state) => const CarritoScreen(),
      ),
      GoRoute(
        path: AppRoutes.ventasCobro,
        builder: (context, state) => const CobroScreen(),
      ),
      GoRoute(
        path: AppRoutes.ventasPostVenta,
        builder: (context, state) => const PostVentaScreen(),
      ),
      GoRoute(
        path: AppRoutes.ventasHistorial,
        builder: (context, state) => const VentasHistorialScreen(),
      ),
      GoRoute(
        path: AppRoutes.inventarioCategorias,
        builder: (context, state) => const CategoriasScreen(),
      ),
      // Clientes (estáticas ANTES que :id)
      GoRoute(
        path: AppRoutes.clientesNuevo,
        builder: (context, state) => const ClienteFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.clientesEditar,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return ClienteFormScreen(clienteId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.clientesDetalle,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) return const SizedBox.shrink();
          return ClienteDetailScreen(clienteId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.proveedoresNuevo,
        builder: (context, state) => const ProveedorFormScreen(),
      ),
      GoRoute(
        path: AppRoutes.proveedoresEditar,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return ProveedorFormScreen(proveedorId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.proveedoresDetalle,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          if (id == null) return const SizedBox.shrink();
          return ProveedorDetailScreen(proveedorId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.impresora,
        builder: (context, state) => const PrinterConfigScreen(),
      ),
      GoRoute(
        path: AppRoutes.configDatos,
        builder: (context, state) => const DatosBodegaScreen(),
      ),
      GoRoute(
        path: AppRoutes.configIdentidad,
        builder: (context, state) => const IdentidadScreen(),
      ),
      GoRoute(
        path: AppRoutes.configImpuestos,
        builder: (context, state) => const ImpuestosScreen(),
      ),
      GoRoute(
        path: AppRoutes.historialTasas,
        builder: (context, state) => const HistorialTasasScreen(),
      ),
      GoRoute(
        path: AppRoutes.configMetodosPago,
        builder: (context, state) => const MetodosPagoScreen(),
      ),
      GoRoute(
        path: AppRoutes.reporteCajero,
        builder: (context, state) => const ReporteCajeroScreen(),
      ),
      GoRoute(
        path: AppRoutes.ventasDevolucion,
        builder: (context, state) {
          final venta = state.extra as VentaData;
          return DevolucionScreen(venta: venta);
        },
      ),
    ],
  );
});
