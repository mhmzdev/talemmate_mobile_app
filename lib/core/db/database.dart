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
  int get schemaVersion => 4;

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

  static QueryExecutor _openConnection() => driftDatabase(name: 'taleemmate');
}
