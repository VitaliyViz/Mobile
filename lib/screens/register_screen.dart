import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/widgets/btn.dart';
import 'package:fan_control/widgets/inp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _obscurePassword = true;

  void _handleRegister() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Enter name' : null;
      _emailError =
          !_emailController.text.contains('@') ? 'Invalid email' : null;
      _passwordError =
          _passwordController.text.length < 6 ? 'Too short' : null;
    });

    if (_nameError == null && _emailError == null && _passwordError == null) {
      context.read<AuthCubit>().register(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoaded && state.isAuthenticated) {
          Navigator.of(context).pop();
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Registration')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Join Smart Fan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                obscureText: _obscurePassword,
                onToggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 24),
              AppBtn('Sign Up', _handleRegister),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
