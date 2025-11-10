import 'package:flutter/material.dart';
import 'dashboard/views/dashboard_screen.dart';
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

  // Only 2 screens now: Dashboard and Records
  final List<Widget> _screens = const [
    DashboardScreen(),
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
            label: 'Dashboard',
            tooltip: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Records',
            tooltip: 'Records',
          ),
        ],
      ),
    );
  }
}