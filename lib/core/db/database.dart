import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:taleemmate/core/db/converters.dart';
import 'package:taleemmate/core/db/tables/library_table.dart';
import 'package:taleemmate/core/db/tables/material_texts_table.dart';
import 'package:taleemmate/core/db/tables/onboarding_table.dart';
import 'package:taleemmate/core/db/tables/progress_table.dart';
import 'package:taleemmate/core/db/tables/quiz_table.dart';
import 'package:taleemmate/core/db/tables/schedule_table.dart';
import 'package:taleemmate/core/db/tables/settings_table.dart';
import 'package:taleemmate/core/db/tables/subjects_table.dart';
import 'package:taleemmate/core/db/tables/tutor_table.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/core/models/onboarding/onboarding_data.dart';
import 'package:taleemmate/core/models/quiz/quiz.dart';
import 'package:taleemmate/core/models/quiz/quiz_attempt.dart';
import 'package:taleemmate/core/models/quiz/quiz_question.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/core/models/settings/appearance_preferences.dart';
import 'package:taleemmate/core/models/settings/language_preferences.dart';
import 'package:taleemmate/core/models/subject/topic.dart';
import 'package:taleemmate/core/models/tutor/citation.dart';
import 'package:taleemmate/core/models/tutor/follow_up_point.dart';
import 'package:taleemmate/core/models/tutor/tutor_conversation.dart';
import 'package:taleemmate/core/models/tutor/tutor_message.dart';
import 'package:taleemmate/core/models/tutor/tutor_settings.dart';

export 'tables/library_table.dart';
export 'tables/material_texts_table.dart';
export 'tables/onboarding_table.dart';
export 'tables/progress_table.dart';
export 'tables/quiz_table.dart';
export 'tables/schedule_table.dart';
export 'tables/settings_table.dart';
export 'tables/subjects_table.dart';
export 'tables/tutor_table.dart';
part 'database.g.dart';
part 'daos/subject_dao.dart';
part 'daos/schedule_dao.dart';
part 'daos/library_dao.dart';
part 'daos/material_texts_dao.dart';
part 'daos/quiz_dao.dart';
part 'daos/progress_dao.dart';
part 'daos/tutor_dao.dart';
part 'daos/settings_dao.dart';
part 'daos/onboarding_dao.dart';

@DriftDatabase(
  tables: [
    Subjects,
    Topics,
    Exams,
    StudyWindows,
    Schedules,
    StudyBlocks,
    LibraryItems,
    MaterialTexts,
    Quizzes,
    QuizQuestions,
    QuizAttempts,
    QuizFeedbackItems,
    ProgressMetrics,
    StudyStreaks,
    DailyScores,
    SessionMetrics,
    TutorConversations,
    TutorMessages,
    TutorSettingsTable,
    NotificationSettingsTable,
    AppearancePrefsTable,
    LanguagePrefsTable,
    PrivacySettingsTable,
    OnboardingDataTable,
  ],
  daos: [
    SubjectDao,
    ScheduleDao,
    LibraryDao,
    MaterialTextsDao,
    QuizDao,
    ProgressDao,
    TutorDao,
    SettingsDao,
    OnboardingDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Shared app-wide instance. Lets the repo singletons and the widget-tree
  /// `Provider<AppDatabase>` use exactly one connection.
  static final AppDatabase ins = AppDatabase();

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // v2: extracted-text storage for library materials (text extraction).
      if (from < 2) await m.createTable(materialTexts);
      // v3: persisted "why this week" reasoning string on the schedule row.
      if (from < 3) await m.addColumn(schedules, schedules.aiReasoning);
      // v4: per-account scoping for subjects + exams (ADR-014). Existing rows
      // default to '' and orphan, rather than leaking across accounts.
      if (from < 4) {
        await m.addColumn(subjects, subjects.userId);
        await m.addColumn(exams, exams.userId);
      }
      // v5: per-question explanation + citation for inline quiz feedback.
      if (from < 5) {
        await m.addColumn(quizQuestions, quizQuestions.explanation);
        await m.addColumn(quizQuestions, quizQuestions.citation);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Persists a full onboarding payload (an `OnboardingData.toJson()` map) to
  /// the local tables in one transaction. Lives here — not in the repo — so the
  /// repo layer stays model-free per ADR-013; the repo just hands over the Map.
  Future<void> saveOnboardingData(Map<String, dynamic> json) async {
    final data = OnboardingData.fromJson(json);
    await transaction(() async {
      await onboardingDao.upsert(
        OnboardingDataTableCompanion(
          userId: Value(data.userId),
          step: Value(data.step),
          institution: Value(data.institution),
        ),
      );

      await Future.wait(
        data.subjects.map(
          (s) => subjectDao.upsertSubject(
            SubjectsCompanion(
              id: Value(s.id),
              userId: Value(data.userId),
              code: Value(s.code),
              name: Value(s.name),
              colorHex: Value(s.colorHex),
              confidenceLevel: Value(s.confidenceLevel),
              order: Value(s.order),
            ),
          ),
        ),
      );

      await Future.wait(
        data.exams.map(
          (e) => subjectDao.upsertExam(
            ExamsCompanion(
              id: Value(e.id),
              userId: Value(data.userId),
              subjectId: Value(e.subjectId),
              date: Value(e.date),
              label: Value(e.label),
            ),
          ),
        ),
      );

      final schedule = data.schedule;
      if (schedule != null) {
        await scheduleDao.upsertSchedule(
          SchedulesCompanion(
            id: Value(schedule.id),
            userId: Value(schedule.userId),
            dailyTargetHours: Value(schedule.dailyTargetHours),
            enabledWindowIds: Value(schedule.enabledWindowIds),
            weekStartDate: Value(schedule.weekStartDate),
            aiReasoning: Value(schedule.aiReasoning),
            isAIGenerated: Value(schedule.isAIGenerated),
          ),
        );
      }

      await Future.wait(
        data.uploadedMaterials.map(
          (m) => libraryDao.upsert(
            LibraryItemsCompanion(
              id: Value(m.id),
              userId: Value(m.userId),
              name: Value(m.name),
              kind: Value(m.kind),
              fileSize: Value(m.fileSize),
              uploadedAt: Value(m.uploadedAt),
              processingStatus: Value(m.processingStatus),
              subjectId: Value(m.subjectId),
              metadata: Value(m.metadata),
              colorHex: Value(m.colorHex),
              indexedPageCount: Value(m.indexedPageCount),
            ),
          ),
        ),
      );
    });
  }

  /// Removes a material and its extracted text in one transaction. The
  /// `material_texts.itemId` FK means the child text row must be deleted first —
  /// once an item is indexed, deleting only the item raises a foreign-key
  /// constraint failure (SQLite error 787).
  Future<void> deleteLibraryItem(String id) => transaction(() async {
    await materialTextsDao.deleteForItem(id);
    await libraryDao.deleteItem(id);
  });

  /// Persists a single library material (a `LibraryItem.toJson()` map) added
  /// outside onboarding (the Library "Add" path). Lives here — not in the repo
  /// — so the repo stays model-free per ADR-013; it just hands over the Map.
  Future<void> saveLibraryItem(Map<String, dynamic> json) async {
    final m = LibraryItem.fromJson(json);
    await libraryDao.upsert(
      LibraryItemsCompanion(
        id: Value(m.id),
        userId: Value(m.userId),
        name: Value(m.name),
        kind: Value(m.kind),
        fileSize: Value(m.fileSize),
        uploadedAt: Value(m.uploadedAt),
        processingStatus: Value(m.processingStatus),
        subjectId: Value(m.subjectId),
        metadata: Value(m.metadata),
        colorHex: Value(m.colorHex),
        indexedPageCount: Value(m.indexedPageCount),
      ),
    );
  }

  // --- Text-extraction pipeline -------------------------------------------
  // Primitive-only surface so `MaterialRepo` stays model-free (ADR-013): the
  // `ProcessingStatus` enum and row→Map conversion live here, not in the repo.

  /// Marks an item as actively extracting.
  Future<void> markLibraryProcessing(String id) =>
      libraryDao.setStatus(id, ProcessingStatus.processing);

  /// Marks an item indexed and records the (estimated) page count.
  Future<void> markLibraryIndexed(String id, int pageCount) => libraryDao
      .setStatus(id, ProcessingStatus.indexed, indexedPageCount: pageCount);

  /// Marks an item failed (unsupported kind or an extraction error).
  Future<void> markLibraryFailed(String id) =>
      libraryDao.setStatus(id, ProcessingStatus.failed);

  /// Persists extracted text for an item (upsert — re-runs overwrite).
  Future<void> saveMaterialText({
    required String itemId,
    required String content,
    required int pageCount,
    required int charCount,
    required DateTime extractedAt,
  }) => materialTextsDao.upsert(
    MaterialTextsCompanion(
      itemId: Value(itemId),
      content: Value(content),
      pageCount: Value(pageCount),
      charCount: Value(charCount),
      extractedAt: Value(extractedAt),
    ),
  );

  /// All extracted text for a user's items in a subject, as plain maps — the
  /// grounding source consumed by the Chat agent.
  Future<List<Map<String, dynamic>>> materialTextsForSubject(
    String userId,
    String subjectId,
  ) async {
    final rows = await materialTextsDao.forSubject(userId, subjectId);
    return rows.map((e) {
      final (r, name) = e;
      return <String, dynamic>{
        'itemId': r.itemId,
        'name': name,
        'content': r.content,
        'pageCount': r.pageCount,
        'charCount': r.charCount,
        'extractedAt': r.extractedAt.toIso8601String(),
      };
    }).toList();
  }

  // --- Chat / tutor persistence ------------------------------------------
  // Model↔row conversion lives here so `ChatRepo` stays model-free (ADR-013):
  // the repo passes/receives `Map`s; `Tutor*.fromJson`/`toJson` happen here.

  /// Live per-user conversation list (newest first), as JSON-shaped maps.
  Stream<List<Map<String, dynamic>>> watchTutorConversations(String userId) =>
      tutorDao
          .watchByUser(userId)
          .map(
            (rows) => rows.map(_tutorConversationToMap).toList(),
          );

  /// Live message list for a conversation (oldest first), as JSON-shaped maps.
  Stream<List<Map<String, dynamic>>> watchTutorMessages(
    String conversationId,
  ) => tutorDao
      .watchMessages(conversationId)
      .map(
        (rows) => rows.map(_tutorMessageToMap).toList(),
      );

  /// Upserts a conversation from a `TutorConversation.toJson()` map.
  Future<void> saveTutorConversation(Map<String, dynamic> json) {
    final c = TutorConversation.fromJson(json);
    return tutorDao.upsertConversation(
      TutorConversationsCompanion(
        id: Value(c.id),
        userId: Value(c.userId),
        subjectId: Value(c.subjectId),
        topicId: Value(c.topicId),
        title: Value(c.title),
        groundedSourceCount: Value(c.groundedSourceCount),
        createdAt: Value(c.createdAt),
        lastMessageAt: Value(c.lastMessageAt),
      ),
    );
  }

  /// Inserts a message from a `TutorMessage.toJson()` map.
  Future<void> saveTutorMessage(Map<String, dynamic> json) {
    final m = TutorMessage.fromJson(json);
    return tutorDao.insertMessage(
      TutorMessagesCompanion(
        id: Value(m.id),
        conversationId: Value(m.conversationId),
        sender: Value(m.sender),
        content: Value(m.text),
        timestamp: Value(m.timestamp),
        followUpPoints: Value(m.followUpPoints),
        citations: Value(m.citations),
        kickerQuestion: Value(m.kickerQuestion),
      ),
    );
  }

  /// The user's tutor settings as a JSON-shaped map, or null if unset.
  Future<Map<String, dynamic>?> tutorSettings(String userId) async {
    final row = await tutorDao.settingsForUser(userId);
    if (row == null) return null;
    return _tutorSettingsToMap(row);
  }

  /// Deletes a conversation and all its messages.
  Future<void> deleteTutorConversation(String id) =>
      tutorDao.deleteConversation(id);

  /// Upserts tutor settings from a `TutorSettings.toJson()` map.
  Future<void> saveTutorSettings(Map<String, dynamic> json) {
    final s = TutorSettings.fromJson(json);
    return tutorDao.upsertSettings(
      TutorSettingsTableCompanion(
        userId: Value(s.userId),
        showCitationsOnEveryReply: Value(s.showCitationsOnEveryReply),
        scope: Value(s.scope),
        reasoningDepth: Value(s.reasoningDepth),
      ),
    );
  }

  Map<String, dynamic> _tutorConversationToMap(TutorConversationRow r) => {
    'id': r.id,
    'userId': r.userId,
    'subjectId': r.subjectId,
    'topicId': r.topicId,
    'title': r.title,
    'groundedSourceCount': r.groundedSourceCount,
    'createdAt': r.createdAt.toIso8601String(),
    'lastMessageAt': r.lastMessageAt.toIso8601String(),
  };

  Map<String, dynamic> _tutorMessageToMap(TutorMessageRow r) => {
    'id': r.id,
    'conversationId': r.conversationId,
    'sender': r.sender.name,
    'text': r.content,
    'timestamp': r.timestamp.toIso8601String(),
    'followUpPoints': r.followUpPoints.map((e) => e.toJson()).toList(),
    'citations': r.citations.map((e) => e.toJson()).toList(),
    'kickerQuestion': r.kickerQuestion,
  };

  Map<String, dynamic> _tutorSettingsToMap(TutorSettingsRow r) => {
    'userId': r.userId,
    'showCitationsOnEveryReply': r.showCitationsOnEveryReply,
    'scope': r.scope.name,
    'reasoningDepth': r.reasoningDepth.name,
  };

  // --- Study-plan persistence --------------------------------------------
  // Map-only surface so `PlanRepo` stays model-free (ADR-013): row↔Map and
  // `StudyBlock.fromJson` conversion live here, not in the repo.

  /// The user's schedule row as a `Schedule.toJson()`-shaped map, or null.
  Future<Map<String, dynamic>?> scheduleForUser(String userId) async {
    final row = await scheduleDao.findByUser(userId);
    if (row == null) return null;
    return _scheduleToMap(row);
  }

  /// Persists the "why this week" reasoning paragraph onto the schedule row.
  Future<void> updateScheduleReasoning(
    String scheduleId,
    String reasoning,
  ) async {
    await (update(schedules)..where((s) => s.id.equals(scheduleId))).write(
      SchedulesCompanion(aiReasoning: Value(reasoning)),
    );
  }

  /// Replaces all of a schedule's study blocks in one transaction — the
  /// generation pass deletes the prior week and writes the fresh one. Each map
  /// is a `StudyBlock.toJson()`-shaped payload.
  Future<void> replaceStudyBlocks(
    String scheduleId,
    List<Map<String, dynamic>> blocks,
  ) async {
    await transaction(() async {
      await scheduleDao.deleteBlocksForSchedule(scheduleId);
      for (final json in blocks) {
        final b = StudyBlock.fromJson(json);
        await scheduleDao.upsertBlock(
          StudyBlocksCompanion(
            id: Value(b.id),
            scheduleId: Value(b.scheduleId),
            dayOfWeek: Value(b.dayOfWeek),
            date: Value(b.date),
            startTime: Value(b.startTime),
            durationMinutes: Value(b.durationMinutes),
            subjectId: Value(b.subjectId),
            topicId: Value(b.topicId),
            title: Value(b.title),
            activities: Value(b.activities),
            status: Value(b.status),
            aiInsight: Value(b.aiInsight),
            isAIGenerated: Value(b.isAIGenerated),
          ),
        );
      }
    });
  }

  /// Targeted single-block update — writes only the supplied columns onto the
  /// existing row (a partial UPDATE, mirroring [updateScheduleReasoning]).
  /// `upsertBlock`/`insertOnConflictUpdate` can't be used here: its INSERT
  /// branch needs every NOT NULL column, which a partial companion lacks. Used
  /// by the reschedule actions (move/snooze/shorten/skip) and "mark block done".
  /// [status], when given, is a `BlockStatus.name` string — mapped to the enum
  /// here so the repo layer stays model-free (ADR-013).
  Future<void> updateStudyBlock(
    String id, {
    String? startTime,
    int? durationMinutes,
    DateTime? date,
    String? status,
  }) async {
    await (update(studyBlocks)..where((b) => b.id.equals(id))).write(
      StudyBlocksCompanion(
        startTime: startTime == null
            ? const Value.absent()
            : Value(startTime),
        durationMinutes: durationMinutes == null
            ? const Value.absent()
            : Value(durationMinutes),
        date: date == null ? const Value.absent() : Value(date),
        status: status == null
            ? const Value.absent()
            : Value(BlockStatus.values.byName(status)),
      ),
    );
  }

  /// Records one completed study session. [topicIds] is JSON-encoded into the
  /// single `topicIds` text column. Mirrors `replaceStudyBlocks`' AppDatabase-
  /// level wrapper style so the repo never touches a DAO directly.
  Future<void> recordSessionMetric({
    required String userId,
    required DateTime date,
    required int durationMinutes,
    required List<String> topicIds,
  }) async {
    await progressDao.insertSessionMetric(
      SessionMetricsCompanion.insert(
        userId: userId,
        date: date,
        durationMinutes: durationMinutes,
        topicIds: jsonEncode(topicIds),
      ),
    );
  }

  // --- Progress persistence ----------------------------------------------
  // Map-only surface so `ProgressRepo` stays model-free (ADR-013): row↔Map
  // conversion lives here, not in the repo. The split `predictedScoreMin/Max`
  // columns are rebuilt into a nested `predictedScoreRange` so the map matches
  // `ProgressMetric.toJson()`; `topicIds` JSON is decoded for session metrics.

  /// Live readiness metrics for a user, as `ProgressMetric.toJson()`-shaped maps.
  Stream<List<Map<String, dynamic>>> watchProgressMetrics(String userId) =>
      progressDao
          .watchByUser(userId)
          .map((rows) => rows.map(_progressMetricToMap).toList());

  /// The user's study streak as a `StudyStreak.toJson()`-shaped map, or null.
  Future<Map<String, dynamic>?> studyStreakForUser(String userId) async {
    final row = await progressDao.streakForUser(userId);
    return row == null ? null : _studyStreakToMap(row);
  }

  /// A user's daily quiz scores (oldest first), as `DailyScore.toJson()` maps.
  Future<List<Map<String, dynamic>>> dailyScoresForUser(
    String userId, {
    DateTime? since,
  }) async {
    final rows = await progressDao.scoresForUser(userId, since: since);
    return rows.map(_dailyScoreToMap).toList();
  }

  /// A user's session metrics (oldest first), as `SessionMetric.toJson()` maps.
  Future<List<Map<String, dynamic>>> sessionMetricsForUser(
    String userId, {
    DateTime? since,
  }) async {
    final rows = await progressDao.sessionMetricsForUser(userId, since: since);
    return rows.map(_sessionMetricToMap).toList();
  }

  /// A user's raw quiz attempts (newest first), as `QuizAttempt.toJson()` maps —
  /// the source for the "N quizzes · N questions" counters.
  Future<List<Map<String, dynamic>>> quizAttemptsForUser(String userId) async {
    final rows = await quizDao.attemptsForUser(userId);
    return rows.map(_quizAttemptToMap).toList();
  }

  /// Inserts one daily quiz score row (one per completed quiz).
  Future<void> recordDailyScore({
    required String userId,
    required DateTime date,
    required int score,
    String? topicId,
  }) => progressDao.insertDailyScore(
    DailyScoresCompanion.insert(
      userId: userId,
      date: date,
      score: score,
      topicId: Value(topicId),
    ),
  );

  /// Upserts the user's single study-streak row.
  Future<void> upsertStudyStreak({
    required String userId,
    required int dayCount,
    required DateTime lastStudiedDate,
    required DateTime startDate,
  }) => progressDao.upsertStreak(
    StudyStreaksCompanion.insert(
      userId: userId,
      dayCount: dayCount,
      lastStudiedDate: lastStudiedDate,
      startDate: startDate,
    ),
  );

  /// Upserts one per-subject readiness metric. [m] carries flat keys: `userId`,
  /// `subjectId`, `readinessScore`, optional `predictedScoreMin/Max`,
  /// `weeklyGain`, `aiInsight`; `lastUpdatedAt` defaults to now when absent.
  Future<void> upsertProgressMetric(Map<String, dynamic> m) {
    final updatedRaw = m['lastUpdatedAt'];
    final updatedAt = updatedRaw is DateTime
        ? updatedRaw
        : updatedRaw is String
        ? DateTime.parse(updatedRaw)
        : DateTime.now();
    return progressDao.upsertMetric(
      ProgressMetricsCompanion.insert(
        userId: m['userId'] as String,
        subjectId: m['subjectId'] as String,
        readinessScore: (m['readinessScore'] as num?)?.toInt() ?? 0,
        lastUpdatedAt: updatedAt,
        predictedScoreMin: Value((m['predictedScoreMin'] as num?)?.toInt()),
        predictedScoreMax: Value((m['predictedScoreMax'] as num?)?.toInt()),
        weeklyGain: Value((m['weeklyGain'] as num?)?.toInt()),
        aiInsight: Value(m['aiInsight'] as String?),
      ),
    );
  }

  Map<String, dynamic> _progressMetricToMap(ProgressMetricRow r) => {
    'userId': r.userId,
    'subjectId': r.subjectId,
    'readinessScore': r.readinessScore,
    'lastUpdatedAt': r.lastUpdatedAt.toIso8601String(),
    'predictedScoreRange': r.predictedScoreMin == null && r.predictedScoreMax == null
        ? null
        : {'min': r.predictedScoreMin ?? 0, 'max': r.predictedScoreMax ?? 0},
    'weeklyGain': r.weeklyGain,
    'aiInsight': r.aiInsight,
  };

  Map<String, dynamic> _studyStreakToMap(StudyStreakRow r) => {
    'userId': r.userId,
    'dayCount': r.dayCount,
    'lastStudiedDate': r.lastStudiedDate.toIso8601String(),
    'startDate': r.startDate.toIso8601String(),
  };

  Map<String, dynamic> _dailyScoreToMap(DailyScoreRow r) => {
    'date': r.date.toIso8601String(),
    'score': r.score,
    'topicId': r.topicId,
  };

  Map<String, dynamic> _sessionMetricToMap(SessionMetricRow r) => {
    'userId': r.userId,
    'date': r.date.toIso8601String(),
    'durationMinutes': r.durationMinutes,
    'topicIds': (jsonDecode(r.topicIds) as List).whereType<String>().toList(),
  };

  Map<String, dynamic> _quizAttemptToMap(QuizAttemptRow r) => {
    'id': r.id,
    'quizId': r.quizId,
    'userId': r.userId,
    'questionId': r.questionId,
    'timestamp': r.timestamp.toIso8601String(),
    'selectedAnswerIndex': r.selectedAnswerIndex,
    'isCorrect': r.isCorrect,
  };

  /// Live block list for a schedule (by date, then start time), as
  /// `StudyBlock.toJson()`-shaped maps.
  Stream<List<Map<String, dynamic>>> watchStudyBlocks(String scheduleId) =>
      scheduleDao
          .watchBlocksForSchedule(scheduleId)
          .map((rows) => rows.map(_studyBlockToMap).toList());

  /// A user's subjects, as `Subject.toJson()`-shaped maps (ADR-014 — scoped per
  /// account so one user's subjects never bleed into another's plan/library).
  Future<List<Map<String, dynamic>>> subjectsForUser(String userId) async {
    final rows = await subjectDao.getByUser(userId);
    return rows.map(_subjectToMap).toList();
  }

  /// A user's exams, soonest first, as `Exam.toJson()`-shaped maps (ADR-014).
  Future<List<Map<String, dynamic>>> examsForUser(String userId) async {
    final rows = await subjectDao.getExamsByUser(userId);
    return rows.map(_examToMap).toList();
  }

  Map<String, dynamic> _scheduleToMap(ScheduleRow r) => {
    'id': r.id,
    'userId': r.userId,
    'dailyTargetHours': r.dailyTargetHours,
    'enabledWindowIds': r.enabledWindowIds,
    'weekStartDate': r.weekStartDate?.toIso8601String(),
    'aiReasoning': r.aiReasoning,
    'isAIGenerated': r.isAIGenerated,
  };

  Map<String, dynamic> _studyBlockToMap(StudyBlockRow r) => {
    'id': r.id,
    'scheduleId': r.scheduleId,
    'dayOfWeek': r.dayOfWeek,
    'date': r.date.toIso8601String(),
    'startTime': r.startTime,
    'durationMinutes': r.durationMinutes,
    'subjectId': r.subjectId,
    'topicId': r.topicId,
    'title': r.title,
    'activities': r.activities,
    'status': r.status.name,
    'aiInsight': r.aiInsight,
    'isAIGenerated': r.isAIGenerated,
  };

  Map<String, dynamic> _subjectToMap(SubjectRow r) => {
    'id': r.id,
    'code': r.code,
    'name': r.name,
    'colorHex': r.colorHex,
    'confidenceLevel': r.confidenceLevel,
    'order': r.order,
  };

  Map<String, dynamic> _examToMap(ExamRow r) => {
    'id': r.id,
    'subjectId': r.subjectId,
    'date': r.date.toIso8601String(),
    'label': r.label,
  };

  // --- Quiz persistence --------------------------------------------------
  // Map-only surface so `QuizRepo` stays model-free (ADR-013): row↔Map and
  // `Quiz.fromJson` / `QuizQuestion.fromJson` / `QuizAttempt.fromJson`
  // conversion live here, not in the repo. NB: the `QuizQuestions.content`
  // column is exposed under the model's `text` key — reconciled in the map,
  // not via a column rename (no destructive migration).

  /// A single subject row as a `Subject.toJson()`-shaped map, or null — used to
  /// resolve the subject name + confidence for a quiz generation turn.
  Future<Map<String, dynamic>?> subjectById(String id) async {
    final row = await (select(
      subjects,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    return row == null ? null : _subjectToMap(row);
  }

  /// A single topic's name as a thin map `{id, subjectId, name}`, or null.
  Future<Map<String, dynamic>?> topicById(String id) async {
    final row = await (select(
      topics,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return {'id': row.id, 'subjectId': row.subjectId, 'name': row.name};
  }

  /// Extracted text for one library item paired with its display name, as a map
  /// `{itemId, name, content}`, or null when the item has no indexed text — the
  /// single-material grounding source for a quiz.
  Future<Map<String, dynamic>?> materialTextForItem(String itemId) async {
    final text = await materialTextsDao.forItem(itemId);
    if (text == null) return null;
    final item = await (select(
      libraryItems,
    )..where((i) => i.id.equals(itemId))).getSingleOrNull();
    return {
      'itemId': text.itemId,
      'name': item?.name ?? 'Material',
      'content': text.content,
    };
  }

  /// A persisted quiz with its ordered questions as a `Quiz.toJson()`-shaped map
  /// (nested `questions`), or null. Kept thin — used for reload.
  Future<Map<String, dynamic>?> quizById(String quizId) async {
    final quiz = await quizDao.findById(quizId);
    if (quiz == null) return null;
    final questions = await quizDao.questionsForQuiz(quizId);
    return _quizToMap(quiz, questions);
  }

  /// Persists a quiz and its questions in one transaction. [quiz] is a
  /// `Quiz.toJson()`-shaped map (without nested questions needed); [questions]
  /// are `QuizQuestion.toJson()`-shaped maps (the `text` key maps to the
  /// `content` column). `fromJson` happens here so the repo stays model-free.
  Future<void> replaceQuizQuestions(
    Map<String, dynamic> quiz,
    List<Map<String, dynamic>> questions,
  ) async {
    final q = Quiz.fromJson(quiz);
    await transaction(() async {
      await quizDao.upsertQuiz(
        QuizzesCompanion(
          id: Value(q.id),
          subjectId: Value(q.subjectId),
          topicId: Value(q.topicId),
          currentQuestionIndex: Value(q.currentQuestionIndex),
          sourceLabel: Value(q.sourceLabel),
          isAIGenerated: Value(q.isAIGenerated),
        ),
      );
      for (final json in questions) {
        final question = QuizQuestion.fromJson(json);
        await quizDao.upsertQuestion(
          QuizQuestionsCompanion(
            id: Value(question.id),
            quizId: Value(question.quizId),
            index: Value(question.index),
            content: Value(question.text),
            type: Value(question.type),
            markValue: Value(question.markValue),
            options: Value(question.options),
            correctAnswerIndex: Value(question.correctAnswerIndex),
            timeLimit: Value(question.timeLimit),
            explanation: Value(question.explanation),
            citation: Value(question.citation),
          ),
        );
      }
    });
  }

  /// Records one answered question as a `QuizAttempt` from a
  /// `QuizAttempt.toJson()`-shaped map.
  Future<void> insertQuizAttempt(Map<String, dynamic> attempt) async {
    final a = QuizAttempt.fromJson(attempt);
    await quizDao.insertAttempt(
      QuizAttemptsCompanion(
        id: Value(a.id),
        quizId: Value(a.quizId),
        userId: Value(a.userId),
        questionId: Value(a.questionId),
        timestamp: Value(a.timestamp),
        selectedAnswerIndex: Value(a.selectedAnswerIndex),
        isCorrect: Value(a.isCorrect),
      ),
    );
  }

  Map<String, dynamic> _quizToMap(QuizRow r, List<QuizQuestionRow> qs) => {
    'id': r.id,
    'subjectId': r.subjectId,
    'topicId': r.topicId,
    'currentQuestionIndex': r.currentQuestionIndex,
    'sourceLabel': r.sourceLabel,
    'isAIGenerated': r.isAIGenerated,
    'questions': qs.map(_quizQuestionToMap).toList(),
  };

  Map<String, dynamic> _quizQuestionToMap(QuizQuestionRow r) => {
    'id': r.id,
    'quizId': r.quizId,
    'index': r.index,
    'text': r.content,
    'type': r.type.name,
    'markValue': r.markValue,
    'options': r.options,
    'correctAnswerIndex': r.correctAnswerIndex,
    'timeLimit': r.timeLimit,
    'explanation': r.explanation,
    'citation': r.citation,
  };

  static QueryExecutor _openConnection() => driftDatabase(name: 'taleemmate');
}
