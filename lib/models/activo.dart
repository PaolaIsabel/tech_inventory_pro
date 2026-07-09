class Activo {
  final int? idActivo;

  final String serie;
  final String tipoActivo;
  final String marca;
  final String modelo;
  final String estado;
  final String? condicionFisica;
  final String? ubicacion;
  final String? fechaCompra;
  final String? fechaRegistro;
  final String? garantia;
  final String? observaciones;

  const Activo({
    this.idActivo,
    required this.serie,
    required this.tipoActivo,
    required this.marca,
    required this.modelo,
    required this.estado,
    this.condicionFisica,
    this.ubicacion,
    this.fechaCompra,
    this.fechaRegistro,
    this.garantia,
    this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'idActivo': idActivo,
      'serie': serie,
      'tipoActivo': tipoActivo,
      'marca': marca,
      'modelo': modelo,
      'estado': estado,
      'condicionFisica': condicionFisica,
      'ubicacion': ubicacion,
      'fechaCompra': fechaCompra,
      'fechaRegistro': fechaRegistro,
      'garantia': garantia,
      'observaciones': observaciones,
    };
  }

  factory Activo.fromMap(Map<String, dynamic> map) {
    return Activo(
      idActivo: map['idActivo'],
      serie: map['serie'],
      tipoActivo: map['tipoActivo'],
      marca: map['marca'],
      modelo: map['modelo'],
      estado: map['estado'],
      condicionFisica: map['condicionFisica'],
      ubicacion: map['ubicacion'],
      fechaCompra: map['fechaCompra'],
      fechaRegistro: map['fechaRegistro'],
      garantia: map['garantia'],
      observaciones: map['observaciones'],
    );
  }
}