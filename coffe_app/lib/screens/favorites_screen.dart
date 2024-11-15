import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recipe> _favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final allRecipes = await DatabaseService.instance.fetchRecipes();
    setState(() {
      _favoriteRecipes = allRecipes.where((recipe) => recipe.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _favoriteRecipes.isEmpty
          ? const Center(child: Text('No favorite recipes yet!'))
          : ListView.builder(
              itemCount: _favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = _favoriteRecipes[index];
                return ListTile(
                  title: Text(recipe.name),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/recipe-detail',
                      arguments: recipe,
                    ).then((_) => _loadFavoriteRecipes());
                  },
                );
              },
            ),
    );
  }
}
