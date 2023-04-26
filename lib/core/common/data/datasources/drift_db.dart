import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../../core/error/exceptions.dart';
import 'data_sources_contracts.dart';

part 'drift_db.g.dart';

@DataClassName('DriftRecordModel')
class Records extends Table {
  IntColumn get idRecord => integer().autoIncrement()();

  TextColumn get activityName => text().references(Activities, #name)();

  IntColumn get startTime => integer()();

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
  Future<List<RecordWithActivitySettings>> getRecordsRange({
    required int from,
    required int to,
  }) async {
    // find record with startTime closest to [from],
    // this would be the first record because endTime of it would be in range
    var query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.startTime.isSmallerOrEqualValue(from))
      ..orderBy([
        OrderingTerm(
          expression: records.startTime,
          mode: OrderingMode.desc,
        )
      ])
      ..limit(1);
    final firstRecord =
        await query.map((r) => r.readTable(records)).getSingleOrNull();
    if (firstRecord == null) throw CacheException();

    // get all records between firstRecord.startTime and [to]
    query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.startTime.isBiggerOrEqualValue(firstRecord.startTime))
      ..where(records.startTime.isSmallerThanValue(to))
      ..orderBy([
        OrderingTerm(
          expression: records.startTime,
        )
      ]);

    final result = query.get().then((rows) => rows
        .map((row) => RecordWithActivitySettings(
            row.readTable(records), row.readTable(activities)))
        .toList());
    return result;
  }

  @override
  Future<List<RecordWithActivitySettings>> getRecords({
    required int ammount,
    int? skip,
  }) {
    final query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..orderBy([
        OrderingTerm(
          expression: records.startTime,
          mode: OrderingMode.desc,
        )
      ])
      ..limit(ammount, offset: skip);

    final result = query.get().then((rows) => rows
        .map((row) => RecordWithActivitySettings(
            row.readTable(records), row.readTable(activities)))
        .toList());

    return result;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await customStatement('ALTER TABLE records RENAME TO _records_old');
          await customStatement('''
            CREATE TABLE records (
              id_record INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              activity_name TEXT NOT NULL REFERENCES activities (name),
              start_time INTEGER NOT NULL,
              emoji TEXT NULL
            )
          ''');
          await customStatement(
              '''INSERT INTO records (activity_name, start_time, emoji)
          SELECT activity_name, start_time, emoji
          FROM _records_old
          ''');
          // await customStatement('DROP TABLE _records_old');
        }
      },
    );
  }

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
    required int startTime,
  }) async {
    await (update(records)..where((r) => r.idRecord.equals(idRecord)))
        .write(RecordsCompanion(startTime: Value(startTime)));

    return;
  }

  Future<DriftRecordModel> _getRecordModel(int id) {
    return (select(records)..where((r) => r.idRecord.equals(id))).getSingle();
  }

  Future<DriftActivityModel> _getActivityModel(String name) {
    return (select(activities)..where((a) => a.name.equals(name))).getSingle();
  }

  @override
  Future<List<DriftActivityModel>> getActivitiesSettings() =>
      select(activities).get();

  @override
  Future<DriftActivityModel> updateActivitySettings({
    required String activityName,
    String? newActivityName,
    int? newColorHex,
    String? tags,
    int? newGoal,
  }) async {
    final result = await (update(activities)
          ..where((a) => a.name.equals(activityName)))
        .writeReturning(
      ActivitiesCompanion(
        name: newActivityName != null
            ? Value(newActivityName)
            : const Value.absent(),
        color: newColorHex != null ? Value(newColorHex) : const Value.absent(),
        tags: tags != null ? Value(tags) : const Value.absent(),
        goal: newGoal != null ? Value(newGoal) : const Value.absent(),
      ),
    );

    if (result.length != 1) throw CacheException();
    return result[0];
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
      return NativeDatabase(file);
    } on MissingPlatformDirectoryException {
      return NativeDatabase(
        File(path.join(Directory.current.path, 'activities.sqlite')),
      );
    }
  });
}
