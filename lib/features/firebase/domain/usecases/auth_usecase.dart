import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/firebase_auth_repository.dart';

@LazySingleton()
class AuthUsecase extends UseCase<Stream<User?>, AuthParams> {
  AuthUsecase(this.repository);

  final FirebaseAuthRepository repository;

  @override
  Future<Either<Failure, Stream<User?>>> call(AuthParams params) =>
      repository.initialize();

  Future<Either<Failure, UserCredential>> createUser(
          String email, String pass) =>
      repository.createUser(email, pass);

  Future<Either<Failure, UserCredential>> signIn(String email, String pass) =>
      repository.signIn(email, pass);

  Future signOut() => repository.signOut();
}

class AuthParams {
  AuthParams();
}
