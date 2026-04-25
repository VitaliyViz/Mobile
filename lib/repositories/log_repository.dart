import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class LogRepository {
  static final LogRepository _instance = LogRepository._internal();

  factory LogRepository() {
    return _instance;
  }

  LogRepository._internal();

  DatabaseReference? _dbRef;

  void setupUser(String email) {
    final String userPath = email.replaceAll('.', '_');
    _dbRef = FirebaseDatabase.instance.ref('logs/$userPath');
  }

  Stream<List<Map<String, dynamic>>> getLogs() {
    if (_dbRef == null) return Stream.value([]);

    return _dbRef!.onValue.map((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;
      if (data == null) return [];

      final Map<dynamic, dynamic> values = data as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> logs = [];

      values.forEach((key, value) {
        logs.add({
          'value': value['value'].toString(),
          'time': value['time'].toString(),
          'timestamp': value['timestamp'] ?? 0,
        });
      });

      logs.sort((a, b) =>
          (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      return logs;
    });
  }

  Future<void> addLog(String value, List<Map<String, dynamic>> currentLogs) 
  async {
    if (_dbRef == null) return;
    if (currentLogs.isEmpty || currentLogs.first['value'] != value) {
      final String time = DateFormat('HH:mm:ss').format(DateTime.now());
      await _dbRef!.push().set({
        'value': value,
        'time': time,
        'timestamp': ServerValue.timestamp,
      });
    }
  }

  Future<void> clearLogs() async {
    if (_dbRef == null) return;
    await _dbRef!.remove();
  }
}
