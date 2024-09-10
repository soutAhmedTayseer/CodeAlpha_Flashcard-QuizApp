import 'package:flutter/material.dart';
import 'package:flutter_projects/flashcards_screen.dart';
import 'package:flutter_projects/results_screen.dart'; // Add this import
import 'package:flutter_projects/my_account_screen.dart'; // Add this import

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    FlashcardsScreen(),
    ResultsScreen(), // Updated
    MyAccountScreen(), // Updated
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Flashcards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Results', // Updated
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account', // Updated
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
