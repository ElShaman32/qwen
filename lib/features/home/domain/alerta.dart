enum TipoAlerta {
  venceHoy,
  vence3Dias,
  venceSemana,
  stockBajo,
  fiadoVencido,
}

class Alerta {
  final int id;
  final String nombre;
  final TipoAlerta tipo;
  final String modulo;
  final String? detalle;

  const Alerta({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.modulo,
    this.detalle,
  });
}

class ResumenAlertas {
  final List<Alerta> venceHoy;
  final List<Alerta> vence3Dias;
  final List<Alerta> venceSemana;
  final List<Alerta> stockBajo;
  final List<Alerta> fiadosVencidos;

  const ResumenAlertas({
    required this.venceHoy,
    required this.vence3Dias,
    required this.venceSemana,
    required this.stockBajo,
    required this.fiadosVencidos,
  });

  int get totalAlertas =>
      venceHoy.length +
      vence3Dias.length +
      venceSemana.length +
      stockBajo.length +
      fiadosVencidos.length;

  bool get hayAlertas => totalAlertas > 0;
}
