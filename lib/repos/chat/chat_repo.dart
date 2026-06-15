import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/repos/material/material_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:taleemmate/services/firebase/ai/ai_service.dart';
import 'package:taleemmate/services/firebase/ai/system_prompts.dart';
import 'package:uuid/uuid.dart';

part 'chat_mocks.dart';
part 'chat_parser.dart';
part 'chat_data_provider.dart';

/// Grounded-tutor business logic (ADR-013): public methods take/return
/// `Map`/`List<Map>`/primitives only — `ChatCubit` does the `Tutor*.fromJson`
/// conversion. Wraps the shared `AiService` chat model, the per-subject
/// grounding source (`MaterialRepo`), and Drift persistence (`AppDatabase`).
class ChatRepo {
  static final ChatRepo _instance = ChatRepo._();
  ChatRepo._();

  static ChatRepo get ins => _instance;

  /// --- repo functions --- ///

  /// Live per-user conversation list (newest first).
  Stream<List<Map<String, dynamic>>> watchConversations(String userId) =>
      _ChatProvider.watchConversations(userId);

  /// Live message list for a conversation (oldest first).
  Stream<List<Map<String, dynamic>>> watchMessages(String conversationId) =>
      _ChatProvider.watchMessages(conversationId);

  /// Creates + persists an empty conversation for [subjectId]; returns its map.
  Future<Map<String, dynamic>> createConversation(
    String userId,
    String subjectId,
  ) => _ChatProvider.createConversation(userId, subjectId);

  /// Builds the grounded prompt, calls Gemini single-shot, persists the user
  /// turn + AI turn, updates the conversation row, and returns the AI message
  /// map. Throws a [Fault] on failure.
  Future<Map<String, dynamic>> send({
    required Map<String, dynamic> conversation,
    required List<Map<String, dynamic>> history,
    required String userText,
    Map<String, dynamic>? settings,
  }) => _ChatProvider.send(
    conversation: conversation,
    history: history,
    userText: userText,
    settings: settings,
  );

  /// Permanently deletes a conversation and its messages.
  Future<void> deleteConversation(String conversationId) =>
      _ChatProvider.deleteConversation(conversationId);

  /// The user's tutor settings map, or null if never saved.
  Future<Map<String, dynamic>?> settings(String userId) =>
      _ChatProvider.settings(userId);

  /// Upserts the user's tutor settings from a `TutorSettings.toJson()` map.
  Future<void> saveSettings(Map<String, dynamic> values) =>
      _ChatProvider.saveSettings(values);
}
