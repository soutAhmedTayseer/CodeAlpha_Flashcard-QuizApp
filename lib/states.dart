abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppAddFlashcardState extends AppStates {}

class AppGetFlashcardsState extends AppStates {}

class AppQuizCompleteState extends AppStates {}

class AppIndexChangedState extends AppStates {
  final int index;
  AppIndexChangedState(this.index);
}

class AppThemeChangedState extends AppStates {}

class AppNavigateToProfileState extends AppStates {}

class AppNavigateToFavoritesState extends AppStates {}

class AppNavigateToLanguagesState extends AppStates {}

class AppNavigateToAboutState extends AppStates {}

class AppNavigateToThemesState extends AppStates {}
