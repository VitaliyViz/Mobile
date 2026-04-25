part of 'log_cubit.dart';

abstract class LogState {
  const LogState();
}

class LogInitial extends LogState {
  const LogInitial();
}

class LogLoading extends LogState {
  const LogLoading();
}

class LogLoaded extends LogState {
  final List<Map<String, dynamic>> logs;

  const LogLoaded(this.logs);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogLoaded &&
          runtimeType == other.runtimeType &&
          logs == other.logs;

  @override
  int get hashCode => logs.hashCode;
}

class LogError extends LogState {
  final String message;

  const LogError(this.message);
}
