import 'dart:convert';
import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository implements AuthRepository {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user_email';

  @override
  Future<User?> signIn(String email, String password) async {
    final user = await findUser(email);
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, email);
      return user;
    }
    return null;
  }

  @override
  Future<void> signUp(String name, String email, String password) async {
    final newUser = User(
      name: name,
      email: email,
      password: password,
    );
    await saveUser(newUser);
  }

  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersRaw = prefs.getString(_usersKey);

    var users = <String, dynamic>{};
    if (usersRaw != null) {
      users = jsonDecode(usersRaw) as Map<String, dynamic>;
    }

    users[user.email] = user.toJson();

    await prefs.setString(_usersKey, jsonEncode(users));
    await prefs.setString(_currentUserKey, user.email);
  }

  Future<User?> findUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersRaw = prefs.getString(_usersKey);

    if (usersRaw == null) return null;

    final users = jsonDecode(usersRaw) as Map<String, dynamic>;
    if (users.containsKey(email)) {
      return User.fromJson(users[email] as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString(_currentUserKey);
    if (currentEmail == null) return null;
    return findUser(currentEmail);
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
