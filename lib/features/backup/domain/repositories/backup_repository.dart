import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/return_types.dart';

abstract interface class BackupRepository {
  Future<Either<Failure, Unit>> exportDatabase(File file);

  Future<Either<Failure, Unit>> importDatabase(File file);
}
