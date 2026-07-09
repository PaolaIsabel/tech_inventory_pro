import 'package:sqflite/sqflite.dart';

import '../database/database_constants.dart';
import '../database/database_helper.dart';
import '../models/categoria.dart';

class CategoriaRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Categoria>> obtenerCategorias() async {
    final Database db = await _databaseHelper.database;

    final resultado = await db.query(
      DatabaseConstants.categoriaTable,
      orderBy: 'nombre',
    );

    return resultado
        .map((e) => Categoria.fromMap(e))
        .toList();
  }
}