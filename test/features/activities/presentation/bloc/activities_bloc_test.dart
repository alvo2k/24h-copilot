import 'package:bloc_test/bloc_test.dart';
import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
import 'package:copilot/features/activities/domain/entities/activity_day.dart';
import 'package:copilot/features/activities/domain/usecases/activities_usecases.dart';
import 'package:copilot/features/activities/presentation/bloc/activities_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';

class MockLoadActivitiesUsecase extends Mock implements LoadActivitiesUsecase {}

class MockSwitchActivitiesUsecase extends Mock
    implements SwitchActivitiesUsecase {}

class MockAddEmojiUsecase extends Mock implements AddEmojiUsecase {}

class MockEditNameUsecase extends Mock implements EditNameUsecase {}

class MockEditRecordsUsecase extends Mock implements EditRecordsUsecase {}

void main() {
  late ActivitiesBloc sut;
  late MockLoadActivitiesUsecase mockLoadActivitiesUsecase;
  late MockSwitchActivitiesUsecase mockSwitchActivitiesUsecase;
  late MockAddEmojiUsecase mockAddEmojiUsecase;
  late MockEditNameUsecase mockEditNameUsecase;
  late MockEditRecordsUsecase mockEditRecordsUsecase;

  setUp(() {
    mockLoadActivitiesUsecase = MockLoadActivitiesUsecase();
    mockSwitchActivitiesUsecase = MockSwitchActivitiesUsecase();
    mockAddEmojiUsecase = MockAddEmojiUsecase();
    mockEditNameUsecase = MockEditNameUsecase();
    mockEditRecordsUsecase = MockEditRecordsUsecase();
    sut = ActivitiesBloc(
      loadActivitiesUsecase: mockLoadActivitiesUsecase,
      switchActivityUsecase: mockSwitchActivitiesUsecase,
      addEmojiUsecase: mockAddEmojiUsecase,
      editNameUsecase: mockEditNameUsecase,
      editRecordsUsecase: mockEditRecordsUsecase,
    );
  });

  blocTest(
    'emits [] when nothing is added',
    build: () => sut,
    expect: () => [],
  );
  blocTest(
    'verify empty initial state',
    build: () => sut,
    verify: (ActivitiesBloc bloc) =>
        expect(bloc.state, Initial()),
  );

  group('Usecases:', () {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final activity = Activity(
      name: 'test',
      recordId: 1,
      color: Colors.black,
      startTime: date,
    );
    final activityDay = ActivityDay([activity], date);
    blocTest(
      'should call LoadActivitiesUsecase when LoadActivities is added & emit [loading, loaded]',
      setUp: () {
        registerFallbackValue(LoadActivitiesParams(date));
        when(() => mockLoadActivitiesUsecase(any()))
            .thenAnswer((_) async => Stream.value(activityDay));
      },
      build: () => sut,
      act: (ActivitiesBloc bloc) =>
          bloc.add(LoadActivities(date)),
      expect: () => [
        Loading(),
        Loaded([activityDay]),
      ],
      verify: (bloc) {
        verify(() => mockLoadActivitiesUsecase(any())).called(1);
        expect(bloc.loadedActivities, [activityDay]);
      },
    );
    blocTest(
      'should call AddEmojiUsecase when addEmoji is added & emit []',
      setUp: () {
        registerFallbackValue(const AddEmojiParams(1, ''));
        when(() => mockAddEmojiUsecase(any()))
            .thenAnswer((_) async => const Right(Success()));
      },
      build: () => sut,
      act: (ActivitiesBloc bloc) => bloc.add(AddEmoji(1, '')),
      expect: () => [],
      verify: (_) {
        verify(() => mockAddEmojiUsecase(any())).called(1);
      },
    );
  });
}
