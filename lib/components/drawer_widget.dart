import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerWidget extends StatelessWidget {
  final VoidCallback onThemesTap;
  final VoidCallback onLanguagesTap;
  final VoidCallback onAboutTap;

  const DrawerWidget({
    required this.onThemesTap,
    required this.onLanguagesTap,
    required this.onAboutTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Row(
              children: [
                const Icon(Icons.settings, size: 40, color: Colors.white),
                const SizedBox(width: 16),
                Text(
                  tr('Settings'),
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode, color: Colors.green),
            title: Text(tr('Themes')),
            onTap: onThemesTap,
          ),
          ListTile(
            leading: const Icon(Icons.translate, color: Colors.green),
            title: Text(tr('Languages')),
            onTap: onLanguagesTap,
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.green),
            title: Text(tr('About')),
            onTap: onAboutTap,
          ),
        ],
      ),
    );
  }
}
