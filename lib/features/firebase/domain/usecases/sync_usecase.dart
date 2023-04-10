import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../repositories/firebase_auth_repository.dart';
import '../repositories/local_sync_repository.dart';

@LazySingleton()
class SyncUsecase {
  SyncUsecase(this.repository, this.authRepo) {
    authRepo.initialize();
  }

  LocalSyncRepository repository;
  FirebaseAuthRepository authRepo;

  Either<FirestoreFailure, Success> call() {
    final firestore = FirebaseFirestore.instance;
    final user = authRepo.getUser();
    if (user == null) {
      return const Left(FirestoreFailure('Sign in to access this feature.'));
    }
    var userDoc = firestore.collection('users').doc(user.uid);

    repository.allActivities().listen((allActivities) {
      for (final activity in allActivities) {
        final activityData = activity.toJson();
        userDoc
            .collection('activities')
            .doc(activityData['name'])
            .set(activityData);
      }
    });

    repository.allRecords().listen((allRecords) {
      userDoc = FirebaseFirestore.instance.collection('records').doc('test');
      for (final record in allRecords) {
        final recordData = record.toJson();
        recordData['startTime'] = DateTime.fromMillisecondsSinceEpoch(
            recordData['startTime'],
            isUtc: true);
        recordData['endTime'] = DateTime.fromMillisecondsSinceEpoch(
            recordData['endTime'],
            isUtc: true);
        userDoc
            .collection('records')
            .doc(recordData['startTime'])
            .set(recordData);
      }
    });

    return const Right(Success());
  }
}
