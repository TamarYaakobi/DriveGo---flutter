import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/car_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'drive_go_favorites.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            name TEXT,
            year INTEGER,
            seats INTEGER,
            imageUrl TEXT,
            companyId TEXT,
            categoryId TEXT,
            description TEXT
          )
        ''');
      },
    );
  }

  Future<void> addFavorite(Car car) async {
    final db = await database;
    await db.insert(
      'favorites',
      car.toSQLiteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String carId) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [carId]);
  }

  Future<List<Car>> getFavorites() async {
    final db = await database;
    final result = await db.query('favorites');
    return result.map((map) => Car.fromSQLiteMap(map)).toList();
  }
}