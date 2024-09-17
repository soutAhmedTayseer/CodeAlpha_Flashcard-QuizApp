import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_projects/managment/cubit.dart';
import 'package:flutter_projects/managment/states.dart';

class LanguagesTranslationScreen extends StatelessWidget {
  const LanguagesTranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final appCubit = AppCubit.get(context);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // AnimatedSwitcher for the language icon
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: Icon(
                      Icons.language,
                      key: ValueKey<String>(appCubit.locale.languageCode),
                      size: 100,
                      color: appCubit.isDark ? Colors.white : Colors.black,
                    ),
                    transitionBuilder: (widget, animation) {
                      const begin = Offset(0.0, 0.1);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(position: offsetAnimation, child: widget);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    tr('Choose your preferred language:'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400), // Max width for better layout control
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: appCubit.locale.languageCode == 'en'
                              ? Colors.green // Highlight selected language
                              : appCubit.isDark ? Colors.grey[850] : Colors.grey[200],
                          title: Align(
                            alignment: Alignment.center,
                            child: Text(
                              tr('English'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          onTap: () {
                            _showRestartDialog(context, 'en');
                          },
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          tileColor: appCubit.locale.languageCode == 'ar'
                              ? Colors.green // Highlight selected language
                              : appCubit.isDark ? Colors.grey[850] : Colors.grey[200],
                          title: Align(
                            alignment: Alignment.center,
                            child: Text(
                              tr('Arabic'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          onTap: () {
                            _showRestartDialog(context, 'ar');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: appCubit.isDark ? Colors.black : Colors.white,
        );
      },
    );
  }

  void _showRestartDialog(BuildContext context, String languageCode) {
    final appCubit = AppCubit.get(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('Language Change')),
          content: Text(tr('To apply the language changes, please restart the app.')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                appCubit.changeLocale(languageCode);
              },
              child: Text(tr('OK')),
            ),
          ],
        );
      },
    );
  }
}
