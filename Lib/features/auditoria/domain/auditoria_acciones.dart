/// Códigos de acción del log. Snake_case porque van a Drift y luego
/// (vía SyncService, pendiente #3) a la colección auditoria/ del cliente.
///
/// Reglas Firestore del cliente: auditoria/ write = esUsuarioValido
/// (admin y cajero pueden escribir), read = esAdmin (solo admin ve).
class AccionesAuditoria {
  AccionesAuditoria._();

  // Auth
  static const login = 'login';
  static const logout = 'logout';

  // Ventas
  static const ventaAnulada = 'venta_anulada';

  // Caja
  static const cajaApertura = 'caja_apertura';
  static const cajaCierre = 'caja_cierre';
  static const cajaRetiro = 'caja_retiro';

  // Inventario
  static const productoCreado = 'producto_creado';
  static const productoActualizado = 'producto_actualizado';
  static const productoEliminado = 'producto_eliminado';

  // Clientes
  static const clienteCreado = 'cliente_creado';
  static const fiadoRegistrado = 'fiado_registrado';
  static const abonoRegistrado = 'abono_registrado';

  // Configuración
  static const tasaActualizada = 'tasa_actualizada';
  static const configActualizada = 'config_actualizada';

  // RRHH
  static const usuarioCreado = 'usuario_creado';
  static const usuarioRolCambiado = 'usuario_rol_cambiado';
  static const usuarioEstadoCambiado = 'usuario_estado_cambiado';

  // Auditoría misma
  static const auditoriaExportada = 'auditoria_exportada';

  // ═══════════════════════════════════════════════════════════
  // Movimientos críticos (Decisiones.md — diseño congelado)
  // ═══════════════════════════════════════════════════════════
  static const retiroCaja = 'retiro_caja';
  static const cierreCaja = 'cierre_caja';
  static const merma = 'merma';
  static const usuarioModificado = 'usuario_modificado';
  static const configCambiada = 'config_cambiada';
}
