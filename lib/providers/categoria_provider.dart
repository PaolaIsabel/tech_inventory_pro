import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/categoria.dart';
import '../repositories/categoria_repository.dart';

final categoriaRepositoryProvider =
    Provider<CategoriaRepository>((ref) {
  return CategoriaRepository();
});

final categoriasProvider =
    FutureProvider<List<Categoria>>((ref) async {

  final repository =
      ref.read(categoriaRepositoryProvider);

  return repository.obtenerCategorias();

});