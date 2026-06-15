part of '../database.dart';

@DriftAccessor(tables: [TutorConversations, TutorMessages, TutorSettingsTable])
class TutorDao extends DatabaseAccessor<AppDatabase> with _$TutorDaoMixin {
  TutorDao(super.db);

  Stream<List<TutorConversationRow>> watchByUser(String userId) =>
      (select(tutorConversations)
            ..where((c) => c.userId.equals(userId))
            ..orderBy([(c) => OrderingTerm.desc(c.lastMessageAt)]))
          .watch();

  Stream<List<TutorMessageRow>> watchMessages(String conversationId) =>
      (select(tutorMessages)
            ..where((m) => m.conversationId.equals(conversationId))
            ..orderBy([(m) => OrderingTerm.asc(m.timestamp)]))
          .watch();

  Future<TutorSettingsRow?> settingsForUser(String userId) => (select(
    tutorSettingsTable,
  )..where((s) => s.userId.equals(userId))).getSingleOrNull();

  Future<void> upsertConversation(TutorConversationsCompanion companion) =>
      into(tutorConversations).insertOnConflictUpdate(companion);

  Future<void> insertMessage(TutorMessagesCompanion companion) =>
      into(tutorMessages).insertOnConflictUpdate(companion);

  Future<void> upsertSettings(TutorSettingsTableCompanion companion) =>
      into(tutorSettingsTable).insertOnConflictUpdate(companion);

  /// Deletes a conversation and its messages in one transaction (messages
  /// first — the FK has no cascade and `foreign_keys` is ON).
  Future<void> deleteConversation(String conversationId) =>
      transaction(() async {
        await (delete(
          tutorMessages,
        )..where((m) => m.conversationId.equals(conversationId))).go();
        await (delete(
          tutorConversations,
        )..where((c) => c.id.equals(conversationId))).go();
      });
}
