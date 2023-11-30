part of 'auth_bloc.dart';

class Initial extends AuthState {
  @override
  List<Object> get props => [];
}

class Failure extends AuthState {
  Failure(this.type);

  final FailureType type;

  @override
  List<Object> get props => [type];
}

class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoggedIn extends AuthState {
  LoggedIn({required this.email, this.displayName});

  final String? displayName;
  final String email;

  @override
  List<Object?> get props => [email, displayName];
}

class LoggedOut extends AuthState {
  @override
  List<Object?> get props => [];
}

class NoInternet extends AuthState {
  @override
  List<Object?> get props => [];
}

abstract class AuthState extends Equatable {}
