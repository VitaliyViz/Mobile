import 'package:fan_control/widgets/btn.dart';
import 'package:fan_control/widgets/inp.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Join Smart Fan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const AppInp('Full Name'),
            const SizedBox(height: 12),
            const AppInp('Email'),
            const SizedBox(height: 12),
            const AppInp('Password'),
            const SizedBox(height: 24),
            AppBtn(
              'Sign Up',
              () => Navigator.pushReplacementNamed(context, '/home'),
            ),
          ],
        ),
      ),
    );
  }
}
