part of 'progress_repo.dart';

/// How many days of quiz scores / session time the readiness pass considers.
const _readinessWindowDays = 14;

class _ProgressProvider {
  /// See [ProgressRepo.watchMetrics].
  static Stream<List<Map<String, dynamic>>> watchMetrics(String userId) =>
      AppDatabase.ins.watchProgressMetrics(userId);

  /// See [ProgressRepo.dashboardData].
  static Future<Map<String, dynamic>> dashboardData(String userId) async {
    try {
      final streak = await AppDatabase.ins.studyStreakForUser(userId);
      final dailyScores = await AppDatabase.ins.dailyScoresForUser(userId);
      final sessions = await AppDatabase.ins.sessionMetricsForUser(userId);
      final subjects = await AppDatabase.ins.subjectsForUser(userId);
      final exams = await AppDatabase.ins.examsForUser(userId);
      final attempts = await AppDatabase.ins.quizAttemptsForUser(userId);
      final quizCount = attempts.map((a) => a['quizId']).toSet().length;
      return {
        'streak': streak,
        'dailyScores': dailyScores,
        'sessionMetrics': sessions,
        'subjects': subjects,
        'exams': exams,
        'quizCount': quizCount,
        'questionCount': attempts.length,
      };
    } on Fault {
      rethrow;
    } catch (e, st) {
      throw UnknownFault('Couldn\'t load your progress.', st);
    }
  }

  /// See [ProgressRepo.recordQuizScore].
  static Future<void> recordQuizScore({
    required String userId,
    required String subjectId,
    required int score,
    required int total,
    required DateTime date,
  }) async {
    try {
      final pct = total <= 0 ? 0 : ((score / total) * 100).round();
      await AppDatabase.ins.recordDailyScore(
        userId: userId,
        date: date,
        score: pct,
      );
      await recordStudyActivity(userId: userId, date: date);
    } on Fault {
      rethrow;
    } catch (e, st) {
      throw UnknownFault('Couldn\'t record the quiz result.', st);
    }
  }

  /// See [ProgressRepo.recordStudyActivity].
  static Future<void> recordStudyActivity({
    required String userId,
    DateTime? date,
  }) async {
    try {
      final today = date ?? DateTime.now();
      final raw = await AppDatabase.ins.studyStreakForUser(userId);
      final update = computeStreak(
        today: today,
        currentDayCount: raw == null ? null : raw['dayCount'] as int,
        lastStudiedDate: raw == null
            ? null
            : DateTime.parse(raw['lastStudiedDate'] as String),
        startDate: raw == null
            ? null
            : DateTime.parse(raw['startDate'] as String),
      );
      if (!update.changed) return; // already counted today
      await AppDatabase.ins.upsertStudyStreak(
        userId: userId,
        dayCount: update.dayCount,
        lastStudiedDate: DateTime(today.year, today.month, today.day),
        startDate: update.startDate,
      );
    } on Fault {
      rethrow;
    } catch (e, st) {
      throw UnknownFault('Couldn\'t update your streak.', st);
    }
  }

  /// See [ProgressRepo.refreshReadiness]. Loads the recent study context, asks
  /// the readiness model for a per-subject assessment, upserts one
  /// `ProgressMetric` per subject, and returns the global study insight.
  static Future<String?> refreshReadiness(String userId) async {
    try {
      final subjects = await AppDatabase.ins.subjectsForUser(userId);
      if (subjects.isEmpty) return null;

      final since = DateTime.now().subtract(
        const Duration(days: _readinessWindowDays),
      );
      final scores = await AppDatabase.ins.dailyScoresForUser(
        userId,
        since: since,
      );
      final sessions = await AppDatabase.ins.sessionMetricsForUser(
        userId,
        since: since,
      );
      final exams = await AppDatabase.ins.examsForUser(userId);

      final now = DateTime.now();
      final turn = _readinessTurn(
        subjects: subjects,
        scores: scores,
        sessions: sessions,
        exams: exams,
        today: now,
      );
      final model = AiService.ins.progressModel(await SystemPrompts.progress());
      final res = await model.generateContent([Content.text(turn)]);

      final decoded = _decode(res.text);
      final validIds = subjects.map((s) => s['id'] as String).toSet();
      for (final raw in (decoded['subjects'] as List? ?? const [])) {
        final m = raw as Map<String, dynamic>;
        final sid = m['subjectId'] as String?;
        if (sid == null || !validIds.contains(sid)) continue;
        await AppDatabase.ins.upsertProgressMetric({
          'userId': userId,
          'subjectId': sid,
          'readinessScore': (m['readinessScore'] as num?)?.toInt() ?? 0,
          'predictedScoreMin': (m['predictedScoreMin'] as num?)?.toInt(),
          'predictedScoreMax': (m['predictedScoreMax'] as num?)?.toInt(),
          'weeklyGain': (m['weeklyGain'] as num?)?.toInt(),
          'aiInsight': (m['aiInsight'] as String?)?.trim(),
          'lastUpdatedAt': now,
        });
      }
      return (decoded['studyInsight'] as String?)?.trim();
    } on Fault {
      rethrow;
    } on FirebaseAIException catch (e, st) {
      throw AiFault.fromAiException(e, st);
    } on FormatException catch (e, st) {
      throw UnknownFault('Couldn\'t refresh your readiness.', st);
    } catch (e, st) {
      throw UnknownFault('Couldn\'t refresh your readiness.', st);
    }
  }

  // --- prompt assembly ----------------------------------------------------

  static String _readinessTurn({
    required List<Map<String, dynamic>> subjects,
    required List<Map<String, dynamic>> scores,
    required List<Map<String, dynamic>> sessions,
    required List<Map<String, dynamic>> exams,
    required DateTime today,
  }) {
    String day(DateTime d) => d.toIso8601String().split('T').first;

    final subjLines = subjects
        .map((s) {
          final conf = (s['confidenceLevel'] as num?)?.toDouble() ?? 0.5;
          return '- id=${s['id']} | ${s['name']} | '
              'confidence=${conf.toStringAsFixed(2)}';
        })
        .join('\n');

    final examLines = exams.isEmpty
        ? '(none)'
        : exams
              .map((e) {
                final date = DateTime.tryParse(e['date'] as String? ?? '');
                final daysUntil = date == null
                    ? '?'
                    : date.difference(today).inDays.toString();
                return '- subjectId=${e['subjectId']} | '
                    'date=${date == null ? '?' : day(date)} | '
                    'daysUntil=$daysUntil';
              })
              .join('\n');

    final scoreVals = scores
        .map((s) => (s['score'] as num?)?.toInt())
        .whereType<int>()
        .toList();
    final scoreLine = scoreVals.isEmpty
        ? '(no quizzes yet)'
        : scoreVals.join(', ');

    final totalMinutes = sessions.fold<int>(
      0,
      (a, s) => a + ((s['durationMinutes'] as num?)?.toInt() ?? 0),
    );

    return '''
TODAY: ${day(today)}

SUBJECTS (id | name | confidence 0–1, lower = weaker):
$subjLines

EXAMS:
$examLines

RECENT QUIZ SCORES (last $_readinessWindowDays days, %, oldest first):
$scoreLine

STUDY TIME (last $_readinessWindowDays days): $totalMinutes minutes across ${sessions.length} sessions.

Assess readiness as JSON exactly per the provided schema — one entry per subject above, plus one global studyInsight.''';
  }

  static Map<String, dynamic> _decode(String? text) {
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('Empty AI response');
    }
    return jsonDecode(text) as Map<String, dynamic>;
  }
}
