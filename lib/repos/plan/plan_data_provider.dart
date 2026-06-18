part of 'plan_repo.dart';

class _PlanProvider {
  static const _uuid = Uuid();

  static Stream<List<Map<String, dynamic>>> watchBlocks(String scheduleId) =>
      AppDatabase.ins.watchStudyBlocks(scheduleId);

  static Future<Map<String, dynamic>?> currentSchedule(String userId) async {
    try {
      return await AppDatabase.ins.scheduleForUser(userId);
    } catch (e, st) {
      throw UnknownFault('Could not load your study plan.', st);
    }
  }

  static Future<List<Map<String, dynamic>>> exams(String userId) async {
    try {
      return await AppDatabase.ins.examsForUser(userId);
    } catch (e, st) {
      throw UnknownFault('Could not load your exams.', st);
    }
  }

  /// See [PlanRepo.updateBlock]. Parses the patch and writes only the changed
  /// columns. `status` arrives as a `BlockStatus.name`; `date` as ISO-8601.
  static Future<void> updateBlock(Map<String, dynamic> patch) async {
    try {
      final id = patch['id'] as String;
      final dateStr = patch['date'] as String?;
      await AppDatabase.ins.updateStudyBlock(
        id,
        startTime: patch['startTime'] as String?,
        durationMinutes: (patch['durationMinutes'] as num?)?.toInt(),
        date: dateStr == null ? null : DateTime.parse(dateStr),
        status: patch['status'] as String?,
      );
    } on Fault {
      rethrow;
    } catch (e, st) {
      throw UnknownFault('Couldn\'t update the block. Please try again.', st);
    }
  }

  /// See [PlanRepo.recordSession].
  static Future<void> recordSession(Map<String, dynamic> metric) async {
    try {
      final dateStr = metric['date'] as String?;
      await AppDatabase.ins.recordSessionMetric(
        userId: metric['userId'] as String,
        date: dateStr == null ? DateTime.now() : DateTime.parse(dateStr),
        durationMinutes: (metric['durationMinutes'] as num?)?.toInt() ?? 0,
        topicIds:
            (metric['topicIds'] as List?)?.whereType<String>().toList() ??
            const <String>[],
      );
    } on Fault {
      rethrow;
    } catch (e, st) {
      throw UnknownFault('Couldn\'t record the session.', st);
    }
  }

  /// See [PlanRepo.updateReasoning]. Loads the current plan context, asks the
  /// narrow reasoning model for a fresh paragraph, persists it, and returns it.
  static Future<String> updateReasoning(String userId) async {
    try {
      final schedule = await AppDatabase.ins.scheduleForUser(userId);
      if (schedule == null) {
        throw UnknownFault(
          'No schedule found. Please finish onboarding first.',
          StackTrace.current,
        );
      }
      final scheduleId = schedule['id'] as String;
      final subjects = await AppDatabase.ins.subjectsForUser(userId);
      final exams = await AppDatabase.ins.examsForUser(userId);
      final blocks = await AppDatabase.ins.watchStudyBlocks(scheduleId).first;

      final turn = _reasonTurn(
        subjects: subjects,
        exams: exams,
        blocks: blocks,
        today: DateTime.now(),
      );
      final model = AiService.ins.reasonModel(await SystemPrompts.reason());
      final res = await model.generateContent([Content.text(turn)]);

      final decoded = _decode(res.text);
      final reasoning = (decoded['aiReasoning'] as String?)?.trim();
      if (reasoning == null || reasoning.isEmpty) {
        throw const FormatException('Empty reasoning response');
      }
      await AppDatabase.ins.updateScheduleReasoning(scheduleId, reasoning);
      return reasoning;
    } on Fault {
      rethrow;
    } on FirebaseAIException catch (e, st) {
      throw AiFault.fromAiException(e, st);
    } on FormatException catch (e, st) {
      throw UnknownFault('Couldn\'t refresh the reasoning.', st);
    } catch (e, st) {
      throw UnknownFault('Couldn\'t refresh the reasoning.', st);
    }
  }

  /// See [PlanRepo.generate].
  static Future<Map<String, dynamic>> generate(String userId) async {
    try {
      // 1. Inputs.
      final schedule = await AppDatabase.ins.scheduleForUser(userId);
      if (schedule == null) {
        throw UnknownFault(
          'No schedule found. Please finish onboarding first.',
          StackTrace.current,
        );
      }
      final scheduleId = schedule['id'] as String;
      final subjects = await AppDatabase.ins.subjectsForUser(userId);
      final exams = await AppDatabase.ins.examsForUser(userId);

      // 2. Resolve enabled windows from the shared catalogue.
      final enabledIds =
          (schedule['enabledWindowIds'] as List?)?.cast<String>() ??
          const <String>[];
      final windows = kStudyWindowCatalog
          .where((w) => enabledIds.contains(w.id))
          .toList();

      // 3. Assemble the user turn + 4. single-shot structured call.
      final today = DateTime.now();
      final userTurn = _userTurn(
        schedule: schedule,
        subjects: subjects,
        exams: exams,
        windows: windows,
        today: today,
      );
      final model = AiService.ins.planModel(await SystemPrompts.plan());
      final res = await model.generateContent([Content.text(userTurn)]);

      // 5. Parse → StudyBlock maps (drop blocks with unknown subject ids).
      final decoded = _decode(res.text);
      final aiReasoning = decoded['aiReasoning'] as String?;
      final validSubjectIds = subjects.map((s) => s['id'] as String).toSet();

      final blocks = <Map<String, dynamic>>[];
      final days = <Map<String, dynamic>>[];
      for (final rawDay in (decoded['days'] as List? ?? const [])) {
        final dayMap = rawDay as Map<String, dynamic>;
        final date = DateTime.tryParse(dayMap['date'] as String? ?? '');
        if (date == null) continue;
        final dayBlocks = <Map<String, dynamic>>[];
        for (final rawBlock in (dayMap['blocks'] as List? ?? const [])) {
          final b = rawBlock as Map<String, dynamic>;
          final subjectId = b['subjectId'] as String?;
          if (subjectId == null || !validSubjectIds.contains(subjectId)) {
            continue;
          }
          final block = <String, dynamic>{
            'id': _uuid.v4(),
            'scheduleId': scheduleId,
            'dayOfWeek': date.weekday,
            'date': date.toIso8601String(),
            'startTime': b['startTime'] as String? ?? '',
            'durationMinutes': (b['durationMinutes'] as num?)?.toInt() ?? 30,
            'subjectId': subjectId,
            'topicId': null,
            'title': b['title'] as String? ?? '',
            'activities': b['activities'] as String? ?? '',
            'status': 'upcoming',
            'aiInsight': b['aiInsight'] as String?,
            'isAIGenerated': true,
          };
          blocks.add(block);
          dayBlocks.add(block);
        }
        days.add({
          'date': date.toIso8601String(),
          'blocks': dayBlocks,
          'exam': null,
          'isDone': false,
        });
      }

      // 6. Persist (replace prior week + store the reasoning).
      await AppDatabase.ins.replaceStudyBlocks(scheduleId, blocks);
      if (aiReasoning != null && aiReasoning.trim().isNotEmpty) {
        await AppDatabase.ins.updateScheduleReasoning(scheduleId, aiReasoning);
      }

      // 7. Return a WeekPlan.toJson()-shaped map.
      final start = DateTime(today.year, today.month, today.day);
      return {
        'id': scheduleId,
        'scheduleId': scheduleId,
        'startDate': start.toIso8601String(),
        'endDate': start.add(const Duration(days: 6)).toIso8601String(),
        'days': days,
        'aiReasoning': aiReasoning,
      };
    } on Fault {
      rethrow;
    } on FirebaseAIException catch (e, st) {
      throw AiFault.fromAiException(e, st);
    } on FormatException catch (e, st) {
      throw UnknownFault('Couldn\'t read the plan. Please try again.', st);
    } catch (e, st) {
      throw UnknownFault('Couldn\'t build your plan. Please try again.', st);
    }
  }

  // --- prompt assembly ----------------------------------------------------

  static String _userTurn({
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> subjects,
    required List<Map<String, dynamic>> exams,
    required List<StudyWindow> windows,
    required DateTime today,
  }) {
    String day(DateTime d) => d.toIso8601String().split('T').first;

    final subjLines = subjects.isEmpty
        ? '(none)'
        : subjects.map((s) {
            final conf = (s['confidenceLevel'] as num?)?.toDouble() ?? 0.5;
            return '- id=${s['id']} | ${s['name']} | '
                'confidence=${conf.toStringAsFixed(2)}';
          }).join('\n');

    final examLines = exams.isEmpty
        ? '(none)'
        : exams.map((e) {
            final date = DateTime.tryParse(e['date'] as String? ?? '');
            final daysUntil = date == null
                ? '?'
                : date.difference(today).inDays.toString();
            return '- subjectId=${e['subjectId']} | '
                'date=${date == null ? '?' : day(date)} | '
                'daysUntil=$daysUntil';
          }).join('\n');

    final windowLines = windows.isEmpty
        ? '(none configured — pick reasonable daytime study hours)'
        : windows
              .map((w) => '- ${w.id} | ${w.label} | ${w.startTime}-${w.endTime}')
              .join('\n');

    final target = (schedule['dailyTargetHours'] as num?)?.toDouble() ?? 2.0;
    final rangeEnd = today.add(const Duration(days: 6));

    return '''
STUDENT: A student preparing with TaleemMate on a Pakistani curriculum.

SUBJECTS (id | name | confidence 0–1, lower = weaker → more/earlier time):
$subjLines

EXAMS (front-load near-exam subjects):
$examLines

WINDOWS (only schedule blocks INSIDE these time ranges):
$windowLines

DAILY TARGET: ${target.toStringAsFixed(1)} hours per day.

TODAY: ${day(today)}
RANGE: ${day(today)} to ${day(rangeEnd)} (7 days inclusive).

Produce the week plan as JSON exactly per the provided schema.''';
  }

  /// Compact user turn for the reasoning rewrite — the nearest exam plus a
  /// short summary of the remaining blocks. The cubit has already committed the
  /// move, so [blocks] reflects the post-change week.
  static String _reasonTurn({
    required List<Map<String, dynamic>> subjects,
    required List<Map<String, dynamic>> exams,
    required List<Map<String, dynamic>> blocks,
    required DateTime today,
  }) {
    String day(DateTime d) => d.toIso8601String().split('T').first;

    final names = {for (final s in subjects) s['id'] as String: s['name']};

    final upcoming = exams
        .map((e) => (e, DateTime.tryParse(e['date'] as String? ?? '')))
        .where((p) => p.$2 != null && !p.$2!.isBefore(today))
        .toList()
      ..sort((a, b) => a.$2!.compareTo(b.$2!));
    final nearestExam = upcoming.isEmpty
        ? '(none)'
        : () {
            final (e, date) = upcoming.first;
            return '${names[e['subjectId']] ?? 'a subject'} on ${day(date!)} '
                '(${date.difference(today).inDays} days away)';
          }();

    final future = blocks
        .map((b) => (b, DateTime.tryParse(b['date'] as String? ?? '')))
        .where((p) => p.$2 != null && !p.$2!.isBefore(today))
        .toList()
      ..sort((a, b) => a.$2!.compareTo(b.$2!));
    final blockLines = future.isEmpty
        ? '(none remaining)'
        : future
              .take(20)
              .map((p) {
                final b = p.$1;
                return '- ${day(p.$2!)} ${b['startTime']} · '
                    '${names[b['subjectId']] ?? 'Study'} · '
                    '${b['durationMinutes']}min · ${b['title']}';
              })
              .join('\n');

    return '''
TODAY: ${day(today)}

NEAREST EXAM: $nearestExam

THE CHANGE: The student just rescheduled one of their study blocks.

CURRENT BLOCKS (what's still planned):
$blockLines

Rewrite the "Why this plan" paragraph so it still reads true after the change.''';
  }

  static Map<String, dynamic> _decode(String? text) {
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('Empty AI response');
    }
    return jsonDecode(text) as Map<String, dynamic>;
  }
}
