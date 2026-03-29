import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;

  const AuthService(this._repository);

  // Валідація імені (не повинно містити цифр)
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    }
    final nameRegExp = RegExp(r'^[a-zA-Zа-яА-ЯіїєІЇЄ\s]+$');
    if (!nameRegExp.hasMatch(name)) {
      return 'Name should not contain digits or special symbols';
    }
    return null;
  }

  // Валідація пошти (має містити @)
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!email.contains('@')) {
      return 'Enter a valid email with @';
    }
    return null;
  }

  // Валідація пароля (мінімум 6 символів)
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // Реєстрація
  Future<void> register(String name, String email, String password) async {
    final user = User(
      name: name,
      email: email,
      password: password,
    );
    await _repository.saveUser(user);
  }

  // Логін (повертає true, якщо дані збігаються)
  Future<bool> login(String email, String password) async {
    final user = await _repository.getUser();
    if (user != null && user.email == email && user.password == password) {
      return true;
    }
    return false;
  }

  // Отримання поточного користувача для профілю
  Future<User?> getCurrentUser() async {
    return _repository.getUser();
  }
}
