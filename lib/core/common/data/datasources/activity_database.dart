import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../../../core/error/exceptions.dart';
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
  Future<List<DriftActivityModel>> getActivitiesSettings() =>
      select(activities).get();

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
    // if (firstRecord == null) {
    //   // either there are no records or all records are after [from]
    //   return [];
    // }

    // get all records between firstRecord.startTime and [to]
    query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.startTime.isBiggerOrEqualValue(firstRecord?.startTime ?? from))
      ..where(records.startTime.isSmallerThanValue(to))
      ..orderBy([
        OrderingTerm(
          expression: records.startTime,
        )
      ]);

    return query.watch().map((rows) => rows
        .map((row) => RecordWithActivitySettings(
            row.readTable(records), row.readTable(activities)))
        .toList());
  }

  @override
  Future<List<RecordWithActivitySettings>> getRecordsRangeWithTag({
    required int from,
    required int to,
    required String tag,
  }) async {
    // TODO needs some love
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
    if (firstRecord == null) {
      // either there are no records or all records are after [from]
      if (await (select(records)..limit(1)).getSingleOrNull() == null) {
        return [];
      }
      throw CacheException();
    }

    // get all records between firstRecord.startTime and [to] with tag
    query = select(records).join([
      innerJoin(activities, activities.name.equalsExp(records.activityName))
    ])
      ..where(records.startTime.isBiggerOrEqualValue(firstRecord.startTime))
      ..where(records.startTime.isSmallerThanValue(to))
      ..where(activities.tags.like('%$tag%'))
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
  Future<DriftActivityModel> updateActivitySettings({
    required String activityName,
    required String newActivityName,
    required int newColorHex,
    required String? tags,
    required int? newGoal,
  }) async {
    final bool nameChanged = newActivityName != activityName;
    if (nameChanged) {
      // new name shouldn't be already taken
      final exists = await (select(activities)
            ..where((a) => a.name.equals(newActivityName)))
          .getSingleOrNull();
      if (exists != null) throw CacheException();
    }
    final result = await (update(activities)
          ..where((a) => a.name.equals(activityName)))
        .writeReturning(
      ActivitiesCompanion(
        name: Value(newActivityName),
        color: Value(newColorHex),
        tags: Value(tags),
        goal: newGoal == 0 ? const Value(null) : Value(newGoal),
      ),
    );
    if (result.length != 1) throw CacheException();

    if (nameChanged) {
      // change activityName in records
      await (update(records)..where((r) => r.activityName.equals(activityName)))
          .write(RecordsCompanion(activityName: Value(newActivityName)));
    }
    return result[0];
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

  Future _removeDuplicatesRecords() async {
    final last100 = (select(records)
          ..orderBy([
            (r) => OrderingTerm(
                  expression: r.startTime,
                  mode: OrderingMode.asc,
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
                  ..where((r) => r.startTime.equals(list[i + 1].startTime)))
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
}

class RecordWithActivitySettings {
  RecordWithActivitySettings(this.record, this.activity);

  final DriftActivityModel activity;
  final DriftRecordModel record;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    try {
      final documentsFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(
        documentsFolder.path,
        Constants.appFolderName,
        'activities.sqlite',
      ));
      return NativeDatabase(file);
    } on MissingPlatformDirectoryException {
      return NativeDatabase(
        File(path.join(
          Directory.current.path,
          Constants.appFolderName,
          'activities.sqlite',
        )),
      );
    }
  });
}
