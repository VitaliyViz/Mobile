import 'package:fan_control/widgets/btn.dart';
import 'package:fan_control/widgets/fan.dart';
import 'package:fan_control/widgets/inp.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FanImg(80),
            const SizedBox(height: 40),
            const AppInp('Email'),
            const SizedBox(height: 16),
            const AppInp('Password'),
            const SizedBox(height: 24),
            AppBtn(
              'Login',
              () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/reg'),
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
