import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/return_types.dart';

abstract class FirebaseAuthRepository {
  Future<Either<Failure, Stream<User?>>> initialize();

  User? getUser();

  Future<Either<Failure, UserCredential>> createUser(String email, String pass);

  Future<Either<Failure, UserCredential>> signIn(String email, String pass);

  Future signOut();

  Future sendPasswordResetEmail();

  Future confirmPasswordReset(String code, String newPassword);

  Future deleteUser();

  Future updateDisplayName(String displayName);

  Future updateEmail(String newEmail);
}
