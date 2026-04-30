import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/auth_repository.dart';
import 'package:fan_control/repositories/local_storage_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<bool> login(String email, String password) async {
    final storage = _authRepository as LocalStorageRepository;
    final user = await storage.findUser(email);

    if (user != null && user.password == password) {
      await _authRepository.saveUser(user);
      return true;
    }
    return false;
  }

  Future<void> register(String name, String email, String password) async {
    final user = User(name: name, email: email, password: password);
    await _authRepository.saveUser(user);
  }

  Future<User?> getCurrentUser() async {
    return _authRepository.getUser();
  }

  Future<void> logout() async {
    await _authRepository.clearUser();
  }
}
