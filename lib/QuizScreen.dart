import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'QuizState.dart';
import 'ResultScreen.dart';


class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Consumer<QuizState>(
        builder: (context, quizState, child) {
          if (quizState.isQuizComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ResultScreen()),
              );
            });
            return Container();
          }

          final flashcard = quizState.currentFlashcard;
          return flashcard != null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(flashcard.question, style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  quizState.answerFlashcard(true);
                },
                child: Text('Show Answer'),
              ),
            ],
          )
              : Center(child: Text('No flashcards available.'));
        },
      ),
    );
  }
}
