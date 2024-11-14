import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class ExploreRecipesScreen extends StatefulWidget {
  const ExploreRecipesScreen({super.key});

  @override
  _ExploreRecipesScreenState createState() => _ExploreRecipesScreenState();
}

class _ExploreRecipesScreenState extends State<ExploreRecipesScreen> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes(); // Carga las recetas al iniciar la pantalla
  }

  Future<void> _loadRecipes() async {
    // Obtén todas las recetas desde la base de datos
    final allRecipes = await DatabaseService.instance.fetchRecipes();
    setState(() {
      recipes = allRecipes; // Actualiza la lista de recetas en el estado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Recipes')),
      body: recipes.isEmpty
          ? const Center(child: Text('No recipes available'))
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  title: Text(recipe.name),
                  onTap: () {
                    // Navega a RecipeDetailScreen pasando la receta seleccionada como argumento
                    Navigator.pushNamed(
                      context,
                      '/recipe-detail',
                      arguments: recipe, // Pasamos el objeto Recipe seleccionado
                    );
                  },
                );
              },
            ),
    );
  }
}
