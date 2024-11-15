import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/recipe.dart';

class BaristaScreen extends StatefulWidget {
  const BaristaScreen({super.key});

  @override
  _BaristaScreenState createState() => _BaristaScreenState();
}

class _BaristaScreenState extends State<BaristaScreen> {
  late Future<List<Recipe>> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = loadRecipes();
  }

  Future<List<Recipe>> loadRecipes() async {
    try {
      final String response = await rootBundle.loadString('assets/recipes.json');
      final data = json.decode(response);

      print("Data cargada desde JSON: $data");

      return (data['recipes'] as List<dynamic>)
          .map((recipeJson) => Recipe.fromMap(recipeJson))
          .toList();
    } catch (e) {
      print("Error al cargar recetas: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Barista")),
      body: FutureBuilder<List<Recipe>>(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes available'));
          } else {
            final recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return ListTile(
                  title: Text(recipe.name),
                  subtitle: Text(
                    recipe.ingredients.map((i) => "${i.amount} ${i.item}").join(", "),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
