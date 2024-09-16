import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_projects/cubit.dart';
import 'package:flutter_projects/states.dart';

class LanguagesTranslationScreen extends StatelessWidget {
  const LanguagesTranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final appCubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(tr('Select Language')),  // Use `tr()` for translation
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // AnimatedSwitcher for language options
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    key: ValueKey<String>(appCubit.locale.languageCode),
                    children: [
                      ListTile(
                        title: Text(tr('English')),  // Use `tr()` for translation
                        onTap: () {
                          appCubit.changeLocale('en');
                        },
                        trailing: appCubit.locale.languageCode == 'en'
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      ),
                      ListTile(
                        title: Text(tr('Arabic')),  // Use `tr()` for translation
                        onTap: () {
                          appCubit.changeLocale('ar');
                        },
                        trailing: appCubit.locale.languageCode == 'ar'
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: appCubit.isDark ? Colors.black : Colors.white,
        );
      },
    );
  }
}
