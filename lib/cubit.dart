import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projects/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState()) {
    _loadTheme();
  }

  static AppCubit get(BuildContext context) => BlocProvider.of<AppCubit>(context);

  // Index for bottom navigation
  int _currentIndex = 1; // Start on Categories page
  int get currentIndex => _currentIndex;

  // Toggle between dark and light mode
  bool isDark = false;

  // Switch index in BottomNavigationBar
  void changeIndex(int index) {
    _currentIndex = index;
    emit(AppIndexChangedState(index));
  }

  // Toggle Theme Mode
  void toggleTheme() async {
    isDark = !isDark;
    await _saveTheme();
    emit(AppThemeChangedState());
  }

  ThemeData get currentTheme => isDark ? ThemeData.dark() : ThemeData.light();

  // Load theme preference
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    emit(AppThemeChangedState()); // Emit state to apply theme
  }

  // Save theme preference
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }
}
