import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/data/datasources/activity_database.dart';
import '../../../../core/error/return_types.dart';
import '../repositories/backup_repository.dart';

@LazySingleton()
class ImportUseCase {
  ImportUseCase(this._repository);

  final BackupRepository _repository;

  Future<Either<Failure, Unit>> call(File importedFile) async {
    final currentFile = await dbFile();
    final tempBackup = await currentFile.newName('activities_bak.sqlite');

    final result = await _repository.importDatabase(importedFile);

    return result.fold(
      (l) async {
        await tempBackup.rename(currentFile.path);
        return left(l);
      },
      (r) {
        tempBackup.delete();
        return right(r);
      },
    );
  }
}

extension Rename on File {
  Future<File> newName(String newFileName) {
    final lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    final newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return rename(newPath);
  }
}
