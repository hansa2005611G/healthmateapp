import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/utils/user_preferences.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/welcome/welcome_back_screen.dart';
import 'features/main_screen.dart';

/// App Widget
/// Root widget that configures the MaterialApp
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          
          // Dynamic theme switching
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // Determine initial screen based on first-time user
          home: FutureBuilder<bool>(
            future: UserPreferences.isFirstTime(),
            builder: (context, snapshot) {
              // Show loading while checking
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // First time user - show onboarding
              if (snapshot.data == true) {
                return const OnboardingScreen();
              }

              // Returning user - check if they've seen welcome screen this session
              return FutureBuilder<String>(
                future: UserPreferences.getUserName(),
                builder: (context, nameSnapshot) {
                  if (nameSnapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Show welcome back screen for returning users
                  return const WelcomeBackScreen();
                },
              );
            },
          ),
        );
      },
    );
  }
}