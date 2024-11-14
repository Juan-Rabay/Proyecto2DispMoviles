import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  Future<void> _saveRecipe() async {
    final newRecipe = Recipe(
      name: _nameController.text,
      ingredients: _ingredientsController.text,
      steps: _stepsController.text,
      imagePath: '', // Añade una imagen si es necesario
      isFavorite: false,
    );

    // Guarda la receta en la base de datos
    await DatabaseService.instance.insertRecipe(newRecipe);

    // Regresa a la pantalla anterior
    Navigator.pop(context, newRecipe); // Devuelve la nueva receta a la pantalla anterior si es necesario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              controller: _stepsController,
              decoration: const InputDecoration(labelText: 'Steps'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: const Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
