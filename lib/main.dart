import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/home_layout.dart';
import 'package:flutter_projects/cubit.dart';
import 'package:flutter_projects/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Colors.orange, // Main color theme
        //   scaffoldBackgroundColor: Colors.orange.shade50, // Light orange background for all screens
        //   appBarTheme: const AppBarTheme(
        //     backgroundColor: Colors.orange, // AppBar color
        //     titleTextStyle: TextStyle(
        //       color: Colors.white, // AppBar text color
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   textTheme: const TextTheme(
        //     bodyLarge: TextStyle(color: Colors.orange, fontSize: 18), // Default text style
        //     bodyMedium: TextStyle(color: Colors.orange), // Secondary text style
        //   ),
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //       foregroundColor: Colors.white, backgroundColor: Colors.orange, // Button text color
        //     ),
        //   ),
        // ),
        home: SplashScreen(),
      ),
    );
  }
}
