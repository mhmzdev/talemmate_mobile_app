import 'package:drift/drift.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';

import '../converters.dart';
import 'subjects_table.dart';

@DataClassName('StudyWindowRow')
class StudyWindows extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScheduleRow')
class Schedules extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get dailyTargetHours => real()();
  TextColumn get enabledWindowIds => text().map(const StringListConverter())();
  DateTimeColumn get weekStartDate => dateTime().nullable()();
  TextColumn get aiReasoning => text().nullable()();
  BoolColumn get isAIGenerated => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StudyBlockRow')
class StudyBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get scheduleId => text().references(Schedules, #id)();
  IntColumn get dayOfWeek => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get startTime => text()();
  IntColumn get durationMinutes => integer()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get topicId => text().references(Topics, #id).nullable()();
  TextColumn get title => text()();
  TextColumn get activities => text()();
  TextColumn get status =>
      text().map(const EnumConverter<BlockStatus>(BlockStatus.values))();
  TextColumn get aiInsight => text().nullable()();
  BoolColumn get isAIGenerated =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
