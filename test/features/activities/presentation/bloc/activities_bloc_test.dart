import 'package:bloc_test/bloc_test.dart';
import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/activities/domain/entities/activity.dart';
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

class MockInsertActivityUsecase extends Mock implements InsertActivityUsecase {}

void main() {
  late ActivitiesBloc sut;
  late MockLoadActivitiesUsecase mockLoadActivitiesUsecase;
  late MockSwitchActivitiesUsecase mockSwitchActivitiesUsecase;
  late MockAddEmojiUsecase mockAddEmojiUsecase;
  late MockEditNameUsecase mockEditNameUsecase;
  late MockInsertActivityUsecase mockInsertActivityUsecase;

  setUp(() {
    mockLoadActivitiesUsecase = MockLoadActivitiesUsecase();
    mockSwitchActivitiesUsecase = MockSwitchActivitiesUsecase();
    mockAddEmojiUsecase = MockAddEmojiUsecase();
    mockEditNameUsecase = MockEditNameUsecase();
    mockInsertActivityUsecase = MockInsertActivityUsecase();
    sut = ActivitiesBloc(
      loadActivitiesUsecase: mockLoadActivitiesUsecase,
      switchActivityUsecase: mockSwitchActivitiesUsecase,
      addEmojiUsecase: mockAddEmojiUsecase,
      editNameUsecase: mockEditNameUsecase,
      insertActivityUsecase: mockInsertActivityUsecase,
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
    verify: (ActivitiesBloc bloc) => expect(bloc.state, ActivitiesState.initial()),
  );

  group('Usecases:', () {
    final date = DateTime.now();
    final activity = Activity(
      name: 'test',
      recordId: 1,
      color: Colors.black,
      startTime: date,
    );
    blocTest(
      'should call LoadActivitiesUsecase when LoadActivities is added & emit [loading, loaded]',
      setUp: () {
        registerFallbackValue(LoadActivitiesParams(date));
        when(() => mockLoadActivitiesUsecase(any()))
            .thenAnswer((_) async => const Right(<Activity>[]));
      },
      build: () => sut,
      act: (ActivitiesBloc bloc) =>
          bloc.add(ActivitiesEvent.loadActivities(date)),
      expect: () => [
        ActivitiesState.loading(),
        ActivitiesState.loaded([]),
      ],
      verify: (_) {
        verify(() => mockLoadActivitiesUsecase(any())).called(1);
      },
    );
    blocTest(
      'should call SwitchActivityUsecase when switchActivity is added & emit [loading, loadedSingle]',
      setUp: () {
        registerFallbackValue(const SwitchActivitiesParams(''));
        when(() => mockSwitchActivitiesUsecase(any()))
            .thenAnswer((_) async => Right(activity));
      },
      build: () => sut,
      act: (ActivitiesBloc bloc) =>
          bloc.add(ActivitiesEvent.switchActivity('')),
      expect: () => [
        ActivitiesState.loading(),
        ActivitiesState.loaded([activity]),
      ],
      verify: (_) {
        verify(() => mockSwitchActivitiesUsecase(any())).called(1);
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
      act: (ActivitiesBloc bloc) => bloc.add(ActivitiesEvent.addEmoji(1, '')),
      expect: () => [],
      verify: (_) {
        verify(() => mockAddEmojiUsecase(any())).called(1);
      },
    );
    blocTest(
      'should call EditNameUsecase when editName is added & emit [loading, loadedSingle]',
      setUp: () {
        registerFallbackValue(const EditNameParams(1, ''));
        when(() => mockEditNameUsecase(any()))
            .thenAnswer((_) async => Right(activity));
      },
      build: () => sut,
      act: (ActivitiesBloc bloc) => bloc.add(ActivitiesEvent.editName(1, '')),
      expect: () => [
        ActivitiesState.loading(),
        ActivitiesState.loaded([activity]),
      ],
      verify: (_) {
        verify(() => mockEditNameUsecase(any())).called(1);
      },
    );
    blocTest(
      'should call InsertActivityUsecase when insertActivity is added & emit [loading, loadedSingle]',
      setUp: () {
        registerFallbackValue(InsertActivityParams(
          name: '',
          startTime: date,
          endTime: date,
        ));
        when(() => mockInsertActivityUsecase(any()))
            .thenAnswer((_) async => Right(activity));
      },
      build: () => sut,
      act: (ActivitiesBloc bloc) => bloc.add(ActivitiesEvent.insertActivity(
        name: '',
        startTime: date,
        endTime: date,
      )),
      expect: () => [
        ActivitiesState.loading(),
        ActivitiesState.loaded([activity]),
      ],
      verify: (_) {
        verify(() => mockInsertActivityUsecase(any())).called(1);
      },
    );
  });
}
