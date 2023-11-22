// Mocks generated by Mockito 5.4.2 from annotations
// in copilot/test/features/activities/domain/usecases/shared_mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i7;

import 'package:copilot/core/common/activity_settings.dart' as _i9;
import 'package:copilot/core/error/return_types.dart' as _i6;
import 'package:copilot/features/activities/domain/entities/activity.dart'
    as _i5;
import 'package:copilot/features/activities/domain/entities/edit_record.dart'
    as _i8;
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart'
    as _i3;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ActivityRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockActivityRepository extends _i1.Mock
    implements _i3.ActivityRepository {
  MockActivityRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i4.Stream<List<_i5.Activity>>> getActivities({
    required int? from,
    required int? to,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getActivities,
          [],
          {
            #from: from,
            #to: to,
          },
        ),
        returnValue: _i4.Future<_i4.Stream<List<_i5.Activity>>>.value(
            _i4.Stream<List<_i5.Activity>>.empty()),
      ) as _i4.Future<_i4.Stream<List<_i5.Activity>>>);

  @override
  _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>> switchActivities({
    required String? nextActivityName,
    required DateTime? startTime,
    required _i7.Color? color,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #switchActivities,
          [],
          {
            #nextActivityName: nextActivityName,
            #startTime: startTime,
            #color: color,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>>.value(
            _FakeEither_0<_i6.Failure, _i5.Activity>(
          this,
          Invocation.method(
            #switchActivities,
            [],
            {
              #nextActivityName: nextActivityName,
              #startTime: startTime,
              #color: color,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>>);

  @override
  _i4.Future<_i2.Either<_i6.Failure, _i6.Success>> addEmoji(
    int? recordId,
    String? emoji,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addEmoji,
          [
            recordId,
            emoji,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i6.Failure, _i6.Success>>.value(
            _FakeEither_0<_i6.Failure, _i6.Success>(
          this,
          Invocation.method(
            #addEmoji,
            [
              recordId,
              emoji,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i6.Failure, _i6.Success>>);

  @override
  _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>> editName({
    required int? recordId,
    required String? newName,
    required _i7.Color? color,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #editName,
          [],
          {
            #recordId: recordId,
            #newName: newName,
            #color: color,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>>.value(
            _FakeEither_0<_i6.Failure, _i5.Activity>(
          this,
          Invocation.method(
            #editName,
            [],
            {
              #recordId: recordId,
              #newName: newName,
              #color: color,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>>);

  @override
  _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>> editRecords(
          _i8.EditRecord? record) =>
      (super.noSuchMethod(
        Invocation.method(
          #editRecords,
          [record],
        ),
        returnValue: _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>>.value(
            _FakeEither_0<_i6.Failure, _i5.Activity>(
          this,
          Invocation.method(
            #editRecords,
            [record],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i6.Failure, _i5.Activity>>);

  @override
  _i4.Future<_i2.Either<_i6.Failure, bool>> hasActivitySettings(
          String? activityName) =>
      (super.noSuchMethod(
        Invocation.method(
          #hasActivitySettings,
          [activityName],
        ),
        returnValue: _i4.Future<_i2.Either<_i6.Failure, bool>>.value(
            _FakeEither_0<_i6.Failure, bool>(
          this,
          Invocation.method(
            #hasActivitySettings,
            [activityName],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i6.Failure, bool>>);

  @override
  _i4.Stream<List<_i9.ActivitySettings>> mostCommonActivities(
          {required int? ammount}) =>
      (super.noSuchMethod(
        Invocation.method(
          #mostCommonActivities,
          [],
          {#ammount: ammount},
        ),
        returnValue: _i4.Stream<List<_i9.ActivitySettings>>.empty(),
      ) as _i4.Stream<List<_i9.ActivitySettings>>);
}
