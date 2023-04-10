import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../features/activities/data/datasources/data_sources_contracts.dart';
import '../../../../features/firebase/data/datasources/sync_local_datasource.dart';

part 'drift_db.g.dart';

@DataClassName('DriftRecordModel')
class Records extends Table {
  IntColumn get idRecord => integer().autoIncrement()();

  TextColumn get activityName => text().references(Activities, #name)();

  IntColumn get startTime => integer()();

  IntColumn get endTime => integer().nullable()();

  TextColumn get emoji => text().nullable()();
}

@DataClassName('DriftActivityModel')
class Activities extends Table {
  @override
  Set<Column> get primaryKey => {name};

  TextColumn get name => text()();

  IntColumn get color => integer()();

  TextColumn get tags => text().nullable()();

  IntColumn get goal => integer().nullable()();
}

// [SyncLocalDataSource] has been manually injected into the injectable.dart file as a singleton,
// resulting in two instances of the ActivityDatabase.
@LazySingleton(as: ActivityLocalDataSource)
@DriftDatabase(tables: [Records, Activities])
class ActivityDatabase extends _$ActivityDatabase
    with ActivityLocalDataSource, SyncLocalDataSource {
  ActivityDatabase() : super(_openConnection());

  ActivityDatabase._(QueryExecutor e) : super(e);

  factory ActivityDatabase.testConnection(QueryExecutor e) {
    return ActivityDatabase._(e);
  }

  @override
  Future<DriftActivityModel> createActivity(String name, int colorHex) async {
    final activity = ActivitiesCompanion(
      name: Value(name),
      color: Value(colorHex),
    );

    await into(activities).insert(activity, mode: InsertMode.insertOrIgnore);

    return await (select(activities)..where((a) => a.name.equals(name)))
        .getSingle();
  }

  @override
  Future<RecordWithActivitySettings> createRecord({
    required String activityName,
    required int startTime,
    int? endTime,
  }) async {
    final nameExist = await (select(activities)
                  ..where((a) => a.name.equals(activityName)))
                .getSingleOrNull() ==
            null
        ? false
        : true;
    if (!nameExist) {
      throw CacheException();
    }

    final record = RecordsCompanion(
      activityName: Value(activityName),
      startTime: Value(startTime),
      endTime: endTime == null ? const Value.absent() : Value(endTime),
    );

    final recordId = await into(records).insert(record);

    return RecordWithActivitySettings(
      await _getRecordModel(recordId),
      await _getActivityModel(activityName),
    );
  }

  @override
  Future<DriftActivityModel?> findActivitySettings(String name) {
    final query = (select(activities)..where((a) => a.name.equals(name)))
        .getSingleOrNull();

    return query;
  }

  @override
  Future<int> getLastRecordId() {
    final query = select(records)
      ..orderBy([
        (r) => OrderingTerm(expression: r.idRecord, mode: OrderingMode.desc)
      ])
      ..limit(1);
    return query.map((r) => r.idRecord).getSingle();
  }

  /// Includes [from], excluding [to]
  @override
  Future<List<RecordWithActivitySettings>> getRecords({
    required int from,
    required int to,
  }) {
    final query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(
          records.endTime.isBiggerOrEqualValue(from) | records.endTime.isNull())
      ..where(records.startTime.isSmallerThanValue(to))
      ..orderBy([OrderingTerm(expression: records.startTime)]);

    final result = query.get().then((rows) => rows
        .map((row) => RecordWithActivitySettings(
            row.readTable(records), row.readTable(activities)))
        .toList());

    return result;
  }

  @override
  int get schemaVersion => 1;

  @override
  Future<void> updateRecordEmoji(int idRecord, String emoji) async {
    await (update(records)..where((r) => r.idRecord.equals(idRecord)))
        .write(RecordsCompanion(emoji: Value(emoji)));

    return;
  }

  @override
  Future<RecordWithActivitySettings> updateRecordSettings({
    required int idRecord,
    required String activityName,
  }) async {
    await (update(records)..where((r) => r.idRecord.equals(idRecord)))
        .write(RecordsCompanion(activityName: Value(activityName)));

    return RecordWithActivitySettings(
      await _getRecordModel(idRecord),
      await _getActivityModel(activityName),
    );
  }

  @override
  Future<void> updateRecordTime({
    required int idRecord,
    int? startTime,
    int? endTime,
  }) async {
    final Value<int> valueStartTime =
        startTime == null ? const Value.absent() : Value(startTime);
    final Value<int> valueEndTime =
        endTime == null ? const Value.absent() : Value(endTime);

    await (update(records)..where((r) => r.idRecord.equals(idRecord))).write(
        RecordsCompanion(startTime: valueStartTime, endTime: valueEndTime));

    return;
  }

  Future<DriftRecordModel> _getRecordModel(int id) {
    return (select(records)..where((r) => r.idRecord.equals(id))).getSingle();
  }

  Future<DriftActivityModel> _getActivityModel(String name) {
    return (select(activities)..where((a) => a.name.equals(name))).getSingle();
  }

  @override
  Stream<List<DriftActivityModel>> watchAllActivities() =>
      select(activities).watch();

  @override
  Stream<List<DriftRecordModel>> watchAllRecords({int? from}) {
    if (from != null) {
      return (select(records)
            ..where((tbl) => tbl.startTime.isBiggerOrEqualValue(from)))
          .watch();
    } else {
      return select(records).watch();
    }
  }
}

class RecordWithActivitySettings {
  RecordWithActivitySettings(this.record, this.activity);

  final DriftActivityModel activity;
  final DriftRecordModel record;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'activities.sqlite'));
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      return NativeDatabase(file);
    } on MissingPlatformDirectoryException {
      return NativeDatabase(
        File(path.join(Directory.current.path, 'activities.sqlite')),
      );
    }
  });
}
