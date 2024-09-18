import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  final String languageCode;
  final bool isDarkMode;

  const LanguageSwitcher({
    required this.languageCode,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: Icon(
        Icons.language,
        key: ValueKey<String>(languageCode),
        size: 100,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      transitionBuilder: (widget, animation) {
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: widget);
      },
    );
  }
}
