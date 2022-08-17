import 'package:copilot/features/activities/data/models/activity_model.dart';
import 'package:drift/drift.dart';

//part 'tables.g.dart';

@DataClassName('DriftRecordModel')
class Records extends Table {
  IntColumn get idRecord => integer().named(ActivityModel.colIdRecord).autoIncrement()();

  IntColumn get idActivity => integer().named(ActivityModel.colIdActivity).references(Activities, #idActivity)();

  IntColumn get startTime => integer().named(ActivityModel.colStartTime)();

  IntColumn get endTime => integer().named(ActivityModel.colEndTime).nullable()();

  TextColumn get emoji => text().named(ActivityModel.colEmoji).nullable()();
}

@DataClassName('DriftActivityModel')
class Activities extends Table {
  IntColumn get idActivity => integer().named(ActivityModel.colIdActivity).autoIncrement()();

  TextColumn get name => text().named(ActivityModel.colName).unique()();

  IntColumn get color => integer().named(ActivityModel.colColor)();

  TextColumn get tags => text().named(ActivityModel.colTags).nullable()();

  IntColumn get goal => integer().named(ActivityModel.colGoal).nullable()();
}