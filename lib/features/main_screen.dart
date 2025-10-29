import 'package:flutter/material.dart';
import 'package:healthmateapp/features/health_records/views/edit_record_screen.dart';
import 'package:healthmateapp/core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import 'dashboard/views/dashboard_screen.dart';
import 'health_records/views/add_record_screen.dart';
import 'health_records/views/records_list_screen.dart';

/// Main Screen
/// Container with bottom navigation bar for switching between main features
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = const [
    DashboardScreen(),
    AddRecordScreen(),
    RecordsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: AppStrings.navDashboard,
            tooltip: AppStrings.navDashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: AppStrings.navAddEntry,
            tooltip: AppStrings.navAddEntry,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: AppStrings.navRecords,
            tooltip: AppStrings.navRecords,
          ),
        ],
      ),
    );
  }
}