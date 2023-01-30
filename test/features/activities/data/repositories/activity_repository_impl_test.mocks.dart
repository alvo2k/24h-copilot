// Mocks generated by Mockito 5.3.2 from annotations
// in copilot/test/features/activities/data/repositories/activity_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:copilot/features/activities/data/datasources/data_sources_contracts.dart'
    as _i3;
import 'package:copilot/features/activities/data/datasources/drift/drift_db.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

import 'activity_repository_impl_test.dart';

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

class _FakeRecordWithActivitySettings_0 extends _i1.SmartFake
    implements _i2.RecordWithActivitySettings {
  _FakeRecordWithActivitySettings_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ActivityLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockActivityLocalDataSource extends _i1.Mock
    implements _i3.ActivityLocalDataSource {
  MockActivityLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.RecordWithActivitySettings>> getRecords({
    required int? from,
    required int? to,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRecords,
          [],
          {
            #from: from,
            #to: to,
          },
        ),
        returnValue: _i4.Future<List<_i2.RecordWithActivitySettings>>.value(
            <_i2.RecordWithActivitySettings>[]),
      ) as _i4.Future<List<_i2.RecordWithActivitySettings>>);
  @override
  _i4.Future<_i2.RecordWithActivitySettings> createRecord({
    required String? activityName,
    required int? startTime,
    int? endTime,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createRecord,
          [],
          {
            #activityName: activityName,
            #startTime: startTime,
            #endTime: endTime,
          },
        ),
        returnValue: _i4.Future<_i2.RecordWithActivitySettings>.value(
            _FakeRecordWithActivitySettings_0(
          this,
          Invocation.method(
            #createRecord,
            [],
            {
              #activityName: activityName,
              #startTime: startTime,
              #endTime: endTime,
            },
          ),
        )),
      ) as _i4.Future<_i2.RecordWithActivitySettings>);
  @override
  _i4.Future<void> updateRecordTime({
    required int? idRecord,
    int? startTime,
    int? endTime,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateRecordTime,
          [],
          {
            #idRecord: idRecord,
            #startTime: startTime,
            #endTime: endTime,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<_i2.RecordWithActivitySettings> updateRecordSettings({
    required int? idRecord,
    required String? activityName,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateRecordSettings,
          [],
          {
            #idRecord: idRecord,
            #activityName: activityName,
          },
        ),
        returnValue: _i4.Future<_i2.RecordWithActivitySettings>.value(
            _FakeRecordWithActivitySettings_0(
          this,
          Invocation.method(
            #updateRecordSettings,
            [],
            {
              #idRecord: idRecord,
              #activityName: activityName,
            },
          ),
        )),
      ) as _i4.Future<_i2.RecordWithActivitySettings>);
  @override
  _i4.Future<_i2.DriftActivityModel?> findActivitySettings(String? name) =>
      (super.noSuchMethod(Invocation.method(#findActivitySettings, [name]),
              returnValue: _i4.Future<_i2.DriftActivityModel?>.value(FakeDriftActivityModel()))
          as _i4.Future<_i2.DriftActivityModel?>);
  @override
  _i4.Future<_i2.DriftActivityModel> createActivity(
          String? name, int? colorHex) =>
      (super.noSuchMethod(Invocation.method(#createActivity, [name, colorHex]),
              returnValue: _i4.Future<_i2.DriftActivityModel>.value(FakeDriftActivityModel()))
          as _i4.Future<_i2.DriftActivityModel>);
  @override
  _i4.Future<void> updateRecordEmoji(
    int? idRecord,
    String? emoji,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateRecordEmoji,
          [
            idRecord,
            emoji,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
