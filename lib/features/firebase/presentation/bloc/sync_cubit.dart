import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sync_usecase.dart';

class SyncCubit extends Cubit<SyncState> {
  SyncCubit(this.usecase) : super(_initialState());

  final SyncUsecase usecase;

  static _initialState() => SyncState();

  sync() {
    usecase();
  }
}

class SyncState {}
