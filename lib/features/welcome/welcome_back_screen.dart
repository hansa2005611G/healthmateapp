import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/user_preferences.dart';
import '../main_screen.dart';

class WelcomeBackScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const WelcomeBackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding * 2),
          child: FutureBuilder<String>(
            future: UserPreferences.getUserName(),
            builder: (context, snapshot) {
              final userName = snapshot.data ?? 'User';
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon
                  Icon(
                    Icons.health_and_safety,
                    size: 120,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppDimensions.spacingXXL),

                  // Welcome Message
                  Text(
                    'Welcome,',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXXL),

                  // Description
                  Text(
                    'Start your health journey today!\nTrack your steps, calories, and water intake.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXXL),

                  // Continue Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continue to Dashboard'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
                   