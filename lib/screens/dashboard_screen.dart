import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/logic/cubits/log_cubit.dart';
import 'package:fan_control/services/mqtt_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MqttService _mqttService = MqttService();

  @override
  void initState() {
    super.initState();
    _setupUserLogs();
  }

  Future<void> _setupUserLogs() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthLoaded && authState.user != null) {
      context.read<LogCubit>().setupUser(authState.user!.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: StreamBuilder<String>(
        stream: _mqttService.temperatureStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            final String temp = snapshot.data!;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<LogCubit>().addLog(temp);
            });

            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withAlpha(20),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.blueAccent.withAlpha(60),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.thermostat,
                      size: 80,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          temp,
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '°C',
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Current Temperature',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
