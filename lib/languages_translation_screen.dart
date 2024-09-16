import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            title: const Text('Select Language'),
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
                        title: const Text('English'),
                        onTap: () {
                          appCubit.changeLocale('en');
                        },
                        trailing: appCubit.locale.languageCode == 'en'
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      ),
                      ListTile(
                        title: const Text('Arabic'),
                        onTap: () {
                          appCubit.changeLocale('ar');
                        },
                        trailing: appCubit.locale.languageCode == 'ar'
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      ),
                      ListTile(
                        title: const Text('Spanish'),
                        onTap: () {
                          appCubit.changeLocale('es');
                        },
                        trailing: appCubit.locale.languageCode == 'es'
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                      ),
                      ListTile(
                        title: const Text('French'),
                        onTap: () {
                          appCubit.changeLocale('fr');
                        },
                        trailing: appCubit.locale.languageCode == 'fr'
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
