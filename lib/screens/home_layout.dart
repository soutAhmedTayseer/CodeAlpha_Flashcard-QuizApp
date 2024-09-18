import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; // Ensure easy_localization is imported
import 'package:flutter_projects/screens/flashcards_screen.dart';
import 'package:flutter_projects/screens/categories_screen.dart';
import 'package:flutter_projects/screens/history_screen.dart';
import 'package:flutter_projects/screens/themes_screen.dart';
import '../components/app_bar_widget.dart';
import '../components/bottom_navbar_widget.dart';
import '../components/drawer_widget.dart';
import 'about_screen.dart';
import '../management/cubit.dart';
import 'languages_translation_screen.dart';
import '../management/states.dart'; // Ensure this import is correct

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppNavigateToThemesState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThemesScreen()),
          );
        } else if (state is AppNavigateToLanguagesState) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LanguagesTranslationScreen()),
          );
        } else if (state is AppNavigateToAboutState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutScreen()),
          );
        }
      },
      builder: (context, state) {
        final appCubit = AppCubit.get(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appCubit.currentTheme,
          home: Scaffold(
            appBar: AppBarWidget(title: tr('Quiz App')),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background home.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                IndexedStack(
                  index: appCubit.currentIndex,
                  children: const [
                    FlashcardsScreen(),
                    CategoriesScreen(),
                    HistoryScreen(),
                  ],
                ),
              ],
            ),
            drawer: DrawerWidget(
              onThemesTap: appCubit.navigateToThemes,
              onLanguagesTap: appCubit.navigateToLanguages,
              onAboutTap: appCubit.navigateToAbout,
            ),
            bottomNavigationBar: BottomNavBarWidget(
              currentIndex: appCubit.currentIndex,
              onTap: (index) => appCubit.changeIndex(index),
            ),
          ),
        );
      },
    );
  }
}
