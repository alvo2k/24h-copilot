import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/return_types.dart';
import '../../domain/usecases/export_usecase.dart';
import '../../domain/usecases/import_usecase.dart';

part 'backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit(
    this._exportUseCase,
    this._importUseCase,
  ) : super(const BackupState());

  final ExportUseCase _exportUseCase;
  final ImportUseCase _importUseCase;

  void export() async {
    emit(state.copyWith(status: BackupStatus.exporting));

    final result = await _exportUseCase();

    result.fold(
      (l) => emit(
        state.copyWith(
          failure: l.type,
          status: BackupStatus.failure,
        ),
      ),
      (r) => emit(
        state.copyWith(
          status: BackupStatus.exported,
          exportedPath: r,
        ),
      ),
    );
  }

  void import(File file) async {
    emit(state.copyWith(status: BackupStatus.importing));

    final result = await _importUseCase(file);

    result.fold(
      (l) => emit(
        state.copyWith(
          failure: l.type,
          status: BackupStatus.failure,
        ),
      ),
      (r) => emit(state.copyWith(status: BackupStatus.imported)),
    );
  }
}
