import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class LogRepository {
  LogRepository();

  DatabaseReference? _dbRef;

  void setupUser(String email) {
    final userPath = email.replaceAll('.', '_');
    _dbRef = FirebaseDatabase.instance.ref('logs/$userPath');
  }

  Stream<List<Map<String, dynamic>>> getLogs() {
    final ref = _dbRef;
    if (ref == null) return Stream.value([]);

    return ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final values = data as Map<dynamic, dynamic>;
      final logs = <Map<String, dynamic>>[];

      values.forEach((key, value) {
        final logData = value as Map<dynamic, dynamic>;
        logs.add({
          'value': logData['value'].toString(),
          'time': logData['time'].toString(),
          'timestamp': logData['timestamp'] ?? 0,
        });
      });

      logs.sort(
        (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int),
      );
      return logs;
    });
  }

  Future<void> addLog(
    String value,
    List<Map<String, dynamic>> currentLogs,
  ) async {
    final ref = _dbRef;
    if (ref == null) return;

    if (currentLogs.isEmpty || currentLogs.first['value'] != value) {
      final time = DateFormat('HH:mm:ss').format(DateTime.now());
      await ref.push().set({
        'value': value,
        'time': time,
        'timestamp': ServerValue.timestamp,
      });
    }
  }

  Future<void> clearLogs() async {
    await _dbRef?.remove();
  }
}
