/// Comandos ESC/POS estándar para impresoras térmicas (58/80 mm).
class EscPos {
  EscPos._();

  static const String init = '\x1B\x40';
  static const String boldOn = '\x1B\x45\x01';
  static const String boldOff = '\x1B\x45\x00';
  static const String alignLeft = '\x1B\x61\x00';
  static const String alignCenter = '\x1B\x61\x01';
  static const String sizeNormal = '\x1D\x21\x00';
  static const String sizeDouble = '\x1D\x21\x11';
  static const String corte = '\n\n\n\n\x1D\x56\x00';
}

/// Builder de ticket térmico.
/// Recibe textos YA formateados (vía Formato.dart en el adaptador) y los
/// maqueta al ancho de la impresora. SIN emojis (Decisiones.md: las térmicas
/// no los renderizan).
class TicketTermico {
  TicketTermico({this.ancho = 48});

  /// 32 columnas = 58 mm, 48 columnas = 80 mm.
  final int ancho;
  final StringBuffer _sb = StringBuffer();

  // ── Helpers de maquetación ──────────────────────────────────────────────

  String _centrar(String texto) {
    final t = texto.length > ancho ? texto.substring(0, ancho) : texto;
    final pad = (ancho - t.length) ~/ 2;
    return ' ' * pad + t;
  }

  String _ajustar(String texto) =>
      texto.length > ancho ? '${texto.substring(0, ancho - 1)}-' : texto;

  String _izqDer(String izquierda, String derecha) {
    final maxIzq = ancho - derecha.length;
    final i = izquierda.length > maxIzq
        ? '${izquierda.substring(0, maxIzq - 1)}.'
        : izquierda;
    return i.padRight(maxIzq) + derecha;
  }

  // ── Bloques del ticket ──────────────────────────────────────────────────

  void iniciar() => _sb.write(EscPos.init);

  void corte() => _sb.write(EscPos.corte);

  void separador() => _sb.write('${'-' * ancho}\n');

  /// Línea simple de texto (izquierda).
  void linea(String texto) => _sb.write('${_ajustar(texto)}\n');

  /// Par clave/valor: "IVA ............ Bs 13,79"
  void par(String izquierda, String derecha) =>
      _sb.write('${_izqDer(izquierda, derecha)}\n');

  /// Encabezado del negocio (nombre grande al centro + datos fiscales).
  void encabezadoNegocio({
    required String nombre,
    String? slogan,
    String? rif,
    String? direccion,
    String? telefono,
  }) {
    _sb
      ..write(EscPos.alignCenter)
      ..write(EscPos.sizeDouble)
      ..write(EscPos.boldOn)
      ..write('${_centrar(nombre)}\n')
      ..write(EscPos.boldOff)
      ..write(EscPos.sizeNormal);
    if (slogan != null && slogan.isNotEmpty) {
      _sb.write('${_centrar(slogan)}\n');
    }
    _sb.write(EscPos.alignLeft);
    if (rif != null && rif.isNotEmpty) _sb.write('RIF: $rif\n');
    if (direccion != null && direccion.isNotEmpty) {
      _sb.write('${_ajustar(direccion)}\n');
    }
    if (telefono != null && telefono.isNotEmpty) {
      _sb.write('Tel: $telefono\n');
    }
    separador();
  }

  /// Título centrado en negrita (ej: "TICKET DE VENTA", "ANULADA").
  void titulo(String texto) {
    _sb
      ..write(EscPos.alignCenter)
      ..write(EscPos.boldOn)
      ..write('${_centrar(texto)}\n')
      ..write(EscPos.boldOff)
      ..write(EscPos.alignLeft);
  }

  /// Ítem: nombre en su línea y debajo "  2 x $1.50 ..... $3.00"
  void item({
    required String nombre,
    required String detalle,
    required String total,
  }) {
    _sb
      ..write('${_ajustar(nombre)}\n')
      ..write('${_izqDer('  $detalle', total)}\n');
  }

  /// Total en negrita (ej: "TOTAL ....... $15.50").
  void totalDestacado(String izquierda, String derecha) {
    _sb
      ..write(EscPos.boldOn)
      ..write('${_izqDer(izquierda, derecha)}\n')
      ..write(EscPos.boldOff);
  }

  /// Bytes listos para PrintBluetoothThermal.writeBytes.
  List<int> bytes() => _sb.toString().codeUnits;
}
