class TempLog {
  final String value;
  final String time;
  final int timestamp;

  const TempLog({
    required this.value,
    required this.time,
    required this.timestamp,
  });

  factory TempLog.fromJson(Map<String, dynamic> json) {
    return TempLog(
      value: json['value'] as String,
      time: json['time'] as String,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'time': time,
        'timestamp': timestamp,
      };
}
