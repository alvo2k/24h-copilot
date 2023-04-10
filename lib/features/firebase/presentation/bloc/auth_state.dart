part of 'auth_bloc.dart';

class Initial extends Equatable {
  @override
  List<Object> get props => [];
}

class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class Loading extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoggedIn extends Equatable {
  const LoggedIn({required this.email, this.displayName});

  final String? displayName;
  final String email;

  @override
  List<Object?> get props => [email, displayName];
}

class LoggedOut extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoInternet extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthState extends Union6Impl<Initial, Failure, Loading, LoggedIn,
    LoggedOut, NoInternet> {
  AuthState._(
      Union6<Initial, Failure, Loading, LoggedIn, LoggedOut, NoInternet> union)
      : super(union);

  factory AuthState.failure(String message) =>
      AuthState._(unions.second(Failure(message)));

  factory AuthState.initial() => AuthState._(unions.first(Initial()));

  factory AuthState.loading() => AuthState._(unions.third(Loading()));

  factory AuthState.loggedIn(String email, String? displayName) => AuthState._(
      unions.fourth(LoggedIn(email: email, displayName: displayName)));

  factory AuthState.loggedOut() => AuthState._(unions.fifth(LoggedOut()));

  factory AuthState.noInternet() => AuthState._(unions.sixth(NoInternet()));

  static const unions =
      Sextet<Initial, Failure, Loading, LoggedIn, LoggedOut, NoInternet>();
}
