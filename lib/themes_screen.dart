import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'cubit.dart';
import 'states.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        final appCubit = AppCubit.get(context);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // AnimatedSwitcher for the Icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  child: Icon(
                    appCubit.isDark ? Icons.dark_mode : Icons.light_mode,
                    key: ValueKey<bool>(appCubit.isDark),
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
                // AnimatedSwitcher for the Text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    appCubit.isDark ? tr('Dark Theme') : tr('Light Theme'),
                    key: ValueKey<bool>(appCubit.isDark),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: appCubit.isDark ? Colors.white : Colors.black,
                    ),
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
                const SizedBox(height: 40),
                // ListTile with a Switch
                ListTile(
                  title: Text(tr('Toggle Theme')),
                  contentPadding: EdgeInsets.zero,
                  trailing: Switch(
                    value: appCubit.isDark,
                    onChanged: (value) {
                      appCubit.toggleTheme();
                    },
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.grey,
                    inactiveThumbColor: Colors.grey[700],
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
