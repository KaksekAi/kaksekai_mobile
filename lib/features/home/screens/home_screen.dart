import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'land_measurement_screen.dart';
import 'weather_analysis_screen.dart';
import 'ai_assistant_screen.dart';
import '../../../core/constants/app_strings.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const LandMeasurementScreen(),
    const WeatherAnalysisScreen(),
    const AIAssistantScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2E7D32),
        title: Text(
          AppStrings.appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: Colors.green.shade50,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard, color: Colors.grey.shade600),
            selectedIcon: Icon(Icons.dashboard, color: const Color(0xFF2E7D32)),
            label: AppStrings.dashboard,
          ),
          NavigationDestination(
            icon: Icon(Icons.landscape, color: Colors.grey.shade600),
            selectedIcon: Icon(Icons.landscape, color: const Color(0xFF2E7D32)),
            label: AppStrings.land,
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud, color: Colors.grey.shade600),
            selectedIcon: Icon(Icons.cloud, color: const Color(0xFF2E7D32)),
            label: AppStrings.weather,
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy, color: Colors.grey.shade600),
            selectedIcon: Icon(Icons.smart_toy, color: const Color(0xFF2E7D32)),
            label: AppStrings.assistant,
          ),
        ],
      ),
    );
  }
}
