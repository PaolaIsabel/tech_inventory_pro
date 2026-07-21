class Asignacion {
  final int? idAsignacion;
  final int idActivo;
  final String? numeroActa;
  final String? nombres;
  final String? apellidos;
  final String? cargo;
  final String? area;
  final String? fechaAsignacion;
  final String? responsableTI;

  const Asignacion({
    this.idAsignacion,
    required this.idActivo,
    this.numeroActa,
    this.nombres,
    this.apellidos,
    this.cargo,
    this.area,
    this.fechaAsignacion,
    this.responsableTI,
  });

  Map<String, dynamic> toMap() {
    return {
      'idAsignacion': idAsignacion,
      'idActivo': idActivo,
      'numeroActa': numeroActa,
      'nombres': nombres,
      'apellidos': apellidos,
      'cargo': cargo,
      'area': area,
      'fechaAsignacion': fechaAsignacion,
      'responsableTI': responsableTI,
    };
  }

  factory Asignacion.fromMap(Map<String, dynamic> map) {
    return Asignacion(
      idAsignacion: map['idAsignacion'],
      idActivo: map['idActivo'],
      numeroActa: map['numeroActa'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      cargo: map['cargo'],
      area: map['area'],
      fechaAsignacion: map['fechaAsignacion'],
      responsableTI: map['responsableTI'],
    );
  }
}