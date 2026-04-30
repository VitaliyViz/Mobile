part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
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
  List<Object?> get props => [
        user,
        isAuthenticated,
        isOffline,
      ];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
