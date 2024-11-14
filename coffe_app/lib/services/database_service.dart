import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        ingredients TEXT,
        steps TEXT,
        imagePath TEXT,
        isFavorite INTEGER,
        preparationsCount INTEGER DEFAULT 0
      )
    ''');
  }

  // Método para manejar la migración de la base de datos
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE recipes ADD COLUMN preparationsCount INTEGER DEFAULT 0");
    }
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.insert('recipes', recipe.toMap());
  }

  Future<void> updateFavoriteStatus(int recipeId, bool isFavorite) async {
    final db = await instance.database;
    await db.update(
      'recipes',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<void> updatePreparationCount(int recipeId, int count) async {
    final db = await instance.database;
    await db.update(
      'recipes',
      {'preparationsCount': count},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<List<Recipe>> fetchRecipes() async {
    final db = await instance.database;
    final maps = await db.query('recipes');
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }
}
