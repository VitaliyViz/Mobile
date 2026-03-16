import 'package:fan_control/screens/dashboard_screen.dart';
import 'package:fan_control/screens/login_screen.dart';
import 'package:fan_control/screens/profile_screen.dart';
import 'package:fan_control/screens/register_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const SmartFanApp());

class SmartFanApp extends StatefulWidget {
  const SmartFanApp({super.key});

  @override
  State<SmartFanApp> createState() => _SmartFanAppState();
}

class _SmartFanAppState extends State<SmartFanApp> {
  bool _isDarkTheme = true;

  void _toggleTheme(bool value) {
    setState(() => _isDarkTheme = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Fan Lab 2',
      theme: ThemeData(
        useMaterial3: true,
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/reg': (context) => const RegisterScreen(),
        '/home': (context) => MainNavigationHolder(
              isDark: _isDarkTheme,
              onThemeChanged: _toggleTheme,
            ),
      },
    );
  }
}

class MainNavigationHolder extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const MainNavigationHolder({
    required this.isDark,
    required this.onThemeChanged,
    super.key,
  });

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardScreen(),
      ProfileScreen(
        isDark: widget.isDark,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
