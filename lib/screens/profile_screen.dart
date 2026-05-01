import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/widgets/btn.dart';
import 'package:flash_light_plugin/flash_light_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _isPasswordVisible = false;

  void _showPlatformWarning(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Увага'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pop(dialogContext);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerColor = widget.isDark
        ? Colors.white.withAlpha(5)
        : Colors.blueAccent.withAlpha(15);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthLoaded ? state.user : null;

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: headerColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      GestureDetector(
                        onLongPress: () async {
                          final messengerContext = context;
                          try {
                            await FlashLightPlugin.toggleFlash();
                          } on PlatformException catch (e) {
                            if (!messengerContext.mounted) return;

                            _showPlatformWarning(
                              messengerContext,
                              e.message ?? 'Error',
                            );
                          }
                        },
                        child: const CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user?.name ?? 'Loading...',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(color: Colors.grey),
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Password'),
                        subtitle: Text(
                          _isPasswordVisible
                              ? (user?.password ?? '****')
                              : '********',
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          }),
                        ),
                      ),
                      const Spacer(),
                      AppBtn('Logout', () => _confirmLogout(context)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
