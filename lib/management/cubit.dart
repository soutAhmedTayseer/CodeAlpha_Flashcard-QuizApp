import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/management/states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState()) {
    _loadSettings();
  }

  static AppCubit get(BuildContext context) => BlocProvider.of<AppCubit>(context);

  // Index for bottom navigation
  int _currentIndex = 1; // Start on Categories page
  int get currentIndex => _currentIndex;

  // Toggle between dark and light mode
  bool isDark = false;

  // Current locale
  Locale _locale = const Locale('en'); // Default locale
  Locale get locale => _locale;

  // Switch index in BottomNavigationBar
  void changeIndex(int index) {
    _currentIndex = index;
    emit(AppIndexChangedState(index));
  }

  // Toggle Theme Mode
  void toggleTheme() async {
    isDark = !isDark;
    await _saveSettings();
    emit(AppThemeChangedState());
  }

  ThemeData get currentTheme {
    final colorScheme = isDark
        ? ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    )
        : ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );

    return ThemeData.from(colorScheme: colorScheme);
  }

  // Change locale
  void changeLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await _saveSettings();
    emit(AppLocaleChangedState());
  }

  // Load settings (theme and locale)
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    String languageCode = prefs.getString('locale') ?? 'en';
    _locale = Locale(languageCode);
    emit(AppSettingsLoadedState());
  }

  // Save settings (theme and locale)
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
    prefs.setString('locale', _locale.languageCode);
  }

  // Drawer navigation methods
  void navigateToProfile() {
    emit(AppNavigateToProfileState());
  }

  void navigateToFavorites() {
    emit(AppNavigateToFavoritesState());
  }

  void navigateToLanguages() {
    emit(AppNavigateToLanguagesState());
  }

  void navigateToAbout() {
    emit(AppNavigateToAboutState());
  }

  void navigateToThemes() {
    emit(AppNavigateToThemesState());
  }
}
