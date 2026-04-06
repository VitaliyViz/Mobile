import 'package:fan_control/main.dart';
import 'package:fan_control/widgets/btn.dart';
import 'package:fan_control/widgets/inp.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  // Додаємо змінну стану для видимості пароля
  bool _obscurePassword = true;

  Future<void> _handleRegister() async {
    setState(() {
      _nameError = authService.validateName(_nameController.text);
      _emailError = authService.validateEmail(_emailController.text);
      _passwordError = authService.validatePassword(_passwordController.text);
    });

    if (_nameError == null && _emailError == null && _passwordError == null) {
      await authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Join Smart Fan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AppInp(
              'Full Name',
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: 12),
            AppInp(
              'Email',
              controller: _emailController,
              errorText: _emailError,
            ),
            const SizedBox(height: 12),
            AppInp(
              'Password',
              controller: _passwordController,
              errorText: _passwordError,
              isPassword: true,
              // Використовуємо змінну стану замість жорсткого true
              obscureText: _obscurePassword,
              // Передаємо функцію, яка перемикає стан
              onToggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            const SizedBox(height: 24),
            AppBtn('Sign Up', _handleRegister),
          ],
        ),
      ),
    );
  }
}
