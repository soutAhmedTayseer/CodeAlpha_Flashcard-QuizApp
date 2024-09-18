import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_projects/components/language_dialog.dart';
import 'package:flutter_projects/components/language_switcher.dart';
import 'package:flutter_projects/components/language_tile.dart';
import 'package:flutter_projects/management/cubit.dart';
import 'package:flutter_projects/management/states.dart';

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
                  // LanguageSwitcher for the language icon
                  LanguageSwitcher(
                    languageCode: appCubit.locale.languageCode,
                    isDarkMode: appCubit.isDark,
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
                        LanguageTile(
                          languageCode: 'en',
                          languageName: 'English',
                          isSelected: appCubit.locale.languageCode == 'en',
                          onTap: () => _showRestartDialog(context, 'en'),
                          isDarkMode: appCubit.isDark,
                        ),
                        const SizedBox(height: 10),
                        LanguageTile(
                          languageCode: 'ar',
                          languageName: 'Arabic',
                          isSelected: appCubit.locale.languageCode == 'ar',
                          onTap: () => _showRestartDialog(context, 'ar'),
                          isDarkMode: appCubit.isDark,
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
        return RestartDialog(
          onConfirm: () {
            appCubit.changeLocale(languageCode);
          },
        );
      },
    );
  }
}
