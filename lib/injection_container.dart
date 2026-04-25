import 'package:get_it/get_it.dart';
import 'package:fan_control/repositories/log_repository.dart';
import 'package:fan_control/services/auth_service.dart';
import 'package:fan_control/repositories/local_storage_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register repositories as singletons
  getIt.registerSingleton<LogRepository>(LogRepository());

  // Register services
  getIt.registerSingleton<AuthService>(
    AuthService(LocalStorageRepository()),
  );
}
