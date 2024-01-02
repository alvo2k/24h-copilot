import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../domain/repositories/backup_repository.dart';
import '../datasources/backup_data_source.dart';

@LazySingleton(as: BackupRepository)
class BackupRepositoryImpl implements BackupRepository {
  BackupRepositoryImpl(this._dataSource);

  final BackupDataSource _dataSource;

  @override
  Future<Either<Failure, Unit>> exportDatabase(File file) =>
      _dataSource.exportDatabase(file);

  @override
  Future<Either<Failure, Unit>> importDatabase(File file) =>
      _dataSource.importDatabase(file);
}
