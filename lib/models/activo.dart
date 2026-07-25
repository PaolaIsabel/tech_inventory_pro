class Activo {
  final int? idActivo;
  final int idCategoria;
  final String serie;
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
    required this.idCategoria,
    required this.serie,
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
      'idCategoria': idCategoria,
      'serie': serie,
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
      idCategoria: map['idCategoria'],
      serie: map['serie'],
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