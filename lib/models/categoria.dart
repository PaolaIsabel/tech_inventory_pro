class Categoria {
  final int? idCategoria;
  final String nombre;
  final String? icono;

  const Categoria({
    this.idCategoria,
    required this.nombre,
    this.icono,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCategoria': idCategoria,
      'nombre': nombre,
      'icono': icono,
    };
  }

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      idCategoria: map['idCategoria'],
      nombre: map['nombre'],
      icono: map['icono'],
    );
  }
}