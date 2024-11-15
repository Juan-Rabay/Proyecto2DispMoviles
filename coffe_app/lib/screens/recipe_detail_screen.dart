import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';
import 'dart:io';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _imagePaths = List<String>.from(widget.recipe.imagePaths);
  }

  Future<void> _addImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePaths.add(image.path);
      });
      if (widget.recipe.id != null) {
        await DatabaseService.instance.updateRecipeImages(widget.recipe.id, _imagePaths);
      } else {
        print('La receta no tiene un ID asignado. Asegúrate de que esté guardada en la base de datos.');
      }
    }
  }

  void _toggleFavorite() async {
    if (widget.recipe.id != null) {
      setState(() {
        widget.recipe.isFavorite = !widget.recipe.isFavorite;
      });
      await DatabaseService.instance.updateRecipeFavoriteStatus(
        widget.recipe.id!,
        widget.recipe.isFavorite,
      );
    } else {
      print('La receta no tiene un ID asignado. Asegúrate de que esté guardada en la base de datos.');
    }
  }

  void _incrementPreparationsCount() async {
    if (widget.recipe.id != null) {
      setState(() {
        widget.recipe.preparationsCount += 1;
      });
      await DatabaseService.instance.incrementPreparationsCount(widget.recipe.id!);
    } else {
      print('La receta no tiene un ID asignado. Asegúrate de que esté guardada en la base de datos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                'Mira esta receta: ${widget.recipe.name}\n\n'
                'Ingredientes:\n${widget.recipe.ingredients.map((i) => '${i.amount} ${i.item}').join(", ")}\n\n'
                'Instrucciones:\n${widget.recipe.instructions.join("\n")}'
              );
            },
          ),
          IconButton(
            icon: Icon(widget.recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_imagePaths.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imagePaths.length,
                  itemBuilder: (context, index) {
                    final imagePath = _imagePaths[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: imagePath.startsWith('http')
                          ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              width: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return Text('Imagen no disponible');
                              },
                            )
                          : Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              width: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return Text('Imagen no disponible');
                              },
                            ),
                    );
                  },
                ),
              )
            else
              Text('Imagen no disponible'),
            TextButton.icon(
              icon: Icon(Icons.add_a_photo),
              label: Text('Agregar Imagen'),
              onPressed: _addImage,
            ),
            const SizedBox(height: 16),
            Text(
              'Ingredientes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.recipe.ingredients.map((ingredient) => Text('${ingredient.amount} ${ingredient.item}')).toList(),
            const SizedBox(height: 16),
            Text(
              'Instrucciones:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.recipe.instructions.map((instruction) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(instruction),
            )).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _incrementPreparationsCount,
              child: Text('Preparar (Total: ${widget.recipe.preparationsCount})'),
            ),
          ],
        ),
      ),
    );
  }
}
