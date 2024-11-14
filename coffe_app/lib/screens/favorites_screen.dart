import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteRecipes();
  }

  Future<void> loadFavoriteRecipes() async {
    final allRecipes = await DatabaseService.instance.fetchRecipes();
    setState(() {
      favoriteRecipes = allRecipes.where((recipe) => recipe.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text('No favorite recipes yet!'))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return ListTile(
                  title: Text(recipe.name),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/recipe-detail',
                      arguments: recipe,
                    ).then((_) => loadFavoriteRecipes());
                  },
                );
              },
            ),
    );
  }
}
