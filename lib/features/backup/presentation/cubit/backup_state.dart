part of 'backup_cubit.dart';

class BackupState extends Equatable {
  const BackupState({
    this.status = BackupStatus.initial,
    this.failure,
    this.exportedPath = '',
  });

  final BackupStatus status;
  final FailureType? failure;
  final String exportedPath;

  @override
  List<Object?> get props => [status, failure, exportedPath];

  BackupState copyWith({
    BackupStatus? status,
    FailureType? failure,
    String? exportedPath,
  }) =>
      BackupState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        exportedPath: exportedPath ?? this.exportedPath,
      );
}

enum BackupStatus {
  initial,
  failure,
  exporting,
  importing,
  exported,
  imported,
}
