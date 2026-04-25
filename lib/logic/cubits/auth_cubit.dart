import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/services/auth_service.dart';
import 'package:fan_control/repositories/local_storage_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = AuthService(LocalStorageRepository());

  AuthService get authService => _authService;

  AuthCubit() : super(const AuthInitial()) {
    _initConnectivity();
    _checkConnectivity();
    checkAuth();
  }

  Future<void> _initConnectivity() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    _updateConnectivity(result);
  }

  void _checkConnectivity() {
    Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        _updateConnectivity(result);
      },
    );
  }

  void _updateConnectivity(List<ConnectivityResult> result) {
    final bool isOffline = result.contains(ConnectivityResult.none);
    final currentState = state;
    if (currentState is AuthLoaded) {
      emit(AuthLoaded(
        user: currentState.user,
        isAuthenticated: currentState.isAuthenticated,
        isOffline: isOffline,
      ));
    } else if (currentState is AuthInitial) {
      emit(AuthOfflineChanged(isOffline));
    }
  }

  Future<void> checkAuth() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token != null) {
        final User? user = await _authService.getCurrentUser();
        if (user != null) {
          emit(AuthLoaded(
            user: user,
            isAuthenticated: true,
            isOffline: false,
          ));
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(const AuthLoading());
      final bool success = await _authService.login(email, password);
      if (success) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', 'fake_token');

        final User? user = await _authService.getCurrentUser();
        if (user != null) {
          emit(AuthLoaded(
            user: user,
            isAuthenticated: true,
            isOffline: false,
          ));
        }
      } else {
        emit(const AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      emit(const AuthLoading());
      await _authService.register(name, email, password);
      await login(email, password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await _authService.logout();
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
