part of 'chat_repo.dart';

/// Soft character budget for the grounding block injected into each turn —
/// keeps the prompt well under the model's context window while covering the
/// student's materials. Oldest-first; trailing content is clipped.
const _groundingCharBudget = 12000;

class _ChatProvider {
  static const _uuid = Uuid();

  static Stream<List<Map<String, dynamic>>> watchConversations(String userId) =>
      AppDatabase.ins.watchTutorConversations(userId);

  static Stream<List<Map<String, dynamic>>> watchMessages(
    String conversationId,
  ) => AppDatabase.ins.watchTutorMessages(conversationId);

  static Future<Map<String, dynamic>> createConversation(
    String userId,
    String subjectId,
  ) async {
    try {
      final now = DateTime.now();
      final convo = <String, dynamic>{
        'id': _uuid.v4(),
        'userId': userId,
        'subjectId': subjectId,
        'topicId': null,
        'title': null,
        'groundedSourceCount': 0,
        'createdAt': now.toIso8601String(),
        'lastMessageAt': now.toIso8601String(),
        'messages': <Map<String, dynamic>>[],
      };
      await AppDatabase.ins.saveTutorConversation(convo);
      return convo;
    } catch (e, st) {
      throw UnknownFault('Could not start a new conversation.', st);
    }
  }

  /// See [ChatRepo.send].
  static Future<Map<String, dynamic>> send({
    required Map<String, dynamic> conversation,
    required List<Map<String, dynamic>> history,
    required String userText,
    Map<String, dynamic>? settings,
  }) async {
    final conversationId = conversation['id'] as String;
    final userId = conversation['userId'] as String;
    final subjectId = conversation['subjectId'] as String;

    // 1. Persist the user turn immediately (Drift stream shows it at once).
    final userMsg = <String, dynamic>{
      'id': _uuid.v4(),
      'conversationId': conversationId,
      'sender': 'user',
      'text': userText,
      'timestamp': DateTime.now().toIso8601String(),
      'followUpPoints': <Map<String, dynamic>>[],
      'citations': <Map<String, dynamic>>[],
      'kickerQuestion': null,
    };

    try {
      await AppDatabase.ins.saveTutorMessage(userMsg);

      // 2. Gather grounding from the subject's extracted materials.
      final texts = await MaterialRepo.ins.textsForSubject(userId, subjectId);
      final grounding = _groundingBlock(texts);

      // 3. Assemble the conversation for the model: prior turns + new turn.
      final contents = <Content>[
        for (final m in history)
          if (m['sender'] == 'user')
            Content.text(m['text'] as String? ?? '')
          else
            Content.model([TextPart(m['text'] as String? ?? '')]),
        Content.text(_userTurn(grounding, userText, settings)),
      ];

      // 4. Single-shot structured call.
      final model = AiService.ins.chatModel(await SystemPrompts.chat());
      final res = await model.generateContent(contents);
      final reply = _parseReply(res.text);

      // 5. Persist the AI turn.
      final aiMsg = <String, dynamic>{
        'id': _uuid.v4(),
        'conversationId': conversationId,
        'sender': 'ai',
        'text': reply['text'],
        'timestamp': DateTime.now().toIso8601String(),
        'followUpPoints': reply['followUpPoints'],
        'citations': reply['citations'],
        'kickerQuestion': reply['kickerQuestion'],
      };
      await AppDatabase.ins.saveTutorMessage(aiMsg);

      // 6. Update the conversation row (title on first turn, grounding count,
      //    last-activity timestamp).
      final existingTitle = conversation['title'] as String?;
      await AppDatabase.ins.saveTutorConversation({
        ...conversation,
        'title': existingTitle ?? _deriveTitle(userText),
        'groundedSourceCount': texts.length,
        'lastMessageAt': DateTime.now().toIso8601String(),
      });

      return aiMsg;
    } on Fault {
      rethrow;
    } on FirebaseAIException catch (e, st) {
      throw AiFault.fromAiException(e, st);
    } catch (e, st) {
      throw UnknownFault('Couldn\'t get a reply. Please try again.', st);
    }
  }

  static Future<void> deleteConversation(String conversationId) async {
    try {
      await AppDatabase.ins.deleteTutorConversation(conversationId);
    } catch (e, st) {
      throw UnknownFault('Could not delete this conversation.', st);
    }
  }

  static Future<Map<String, dynamic>?> settings(String userId) async {
    try {
      return await AppDatabase.ins.tutorSettings(userId);
    } catch (e, st) {
      throw UnknownFault('Could not load tutor settings.', st);
    }
  }

  static Future<void> saveSettings(Map<String, dynamic> values) async {
    try {
      await AppDatabase.ins.saveTutorSettings(values);
    } catch (e, st) {
      throw UnknownFault('Could not save tutor settings.', st);
    }
  }

  // --- prompt assembly ----------------------------------------------------

  /// Joins the subject's extracted texts into one grounding block, each chunk
  /// tagged `[itemId | name]` so the model can cite by id. Clipped to budget.
  static String _groundingBlock(List<Map<String, dynamic>> texts) {
    if (texts.isEmpty) return '';
    final buf = StringBuffer();
    var used = 0;
    for (final t in texts) {
      if (used >= _groundingCharBudget) break;
      final id = t['itemId'] as String? ?? '';
      final name = t['name'] as String? ?? 'Material';
      final content = t['content'] as String? ?? '';
      final remaining = _groundingCharBudget - used;
      final clipped = content.length > remaining
          ? content.substring(0, remaining)
          : content;
      buf
        ..writeln('[$id | $name]')
        ..writeln(clipped)
        ..writeln();
      used += clipped.length;
    }
    return buf.toString();
  }

  static String _userTurn(
    String grounding,
    String question,
    Map<String, dynamic>? settings,
  ) {
    final block = grounding.isEmpty
        ? 'GROUNDING: (none — the student has not added materials for this subject yet)'
        : 'GROUNDING:\n$grounding';
    final depth = settings?['reasoningDepth'] as String? ?? 'balanced';
    final scope = settings?['scope'] as String?;
    final prefs = StringBuffer('PREFERENCES: reasoningDepth=$depth');
    if (scope != null) prefs.write('; scope=$scope');
    // Language is decided by the QUESTION, never the grounding source — keep this
    // at the end of the turn (highest salience) so a differently-languaged source
    // can't drag the reply off the student's language.
    const language =
        'LANGUAGE: Reply in the SAME language as the QUESTION above — detect '
        'English vs Urdu vs Roman Urdu from the QUESTION, not from the grounding '
        'materials. Use that one language for "text", every "followUpPoints" '
        'entry, and "kickerQuestion".';
    return '$block\n\n$prefs\n\nQUESTION:\n$question\n\n$language';
  }

  /// Parses the model's JSON reply into a `TutorMessage.toJson()`-shaped map.
  /// Citations get a generated `id` (the model omits it).
  static Map<String, dynamic> _parseReply(String? text) {
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('Empty AI response');
    }
    final decoded = jsonDecode(text) as Map<String, dynamic>;
    final citations = ((decoded['citations'] as List?) ?? [])
        .map((c) => {...Map<String, dynamic>.from(c as Map), 'id': _uuid.v4()})
        .toList();
    return {
      'text': decoded['text'] as String? ?? '',
      'followUpPoints': (decoded['followUpPoints'] as List?) ?? [],
      'citations': citations,
      'kickerQuestion': decoded['kickerQuestion'],
    };
  }

  /// First-turn conversation title derived from the opening question.
  static String _deriveTitle(String question) {
    final t = question.trim().replaceAll(RegExp(r'\s+'), ' ');
    return t.length <= 48 ? t : '${t.substring(0, 45)}…';
  }
}
