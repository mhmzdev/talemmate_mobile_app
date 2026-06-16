import 'package:drift/drift.dart';
import 'package:taleemmate/core/models/subject/topic.dart';

import '../converters.dart';

@DataClassName('SubjectRow')
class Subjects extends Table {
  TextColumn get id => text()();

  /// Owning user — subjects are per-account (ADR-014). Defaulted to '' so the
  /// v3→v4 `addColumn` migration is non-breaking; pre-existing rows orphan
  /// (match no real uid) rather than leaking across accounts.
  TextColumn get userId => text().withDefault(const Constant(''))();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get colorHex => text()();
  RealColumn get confidenceLevel => real()();
  IntColumn get order => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TopicRow')
class Topics extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get name => text()();
  IntColumn get masteryPercentage => integer()();
  TextColumn get trend =>
      text().map(const EnumConverter<TrendType>(TrendType.values))();
  BoolColumn get isWeak => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExamRow')
class Exams extends Table {
  TextColumn get id => text()();

  /// Owning user — scoped alongside [Subjects] (ADR-014). See the note there.
  TextColumn get userId => text().withDefault(const Constant(''))();
  TextColumn get subjectId => text().references(Subjects, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get label => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
