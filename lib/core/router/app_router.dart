import 'package:el_cuaderno_de_mario/features/auditoria/presentation/auditoria_screen.dart';
import 'package:el_cuaderno_de_mario/features/caja/presentation/caja_screen.dart';
import 'package:el_cuaderno_de_mario/features/configuracion/presentation/configuracion_screen.dart';
import 'package:el_cuaderno_de_mario/features/merma/presentation/merma_screen.dart';
import 'package:el_cuaderno_de_mario/features/reportes/presentation/reportes_screen.dart';
import 'package:el_cuaderno_de_mario/features/rrhh/presentation/rrhh_screen.dart';
import 'package:el_cuaderno_de_mario/features/ventas/presentation/ventas_historial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../config/app_config_notifier.dart';
import '../services/client_firebase_provider.dart';
import '../services/negocio_service.dart';
import '../widgets/placeholder_screen.dart';
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

      // 1. Suspensión manual (activa=false) → bloquear todo
      if (appConfig.estaSuspendido) {
        return isSuspension ? null : AppRoutes.suspension;
      }

      // 2. Kill switch activo → bloquear en splash
      if (appConfig.isKillSwitchActive) {
        return isSplash ? null : AppRoutes.splash;
      }

      // 3. El Splash controla su propia salida
      if (isSplash) return null;

      // 4. Verificar sesión activa en Firebase del Cliente
      final haySesion =
          clientFb.isInitialized && clientFb.auth.currentUser != null;

      // 5. Si hay sesión y va a pantallas de auth → home
      if (haySesion &&
          (isActivacion || isLogin || isRegistro || isSuspension)) {
        return AppRoutes.home;
      }

      // 6. Si NO hay sesión y va a ruta protegida → login
      if (!haySesion && !isActivacion && !isLogin && !isRegistro) {
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
            path: AppRoutes.auditoria,
            builder: (context, state) => const AuditoriaScreen(),
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
    ],
  );
});
