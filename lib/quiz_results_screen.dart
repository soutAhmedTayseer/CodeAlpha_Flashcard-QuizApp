import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this package to your pubspec.yaml

class QuizResultsScreen extends StatefulWidget {
  const QuizResultsScreen({super.key});

  @override
  _QuizResultsScreenState createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _results = prefs.getStringList('quiz_results') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: _results.isEmpty
          ? const Center(child: Text('No quiz results available'))
          : ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          return ListTile(
            title: Text('Quiz Result ${index + 1}'),
            subtitle: Text(result),
          );
        },
      ),
    );
  }
}
