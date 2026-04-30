// lib/screens/dashboard_screen.dart
import 'package:fan_control/injection_container.dart';
import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/logic/cubits/log_cubit.dart';
import 'package:fan_control/services/mqtt_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqttService = getIt<MqttService>();
    final authState = context.read<AuthCubit>().state;

    if (authState is AuthLoaded && authState.user != null) {
      context.read<LogCubit>().setupUser(authState.user!.email);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: BlocBuilder<LogCubit, LogState>(
        builder: (context, logState) {
          // ЧЕКАЄМО ЗАВАНТАЖЕННЯ З БАЗИ
          if (logState is! LogLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your data...'),
                ],
              ),
            );
          }

          final String lastDbValue = logState.logs.isNotEmpty
              ? logState.logs.first['value'].toString()
              : '--';

          return StreamBuilder<String>(
            stream: mqttService.temperatureStream,
            initialData: lastDbValue,
            builder: (context, snapshot) {
              final currentTemp = snapshot.data ?? lastDbValue;

              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                context.read<LogCubit>().addLog(snapshot.data!);
              }

              if (currentTemp == '--') {
                return const Center(
                  child: Text('No data yet. Send something via MQTT!'),
                );
              }

              return Center(
                child: _TemperatureCard(temp: currentTemp),
              );
            },
          );
        },
      ),
    );
  }
}

class _TemperatureCard extends StatelessWidget {
  final String temp;
  const _TemperatureCard({required this.temp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withAlpha(20),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blueAccent.withAlpha(60)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.thermostat, size: 80, color: Colors.orange),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                temp,
                style:
                    const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
              const Text('°C',
                  style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold),),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Current Status',
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
