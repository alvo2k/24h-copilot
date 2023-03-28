import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/return_types.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/random_color.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

@LazySingleton()
class EditRecordsUsecase extends UseCase<Activity, EditRecordsParams> {
  EditRecordsUsecase(this.repository);

  final ActivityRepository repository;

  @override
  Future<Either<Failure, Activity>> call(EditRecordsParams params) async {
    if (params.fixedTime != null && params.selectedTime != null) {
      // either overwrite the records completely or put the new one inside
      assert(params.toChange != null);
      final newStartTime = params.fixedTime!.isBefore(params.selectedTime!)
          ? params.fixedTime!
          : params.selectedTime!;
      final newEndTime = params.fixedTime!.isAfter(params.selectedTime!)
          ? params.fixedTime!
          : params.selectedTime!;
      final startsSame =
          params.toChange!.startTime.difference(newStartTime).inMinutes == 0;
      bool endsSame() => params.toChange!.endTime != null ? params.toChange!.endTime!.difference(newEndTime).inMinutes == 0 : false;
      if (startsSame && endsSame()) {
        // overwrite record
        return repository.editRecords(
            name: params.name,
            color: RandomColor.generate,
            toChange: params.toChange!);
      }
      if (startsSame || endsSame()) {
        // add new one above / below
        if (startsSame) {
          return repository.editRecords(
            name: params.name,
            color: RandomColor.generate,
            endTime: newEndTime,
            toChange: params.toChange!,
          );
        } else if (endsSame()) {
          return repository.editRecords(
            name: params.name,
            color: RandomColor.generate,
            startTime: newStartTime,
            toChange: params.toChange!,
          );
        }
      }
      // insert in between
      return repository.editRecords(
        name: params.name,
        color: RandomColor.generate,
        startTime: newStartTime,
        endTime: newEndTime,
        toChange: params.toChange!,
      );
    }
    if (params.fixedTime == null && params.selectedTime != null) {
      assert(params.toChange != null);
      if (params.toChange!.startTime
              .difference(params.selectedTime!)
              .inMinutes ==
          0) {
        // overwrite the last record
        return repository.editRecords(
            name: params.name,
            color: RandomColor.generate,
            toChange: params.toChange!);
      }
      // switch activity with start time change
      return repository.editRecords(
        name: params.name,
        color: RandomColor.generate,
        startTime: params.selectedTime!,
      );
    }
    return const Left(CacheFailure());
  }
}

class EditRecordsParams {
  const EditRecordsParams({
    required this.name,
    this.fixedTime,
    this.selectedTime,
    this.toChange,
  });

  final DateTime? fixedTime;
  final String name;
  final DateTime? selectedTime;
  final Activity? toChange;
}
