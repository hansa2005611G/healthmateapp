import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/database/database_helper.dart';
import 'features/health_records/viewmodels/health_record_viewmodel.dart';
/// Main entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize database
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // This will create tables and insert dummy data

  // Run the app
  runApp(
    // Wrap app with Provider for state management
    ChangeNotifierProvider(
      create: (_) => HealthRecordViewModel(),
      child: const App(),
    ),
  );
}