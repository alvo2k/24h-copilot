part of 'auth_bloc.dart';

class Register extends AuthEvent {
  Register({required this.email, required this.pass});

  final String email;
  final String pass;

  @override
  List<Object> get props => [email, pass];
}

class SignIn extends AuthEvent {
  SignIn({required this.email, required this.pass});

  final String email;
  final String pass;

  @override
  List<Object> get props => [email, pass];
}

class SignOut extends AuthEvent {
  SignOut();

  @override
  List<Object> get props => [];
}

class GetUserData extends AuthEvent {
  GetUserData();

  @override
  List<Object> get props => [];
}

abstract class AuthEvent extends Equatable {}
