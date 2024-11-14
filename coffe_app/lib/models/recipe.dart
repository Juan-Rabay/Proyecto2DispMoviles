class Recipe {
  final int? id;
  final String name;
  final String ingredients;
  final String steps;
  final String imagePath;
  final bool isFavorite;
  int preparationsCount; // Nuevo campo para el contador de preparaciones

  Recipe
  ({
    this.id,
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.imagePath,
    this.isFavorite = false,
    this.preparationsCount = 0, // Valor inicial de 0
  });

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() 
  {
    return 
    {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'steps': steps,
      'imagePath': imagePath,
      'isFavorite': isFavorite ? 1 : 0,
      'preparationsCount': preparationsCount, // Incluye el campo preparationsCount
    };
  }

  // Método para crear un objeto Recipe desde un mapa
  factory Recipe.fromMap(Map<String, dynamic> map) 
  {
    return Recipe(
      id: map['id'],
      name: map['name'],
      ingredients: map['ingredients'],
      steps: map['steps'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1,
      preparationsCount: map['preparationsCount'] ?? 0, // Obtiene el campo preparationsCount
    );
  }
}
