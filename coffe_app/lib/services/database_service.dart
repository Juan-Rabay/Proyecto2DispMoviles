import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/recipe.dart';
import 'package:path/path.dart';

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
      version: 4,
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
        instructions TEXT,
        imagePaths TEXT,
        isFavorite INTEGER,
        preparationsCount INTEGER DEFAULT 0,
        preparationTime INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE recipes ADD COLUMN imagePaths TEXT");
    }
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE recipes ADD COLUMN instructions TEXT");
    }
    if (oldVersion < 4) {
      await db.execute("ALTER TABLE recipes ADD COLUMN preparationTime INTEGER DEFAULT 0");
    }
  }

  Future<void> insertRecipe(Recipe recipe) async {
    final db = await instance.database;
    await db.insert('recipes', recipe.toMap());
    await saveRecipesToJSON(); // Actualiza el JSON
  }

  Future<void> updateRecipeImages(int? recipeId, List<String> imagePaths) async {
    final db = await instance.database;
    await db.update(
      'recipes',
      {'imagePaths': jsonEncode(imagePaths)},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
    await saveRecipesToJSON(); // Actualiza el JSON
  }

  Future<List<Recipe>> fetchRecipes() async {
    final db = await instance.database;
    final maps = await db.query('recipes');
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<void> updateRecipeFavoriteStatus(int recipeId, bool isFavorite) async {
    final db = await instance.database;
    await db.update(
      'recipes',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
    await saveRecipesToJSON(); // Actualiza el JSON
  }

  Future<void> incrementPreparationsCount(int recipeId) async {
    final db = await instance.database;
    await db.rawUpdate(
      'UPDATE recipes SET preparationsCount = preparationsCount + 1 WHERE id = ?',
      [recipeId],
    );
    await saveRecipesToJSON(); // Actualiza el JSON
  }

  Future<void> updatePreparationTime(int recipeId, int preparationTime) async {
    final db = await instance.database;
    await db.update(
      'recipes',
      {'preparationTime': preparationTime},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
    await saveRecipesToJSON(); // Actualiza el JSON
  }

  // Función para guardar el estado actual de la base de datos en el archivo JSON
  Future<void> saveRecipesToJSON() async {
    // Obtén todas las recetas de la base de datos
    List<Recipe> recipes = await fetchRecipes();

    // Convierte las recetas en JSON
    List<Map<String, dynamic>> jsonRecipes =
        recipes.map((recipe) => recipe.toMap()).toList();

    // Crea un mapa para el JSON
    Map<String, dynamic> jsonMap = {
      'recipes': jsonRecipes,
    };

    // Guarda el JSON en el archivo
    final directory = await getApplicationDocumentsDirectory();
    final filePath = join(directory.path, 'recipes.json');
    final file = File(filePath);

    await file.writeAsString(jsonEncode(jsonMap));
  }
}
