import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/providers/auth_provider.dart';
import 'package:fan_control/providers/log_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogsState();
  }

  void _checkLogsState() async {
    final User? user = await context.read<AuthProvider>().getUser();
    if (user != null && mounted) {
      context.read<LogProvider>().setUser(user.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> history = 
        context.watch<LogProvider>().history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature History'),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? const Center(child: Text('No logs found for this account'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> log = history[index];
                return _buildLogItem(log);
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
