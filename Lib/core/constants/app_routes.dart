/// Centralización de rutas para evitar strings mágicos en go_router.
abstract class AppRoutes {
  // Pre-login
  static const splash = '/';
  static const activacion = '/activacion';
  static const login = '/login';
  static const registroAdmin = '/registro-admin';
  static const suspension = '/suspension';

  // Shell (post-login)
  static const home = '/home';
  static const ventas = '/home/ventas';
  static const ventasCarrito = '/home/ventas/carrito';
  static const ventasCobro = '/home/ventas/cobro';
  static const ventasPostVenta = '/home/ventas/postventa';
  static const inventario = '/home/inventario';
  static const inventarioNuevo = '/home/inventario/nuevo';
  static const inventarioEditar = '/home/inventario/editar/:id';
  static const caja = '/home/caja';
  static const clientes = '/home/clientes';
  static const clientesNuevo = '/home/clientes/nuevo';
  static const clientesEditar = '/home/clientes/editar/:id';
  static const clientesDetalle = '/home/clientes/:id';
  static const reportes = '/home/reportes';
  static const ventasHistorial = '/home/ventas/historial';
  static const configuracion = '/home/configuracion';
  static const configDatos = '/configuracion/datos';
  static const configIdentidad = '/configuracion/identidad';
  static const configImpuestos = '/configuracion/impuestos';
  static const configMetodosPago = '/configuracion/metodos-pago';
  static const rrhh = '/home/rrhh';
  static const auditoria = '/home/auditoria';
  static const merma = '/home/merma';
  static const impresora = '/impresora';
}
