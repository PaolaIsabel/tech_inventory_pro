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

    final path = join(
      dbPath,
      DatabaseConstants.databaseName,
    );

    return await openDatabase(

      path,

      version: DatabaseConstants.databaseVersion,

      onCreate: _onCreate,

    );
  }

    Future<void> _onCreate(
    Database db,
    int version,
  ) async {

    await db.execute(DatabaseTables.createCategoria);

    await db.execute(DatabaseTables.createActivo);

    await db.execute(DatabaseTables.createComputadora);

    await db.execute(DatabaseTables.createImpresora);

    await db.execute(DatabaseTables.createCelular);

    await db.execute(DatabaseTables.createRadio);

    await db.execute(DatabaseTables.createAsignacion);

    // Categorías iniciales

    await db.insert(
      'categoria',
      {
        'nombre': 'Computadora',
        'icono': 'computer',
      },
    );

    await db.insert(
      'categoria',
      {
        'nombre': 'Impresora',
        'icono': 'print',
      },
    );

    await db.insert(
      'categoria',
      {
        'nombre': 'Celular',
        'icono': 'smartphone',
      },
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