import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard_screen.dart';
import '../../../core/constants/app_strings.dart';
import 'profile_screen.dart';
import 'land_measurement_instruction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Set system overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _selectedIndex = 0);
      // Reset system overlay style when app is resumed
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  Future<void> _onItemTapped(int index) async {
    if (index == _selectedIndex || _isNavigating) return;

    setState(() => _isNavigating = true);

    try {
      switch (index) {
        case 0:
          setState(() => _selectedIndex = 0);
          break;
        case 1:
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LandMeasurementInstructionScreen(
                fromBottomNav: true,
              ),
            ),
          );
          break;
        case 2:
          await Navigator.pushNamed(
            context,
            '/weather-analysis',
            arguments: {'fromBottomNav': true},
          );
          break;
        case 3:
          await Navigator.pushNamed(
            context,
            '/ai-assistant',
            arguments: {'fromBottomNav': true},
          );
          break;
      }
    } finally {
      if (mounted) {
        setState(() {
          _selectedIndex = 0;
          _isNavigating = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return false;
    }
    final shouldPop = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('ចាកចេញ?'),
        content: const Text('តើអ្នកពិតជាចង់ចាកចេញពីកម្មវិធីមែនទេ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'ទេ',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              elevation: 0,
            ),
            child: const Text('បាទ/ចាស'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF2E7D32),
          centerTitle: true,
          title: Text(
            AppStrings.appName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 28,
                ),
                tooltip: 'គណនី',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  ).then((_) {
                    if (mounted) {
                      setState(() => _selectedIndex = 0);
                    }
                  });
                },
              ),
            ),
          ],
        ),
        body: const DashboardScreen(),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.1),
          indicatorColor: Colors.green.shade50,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 300),
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: Colors.grey.shade600),
              selectedIcon:
                  const Icon(Icons.dashboard, color: Color(0xFF2E7D32)),
              label: AppStrings.dashboard,
              tooltip: AppStrings.dashboard,
            ),
            NavigationDestination(
              icon: Icon(Icons.landscape_outlined, color: Colors.grey.shade600),
              selectedIcon:
                  const Icon(Icons.landscape, color: Color(0xFF2E7D32)),
              label: AppStrings.land,
              tooltip: AppStrings.land,
            ),
            NavigationDestination(
              icon: Icon(Icons.cloud_outlined, color: Colors.grey.shade600),
              selectedIcon: const Icon(Icons.cloud, color: Color(0xFF2E7D32)),
              label: AppStrings.weather,
              tooltip: AppStrings.weather,
            ),
            NavigationDestination(
              icon: Icon(Icons.smart_toy_outlined, color: Colors.grey.shade600),
              selectedIcon:
                  const Icon(Icons.smart_toy, color: Color(0xFF2E7D32)),
              label: AppStrings.assistant,
              tooltip: AppStrings.assistant,
            ),
          ],
        ),
      ),
    );
  }
}
