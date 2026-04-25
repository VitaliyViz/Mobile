import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:fan_control/models/user_model.dart';
import 'package:fan_control/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  AuthCubit(this._authRepository) : super(const AuthInitial()) {
    _initConnectivity();
    _subscribeToConnectivity();
    checkAuth();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _updateConnectivity(result);
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _subscribeToConnectivity() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectivity);
  }

  void _updateConnectivity(List<ConnectivityResult> result) {
    final isOffline = result.contains(ConnectivityResult.none);
    final currentState = state;

    if (currentState is AuthLoaded) {
      emit(
        AuthLoaded(
          user: currentState.user,
          isAuthenticated: currentState.isAuthenticated,
          isOffline: isOffline,
        ),
      );
    }
  }

  Future<void> checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        final user = await _authRepository.getUser();
        if (user != null) {
          emit(
            AuthLoaded(
              user: user,
              isAuthenticated: true,
              isOffline: false,
            ),
          );
        }
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(const AuthLoading());
      // Використовуємо імена методів з твого AuthRepository
      final user = await _authRepository.signIn(email, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', 'fake_token');
        emit(
          AuthLoaded(
            user: user,
            isAuthenticated: true,
            isOffline: false,
          ),
        );
      } else {
        emit(const AuthError('Login failed'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      emit(const AuthLoading());
      await _authRepository.signUp(name, email, password);
      await login(email, password);
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await _authRepository.clearUser();
      emit(const AuthInitial());
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
