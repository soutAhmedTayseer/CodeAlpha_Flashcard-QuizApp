import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/flashcards_screen.dart';
import 'package:flutter_projects/categories_screen.dart';
import 'package:flutter_projects/History_screen.dart';
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
      body: BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          return IndexedStack(
            index: context.read<AppCubit>().currentIndex,
            children: [
               FlashcardsScreen(),
               CategoriesScreen(), // Your new screen
               const ResultsScreen(),
            ],
          );
        },
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
