import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:taleemmate/core/db/converters.dart';
import 'package:taleemmate/core/db/tables/library_table.dart';
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
import 'package:taleemmate/core/models/tutor/tutor_message.dart';
import 'package:taleemmate/core/models/tutor/tutor_settings.dart';

export 'tables/library_table.dart';
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
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

  static QueryExecutor _openConnection() => driftDatabase(name: 'taleemmate');
}
