import 'package:flutter/material.dart';
import 'package:flutter_projects/quiz_results_provider.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quizResults = QuizResultsProvider().getResults();

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Results')),
      body: ListView.builder(
        itemCount: quizResults.length,
        itemBuilder: (context, index) {
          final result = quizResults[index];
          return ListTile(
            title: Text('Date: ${result.date}'),
            subtitle: Text('Score: ${result.score}'),
            onTap: () {
              // You can add more details about the result here
            },
          );
        },
      ),
    );
  }
}
