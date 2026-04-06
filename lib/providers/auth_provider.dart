import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/local_storage_repository.dart';
import 'package:fan_control/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService(LocalStorageRepository());
  User? _user;
  bool _isAuthenticated = false;
  bool _isOffline = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isOffline => _isOffline;
  User? get user => _user;
  AuthService get service => _authService;

  AuthProvider() {
    _initConnectivity();
    _checkConnectivity();
    checkAuth();
  }

  Future<void> _initConnectivity() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    _isOffline = result.contains(ConnectivityResult.none);
    notifyListeners();
  }

  void _checkConnectivity() {
    Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        _isOffline = result.contains(ConnectivityResult.none);
        notifyListeners();
      },
    );
  }

  Future<void> checkAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    
    if (token != null) {
      _user = await _authService.getCurrentUser();
      if (_user != null) {
        _isAuthenticated = true;
        notifyListeners();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    final bool success = await _authService.login(email, password);
    if (success) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'fake_token');
      
      _user = await _authService.getCurrentUser();
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  Future<void> register(String name, String email, String password) async {
    await _authService.register(name, email, password);
    await login(email, password);
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await _authService.logout();
    
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<User?> getUser() async => _user ?? _authService.getCurrentUser();
}
