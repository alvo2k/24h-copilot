// Mocks generated by Mockito 5.2.0 from annotations
// in copilot/test/features/activities/domain/usecases/shared_mocks.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:copilot/core/error/return_types.dart' as _i5;
import 'package:copilot/features/activities/domain/entities/activity.dart'
    as _i6;
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

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [ActivityRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockActivityRepository extends _i1.Mock
    implements _i3.ActivityRepository {
  MockActivityRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Activity>>> getActivities(
          DateTime? forTheDay) =>
      (super.noSuchMethod(Invocation.method(#getActivities, [forTheDay]),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i6.Activity>>>.value(
                      _FakeEither_0<_i5.Failure, List<_i6.Activity>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Activity>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Activity>> switchActivities(
          String? nextActivityName) =>
      (super.noSuchMethod(
              Invocation.method(#switchActivities, [nextActivityName]),
              returnValue: Future<_i2.Either<_i5.Failure, _i6.Activity>>.value(
                  _FakeEither_0<_i5.Failure, _i6.Activity>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.Activity>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i5.Success>> addEmoji(
          _i6.Activity? activity, String? emoji) =>
      (super.noSuchMethod(Invocation.method(#addEmoji, [activity, emoji]),
              returnValue: Future<_i2.Either<_i5.Failure, _i5.Success>>.value(
                  _FakeEither_0<_i5.Failure, _i5.Success>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i5.Success>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i5.Success>> editName(
          _i6.Activity? activity, String? name) =>
      (super.noSuchMethod(Invocation.method(#editName, [activity, name]),
              returnValue: Future<_i2.Either<_i5.Failure, _i5.Success>>.value(
                  _FakeEither_0<_i5.Failure, _i5.Success>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i5.Success>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Activity>> insertActivity(
          {String? name, DateTime? startTime, DateTime? endTime}) =>
      (super.noSuchMethod(
              Invocation.method(#insertActivity, [],
                  {#name: name, #startTime: startTime, #endTime: endTime}),
              returnValue: Future<_i2.Either<_i5.Failure, _i6.Activity>>.value(
                  _FakeEither_0<_i5.Failure, _i6.Activity>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.Activity>>);
}
