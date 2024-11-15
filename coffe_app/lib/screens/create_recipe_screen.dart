import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        name: _nameController.text,
        ingredients: _parseIngredients(_ingredientsController.text),
        instructions: _parseSteps(_stepsController.text),
        imagePaths: [], // Cambia '' por una lista vacía
      );

      await DatabaseService.instance.insertRecipe(recipe);
      Navigator.pop(context);
    }
  }

  List<Ingredient> _parseIngredients(String input) {
    return input.split(',').map((ingredient) {
      final parts = ingredient.trim().split(' ');
      return Ingredient(item: parts[1], amount: parts[0]);
    }).toList();
  }

  List<String> _parseSteps(String input) {
    return input.split('.').map((step) => step.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Ingredients (amount item)'),
                validator: (value) => value!.isEmpty ? 'Please enter ingredients' : null,
              ),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(labelText: 'Steps (separate by periods)'),
                validator: (value) => value!.isEmpty ? 'Please enter steps' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
