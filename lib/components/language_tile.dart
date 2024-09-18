import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageTile extends StatelessWidget {
  final String languageCode;
  final String languageName;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const LanguageTile({
    required this.languageCode,
    required this.languageName,
    required this.isSelected,
    required this.onTap,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      tileColor: isSelected
          ? Colors.green // Highlight selected language
          : isDarkMode ? Colors.grey[850] : Colors.grey[200],
      title: Align(
        alignment: Alignment.center,
        child: Text(
          tr(languageName),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      onTap: onTap,
    );
  }
}
