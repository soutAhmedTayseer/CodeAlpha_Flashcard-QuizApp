import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_projects/management/cubit.dart';
import 'package:flutter_projects/management/states.dart';
import 'package:flutter_projects/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    BlocProvider(
      create: (context) => AppCubit(),
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', ''), // English (United States)
          Locale('ar', ''), // Arabic (Saudi Arabia)
        ],
        path: 'assets/lang', // Path to localization files
        fallbackLocale: const Locale('en', ''), // Fallback locale
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final appCubit = AppCubit.get(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: appCubit.locale, // Set locale from AppCubit
          supportedLocales: context.supportedLocales, // Use EasyLocalization's supported locales
          localizationsDelegates: context.localizationDelegates, // Load localizations
          theme: appCubit.currentTheme, // Set theme from AppCubit
          home: const SplashScreen(),
        );
      },
    );
  }
}
