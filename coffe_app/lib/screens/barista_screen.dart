import 'package:flutter/material.dart';
import '../models/recipe.dart';

class BaristaScreen extends StatelessWidget {
  final List<Recipe> defaultRecipes = [
    Recipe(name: "Espresso", ingredients: "Coffee Beans, Water", steps: "1. Grind beans\n2. Brew", imagePath: '', isFavorite: false),
    Recipe(name: "Cappuccino", ingredients: "Espresso, Milk Foam", steps: "1. Brew espresso\n2. Add milk foam", imagePath: '', isFavorite: false),
    Recipe(name: "Latte", ingredients: "Espresso, Steamed Milk", steps: "1. Brew espresso\n2. Add milk", imagePath: '', isFavorite: false),
    Recipe(name: "Americano", ingredients: "Espresso, Water", steps: "1. Brew espresso\n2. Add hot water", imagePath: '', isFavorite: false),
  ];

BaristaScreen({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Barista")),
      body: ListView.builder(
        itemCount: defaultRecipes.length,
        itemBuilder: (context, index) {
          final recipe = defaultRecipes[index];
          return ListTile(
            title: Text(recipe.name),
            subtitle: Text(recipe.ingredients),
            onTap: () {
              Navigator.pushNamed(context, '/recipe-detail', arguments: recipe);
            },
          );
        },
      ),
    );
  }
}
