import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/cubit.dart';
import 'package:flutter_projects/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', ''), // English (United States)
        Locale('es', ''), // Spanish (Spain)
        Locale('ar', ''), // Arabic (Saudi Arabia)
        Locale('fr', ''), // French (France)
      ],
      path: 'assets/lang', // Path to localization files
      fallbackLocale: const Locale('en', ''), // Fallback locale
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,  // Set locale
        supportedLocales: context.supportedLocales,  // Set supported locales
        localizationsDelegates: context.localizationDelegates,  // Load localizations
        home: const SplashScreen(),
      ),
    );
  }
}
