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
    return Scaffold(
      appBar: AppBar(
      ),
      body: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          return IndexedStack(
            index: context.read<AppCubit>().currentIndex,
            children: [
              FlashcardsScreen(),
              CategoriesScreen(),
               const HistoryScreen(),
            ],
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Row(
                children: [
                  Icon(Icons.settings, size: 40, color: Colors.white),
                  SizedBox(width: 16),
                  Text('Settings', style: TextStyle(fontSize: 24, color: Colors.white)),
                ],
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.account_circle),
            //   title: const Text('Profile'),
            //   onTap: () {
            //     // Handle profile navigation
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.notifications),
            //   title: const Text('Notifications'),
            //   onTap: () {
            //     // Handle notifications navigation
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.help),
            //   title: const Text('Help'),
            //   onTap: () {
            //     // Handle help navigation
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.info),
            //   title: const Text('About'),
            //   onTap: () {
            //     // Handle about navigation
            //   },
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<AppCubit>().currentIndex,
        onTap: (index) => context.read<AppCubit>().changeIndex(index),
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
      ),
    );
  }
}
