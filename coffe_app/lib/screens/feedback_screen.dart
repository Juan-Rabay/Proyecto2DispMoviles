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

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/feedback_questions.json');
    final data = json.decode(response) as List;
    setState(() {
      questions = data.map((item) => item['question'] as String).toList();
    });
  }

  void sendFeedback() async {
    const email = "email@example.com";
    const subject = "App Feedback";
    final body = questions.join("\n");
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
      body: ListView(
        children: questions.map((question) {
          return ListTile(title: Text(question));
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendFeedback,
        child: Icon(Icons.send),
      ),
    );
  }
}
