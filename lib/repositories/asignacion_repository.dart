import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/asignacion.dart';

class AsignacionRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> insertarAsignacion(Asignacion asignacion) async {
    final Database db = await _databaseHelper.database;

    // Evita tener varias asignaciones activas para el mismo activo.
    await db.delete(
      'asignacion',
      where: 'idActivo = ?',
      whereArgs: [asignacion.idActivo],
    );

    return await db.insert(
      'asignacion',
      asignacion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Asignacion?> obtenerPorActivo(int idActivo) async {
    final Database db = await _databaseHelper.database;

    final resultado = await db.query(
      'asignacion',
      where: 'idActivo = ?',
      whereArgs: [idActivo],
      orderBy: 'idAsignacion DESC',
      limit: 1,
    );

    if (resultado.isEmpty) {
      return null;
    }

    return Asignacion.fromMap(resultado.first);
  }

  Future<int> actualizarAsignacion(Asignacion asignacion) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'asignacion',
      {
        'numeroActa': asignacion.numeroActa,
        'nombres': asignacion.nombres,
        'apellidos': asignacion.apellidos,
        'cargo': asignacion.cargo,
        'area': asignacion.area,
        'fechaAsignacion': asignacion.fechaAsignacion,
        //'fechaDevolucion': asignacion.fechaDevolucion,
        'responsableTI': asignacion.responsableTI,
      },
      where: 'idActivo = ?',
      whereArgs: [asignacion.idActivo],
    );
  }

  Future<int> eliminarPorActivo(int idActivo) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'asignacion',
      where: 'idActivo = ?',
      whereArgs: [idActivo],
    );
  }
}