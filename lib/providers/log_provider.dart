import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogProvider extends ChangeNotifier {
  DatabaseReference? _dbRef;
  List<Map<String, dynamic>> _history = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get history => _history;

  void setUser(String email) {
    final String userPath = email.replaceAll('.', '_');
    _dbRef = FirebaseDatabase.instance.ref('logs/$userPath');
    _listenToLogs();
  }

  void _listenToLogs() {
    _dbRef?.onValue.listen((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;
      if (data != null) {
        final Map<dynamic, dynamic> values = data as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> newList = [];

        values.forEach((key, value) {
          newList.add({
            'value': value['value'].toString(),
            'time': value['time'].toString(),
            'timestamp': value['timestamp'] ?? 0,
          });
        });

        newList.sort((a, b) =>
            (b['timestamp'] as int).compareTo(a['timestamp'] as int));
        _history = newList;
        notifyListeners();
      }
    });
  }

  void addLog(String value) {
    if (_dbRef == null) return;
    if (_history.isEmpty || _history.first['value'] != value) {
      final String time = DateFormat('HH:mm:ss').format(DateTime.now());
      _dbRef!.push().set({
        'value': value,
        'time': time,
        'timestamp': ServerValue.timestamp,
      });
    }
  }

  Future<void> clearLogs() async {
    await _dbRef?.remove();
    _history.clear();
    notifyListeners();
  }
}
