part of 'quiz_repo.dart';

/// Soft character budget for the grounding block — mirrors the chat agent so a
/// quiz grounded on a material stays well inside the model's context window.
const _groundingCharBudget = 12000;

/// Quiz length by scope: a single material gets a focused [_materialQuestions];
/// a broader quiz (a subset of materials or the whole subject) gets the longer
/// [_subjectQuestions].
const _materialQuestions = 8;
const _subjectQuestions = 15;

class _QuizProvider {
  static const _uuid = Uuid();

  /// See [QuizRepo.generate].
  static Future<Map<String, dynamic>> generate({
    required String userId,
    required String subjectId,
    String? topicId,
    List<String>? sourceItemIds,
  }) async {
    try {
      // 1. Inputs.
      final subject = await AppDatabase.ins.subjectById(subjectId);
      if (subject == null) {
        throw UnknownFault(
          'Couldn\'t find that subject. Please try again.',
          StackTrace.current,
        );
      }
      final topic = topicId == null
          ? null
          : await AppDatabase.ins.topicById(topicId);

      // 2. Resolve grounding — the chosen materials when launched from Library
      //    (one or a subset), else every indexed material in the subject (the
      //    chat agent's source). [groundedName] is set only for a single source.
      final List<Map<String, dynamic>> texts;
      String? groundedName;
      var groundedCount = 0;
      if (sourceItemIds != null && sourceItemIds.isNotEmpty) {
        final collected = <Map<String, dynamic>>[];
        for (final id in sourceItemIds) {
          final t = await AppDatabase.ins.materialTextForItem(id);
          if (t != null) collected.add(t);
        }
        texts = collected;
        groundedCount = collected.length;
        if (collected.length == 1) {
          groundedName = collected.first['name'] as String?;
        }
      } else {
        texts = await AppDatabase.ins.materialTextsForSubject(
          userId,
          subjectId,
        );
      }
      final grounding = _groundingBlock(texts);

      // 3. Build the user turn + 4. single-shot structured call. A single
      //    material gets a focused quiz; a subset or the whole subject is
      //    broader, so it gets more questions.
      final isSingleMaterial =
          sourceItemIds != null && sourceItemIds.length == 1;
      final count = isSingleMaterial ? _materialQuestions : _subjectQuestions;
      final userTurn = _userTurn(
        subject: subject,
        topic: topic,
        grounding: grounding,
        count: count,
      );
      final model = AiService.ins.quizModel(await SystemPrompts.quiz());
      final res = await model.generateContent([Content.text(userTurn)]);

      // 5. Parse → QuizQuestion maps (drop malformed entries).
      final decoded = _decode(res.text);
      final quizId = _uuid.v4();
      final questions = <Map<String, dynamic>>[];
      for (final raw in (decoded['questions'] as List? ?? const [])) {
        final q = raw as Map<String, dynamic>;
        final options = (q['options'] as List?)
            ?.map((e) => e.toString())
            .toList();
        final correct = (q['correctAnswerIndex'] as num?)?.toInt();
        final text = (q['text'] as String?)?.trim();
        // A valid single-answer MCQ needs a stem, ≥2 options and an in-range
        // correct index — skip anything the model returned half-formed.
        if (text == null ||
            text.isEmpty ||
            options == null ||
            options.length < 2 ||
            correct == null ||
            correct < 0 ||
            correct >= options.length) {
          continue;
        }
        questions.add({
          'id': _uuid.v4(),
          'quizId': quizId,
          'index': questions.length,
          'text': text,
          'type': QuestionType.singleAnswer.name,
          'markValue': 1,
          'options': options,
          'correctAnswerIndex': correct,
          'timeLimit': null,
          'explanation': (q['explanation'] as String?)?.trim(),
          'citation': (q['citation'] as String?)?.trim(),
        });
      }
      if (questions.isEmpty) {
        throw const FormatException('No usable questions in the quiz response');
      }

      // 6. Compute the source label (prefer the model's, else a sensible one).
      final modelLabel = (decoded['sourceLabel'] as String?)?.trim();
      final fallbackLabel = groundedName != null
          ? 'Generated from $groundedName'
          : groundedCount > 1
          ? 'Generated from $groundedCount materials'
          : [
              subject['name'] as String? ?? 'Quiz',
              if (topic != null) topic['name'] as String?,
            ].whereType<String>().join(' · ');
      final sourceLabel = (modelLabel != null && modelLabel.isNotEmpty)
          ? modelLabel
          : fallbackLabel;

      // 7. Persist (quiz row + its questions in one txn).
      final quiz = <String, dynamic>{
        'id': quizId,
        'subjectId': subjectId,
        'topicId': topicId,
        'currentQuestionIndex': 0,
        'sourceLabel': sourceLabel,
        'isAIGenerated': true,
      };
      await AppDatabase.ins.replaceQuizQuestions(quiz, questions);

      // 8. Return a Quiz.toJson()-shaped map for the cubit to hydrate.
      return {...quiz, 'questions': questions};
    } on Fault {
      rethrow;
    } on FirebaseAIException catch (e, st) {
      throw AiFault.fromAiException(e, st);
    } on FormatException catch (e, st) {
      throw UnknownFault('Couldn\'t read the quiz. Please try again.', st);
    } catch (e, st) {
      throw UnknownFault('Couldn\'t build your quiz. Please try again.', st);
    }
  }

  /// See [QuizRepo.recordAnswer]. Best-effort — answering must not block, so the
  /// cubit fires this and ignores failures.
  static Future<void> recordAnswer(Map<String, dynamic> attempt) async {
    try {
      await AppDatabase.ins.insertQuizAttempt(attempt);
    } on Fault {
      rethrow;
    } catch (e, st) {
      throw UnknownFault('Couldn\'t record the answer.', st);
    }
  }

  /// See [QuizRepo.quiz].
  static Future<Map<String, dynamic>?> quiz(String quizId) async {
    try {
      return await AppDatabase.ins.quizById(quizId);
    } catch (e, st) {
      throw UnknownFault('Couldn\'t load the quiz.', st);
    }
  }

  // --- prompt assembly ----------------------------------------------------

  /// Joins the grounding texts into one block, each chunk tagged `[itemId |
  /// name]` so the model can cite by name. Clipped to budget. Mirrors chat.
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

  static String _userTurn({
    required Map<String, dynamic> subject,
    required Map<String, dynamic>? topic,
    required String grounding,
    required int count,
  }) {
    final name = subject['name'] as String? ?? 'this subject';
    final confidence =
        (subject['confidenceLevel'] as num?)?.toDouble() ?? 0.5;
    final topicLine = topic == null
        ? 'TOPIC: (none — cover the subject broadly)'
        : 'TOPIC: ${topic['name']}';
    final block = grounding.isEmpty
        ? 'GROUNDING: (none — write from your own subject/topic knowledge; '
              'do not add any citation)'
        : 'GROUNDING:\n$grounding';
    return '''
SUBJECT: $name (confidence=${confidence.toStringAsFixed(2)} — lower = weaker → easier/foundational questions)
$topicLine

$block

COUNT: $count

LANGUAGE: Write every question, option and explanation in the language the
student studies in — infer it from the SUBJECT and TOPIC names above (English /
Urdu / Roman Urdu). Do NOT take the language from the grounding materials.

Produce the quiz as JSON exactly per the provided schema.''';
  }

  static Map<String, dynamic> _decode(String? text) {
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('Empty AI response');
    }
    return jsonDecode(text) as Map<String, dynamic>;
  }
}
