import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_detail_screen.dart' as detail;
import 'screens/create_recipe_screen.dart';
import 'screens/favorites_screen.dart' as favorites;
import 'screens/feedback_screen.dart' as feedback;
import 'screens/explore_recipes_screen.dart';
import 'screens/barista_screen.dart';
import 'models/recipe.dart';

void main() {
  runApp(CoffeeRecipesApp());
}

class CoffeeRecipesApp extends StatelessWidget {
  const CoffeeRecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Recipes',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown).copyWith(
          secondary: Colors.orange,
        ),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey[100],
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/create-recipe': (context) => CreateRecipeScreen(),
        '/favorites': (context) => favorites.FavoritesScreen(),
        '/feedback': (context) => feedback.FeedbackScreen(),
        '/explore-recipes': (context) => ExploreRecipesScreen(),
        '/barista': (context) => BaristaScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/recipe-detail') {
          final recipe = settings.arguments as Recipe?;
          if (recipe != null) {
            return MaterialPageRoute(
              builder: (context) => detail.RecipeDetailScreen(recipe: recipe),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('No recipe provided')),
              ),
            );
          }
        }
        return null;
      },
    );
  }
}
