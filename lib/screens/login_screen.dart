import 'package:fan_control/providers/auth_provider.dart';
import 'package:fan_control/widgets/btn.dart';
import 'package:fan_control/widgets/fan.dart';
import 'package:fan_control/widgets/inp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _loginError;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final auth = context.read<AuthProvider>();

    // Перевірка інтернету (Вимога Лаби 4)
    if (auth.isOffline) {
      setState(() => _loginError = 'No internet connection');
      return;
    }

    final success = await auth.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!success) {
      setState(() => _loginError = 'Invalid email or password');
    }
    // Navigator.push/pop НЕ ПОТРІБЕН. main.dart сам оновить home.
  }

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
            if (_loginError != null)
              Text(_loginError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            AppInp('Email', controller: _emailController),
            const SizedBox(height: 16),
            AppInp(
              'Password',
              controller: _passwordController,
              isPassword: true,
              obscureText: _obscurePassword,
              onToggleVisibility: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
            const SizedBox(height: 24),
            AppBtn('Login', _handleLogin),
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
