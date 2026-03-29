import 'package:fan_control/main.dart';
import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/widgets/btn.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const ProfileScreen({
    required this.isDark,
    required this.onThemeChanged,
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await authService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _handleLogout() async {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color headerColor = widget.isDark
        ? Colors.white.withAlpha(5)
        : Colors.blueAccent.withAlpha(15);
    const Color avatarBg = Colors.white;
    final Color avatarBorder =
        widget.isDark ? Colors.transparent : Colors.grey.shade300;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: DecoratedBox(
              decoration: BoxDecoration(color: headerColor),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: avatarBorder, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 65,
                        backgroundColor: avatarBg,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _currentUser?.name ?? 'Loading...',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentUser?.email ?? 'no-email@test.com',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Switch(
                      value: widget.isDark,
                      onChanged: widget.onThemeChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: const Text('Password'),
                    subtitle: Text(
                      _isPasswordVisible
                          ? (_currentUser?.password ?? '****')
                          : '********',
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  AppBtn('Logout', _handleLogout),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
