import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/auth_repository.dart';
import 'package:fan_control/repositories/local_storage_repository.dart';

class AuthService {
  final AuthRepository _repository;

  const AuthService(this._repository);

  String? validateName(String? name) {
    if (name == null || name.isEmpty) return 'Name cannot be empty';
    final RegExp nameRegExp = RegExp(r'^[a-zA-Zа-яА-ЯіїєІЇЄ\s]+$');
    return nameRegExp.hasMatch(name) ? null : 'Invalid symbols';
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email cannot be empty';
    return email.contains('@') ? null : 'Enter a valid email';
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password cannot be empty';
    return password.length >= 6 ? null : 'Min 6 characters';
  }

  Future<void> register(String name, String email, String password) async {
    final User newUser = User(name: name, email: email, password: password);
    await _repository.saveUser(newUser);
  }

  Future<bool> login(String email, String password) async {
    final LocalStorageRepository repo = _repository as LocalStorageRepository;
    final User? user = await repo.findUser(email);

    if (user != null && user.password == password) {
      await _repository.saveUser(user);
      return true;
    }
    return false;
  }

  Future<User?> getCurrentUser() async => _repository.getUser();

  Future<void> logout() async => _repository.clearUser();
}
