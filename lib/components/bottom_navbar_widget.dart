import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBarWidget({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.credit_card),
          label: tr('Flashcards'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.workspace_premium_outlined),
          label: tr('Categories'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history),
          label: tr('History'),
        ),
      ],
      selectedItemColor: Colors.green,
    );
  }
}
