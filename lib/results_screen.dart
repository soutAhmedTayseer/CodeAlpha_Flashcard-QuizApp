import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  Map<String, List<Map<String, String>>> _quizzes = {};

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final quizzes = <String, List<Map<String, String>>>{};

    for (final key in keys) {
      if (key.startsWith('Quiz ')) {
        final results = prefs.getStringList(key);
        if (results != null) {
          quizzes[key] = results.map((result) {
            final parts = result.split('|');
            return {
              'question': parts[0],
              'userAnswer': parts[1],
              'correctAnswer': parts[2],
              'result': parts[3],
            };
          }).toList();
        }
      }
    }

    setState(() {
      _quizzes = quizzes;
    });
  }

  void _showQuizResults(String quizLabel) {
    final results = _quizzes[quizLabel] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(quizLabel),
          content: results.isEmpty
              ? const Text('No results available.')
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: results.map((result) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Q: ${result['question']!}\n'
                        'Your answer: ${result['userAnswer']!}\n'
                        'Correct answer: ${result['correctAnswer']!}\n'
                        'Result: ${result['result']!}\n',
                    style:  const TextStyle(fontSize: 16.0),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _quizzes.isEmpty
          ? const Center(child: Text('No results available'))
          : ListView(
        children: _quizzes.keys.map((quizLabel) {
          return ListTile(
            title: Text(quizLabel),
            onTap: () => _showQuizResults(quizLabel),
          );
        }).toList(),
      ),
    );
  }
}
