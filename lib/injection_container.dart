import 'package:fan_control/repositories/auth_repository.dart';
import 'package:fan_control/repositories/log_repository.dart';
import 'package:fan_control/services/mqtt_service.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<LogRepository>(
    LogRepository.new,
  );

  getIt.registerLazySingleton<AuthRepository>(
    AuthRepositoryImpl.new,
  );
  getIt.registerLazySingleton<MqttService>(
    MqttService.new,
  );
}
