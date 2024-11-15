import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<String> questions = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/feedback_questions.json');
    final data = json.decode(response) as Map<String, dynamic>;

    List<String> allQuestions = [];
    data.forEach((category, questions) {
      final List<dynamic> questionsList = questions as List<dynamic>;
      questionsList.forEach((question) {
        allQuestions.add(question['titulo']);
      });
    });

    setState(() {
      questions = allQuestions;
      controllers = List.generate(questions.length, (index) => TextEditingController());
    });
  }

  void sendFeedback() async {
    final email = "email@example.com";
    final subject = "App Feedback";
    final body = questions.asMap().entries.map((entry) {
      int index = entry.key;
      String question = entry.value;
      String answer = controllers[index].text;
      return "$question:\n$answer";
    }).join("\n\n");

    final uri = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Feedback")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < questions.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions[i],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controllers[i],
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu respuesta aquí...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null, // Permite texto multilínea
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendFeedback,
        child: const Icon(Icons.send),
      ),
    );
  }
}
