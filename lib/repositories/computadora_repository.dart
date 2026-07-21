import 'package:sqflite/sqflite.dart';

import '../database/database_constants.dart';
import '../database/database_helper.dart';
import '../models/computadora.dart';

class ComputadoraRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertarComputadora(Computadora computadora) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      DatabaseConstants.computadoraTable,
      computadora.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Computadora?> obtenerPorActivo(int idActivo) async {
    final Database db = await _databaseHelper.database;

    final resultado = await db.query(
      DatabaseConstants.computadoraTable,
      where: 'idActivo = ?',
      whereArgs: [idActivo],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Computadora.fromMap(resultado.first);
  }

  Future<int> actualizarComputadora(Computadora computadora) async {
  final Database db = await _databaseHelper.database;

    return await db.update(
      DatabaseConstants.computadoraTable,
      {
        'tipoComputadora': computadora.tipoComputadora,
        'procesador': computadora.procesador,
        'ram': computadora.ram,
        'almacenamiento': computadora.almacenamiento,
        'sistemaOperativo': computadora.sistemaOperativo,
        'hostname': computadora.hostname,
      },
      where: 'idActivo = ?',
      whereArgs: [computadora.idActivo],
    );
  }

  Future<int> eliminarPorActivo(int idActivo) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      DatabaseConstants.computadoraTable,
      where: 'idActivo = ?',
      whereArgs: [idActivo],
    );
  }
}