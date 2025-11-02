// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:healthmateapp/features/main_screen.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';


/// App Widget
/// Root widget that configures the MaterialApp
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App configuration
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,

      // Home screen
      home: const MainScreen(),

      // Builder for global features (optional)
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}