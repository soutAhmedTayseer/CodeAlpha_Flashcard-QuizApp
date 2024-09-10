import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  // User Authentication
  void loginUser({required String email, required String password}) {
    emit(AppLoginLoadingState());
    // Simulate login logic, success or error:
    try {
      emit(AppLoginSuccessState());
    } catch (e) {
      emit(AppLoginErrorState());
    }
  }

  void signupUser({required String email, required String password}) {
    emit(AppSignupLoadingState());
    // Simulate signup logic:
    try {
      emit(AppSignupSuccessState());
    } catch (e) {
      emit(AppSignupErrorState());
    }
  }

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
