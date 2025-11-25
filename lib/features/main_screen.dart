import 'package:flutter/material.dart';
import 'dashboard/views/dashboard_screen.dart';
import 'health_records/views/records_list_screen.dart';
import 'settings/settings_screen.dart';

/// Main Screen
/// Container with bottom navigation bar (3 tabs: Dashboard, Records, Settings)
class MainScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 3 screens: Dashboard, Records, Settings
  final List<Widget> _screens = const [
    DashboardScreen(),
    RecordsListScreen(),
    SettingsScreen(),
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
            label: 'Dashboard',
            tooltip: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Records',
            tooltip: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}