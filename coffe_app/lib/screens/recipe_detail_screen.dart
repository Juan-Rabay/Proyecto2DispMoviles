import 'dart:async';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/recipe.dart';
import '../services/database_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late bool isFavorite;
  int preparationsCount = 0;
  int timerSeconds = 0;
  bool isTimerRunning = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.recipe.isFavorite;
    preparationsCount = widget.recipe.preparationsCount;
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    await DatabaseService.instance.updateFavoriteStatus(widget.recipe.id!, isFavorite);
  }

  void _incrementPreparationCount() {
    setState(() {
      preparationsCount++;
    });
    DatabaseService.instance.updatePreparationCount(widget.recipe.id!, preparationsCount);
  }

  void _startTimer() {
    setState(() {
      isTimerRunning = true;
      timerSeconds = 0; // Reinicia el temporizador
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timerSeconds++;
      });
    });
  }

  void _stopTimer() {
    setState(() {
      isTimerRunning = false;
    });
    timer?.cancel();
  }

  void _shareRecipe() {
    Share.share(
      'Check out this recipe: ${widget.recipe.name}\n\n'
      'Ingredients:\n${widget.recipe.ingredients}\n\n'
      'Steps:\n${widget.recipe.steps}',
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareRecipe,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.recipe.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.recipe.ingredients),
            const SizedBox(height: 10),
            const Text(
              'Steps:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.recipe.steps),
            const SizedBox(height: 20),
            Text(
              'Preparations: $preparationsCount',
              style: const TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: _incrementPreparationCount,
              child: const Text("Mark as Prepared"),
            ),
            const SizedBox(height: 20),
            Text(
              'Timer: ${Duration(seconds: timerSeconds).toString().split('.').first}',
              style: const TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: isTimerRunning ? null : _startTimer,
                  child: const Text("Start Timer"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isTimerRunning ? _stopTimer : null,
                  child: const Text("Stop Timer"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
