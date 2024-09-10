import 'package:flutter/material.dart';
import 'flashcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizState with ChangeNotifier {
  List<Flashcard> _flashcards = [];
  int _currentFlashcardIndex = 0;
  int _score = 0;
  bool _isQuizComplete = false;

  List<Flashcard> get flashcards => _flashcards;
  int get score => _score;
  bool get isQuizComplete => _isQuizComplete;
  Flashcard? get currentFlashcard => _flashcards.isNotEmpty && _currentFlashcardIndex < _flashcards.length
      ? _flashcards[_currentFlashcardIndex]
      : null;

  void addFlashcard(String question, String answer) {
    _flashcards.add(Flashcard(question: question, answer: answer));
    notifyListeners();
  }

  void resetQuiz() {
    _currentFlashcardIndex = 0;
    _score = 0;
    _isQuizComplete = false;
    notifyListeners();
  }

  void answerFlashcard(bool isCorrect) {
    if (isCorrect) _score++;
    _currentFlashcardIndex++;
    if (_currentFlashcardIndex >= _flashcards.length) {
      _isQuizComplete = true;
    }
    notifyListeners();
  }

  void loadFlashcards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load saved flashcards from SharedPreferences (not implemented here)
  }

  void saveFlashcards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save flashcards to SharedPreferences (not implemented here)
  }
}
