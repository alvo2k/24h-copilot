import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/random_color.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class InsertActivityUsecase extends UseCase<Activity, InsertActivityParams> {
  InsertActivityUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Activity>> call(InsertActivityParams params) async {
    return await repository.hasActivitySettings(params.name).then(
          (value) => value.fold(
            (l) => Left(l),
            (r) {
              if (r) {
                return _repoInsertParamsChooser(params);
              } else {
                final color = RandomColor.generate;
                return _repoInsertParamsChooser(params, color);
              }
            },
          ),
        );
  }

  Future<Either<Failure, Activity>> _repoInsertParamsChooser(
    InsertActivityParams params, [
    Color? color,
  ]) {
    if (params.endTime != null) {
      if (color != null) {
        return repository.insertActivity(
          name: params.name,
          startTime: params.startTime.toUtc(),
          endTime: params.endTime!.toUtc(),
          color: color,
        );
      } else {
        return repository.insertActivity(
          name: params.name,
          startTime: params.startTime.toUtc(),
          endTime: params.endTime!.toUtc(),
        );
      }
    } else {
      if (color != null) {
        return repository.insertActivity(
          name: params.name,
          startTime: params.startTime.toUtc(),
          color: color,
        );
      } else {
        return repository.insertActivity(
          name: params.name,
          startTime: params.startTime.toUtc(),
        );
      }
    }
  }
}

class InsertActivityParams {
  const InsertActivityParams({
    required this.name,
    required this.startTime,
    this.endTime,
  });

  final DateTime? endTime;
  final String name;
  final DateTime startTime;
}
