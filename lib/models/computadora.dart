class Computadora {
  final int? idComputadora;
  final int idActivo;
  final String? tipoComputadora;
  final String? procesador;
  final String? ram;
  final String? almacenamiento;
  final String? sistemaOperativo;
  final String? hostname;

  const Computadora({
    this.idComputadora,
    required this.idActivo,
    this.tipoComputadora,
    this.procesador,
    this.ram,
    this.almacenamiento,
    this.sistemaOperativo,
    this.hostname,
  });

  Map<String, dynamic> toMap() {
    return {
      'idComputadora': idComputadora,
      'idActivo': idActivo,
      'tipoComputadora': tipoComputadora,
      'procesador': procesador,
      'ram': ram,
      'almacenamiento': almacenamiento,
      'sistemaOperativo': sistemaOperativo,
      'hostname': hostname,
    };
  }

  factory Computadora.fromMap(Map<String, dynamic> map) {
    return Computadora(
      idComputadora: map['idComputadora'],
      idActivo: map['idActivo'],
      tipoComputadora: map['tipoComputadora'],
      procesador: map['procesador'],
      ram: map['ram'],
      almacenamiento: map['almacenamiento'],
      sistemaOperativo: map['sistemaOperativo'],
      hostname: map['hostname'],
    );
  }
}