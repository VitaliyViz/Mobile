import 'package:fan_control/logic/cubits/log_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature History'),
        centerTitle: true,
      ),
      body: BlocBuilder<LogCubit, LogState>(
        builder: (context, state) {
          if (state is LogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LogError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is LogLoaded) {
            if (state.logs.isEmpty) {
              return const Center(child: Text('No logs found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.logs.length,
              itemBuilder: (context, index) => _LogItem(log: state.logs[index]),
            );
          }
          return const Center(child: Text('Initialize logs...'));
        },
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final Map<String, dynamic> log;
  const _LogItem({required this.log});

  @override
  Widget build(BuildContext context) {
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
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Colors.blueAccent),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
