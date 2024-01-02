import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../../../core/common/data/datasources/activity_database.dart';
import '../../../../core/error/return_types.dart';

part 'backup_data_source.g.dart';

abstract class BackupDataSource {
  Future<Either<Failure, Unit>> exportDatabase(File file);

  Future<Either<Failure, Unit>> importDatabase(File file);
}

@LazySingleton(as: BackupDataSource)
@DriftAccessor(tables: [Records, Activities])
class BackupDataSourceImpl extends DatabaseAccessor<ActivityDatabase>
    with _$BackupDataSourceImplMixin
    implements BackupDataSource {
  BackupDataSourceImpl(super.attachedDatabase);

  @override
  Future<Either<Failure, Unit>> exportDatabase(File exportTo) async {
    try {
      await customStatement('VACUUM INTO ?', [exportTo.path]);
      return const Right(unit);
    } on SqliteException catch (e) {
      return Left(
        Failure(
          type: FailureType.localStorage,
          extra: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> importDatabase(File importFrom) async {
    final completer = Completer<Either<Failure, Unit>>();

    final import = Future<void>(
      () async {
        final db = sqlite3.open(importFrom.path, mode: OpenMode.readOnly);
        final importTo = await dbFile();
        db.execute('VACUUM INTO ?', [importTo.path]);
      },
    );
    import.catchError(
      (e, _) => completer.complete(
        left(
          Failure(
            type: FailureType.localStorage,
            extra: e,
          ),
        ),
      ),
    );

    import.then((_) => completer.complete(right(unit)));

    return completer.future;
  }
}
