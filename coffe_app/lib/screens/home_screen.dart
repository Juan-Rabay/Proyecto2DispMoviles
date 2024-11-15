import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback),
            onPressed: () {
              Navigator.pushNamed(context, '/feedback');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildCard(
            context,
            'Explore Recipes',
            Icons.coffee,
            '/explore-recipes',
          ),
          _buildCard(
            context,
            'Create New Recipe',
            Icons.add,
            '/create-recipe',
          ),
          _buildCard(
            context,
            'Favorites',
            Icons.favorite,
            '/favorites',
          ),
          _buildCard(
          context,
          'Barista',
          Icons.local_cafe,
          '/barista', // La ruta debe coincidir con la de `main.dart`
        ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 50, color: Colors.brown),
        title: Text(title, style: const TextStyle(fontSize: 20)),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
