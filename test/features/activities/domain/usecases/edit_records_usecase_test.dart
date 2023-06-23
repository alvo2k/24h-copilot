import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/entities/edit_record.dart';
import 'package:copilot/features/activities/domain/repositories/activity_repository.dart';
import 'package:copilot/features/activities/domain/usecases/edit_records_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'shared_mocks.dart';

void main() {
  late EditRecordsUsecase sut;
  late MockActivityRepository mockRepository;

  setUp(() {
    mockRepository = MockActivityRepository();
    sut = EditRecordsUsecase(mockRepository);
  });

  test(
    "should accept instance of ActivityRepository",
    () => expect(sut.repository, isA<ActivityRepository>()),
  );
  group('should call repository and return its value whith the right mode: ',
      () {
    final testEndTime = DateTime.now();
    final testStartTime = testEndTime.subtract(const Duration(minutes: 1));
    final testActivity = Activity(
      recordId: 1,
      name: 'name',
      color: Colors.black,
      startTime: testStartTime,
      endTime: testEndTime,
    );

    test(
        'given fixedTime and selectedTime are equal to toChange.startTime and toChange.endTime - sut should choose override mode',
        () async {
      when(mockRepository.editRecords(any))
          .thenAnswer((_) async => Right(testActivity));

      await sut(EditRecordsParams(
        name: '',
        toChange: testActivity,
        fixedTime: testStartTime,
        selectedTime: testEndTime,
      ));

      final calledWith = verify(mockRepository.editRecords(captureAny))
          .captured
          .first as EditRecord;
      expect(calledWith.mode, EditMode.override);
      verifyNoMoreInteractions(mockRepository);
    });
    test(
        'given fixedTime == null and selectedTime == toChange.startTime - sut should choose override mode',
        () async {
      when(mockRepository.editRecords(any))
          .thenAnswer((_) async => Right(testActivity));

      await sut(EditRecordsParams(
        name: '',
        toChange: testActivity,
        fixedTime: null,
        selectedTime: testStartTime,
      ));

      final calledWith = verify(mockRepository.editRecords(captureAny))
          .captured
          .first as EditRecord;
      expect(calledWith.mode, EditMode.override);
      verifyNoMoreInteractions(mockRepository);
    });
    test(
        'given fixedTime == null and selectedTime != toChange.startTime - sut should choose switchWithStartTime mode',
        () async {
      when(mockRepository.editRecords(any))
          .thenAnswer((_) async => Right(testActivity));

      await sut(EditRecordsParams(
        name: '',
        toChange: testActivity,
        fixedTime: null,
        selectedTime: testStartTime.subtract(const Duration(minutes: 2)),
      ));

      final calledWith = verify(mockRepository.editRecords(captureAny))
          .captured
          .first as EditRecord;
      expect(calledWith.mode, EditMode.switchWithStartTime);
      verifyNoMoreInteractions(mockRepository);
    });
    test(
        'given fixedTime == toChange.startTime and selectedTime != toChange.endTime - sut should choose placeAbove mode',
        () async {
      when(mockRepository.editRecords(any))
          .thenAnswer((_) async => Right(testActivity));

      await sut(EditRecordsParams(
        name: '',
        toChange: testActivity,
        fixedTime: testStartTime,
        selectedTime: testEndTime.add(const Duration(minutes: 2)),
      ));

      final calledWith = verify(mockRepository.editRecords(captureAny))
          .captured
          .first as EditRecord;
      expect(calledWith.mode, EditMode.placeAbove);
      verifyNoMoreInteractions(mockRepository);
    });
    test(
        'given fixedTime == toChange.endTime and selectedTime != toChange.startTime - sut should choose placeBellow mode',
        () async {
      when(mockRepository.editRecords(any))
          .thenAnswer((_) async => Right(testActivity));

      await sut(EditRecordsParams(
        name: '',
        toChange: testActivity,
        selectedTime: testStartTime.subtract(const Duration(minutes: 2)),
        fixedTime: testEndTime,
      ));

      final calledWith = verify(mockRepository.editRecords(captureAny))
          .captured
          .first as EditRecord;
      expect(calledWith.mode, EditMode.placeBellow);
      verifyNoMoreInteractions(mockRepository);
    });
    test(
        'given fixedTime and selectedTime != toChange.endTime and toChange.startTime - sut should choose placeInside mode',
        () async {
      when(mockRepository.editRecords(any))
          .thenAnswer((_) async => Right(testActivity));

      await sut(EditRecordsParams(
        name: '',
        toChange: testActivity,
        selectedTime: testStartTime.subtract(const Duration(minutes: 2)),
        fixedTime: testEndTime.add(const Duration(minutes: 2)),
      ));

      final calledWith = verify(mockRepository.editRecords(captureAny))
          .captured
          .first as EditRecord;
      expect(calledWith.mode, EditMode.placeInside);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
