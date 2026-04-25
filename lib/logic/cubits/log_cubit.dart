import 'package:equatable/equatable.dart';
import 'package:fan_control/repositories/log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_state.dart';

class LogCubit extends Cubit<LogState> {
  final LogRepository _logRepository;
  String? _lastAddedValue;

  LogCubit(this._logRepository) : super(const LogInitial());

  Future<void> setupUser(String email) async {
    _lastAddedValue = null;
    try {
      emit(const LogLoading());
      _logRepository.setupUser(email);

      _logRepository.getLogs().listen(
        (List<Map<String, dynamic>> logs) {
          if (!isClosed) {
            if (logs.isNotEmpty) {
              _lastAddedValue = logs.first['value'].toString();
            }
            emit(LogLoaded(logs));
          }
        },
        onError: (Object error) {
          if (!isClosed) emit(LogError(error.toString()));
        },
      );
    } on Exception catch (e) {
      if (!isClosed) emit(LogError(e.toString()));
    }
  }

  Future<void> addLog(String value) async {
    if (_lastAddedValue == value) return;

    try {
      final currentState = state;
      if (currentState is LogLoaded) {
        _lastAddedValue = value;
        await _logRepository.addLog(value, currentState.logs);
      }
    } on Exception catch (e) {
      if (!isClosed) emit(LogError(e.toString()));
    }
  }

  Future<void> clearLogs() async {
    try {
      await _logRepository.clearLogs();
      _lastAddedValue = null;
      if (!isClosed) emit(const LogLoaded([]));
    } on Exception catch (e) {
      if (!isClosed) emit(LogError(e.toString()));
    }
  }
}
