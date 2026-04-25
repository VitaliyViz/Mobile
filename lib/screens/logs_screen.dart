import 'package:fan_control/logic/cubits/auth_cubit.dart';
import 'package:fan_control/logic/cubits/log_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
    _setupLogs();
  }

  Future<void> _setupLogs() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthLoaded && authState.user != null) {
      context.read<LogCubit>().setupUser(authState.user!.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature History'),
        centerTitle: true,
      ),
      body: BlocBuilder<LogCubit, LogState>(
        builder: (BuildContext context, LogState state) {
          if (state is LogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LogError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is LogLoaded) {
            if (state.logs.isEmpty) {
              return const Center(
                child: Text('No logs found for this account'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.logs.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> log = state.logs[index];
                return _buildLogItem(log);
              },
            );
          }

          return const Center(child: Text('No logs found for this account'));
        },
      ),
    );
  }

  Widget _buildLogItem(Map<String, dynamic> log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent.withAlpha(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.history, color: Colors.blueAccent),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${log['value']}°C',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Time: ${log['time']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.cloud_done, color: Colors.green, size: 16),
        ],
      ),
    );
  }
}
