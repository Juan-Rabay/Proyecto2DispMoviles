import 'dart:convert';

class Recipe {
  final int? id;
  final String name;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final List<String> imagePaths;
  bool isFavorite; // Cambiable
  int preparationsCount;

  Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.imagePaths,
    this.isFavorite = false,
    this.preparationsCount = 0,
  });

  // Método para convertir el objeto en un mapa para guardar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': jsonEncode(ingredients.map((i) => i.toMap()).toList()),
      'instructions': jsonEncode(instructions),
      'imagePaths': jsonEncode(imagePaths),
      'isFavorite': isFavorite ? 1 : 0,
      'preparationsCount': preparationsCount,
    };
  }

  // Método para crear una instancia de Recipe desde un mapa (base de datos o JSON)
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      ingredients: (map['ingredients'] is String)
          ? (jsonDecode(map['ingredients']) as List<dynamic>)
              .map((item) => Ingredient.fromJson(item))
              .toList()
          : (map['ingredients'] as List<dynamic>)
              .map((item) => Ingredient.fromJson(item))
              .toList(),
      instructions: (map['instructions'] is String)
          ? List<String>.from(jsonDecode(map['instructions']))
          : List<String>.from(map['instructions']),
      imagePaths: (map['imagePaths'] is String)
          ? List<String>.from(jsonDecode(map['imagePaths']))
          : List<String>.from(map['imagePaths'] ?? []),
      isFavorite: map['isFavorite'] == 1,
      preparationsCount: map['preparationsCount'] ?? 0,
    );
  }
}

class Ingredient {
  final String item;
  final String amount;

  Ingredient({required this.item, required this.amount});

  // Convertir un ingrediente a un mapa para almacenar en JSON o base de datos
  Map<String, dynamic> toMap() {
    return {
      'item': item,
      'amount': amount,
    };
  }

  // Crear un ingrediente desde un JSON o mapa de datos
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      item: json['item'],
      amount: json['amount'],
    );
  }
}
