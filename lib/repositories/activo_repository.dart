import 'package:sqflite/sqflite.dart';

import '../database/database_constants.dart';
import '../database/database_helper.dart';
import '../models/activo.dart';

class ActivoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertarActivo(Activo activo) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      DatabaseConstants.activoTable,
      activo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Activo>> obtenerActivos() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.activoTable,
      orderBy: 'idActivo DESC',
    );

    return maps.map((map) => Activo.fromMap(map)).toList();
  }

  Future<Activo?> obtenerActivoPorId(int idActivo) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.activoTable,
      where: 'idActivo = ?',
      whereArgs: [idActivo],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    return Activo.fromMap(maps.first);
  }

  Future<int> actualizarActivo(Activo activo) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      DatabaseConstants.activoTable,
      activo.toMap(),
      where: 'idActivo = ?',
      whereArgs: [activo.idActivo],
    );
  }

  Future<int> eliminarActivo(int idActivo) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      DatabaseConstants.activoTable,
      where: 'idActivo = ?',
      whereArgs: [idActivo],
    );
  }
}