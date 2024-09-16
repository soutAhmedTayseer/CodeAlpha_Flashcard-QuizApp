import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; // Ensure easy_localization is imported
import 'package:flutter_projects/flashcards_screen.dart';
import 'package:flutter_projects/categories_screen.dart';
import 'package:flutter_projects/history_screen.dart';
import 'package:flutter_projects/profile_screen.dart';
import 'package:flutter_projects/themes_screen.dart';
import 'about_screen.dart';
import 'cubit.dart';
import 'languages_translation_screen.dart';
import 'states.dart'; // Ensure this import is correct

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
        if (state is AppNavigateToProfileState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (state is AppNavigateToThemesState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThemesScreen()),
          );
        } else if (state is AppNavigateToLanguagesState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LanguagesTranslationScreen()),
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
            appBar: AppBar(
              title: Text(
                tr('Quiz App'),  // Use `tr()` for translation
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              centerTitle: true,
            ),
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
                  children: [
                    FlashcardsScreen(),
                    CategoriesScreen(),
                    const HistoryScreen(),
                  ],
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(  // Remove const here
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.settings, size: 40, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          tr('Settings'),  // Apply `tr()` for translation
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.green),
                    title: Text(tr('Profile')),  // Use `tr()` for translation
                    onTap: () {
                      appCubit.navigateToProfile();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.light_mode, color: Colors.green),
                    title: Text(tr('Themes')),  // Use `tr()` for translation
                    onTap: () {
                      appCubit.navigateToThemes();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.translate, color: Colors.green),
                    title: Text(tr('Languages')),  // Use `tr()` for translation
                    onTap: () {
                      appCubit.navigateToLanguages();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.green),
                    title: Text(tr('About')),  // Use `tr()` for translation
                    onTap: () {
                      appCubit.navigateToAbout();
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: appCubit.currentIndex,
              onTap: (index) => appCubit.changeIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.credit_card),
                  label: tr('Flashcards'),  // Use `tr()` for translation
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.workspace_premium_outlined),
                  label: tr('Categories'),  // Use `tr()` for translation
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.history),
                  label: tr('History'),  // Use `tr()` for translation
                ),
              ],
              selectedItemColor: Colors.green,
            ),
          ),
        );
      },
    );
  }
}
