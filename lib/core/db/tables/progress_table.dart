import 'package:drift/drift.dart';

import 'subjects_table.dart';

@DataClassName('ProgressMetricRow')
class ProgressMetrics extends Table {
  TextColumn get userId => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  IntColumn get readinessScore => integer()();
  DateTimeColumn get lastUpdatedAt => dateTime()();
  IntColumn get predictedScoreMin => integer().nullable()();
  IntColumn get predictedScoreMax => integer().nullable()();
  IntColumn get weeklyGain => integer().nullable()();
  TextColumn get aiInsight => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId, subjectId};
}

@DataClassName('StudyStreakRow')
class StudyStreaks extends Table {
  TextColumn get userId => text()();
  IntColumn get dayCount => integer()();
  DateTimeColumn get lastStudiedDate => dateTime()();
  DateTimeColumn get startDate => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('DailyScoreRow')
class DailyScores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get score => integer()();
  TextColumn get topicId => text().references(Topics, #id).nullable()();
}

@DataClassName('SessionMetricRow')
class SessionMetrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  IntColumn get durationMinutes => integer()();
  TextColumn get topicIds => text()();
}
