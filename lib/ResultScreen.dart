import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomeScreen.dart';
import 'QuizState.dart';


class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final score = Provider.of<QuizState>(context).score;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your score is: $score', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<QuizState>(context, listen: false).resetQuiz();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
