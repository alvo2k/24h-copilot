import 'dart:io';

import 'package:copilot/core/error/exceptions.dart';
import 'package:copilot/features/activities/data/datasources/data_sources_contracts.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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

@LazySingleton(as: ActivityLocalDataSource)
@DriftDatabase(tables: [Records, Activities])
class ActivityDatabase extends _$ActivityDatabase with ActivityLocalDataSource {
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

  /// Includes [from], excluding [to]
  @override
  Future<List<RecordWithActivitySettings>> getRecords({
    required int from,
    required int to,
  }) {
    final query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.endTime.isBiggerOrEqualValue(from))
      ..where(records.startTime.isSmallerThanValue(to));

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
}

class RecordWithActivitySettings {
  RecordWithActivitySettings(this.record, this.activity);

  final DriftActivityModel activity;
  final DriftRecordModel record;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'activities.sqlite'));
    return NativeDatabase(file);
  });
}
