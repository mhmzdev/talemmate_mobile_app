import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:taleemmate/core/db/tables/library_table.dart';
import 'package:taleemmate/core/db/tables/onboarding_table.dart';
import 'package:taleemmate/core/db/tables/progress_table.dart';
import 'package:taleemmate/core/db/tables/quiz_table.dart';
import 'package:taleemmate/core/db/tables/schedule_table.dart';
import 'package:taleemmate/core/db/tables/settings_table.dart';
import 'package:taleemmate/core/db/tables/subjects_table.dart';
import 'package:taleemmate/core/db/tables/tutor_table.dart';

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
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _openConnection() =>
      driftDatabase(name: 'taleemmate');
}
