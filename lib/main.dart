import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_projects/QuizState.dart';
import 'package:flutter_projects/HomeScreen.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizState()),
      ],
      child: FlashcardQuizApp(),
    ),
  );
}

class FlashcardQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
