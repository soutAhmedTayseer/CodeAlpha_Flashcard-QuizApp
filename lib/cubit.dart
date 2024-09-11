import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    _currentIndex = index;
    emit(AppIndexChangedState(index));
  }

  // To access the AppCubit instance from the context
  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

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
