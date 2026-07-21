class DatabaseTables {
  DatabaseTables._();

  static const String createCategoria = '''
  CREATE TABLE categoria(
    idCategoria INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL,
    icono TEXT
  );
  ''';

  static const String createActivo = '''
  CREATE TABLE activo(
    idActivo INTEGER PRIMARY KEY AUTOINCREMENT,
    idCategoria INTEGER NOT NULL,
    serie TEXT UNIQUE NOT NULL,
    marca TEXT NOT NULL,
    modelo TEXT NOT NULL,
    estado TEXT NOT NULL,
    condicionFisica TEXT,
    ubicacion TEXT,
    fechaCompra TEXT,
    fechaRegistro TEXT,
    garantia TEXT,
    observaciones TEXT,
    FOREIGN KEY(idCategoria) REFERENCES categoria(idCategoria)
  );
  ''';

  static const String createComputadora = '''
  CREATE TABLE computadora(
    idComputadora INTEGER PRIMARY KEY AUTOINCREMENT,
    idActivo INTEGER NOT NULL,
    tipoComputadora TEXT,
    procesador TEXT,
    ram TEXT,
    almacenamiento TEXT,
    sistemaOperativo TEXT,
    hostname TEXT,
    FOREIGN KEY(idActivo) REFERENCES activo(idActivo)
  );
  ''';

  static const String createImpresora = '''
  CREATE TABLE impresora(
    idImpresora INTEGER PRIMARY KEY AUTOINCREMENT,
    idActivo INTEGER NOT NULL,
    direccionIP TEXT,
    tipoToner TEXT,
    tipoConexion TEXT,
    color TEXT,
    FOREIGN KEY(idActivo) REFERENCES activo(idActivo)
  );
  ''';

  static const String createCelular = '''
  CREATE TABLE celular(
    idCelular INTEGER PRIMARY KEY AUTOINCREMENT,
    idActivo INTEGER NOT NULL,
    imei1 TEXT,
    imei2 TEXT,
    numeroTelefonico TEXT,
    operadora TEXT,
    almacenamiento TEXT,
    versionAndroid TEXT,
    FOREIGN KEY(idActivo) REFERENCES activo(idActivo)
  );
  ''';

  static const String createRadio = '''
  CREATE TABLE radio(
    idRadio INTEGER PRIMARY KEY AUTOINCREMENT,
    idActivo INTEGER NOT NULL,
    tecnologia TEXT,
    tipoRadio TEXT,
    FOREIGN KEY(idActivo) REFERENCES activo(idActivo)
  );
  ''';

  static const String createAsignacion = '''
  CREATE TABLE asignacion(
    idAsignacion INTEGER PRIMARY KEY AUTOINCREMENT,
    idActivo INTEGER NOT NULL,
    numeroActa TEXT,
    nombres TEXT,
    apellidos TEXT,
    cargo TEXT,
    area TEXT,
    fechaAsignacion TEXT,
    fechaDevolucion TEXT,
    responsableTI TEXT,
    FOREIGN KEY(idActivo) REFERENCES activo(idActivo)
  );
  ''';
  // Migración: agrega código patrimonial sin eliminar datos existentes
  static const String migrationAddCodigoPatrimonial = '''
  ALTER TABLE activo
  ADD COLUMN codigoPatrimonial TEXT;
  ''';
}