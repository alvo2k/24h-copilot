import 'dart:io';

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
  ActivityDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// Includes [from], excluding [to]
  Future<List<RecordWithActivity>> getRecords(int from, int to) {
    final query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.endTime.isBiggerOrEqualValue(from))
      ..where(records.startTime.isSmallerThanValue(to));

    final result = query.get().then((rows) => rows
        .map((row) => RecordWithActivity(
            row.readTable(records), row.readTable(activities)))
        .toList());

    //final result = await query.get().then((value) => value.map((e) => e.rawData).toList());

    return result;
  }

  Future<int> addRecord(RecordsCompanion record) {
    return into(records).insert(record);
  }

  Future<int> addActivitySettings(ActivitiesCompanion settings) {
    return into(activities).insert(settings, mode: InsertMode.insertOrIgnore);
  }

  Future<bool> updateRecordTime(RecordsCompanion record) {
    return update(records).replace(record);
  }

  Future<bool> updateRecordSettings(RecordsCompanion record) {
    return update(records).replace(record);
  }

  Future<DriftActivityModel> findActivitySettings(String name) {
    final query = select(activities)
      ..where((a) => a.name.equals(name))
      ..getSingle();

    return query.getSingle();
  }

  Future<bool> updateActivitySettings(ActivitiesCompanion settings) {
    return update(activities).replace(settings);
  }

  Future<bool> updateRecordEmoji(RecordsCompanion record) {
    return update(records).replace(record);
  }
}

class RecordWithActivity {
  RecordWithActivity(this.record, this.activity);

  final DriftActivityModel activity;
  final DriftRecordModel record;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'activities.sqlite'));
    return NativeDatabase(file, logStatements: true);
  });
}
