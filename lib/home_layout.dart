import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/flashcards_screen.dart';
import 'package:flutter_projects/categories_screen.dart';
import 'package:flutter_projects/history_screen.dart';
import 'package:flutter_projects/states.dart';
import 'cubit.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final appCubit = AppCubit.get(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appCubit.currentTheme,
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Quiz App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(appCubit.isDark ? Icons.brightness_3 : Icons.wb_sunny),
                  onPressed: () {
                    appCubit.toggleTheme();
                  },
                ),
              ],
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
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.settings, size: 40, color: Colors.white),
                        SizedBox(width: 16),
                        Text('Settings', style: TextStyle(fontSize: 24, color: Colors.white)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.green),
                    title: const Text('Home'),
                    onTap: () {
                      // Handle navigation to Home screen
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.green),
                    title: const Text('Favorites'),
                    onTap: () {
                      // Handle navigation to Favorites screen
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.green),
                    title: const Text('Settings'),
                    onTap: () {
                      // Handle navigation to Settings screen
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.green),
                    title: const Text('About'),
                    onTap: () {
                      // Handle navigation to About screen
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
            ),

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: appCubit.currentIndex,
              onTap: (index) => appCubit.changeIndex(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.credit_card),
                  label: 'Flashcards',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium_outlined),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                ),
              ],
              selectedItemColor: Colors.green, // Highlight selected index
            ),
          ),
        );
      },
    );
  }
}
