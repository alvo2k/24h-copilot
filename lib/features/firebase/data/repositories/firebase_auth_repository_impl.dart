import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../firebase_options.dart';
import '../../domain/repositories/firebase_auth_repository.dart';

@LazySingleton(as: FirebaseAuthRepository)
class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {
  @override
  Future confirmPasswordReset(String code, String newPassword) {
    // TODO: implement confirmPasswordReset
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserCredential>> createUser(
      String email, String pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      credential.user?.sendEmailVerification();

      return Right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left(FirebaseAuthFailure(FirebaseAuthError.weakPassword));
      } else if (e.code == 'email-already-in-use') {
        return Left(FirebaseAuthFailure(FirebaseAuthError.emailInUse));
      }
    }
    return Left(FirebaseAuthFailure(FirebaseAuthError.unknown));
  }

  @override
  Future deleteUser() {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Stream<User?>>> initialize() async {
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    } on UnsupportedError catch (_, __) {
      return const Left(UnsupportedPlatformFailure());
    }

    return Right(FirebaseAuth.instance.userChanges());
  }

  @override
  Future sendPasswordResetEmail() {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserCredential>> signIn(
      String email, String pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(FirebaseAuthFailure(FirebaseAuthError.userNotFound));
      } else if (e.code == 'wrong-password') {
        return Left(FirebaseAuthFailure(FirebaseAuthError.wrongPassword));
      } else if (e.code == 'user-disabled') {
        return Left(FirebaseAuthFailure(FirebaseAuthError.userDisabled));
      } else if (e.code == 'too-many-requests') {
        return Left(FirebaseAuthFailure(FirebaseAuthError.tooManyRequests));
      }
    }
    return Left(FirebaseAuthFailure(FirebaseAuthError.unknown));
  }

  @override
  Future signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future updateDisplayName(String displayName) {
    // TODO: implement updateDisplayName
    throw UnimplementedError();
  }

  @override
  Future updateEmail(String newEmail) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }
}
