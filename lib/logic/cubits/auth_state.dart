part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoaded extends AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isOffline;

  const AuthLoaded({
    required this.user,
    required this.isAuthenticated,
    required this.isOffline,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthLoaded &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isAuthenticated == other.isAuthenticated &&
          isOffline == other.isOffline;

  @override
  int get hashCode =>
      user.hashCode ^ isAuthenticated.hashCode ^ isOffline.hashCode;
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

class AuthOfflineChanged extends AuthState {
  final bool isOffline;

  const AuthOfflineChanged(this.isOffline);
}
