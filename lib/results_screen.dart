import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, String>> _results = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedResults = prefs.getStringList('results');
    if (savedResults != null) {
      setState(() {
        _results = savedResults.map((result) {
          final parts = result.split('|');
          return {
            'question': parts[0],
            'userAnswer': parts[1],
            'correctAnswer': parts[2],
            'result': parts[3],
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: _results.isEmpty
          ? Center(child: Text('No results available'))
          : ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final result = _results[index];
          return ListTile(
            title: Text(result['question']!),
            subtitle: Text('Your answer: ${result['userAnswer']!}\n'
                'Correct answer: ${result['correctAnswer']!}\n'
                'Result: ${result['result']!}'),
          );
        },
      ),
    );
  }
}
