import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/screens/dashboard_screen.dart';
import 'package:fan_control/screens/logs_screen.dart';
import 'package:fan_control/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) {
        final bool isOffline =
            state is AuthLoaded && state.isOffline;

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
      },
    );
  }
}
