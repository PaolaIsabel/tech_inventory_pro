import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';
import 'database_tables.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);

    return openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseTables.createCategoria);
    await db.execute(DatabaseTables.createActivo);
    await db.execute(DatabaseTables.createComputadora);
    await db.execute(DatabaseTables.createImpresora);
    await db.execute(DatabaseTables.createCelular);
    await db.execute(DatabaseTables.createRadio);
    await db.execute(DatabaseTables.createAsignacion);

    await _insertarCategoriasIniciales(db);
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Migración de la versión 1 a la versión 2.
    // Se agrega el campo codigoPatrimonial sin eliminar datos existentes.
    if (oldVersion < 2) {
      await db.execute(
        DatabaseTables.migrationAddCodigoPatrimonial,
      );
    }
  }

  Future<void> _insertarCategoriasIniciales(Database db) async {
    await db.insert(
      'categoria',
      {'nombre': 'Computadora', 'icono': 'computer'},
    );

    await db.insert(
      'categoria',
      {'nombre': 'Impresora', 'icono': 'print'},
    );

    await db.insert(
      'categoria',
      {'nombre': 'Celular', 'icono': 'smartphone'},
    );

    await db.insert(
      'categoria',
      {
        'nombre': 'Radio',
        'icono': 'settings_input_antenna',
      },
    );
  }
}