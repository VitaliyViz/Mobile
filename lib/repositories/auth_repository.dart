import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/local_storage_repository.dart';
import 'package:fan_control/services/auth_service.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<void> signUp(String name, String email, String password);
  Future<User?> getUser();
  Future<void> saveUser(User user);
  Future<void> clearUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService = AuthService(LocalStorageRepository());

  @override
  Future<User?> signIn(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      return _authService.getCurrentUser();
    }
    return null;
  }

  @override
  Future<void> signUp(String name, String email, String password) async {
    await _authService.register(name, email, password);
  }

  @override
  Future<User?> getUser() async {
    return _authService.getCurrentUser();
  }

  @override
  Future<void> saveUser(User user) async {
    final storage = LocalStorageRepository();
    await storage.saveUser(user);
  }

  @override
  Future<void> clearUser() async {
    await _authService.logout();
  }
}
