part of 'auth_bloc.dart';

class Register extends Equatable {
  const Register({required this.email, required this.pass});

  final String email;
  final String pass;

  @override
  List<Object> get props => [email, pass];
}

class SignIn extends Equatable {
  const SignIn({required this.email, required this.pass});

  final String email;
  final String pass;

  @override
  List<Object> get props => [email, pass];
}

class SignOut extends Equatable {
  const SignOut();

  @override
  List<Object> get props => [];
}

class GetUserData extends Equatable {
  const GetUserData();

  @override
  List<Object> get props => [];
}

class AuthEvent extends Union4Impl<Register, SignIn, SignOut, GetUserData> {
  AuthEvent._(Union4<Register, SignIn, SignOut, GetUserData> union) : super(union);

  factory AuthEvent.register(String email, String pass) =>
      AuthEvent._(unions.first(Register(email: email, pass: pass)));

  factory AuthEvent.signIn(String email, String pass) =>
      AuthEvent._(unions.second(SignIn(email: email, pass: pass)));

  factory AuthEvent.signOut() => AuthEvent._(unions.third(const SignOut()));

  factory AuthEvent.getUserData() => AuthEvent._(unions.fourth(const GetUserData()));

  static const unions = Quartet<Register, SignIn, SignOut, GetUserData>();
}
