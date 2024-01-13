import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../features/activity_analytics/data/datasources/activity_analytics_data_source.dart';
import '../../../utils/constants.dart';
import 'activity_local_data_source.dart';

part 'activity_database.g.dart';

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

@LazySingleton()
@DriftDatabase(tables: [Records, Activities])
class ActivityDatabase extends _$ActivityDatabase
    implements ActivityLocalDataSource, ActivityAnalyticsDataSource {
  ActivityDatabase() : super(_openConnection());

  ActivityDatabase._(super.e);

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

    _removeDuplicatesRecords();

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
  Future<DriftRecordModel?> getFirstRecord() async => await (select(records)
        ..orderBy([(r) => OrderingTerm.asc(r.startTime)])
        ..limit(1))
      .getSingleOrNull();

  @override
  Future<int> getLastRecordId() {
    final query = select(records)
      ..orderBy([
        (r) => OrderingTerm(expression: r.idRecord, mode: OrderingMode.desc)
      ])
      ..limit(1);
    return query.map((r) => r.idRecord).getSingle();
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

  /// Includes [from], excluding [to]
  @override
  Future<Stream<List<RecordWithActivitySettings>>> getRecordsRange({
    required int from,
    required int to,
    String? name,
  }) async {
    final firstRecord = await _findFirstRecord(from, name);

    // get all records between firstRecord.startTime and [to]
    final query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.startTime
          .isBiggerOrEqualValue(firstRecord?.startTime ?? from))
      ..where(records.startTime.isSmallerThanValue(to))
      ..orderBy([
        OrderingTerm(
          expression: records.startTime,
        )
      ]);

    if (name != null) query.where(records.activityName.equals(name));

    return query.watch().map((rows) => rows
        .map((row) => RecordWithActivitySettings(
            row.readTable(records), row.readTable(activities)))
        .toList());
  }

  @override
  Future<Stream<List<RecordWithActivitySettings>>> getRecordsRangeWithTag({
    required int from,
    required int to,
    required String tag,
  }) async {
    final firstRecord = await _findFirstRecord(from);

    // get all records between firstRecord.startTime and [to] with tag
    final query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.startTime
          .isBiggerOrEqualValue(firstRecord?.startTime ?? from))
      ..where(records.startTime.isSmallerThanValue(to))
      ..where(activities.tags.like('%$tag%'))
      ..orderBy([
        OrderingTerm(
          expression: records.startTime,
        )
      ]);

    final result = query.watch().map((rows) => rows
        .map((row) => RecordWithActivitySettings(
            row.readTable(records), row.readTable(activities)))
        .toList());
    return result;
  }

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
  int get schemaVersion => 2;

  @override
  Future<List<String>?> searchActivities(String activityName) async {
    final result = await (select(activities)
          ..where((a) => a.name.like('%$activityName%')))
        .get();

    return result.map((a) => a.name).toList();
  }

  @override
  Future<List<String>> searchTags(String tag) async {
    final result = await () async {
      if (tag.isEmpty) {
        // get all tags
        return await (select(activities)..where((a) => a.tags.isNotNull()))
            .get();
      } else {
        return await (select(activities)..where((a) => a.tags.like('%$tag%')))
            .get();
      }
    }();

    final List<String> out = [];
    for (final a in result) {
      final tags = a.tags!.split(';');
      for (final t in tags) {
        if (tag.isNotEmpty && t.startsWith(tag) || tag.isEmpty) out.add('#$t');
      }
    }
    return out;
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

    _removeDuplicatesRecords();

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

    _removeDuplicatesRecords();
    return;
  }

  @override
  Stream<List<DriftActivityModel>> mostCommonActivities(int amount) {
    final query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..groupBy([records.activityName])
      ..orderBy([OrderingTerm.desc(records.activityName.count())])
      ..limit(amount);

    return query
        .watch()
        .map((event) => event.map((e) => e.readTable(activities)).toList());
  }

  Future<DriftRecordModel?> _findFirstRecord(int from, [String? name]) async {
    // find record with startTime closest to [from],
    // this would be the first record because endTime of it would be in range
    final query = select(records).join([
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

    if (name != null) query.where(records.activityName.equals(name));

    return await query.map((r) => r.readTable(records)).getSingleOrNull();
  }

  Future _removeDuplicatesRecords() async {
    final last100 = (select(records)
          ..orderBy([
            (r) => OrderingTerm(
                  expression: r.startTime,
                  mode: OrderingMode.desc,
                )
          ])
          ..limit(100))
        .get();

    last100.then((list) {
      for (int i = 0; i < list.length; i++) {
        try {
          if (list[i + 1].activityName == list[i].activityName) {
            // if there are two activities with the same name next to each other,
            // delete the record with the larger startTime
            (delete(records)
                  ..where((r) => r.idRecord.equals(list[i + 1].idRecord)))
                .go();
          }
        } on RangeError catch (_) {}
      }
    });
  }

  Future<DriftRecordModel> _getRecordModel(int id) {
    return (select(records)..where((r) => r.idRecord.equals(id))).getSingle();
  }

  Future<DriftActivityModel> _getActivityModel(String name) {
    return (select(activities)..where((a) => a.name.equals(name))).getSingle();
  }

  @override
  Future<int?> findEndTimeFor(int startTime) async {
    final nextRecord = await (select(records)
          ..where((r) => r.startTime.isBiggerThanValue(startTime))
          ..limit(1)
          ..orderBy([
            (r) => OrderingTerm(expression: r.startTime, mode: OrderingMode.asc)
          ]))
        .getSingleOrNull();

    return nextRecord?.startTime;
  }
}

Future<File> dbFile() async {
  try {
    final documentsFolder = await getApplicationDocumentsDirectory();
    final file = File(
      path.join(
        documentsFolder.path,
        Constants.appFolderName,
        'activities.sqlite',
      ),
    );

    return file;
  } on MissingPlatformDirectoryException {
    return File(
      path.join(
        Directory.current.path,
        Constants.appFolderName,
        'activities.sqlite',
      ),
    );
  }
}

class RecordWithActivitySettings {
  RecordWithActivitySettings(this.record, this.activity);

  final DriftActivityModel activity;
  final DriftRecordModel record;
}

LazyDatabase _openConnection() =>
    LazyDatabase(() async => NativeDatabase(await dbFile()));
