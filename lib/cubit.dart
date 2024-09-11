import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  // Flashcard Management
  List<Map> flashcards = [];

  void addFlashcard({required String question, required String answer}) {
    flashcards.add({'question': question, 'answer': answer});
    emit(AppAddFlashcardState());
  }

  void getFlashcards() {
    emit(AppGetFlashcardsState());
  }

  // Quiz Logic
  int correctAnswers = 0;

  void submitQuiz(List<bool> answers) {
    correctAnswers = answers.where((answer) => answer).length;
    emit(AppQuizCompleteState());
  }
}
