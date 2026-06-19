import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/progress/cubit.dart';
import 'package:taleemmate/blocs/progress/progress_dashboard.dart';
import 'package:taleemmate/blocs/quiz/cubit.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/core/models/quiz/quiz.dart';
import 'package:taleemmate/core/models/quotes/quote.dart';
import 'package:taleemmate/core/models/progress/score_range.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/core/models/user/user.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'mocks.dart';

// ---------------------------------------------------------------------------
// Domain fixtures — canonical model instances + their raw Firestore/JSON form.
//
// Repos return raw `Map<String, dynamic>` (cubits do `Model.fromJson`), so the
// raw fixtures are what you stub `fetchProfile` etc. with; the model fixtures
// are what you assert against.
// ---------------------------------------------------------------------------

class TestUser {
  static const uid = 'test-uid';

  static Map<String, dynamic> rawJson({bool onboarded = true}) => {
    'uid': uid,
    'fullName': 'Test User',
    'email': 'test@example.com',
    'institution': null,
    'isOnboardingComplete': onboarded,
  };

  static UserData data({bool onboarded = true}) =>
      UserData.fromJson(rawJson(onboarded: onboarded));
}

class TestQuote {
  static Quote sample() => const Quote(
    q: 'The journey of a thousand miles begins with one step.',
    a: 'Lao Tzu',
    date: '2026-06-16',
  );
}

class TestBlock {
  static const scheduleId = 'test-schedule';

  /// A study block fixture. `date` defaults to a fixed day so reschedule
  /// computations (snooze/skip) are deterministic.
  static StudyBlock sample({
    String id = 'block-1',
    String startTime = '08:30',
    int durationMinutes = 60,
    String subjectId = 'subj-maths',
    String? topicId,
    String title = 'Quadratic equations — practice',
    String activities = 'Read + 5 questions',
    BlockStatus status = BlockStatus.upcoming,
    DateTime? date,
    String? aiInsight,
  }) => StudyBlock(
    id: id,
    scheduleId: scheduleId,
    dayOfWeek: 1,
    date: date ?? DateTime(2026, 6, 18),
    startTime: startTime,
    durationMinutes: durationMinutes,
    subjectId: subjectId,
    topicId: topicId,
    title: title,
    activities: activities,
    status: status,
    aiInsight: aiInsight,
  );

  static Map<String, dynamic> rawSchedule({String userId = TestUser.uid}) => {
    'id': scheduleId,
    'userId': userId,
    'dailyTargetHours': 2.0,
    'enabledWindowIds': <String>[],
    'weekStartDate': null,
    'aiReasoning': 'Original reasoning.',
    'isAIGenerated': true,
  };
}

class TestQuiz {
  static const id = 'quiz-1';

  /// A `Quiz.toJson()`-shaped map (nested `questions`) — what `QuizRepo.generate`
  /// returns and the cubit hydrates. Two single-answer MCQs: q1 cites a source,
  /// q2 does not.
  static Map<String, dynamic> rawJson() => {
    'id': id,
    'subjectId': 'subj-maths',
    'topicId': null,
    'currentQuestionIndex': 0,
    'sourceLabel': 'Generated from Algebra notes',
    'isAIGenerated': true,
    'questions': [
      {
        'id': 'q1',
        'quizId': id,
        'index': 0,
        'text': 'What is 2 + 2?',
        'type': 'singleAnswer',
        'markValue': 1,
        'options': ['3', '4', '5', '6'],
        'correctAnswerIndex': 1,
        'timeLimit': null,
        'explanation': 'Two plus two equals four.',
        'citation': 'Algebra notes — p.1',
      },
      {
        'id': 'q2',
        'quizId': id,
        'index': 1,
        'text': 'What is the capital of France?',
        'type': 'singleAnswer',
        'markValue': 1,
        'options': ['Berlin', 'Madrid', 'Paris', 'Rome'],
        'correctAnswerIndex': 2,
        'timeLimit': null,
        'explanation': 'Paris is the capital of France.',
        'citation': null,
      },
    ],
  };

  static Quiz sample() => Quiz.fromJson(rawJson());
}

class TestProgress {
  /// A `ProgressRepo.dashboardData` map — the deterministic snapshot. Defaults
  /// to two subjects, a 3-day streak, three quiz scores and two sessions.
  static Map<String, dynamic> rawDashboardData({
    bool empty = false,
    String userId = TestUser.uid,
  }) {
    if (empty) {
      return {
        'streak': null,
        'dailyScores': const [],
        'sessionMetrics': const [],
        'subjects': const [],
        'exams': const [],
        'quizCount': 0,
        'questionCount': 0,
      };
    }
    final now = DateTime(2026, 6, 19);
    String day(int back) =>
        now.subtract(Duration(days: back)).toIso8601String();
    return {
      'streak': {
        'userId': userId,
        'dayCount': 3,
        'lastStudiedDate': day(0),
        'startDate': day(2),
      },
      'dailyScores': [
        {'date': day(2), 'score': 60, 'topicId': null},
        {'date': day(1), 'score': 72, 'topicId': null},
        {'date': day(0), 'score': 80, 'topicId': null},
      ],
      'sessionMetrics': [
        {
          'userId': userId,
          'date': day(1),
          'durationMinutes': 40,
          'topicIds': const <String>[],
        },
        {
          'userId': userId,
          'date': day(0),
          'durationMinutes': 50,
          'topicIds': const <String>[],
        },
      ],
      'subjects': [
        {
          'id': 'subj-maths',
          'code': 'MATH',
          'name': 'Mathematics',
          'colorHex': '#4F7A5C',
          'confidenceLevel': 0.6,
          'order': 0,
        },
        {
          'id': 'subj-physics',
          'code': 'PHY',
          'name': 'Physics',
          'colorHex': '#A35C5C',
          'confidenceLevel': 0.3,
          'order': 1,
        },
      ],
      'exams': [
        {
          'id': 'exam-1',
          'subjectId': 'subj-physics',
          'date': now.add(const Duration(days: 5)).toIso8601String(),
          'label': 'Midterm',
        },
      ],
      'quizCount': 3,
      'questionCount': 24,
    };
  }

  /// A `ProgressMetric.toJson()`-shaped map per subject — what the metrics watch
  /// emits. [updatedAt] controls staleness in cubit tests.
  static List<Map<String, dynamic>> rawMetrics({
    String userId = TestUser.uid,
    DateTime? updatedAt,
  }) {
    final at = (updatedAt ?? DateTime(2026, 6, 19)).toIso8601String();
    return [
      {
        'userId': userId,
        'subjectId': 'subj-maths',
        'readinessScore': 68,
        'lastUpdatedAt': at,
        'predictedScoreRange': {'min': 62, 'max': 74},
        'weeklyGain': 6,
        'aiInsight': 'Keep drilling quadratic equations.',
      },
      {
        'userId': userId,
        'subjectId': 'subj-physics',
        'readinessScore': 42,
        'lastUpdatedAt': at,
        'predictedScoreRange': {'min': 35, 'max': 50},
        'weeklyGain': -3,
        'aiInsight': 'Revisit kinematics basics.',
      },
    ];
  }

  /// A populated dashboard view-model for widget tests.
  static ProgressDashboard dashboard() => const ProgressDashboard(
    hero: MasterySubject(
      subjectId: 'subj-physics',
      name: 'Physics',
      readinessScore: 42,
      weeklyGain: -3,
      predictedRange: ScoreRange(min: 35, max: 50),
      aiInsight: 'Revisit kinematics basics.',
    ),
    subjects: [
      MasterySubject(
        subjectId: 'subj-maths',
        name: 'Mathematics',
        readinessScore: 68,
        weeklyGain: 6,
        predictedRange: ScoreRange(min: 62, max: 74),
        aiInsight: 'Keep drilling quadratic equations.',
      ),
      MasterySubject(
        subjectId: 'subj-physics',
        name: 'Physics',
        readinessScore: 42,
        weeklyGain: -3,
        predictedRange: ScoreRange(min: 35, max: 50),
        aiInsight: 'Revisit kinematics basics.',
      ),
    ],
    dailyScores: [60, 72, 80],
    streakDays: 3,
    weekHours: 1.5,
    avgSessionMinutes: 45,
    quizCount: 3,
    questionCount: 24,
    studyInsight: 'You retain best in the morning.',
  );
}

/// A Firebase [User] mock with `.uid` stubbed — the only field cubits read.
MockFirebaseUser fakeFirebaseUser({String uid = TestUser.uid}) {
  final user = MockFirebaseUser();
  when(() => user.uid).thenReturn(uid);
  return user;
}

/// A non-logging fault for failure-path tests. The `Fault.fromX` factories pipe
/// through `appLog` → Crashlytics (not initialised under test), so build the
/// raw subtype directly instead.
Fault testFault([String message = 'Something went wrong']) =>
    UnknownFault(message, StackTrace.empty);

// ---------------------------------------------------------------------------
// State builders — compose common composite states without boilerplate.
// Call on a `.def()` state: `UserState.def().loginSuccess()`.
// ---------------------------------------------------------------------------

extension UserStateX on UserState {
  UserState loginLoading() => copyWith(login: login.toLoading());

  UserState loginSuccess({bool onboarded = true}) => copyWith(
    user: fakeFirebaseUser(),
    userData: TestUser.data(onboarded: onboarded),
    login: login.toSuccess(data: TestUser.data(onboarded: onboarded)),
  );

  UserState loginFailed([String message = 'Incorrect email or password.']) =>
      copyWith(login: login.toFailed(fault: testFault(message)));

  UserState initSuccessLoggedIn({bool onboarded = true}) => copyWith(
    user: fakeFirebaseUser(),
    userData: TestUser.data(onboarded: onboarded),
    init: init.toSuccess(data: TestUser.data(onboarded: onboarded)),
  );

  UserState initSuccessLoggedOut() => copyWith(init: init.toSuccess());

  UserState initFailed([String message = 'Session restore failed']) =>
      copyWith(init: init.toFailed(fault: testFault(message)));
}

extension QuotesStateX on QuotesState {
  QuotesState todaySuccess([Quote? quote]) => copyWith(
    today: today.toSuccess(data: quote ?? TestQuote.sample()),
  );
}

extension QuizStateX on QuizState {
  QuizState generateSuccess([Quiz? quiz]) =>
      copyWith(generate: generate.toSuccess(data: quiz ?? TestQuiz.sample()));
}

extension ProgressStateX on ProgressState {
  ProgressState dashboardSuccess([ProgressDashboard? data]) => copyWith(
    dashboard: dashboard.toSuccess(data: data ?? TestProgress.dashboard()),
  );

  ProgressState dashboardEmpty() => copyWith(
    dashboard: dashboard.toSuccess(data: const ProgressDashboard()),
  );

  ProgressState dashboardFailed([String message = 'Couldn\'t load progress']) =>
      copyWith(dashboard: dashboard.toFailed(fault: testFault(message)));
}
