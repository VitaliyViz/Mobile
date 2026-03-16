import 'package:fan_control/widgets/btn.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const ProfileScreen({
    required this.isDark,
    required this.onThemeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color headerColor = isDark 
        ? Colors.white.withAlpha(5) 
        : Colors.blueAccent.withAlpha(15);
    final Color avatarBg = isDark ?
    Colors.white : Colors.white;
    final Color avatarBorder = isDark ?
    Colors.transparent : Colors.grey.shade300;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(color: headerColor),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: avatarBorder, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: avatarBg,
                        child: const Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Vitaliy Vizer',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'An akatsuki member',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Switch(
                      value: isDark,
                      onChanged: onThemeChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppBtn(
                    'Logout',
                    () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (r) => false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
