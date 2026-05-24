import 'package:drift/drift.dart';
import 'package:taleemmate/core/models/tutor/tutor_message.dart';
import 'package:taleemmate/core/models/tutor/tutor_settings.dart';

import '../converters.dart';
import 'subjects_table.dart';

@DataClassName('TutorConversationRow')
class TutorConversations extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get topicId =>
      text().references(Topics, #id).nullable()();
  TextColumn get title => text().nullable()();
  IntColumn get groundedSourceCount => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastMessageAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TutorMessageRow')
class TutorMessages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId =>
      text().references(TutorConversations, #id)();
  TextColumn get sender =>
      text().map(EnumConverter<MessageSender>(MessageSender.values))();
  TextColumn get content => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get followUpPoints =>
      text().map(const FollowUpPointsConverter())();
  TextColumn get citations => text().map(const CitationsConverter())();
  TextColumn get kickerQuestion => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TutorSettingsRow')
class TutorSettingsTable extends Table {
  @override
  String get tableName => 'tutor_settings';

  TextColumn get userId => text()();
  BoolColumn get showCitationsOnEveryReply =>
      boolean().withDefault(const Constant(true))();
  TextColumn get scope =>
      text().map(EnumConverter<TutorScope>(TutorScope.values))();
  TextColumn get reasoningDepth =>
      text().map(EnumConverter<ReasoningDepth>(ReasoningDepth.values))();

  @override
  Set<Column> get primaryKey => {userId};
}
