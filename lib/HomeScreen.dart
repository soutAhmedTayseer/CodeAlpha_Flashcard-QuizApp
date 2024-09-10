import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_projects/QuizState.dart';

import 'QuizScreen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Quiz'),
      ),
      body: Column(
        children: [
          TextField(
            controller: questionController,
            decoration: InputDecoration(labelText: 'Question'),
          ),
          TextField(
            controller: answerController,
            decoration: InputDecoration(labelText: 'Answer'),
          ),
          ElevatedButton(
            onPressed: () {
              if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                Provider.of<QuizState>(context, listen: false).addFlashcard(
                  questionController.text,
                  answerController.text,
                );
                questionController.clear();
                answerController.clear();
              }
            },
            child: Text('Add Flashcard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen()),
              );
            },
            child: Text('Start Quiz'),
          ),
          Expanded(
            child: Consumer<QuizState>(
              builder: (context, quizState, child) {
                return ListView.builder(
                  itemCount: quizState.flashcards.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(quizState.flashcards[index].question),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
