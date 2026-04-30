import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/widgets/btn.dart';
import 'package:fan_control/widgets/fan.dart';
import 'package:fan_control/widgets/inp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _handleLogin() {
    final authCubit = context.read<AuthCubit>();
    final authState = authCubit.state;

    if (authState is AuthLoaded && authState.isOffline) {
      setState(() => _loginError = 'No internet connection');
      return;
    }

    authCubit.login(
      _emailController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          setState(() => _loginError = state.message);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FanImg(80),
              const SizedBox(height: 40),
              if (_loginError != null)
                Text(
                  _loginError!,
                  style: const TextStyle(color: Colors.red),
                ),
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
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
