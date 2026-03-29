import 'package:fan_control/models/user_model.dart';

abstract class AuthRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}
