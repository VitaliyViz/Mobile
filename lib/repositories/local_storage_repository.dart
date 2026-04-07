import 'dart:convert';
import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository extends AuthRepository {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user_email';

  @override
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usersRaw = prefs.getString(_usersKey);

    Map<String, dynamic> users = <String, dynamic>{};
    if (usersRaw != null) {
      users = jsonDecode(usersRaw) as Map<String, dynamic>;
    }

    users[user.email] = user.toJson();

    await prefs.setString(_usersKey, jsonEncode(users));
    await prefs.setString(_currentUserKey, user.email);
  }

  Future<User?> findUser(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usersRaw = prefs.getString(_usersKey);

    if (usersRaw == null) return null;

    final Map<String, dynamic> users =
        jsonDecode(usersRaw) as Map<String, dynamic>;
    if (users.containsKey(email)) {
      return User.fromJson(users[email] as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? currentEmail = prefs.getString(_currentUserKey);
    if (currentEmail == null) return null;
    return findUser(currentEmail);
  }

  @override
  Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
