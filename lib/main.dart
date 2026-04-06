import 'package:fan_control/firebase_options.dart';
import 'package:fan_control/providers/auth_provider.dart';
import 'package:fan_control/providers/log_provider.dart';
import 'package:fan_control/screens/dashboard_screen.dart';
import 'package:fan_control/screens/login_screen.dart';
import 'package:fan_control/screens/logs_screen.dart';
import 'package:fan_control/screens/profile_screen.dart';
import 'package:fan_control/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseConfig.options,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
      ],
      child: const SmartFanApp(),
    ),
  );
}

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
    final AuthProvider auth = context.watch<AuthProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Fan Lab 5',
      theme: ThemeData(
        useMaterial3: true,
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      home: auth.isAuthenticated
          ? MainNavigationHolder(
              isDark: _isDarkTheme,
              onThemeChanged: _toggleTheme,
            )
          : const LoginScreen(),
      routes: <String, WidgetBuilder>{
        '/reg': (BuildContext context) => const RegisterScreen(),
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
    final bool isOffline = context.watch<AuthProvider>().isOffline;

    final List<Widget> pages = <Widget>[
      const DashboardScreen(),
      const LogsScreen(),
      ProfileScreen(
        isDark: widget.isDark,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            if (isOffline)
              Container(
                width: double.infinity,
                color: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(child: pages[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Logs',
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
