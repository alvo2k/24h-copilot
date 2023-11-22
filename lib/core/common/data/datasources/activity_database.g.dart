// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_database.dart';

// ignore_for_file: type=lint
class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, DriftActivityModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<int> goal = GeneratedColumn<int>(
      'goal', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name, color, tags, goal, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(Insertable<DriftActivityModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    if (data.containsKey('goal')) {
      context.handle(
          _goalMeta, goal.isAcceptableOrUnknown(data['goal']!, _goalMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  DriftActivityModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftActivityModel(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
      goal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goal']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class DriftActivityModel extends DataClass
    implements Insertable<DriftActivityModel> {
  final String name;
  final int color;
  final String? tags;
  final int? goal;
  final int amount;
  const DriftActivityModel(
      {required this.name,
      required this.color,
      this.tags,
      this.goal,
      required this.amount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || goal != null) {
      map['goal'] = Variable<int>(goal);
    }
    map['amount'] = Variable<int>(amount);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      name: Value(name),
      color: Value(color),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      goal: goal == null && nullToAbsent ? const Value.absent() : Value(goal),
      amount: Value(amount),
    );
  }

  factory DriftActivityModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftActivityModel(
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      tags: serializer.fromJson<String?>(json['tags']),
      goal: serializer.fromJson<int?>(json['goal']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'tags': serializer.toJson<String?>(tags),
      'goal': serializer.toJson<int?>(goal),
      'amount': serializer.toJson<int>(amount),
    };
  }

  DriftActivityModel copyWith(
          {String? name,
          int? color,
          Value<String?> tags = const Value.absent(),
          Value<int?> goal = const Value.absent(),
          int? amount}) =>
      DriftActivityModel(
        name: name ?? this.name,
        color: color ?? this.color,
        tags: tags.present ? tags.value : this.tags,
        goal: goal.present ? goal.value : this.goal,
        amount: amount ?? this.amount,
      );
  @override
  String toString() {
    return (StringBuffer('DriftActivityModel(')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('tags: $tags, ')
          ..write('goal: $goal, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, color, tags, goal, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftActivityModel &&
          other.name == this.name &&
          other.color == this.color &&
          other.tags == this.tags &&
          other.goal == this.goal &&
          other.amount == this.amount);
}

class ActivitiesCompanion extends UpdateCompanion<DriftActivityModel> {
  final Value<String> name;
  final Value<int> color;
  final Value<String?> tags;
  final Value<int?> goal;
  final Value<int> amount;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.tags = const Value.absent(),
    this.goal = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String name,
    required int color,
    this.tags = const Value.absent(),
    this.goal = const Value.absent(),
    required int amount,
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        color = Value(color),
        amount = Value(amount);
  static Insertable<DriftActivityModel> custom({
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? tags,
    Expression<int>? goal,
    Expression<int>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (tags != null) 'tags': tags,
      if (goal != null) 'goal': goal,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith(
      {Value<String>? name,
      Value<int>? color,
      Value<String?>? tags,
      Value<int?>? goal,
      Value<int>? amount,
      Value<int>? rowid}) {
    return ActivitiesCompanion(
      name: name ?? this.name,
      color: color ?? this.color,
      tags: tags ?? this.tags,
      goal: goal ?? this.goal,
      amount: amount ?? this.amount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (goal.present) {
      map['goal'] = Variable<int>(goal.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('tags: $tags, ')
          ..write('goal: $goal, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordsTable extends Records
    with TableInfo<$RecordsTable, DriftRecordModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idRecordMeta =
      const VerificationMeta('idRecord');
  @override
  late final GeneratedColumn<int> idRecord = GeneratedColumn<int>(
      'id_record', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _activityNameMeta =
      const VerificationMeta('activityName');
  @override
  late final GeneratedColumn<String> activityName = GeneratedColumn<String>(
      'activity_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES activities (name)'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [idRecord, activityName, startTime, emoji];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records';
  @override
  VerificationContext validateIntegrity(Insertable<DriftRecordModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_record')) {
      context.handle(_idRecordMeta,
          idRecord.isAcceptableOrUnknown(data['id_record']!, _idRecordMeta));
    }
    if (data.containsKey('activity_name')) {
      context.handle(
          _activityNameMeta,
          activityName.isAcceptableOrUnknown(
              data['activity_name']!, _activityNameMeta));
    } else if (isInserting) {
      context.missing(_activityNameMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idRecord};
  @override
  DriftRecordModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftRecordModel(
      idRecord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_record'])!,
      activityName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}activity_name'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji']),
    );
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(attachedDatabase, alias);
  }
}

class DriftRecordModel extends DataClass
    implements Insertable<DriftRecordModel> {
  final int idRecord;
  final String activityName;
  final int startTime;
  final String? emoji;
  const DriftRecordModel(
      {required this.idRecord,
      required this.activityName,
      required this.startTime,
      this.emoji});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_record'] = Variable<int>(idRecord);
    map['activity_name'] = Variable<String>(activityName);
    map['start_time'] = Variable<int>(startTime);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      idRecord: Value(idRecord),
      activityName: Value(activityName),
      startTime: Value(startTime),
      emoji:
          emoji == null && nullToAbsent ? const Value.absent() : Value(emoji),
    );
  }

  factory DriftRecordModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftRecordModel(
      idRecord: serializer.fromJson<int>(json['idRecord']),
      activityName: serializer.fromJson<String>(json['activityName']),
      startTime: serializer.fromJson<int>(json['startTime']),
      emoji: serializer.fromJson<String?>(json['emoji']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idRecord': serializer.toJson<int>(idRecord),
      'activityName': serializer.toJson<String>(activityName),
      'startTime': serializer.toJson<int>(startTime),
      'emoji': serializer.toJson<String?>(emoji),
    };
  }

  DriftRecordModel copyWith(
          {int? idRecord,
          String? activityName,
          int? startTime,
          Value<String?> emoji = const Value.absent()}) =>
      DriftRecordModel(
        idRecord: idRecord ?? this.idRecord,
        activityName: activityName ?? this.activityName,
        startTime: startTime ?? this.startTime,
        emoji: emoji.present ? emoji.value : this.emoji,
      );
  @override
  String toString() {
    return (StringBuffer('DriftRecordModel(')
          ..write('idRecord: $idRecord, ')
          ..write('activityName: $activityName, ')
          ..write('startTime: $startTime, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idRecord, activityName, startTime, emoji);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftRecordModel &&
          other.idRecord == this.idRecord &&
          other.activityName == this.activityName &&
          other.startTime == this.startTime &&
          other.emoji == this.emoji);
}

class RecordsCompanion extends UpdateCompanion<DriftRecordModel> {
  final Value<int> idRecord;
  final Value<String> activityName;
  final Value<int> startTime;
  final Value<String?> emoji;
  const RecordsCompanion({
    this.idRecord = const Value.absent(),
    this.activityName = const Value.absent(),
    this.startTime = const Value.absent(),
    this.emoji = const Value.absent(),
  });
  RecordsCompanion.insert({
    this.idRecord = const Value.absent(),
    required String activityName,
    required int startTime,
    this.emoji = const Value.absent(),
  })  : activityName = Value(activityName),
        startTime = Value(startTime);
  static Insertable<DriftRecordModel> custom({
    Expression<int>? idRecord,
    Expression<String>? activityName,
    Expression<int>? startTime,
    Expression<String>? emoji,
  }) {
    return RawValuesInsertable({
      if (idRecord != null) 'id_record': idRecord,
      if (activityName != null) 'activity_name': activityName,
      if (startTime != null) 'start_time': startTime,
      if (emoji != null) 'emoji': emoji,
    });
  }

  RecordsCompanion copyWith(
      {Value<int>? idRecord,
      Value<String>? activityName,
      Value<int>? startTime,
      Value<String?>? emoji}) {
    return RecordsCompanion(
      idRecord: idRecord ?? this.idRecord,
      activityName: activityName ?? this.activityName,
      startTime: startTime ?? this.startTime,
      emoji: emoji ?? this.emoji,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idRecord.present) {
      map['id_record'] = Variable<int>(idRecord.value);
    }
    if (activityName.present) {
      map['activity_name'] = Variable<String>(activityName.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsCompanion(')
          ..write('idRecord: $idRecord, ')
          ..write('activityName: $activityName, ')
          ..write('startTime: $startTime, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }
}

abstract class _$ActivityDatabase extends GeneratedDatabase {
  _$ActivityDatabase(QueryExecutor e) : super(e);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $RecordsTable records = $RecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [activities, records];
}
