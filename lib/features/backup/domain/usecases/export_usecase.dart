import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/return_types.dart';
import '../repositories/backup_repository.dart';

@LazySingleton()
class ExportUseCase {
  ExportUseCase(this._repository);

  final BackupRepository _repository;

  Future<Either<Failure, String>> call() async {
    final documentsFolder = await pathToDownloadFolder();
    if (documentsFolder == null) {
      return left(Failure(type: FailureType.unreachableFolder));
    }
    final file = File(
      path.join(
        documentsFolder.path,
        'copilot_backup_${DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now())}.sqlite',
      ),
    );

    if (await file.exists()) {
      await file.delete();
    }

    final result = await _repository.exportDatabase(file);

    return result.fold(
      (l) => left(l),
      (r) => right(file.path),
    );
  }

  Future<Directory?> pathToDownloadFolder() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download/');
    }
    return (await getDownloadsDirectory());
  }
}
