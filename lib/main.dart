import 'package:fan_control/firebase_options.dart';
import 'package:fan_control/injection_container.dart';
import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/logic/cubits/log_cubit.dart';
import 'package:fan_control/repositories/auth_repository.dart';
import 'package:fan_control/repositories/log_repository.dart';
import 'package:fan_control/screens/login_screen.dart';
import 'package:fan_control/screens/register_screen.dart';
import 'package:fan_control/widgets/main_navigation_holder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseConfig.options,
  );

  setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(getIt<AuthRepository>()),
        ),
        BlocProvider(
          create: (_) => LogCubit(getIt<LogRepository>()),
        ),
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isAuthenticated = state is AuthLoaded && state.isAuthenticated;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Fan Lab 6',
          theme: ThemeData(
            useMaterial3: true,
            brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
          ),
          home: isAuthenticated
              ? MainNavigationHolder(
                  isDark: _isDarkTheme,
                  onThemeChanged: _toggleTheme,
                )
              : const LoginScreen(),
          routes: {
            '/reg': (_) => const RegisterScreen(),
          },
        );
      },
    );
  }
}
