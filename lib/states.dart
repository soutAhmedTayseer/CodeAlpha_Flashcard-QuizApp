abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppAddFlashcardState extends AppStates {}

class AppGetFlashcardsState extends AppStates {}

class AppQuizCompleteState extends AppStates {}

class AppIndexChangedState extends AppStates {
  final int index;
  AppIndexChangedState(this.index);
}