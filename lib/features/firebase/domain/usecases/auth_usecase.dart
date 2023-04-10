import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/firebase_auth_repository.dart';

@LazySingleton()
class AuthUsecase extends UseCase<Stream<User?>, AuthParams> {
  AuthUsecase(this._repository) {
    _repository.initialize();
  }

  final FirebaseAuthRepository _repository;

  @override
  Future<Either<Failure, Stream<User?>>> call(AuthParams params) async {
    return await _repository.initialize();
  }

  Future<Either<Failure, UserCredential>> createUser(
          String email, String pass) =>
      _repository.createUser(email, pass);

  Future<Either<Failure, UserCredential>> signIn(String email, String pass) =>
      _repository.signIn(email, pass);

  Future signOut() => _repository.signOut();

  User? getUser() => _repository.getUser();
}

class AuthParams {
  AuthParams();
}
