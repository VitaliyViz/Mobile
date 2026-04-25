part of 'log_cubit.dart';

abstract class LogState extends Equatable {
  const LogState();

  @override
  List<Object?> get props => [];
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
  List<Object?> get props => [logs];
}

class LogError extends LogState {
  final String message;

  const LogError(this.message);

  @override
  List<Object?> get props => [message];
}
