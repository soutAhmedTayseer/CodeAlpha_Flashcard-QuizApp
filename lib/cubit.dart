import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of<AppCubit>(context);

  // Index for bottom navigation
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Toggle between dark and light mode
  bool isDark = false;

  // Switch index in BottomNavigationBar
  void changeIndex(int index) {
    _currentIndex = index;
    emit(AppIndexChangedState(index));
  }

  // Toggle Theme Mode
  void toggleTheme() {
    isDark = !isDark;
    emit(AppThemeChangedState());
  }

  ThemeData get currentTheme => isDark ? ThemeData.dark() : ThemeData.light();
}
