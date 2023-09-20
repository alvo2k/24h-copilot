import 'package:copilot/core/common/data/datasources/activity_database.dart';
import 'package:copilot/core/common/data/datasources/activity_local_data_source.dart';
import 'package:copilot/core/common/data/models/activity_model.dart';
import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/dashboard/data/repositories/pie_chart_data_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ActivityLocalDataSource])
import 'pie_chart_data_repository_impl_test.mocks.dart';

void main() {
  late PieChartDataRepositoryImpl sut;
  late MockActivityLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockActivityLocalDataSource();
    sut = PieChartDataRepositoryImpl(mockLocalDataSource);
  });

  final tDriftRow = RecordWithActivitySettings(
    DriftRecordModel(
      idRecord: 0,
      activityName: 'name',
      startTime: DateTime(1).toUtc().millisecondsSinceEpoch,
      emoji: '🤪',
    ),
    const DriftActivityModel(
      name: 'name',
      color: 0xFF000000,
      tags: 'sport;body',
      goal: 1,
    ),
  );
  final tDriftRow2 = RecordWithActivitySettings(
    DriftRecordModel(
      idRecord: 1,
      startTime: DateTime(2).toUtc().millisecondsSinceEpoch,
      emoji: '🤪',
      activityName: 'name2',
    ),
    const DriftActivityModel(
      name: 'name2',
      color: 0xFF000000,
      tags: 'sport;body',
      goal: 1,
    ),
  );
  final List<RecordWithActivitySettings> rawActivities = [
    tDriftRow,
    tDriftRow2,
  ];

  group('getActivities():', () {
    test(
      'should call getRecordsRange when no search is given',
      () async {
        when(mockLocalDataSource.getRecordsRange(
          from: anyNamed('from'),
          to: anyNamed('to'),
        )).thenAnswer((_) async => const Stream.empty());

        await sut.getActivities(
          from: 0,
          to: 1,
        );

        verify(mockLocalDataSource.getRecordsRange(
          from: anyNamed('from'),
          to: anyNamed('to'),
        )).called(1);
      },
    );
    test(
      'should call getRecordsRangeWithTag when search is given without \'#\' in [tag]',
      () async {
        when(mockLocalDataSource.getRecordsRangeWithTag(
          from: anyNamed('from'),
          to: anyNamed('to'),
          tag: anyNamed('tag'),
        )).thenAnswer((_) async => const Stream.empty());

        await sut.getActivities(
          from: 0,
          to: 1,
          search: '#tag',
        );

        final call = verify(mockLocalDataSource.getRecordsRangeWithTag(
          from: anyNamed('from'),
          to: anyNamed('to'),
          tag: captureAnyNamed('tag'),
        ))
          ..called(1);
        expect(call.captured[0], 'tag');
      },
    );
    test(
      'should call getRecordsRange and return valid models',
      () async {
        when(mockLocalDataSource.getRecordsRange(
          from: anyNamed('from'),
          to: anyNamed('to'),
        )).thenAnswer((_) async => Stream.value(rawActivities));

        final result = (await (await sut.getActivities(
          from: 0,
          to: 1,
        ))
                .first as Right<Failure, List<ActivityModel>>)
            .value;

        expect(
            result[0],
            ActivityModel.fromDriftRow(
              tDriftRow,
              tDriftRow2.record.startTime,
            ));
        expect(
            result[1],
            ActivityModel.fromDriftRow(
              tDriftRow2,
              null,
            ));
      },
    );
  });

  test('should call getFirstRecord and return valid DateTime', () async {
    when(mockLocalDataSource.getFirstRecord())
        .thenAnswer((_) async => tDriftRow.record);

    final result = await sut.getFirstEverRecordStartTime();

    verify(mockLocalDataSource.getFirstRecord()).called(1);
    expect(result,
        DateTime.fromMillisecondsSinceEpoch(tDriftRow.record.startTime));
  });

  group('getSuggestion(): ', () {
    test(
        'should call searchTags without \'#\' if argument starts with it and return it',
        () async {
      when(mockLocalDataSource.searchTags(captureAny))
          .thenAnswer((_) async => ['lorem', 'ipsum']);

      final result = await sut.getSuggestion('#search');

      expect((result as Right).value, ['lorem', 'ipsum']);
      expect('search',
          verify(mockLocalDataSource.searchTags(captureAny)).captured[0]);
    });

    test('should call searchActivities and return it', () async {
      when(mockLocalDataSource.searchActivities(captureAny))
          .thenAnswer((_) async => ['lorem', 'ipsum']);

      final result = await sut.getSuggestion('search');

      expect((result as Right).value, ['lorem', 'ipsum']);
      expect('search',
          verify(mockLocalDataSource.searchActivities(captureAny)).captured[0]);
    });
  });
}
