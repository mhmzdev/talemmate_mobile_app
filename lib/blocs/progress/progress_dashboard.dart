import 'package:equatable/equatable.dart';
import 'package:taleemmate/core/models/progress/score_range.dart';

/// One subject's readiness, used by both the hero card and the mastery list.
/// Derived fields (no new columns): [trend] is the sign of [weeklyGain]; [weak]
/// is a low-readiness flag.
class MasterySubject extends Equatable {
  const MasterySubject({
    required this.subjectId,
    required this.name,
    required this.readinessScore,
    this.weeklyGain,
    this.predictedRange,
    this.aiInsight,
  });

  final String subjectId;
  final String name;
  final int readinessScore;
  final int? weeklyGain;
  final ScoreRange? predictedRange;
  final String? aiInsight;

  /// Sign of the weekly gain: 1 (up), -1 (down), 0 (flat).
  int get trend {
    final g = weeklyGain ?? 0;
    return g > 0 ? 1 : (g < 0 ? -1 : 0);
  }

  bool get weak => readinessScore < 50;

  @override
  List<Object?> get props => [
    subjectId,
    name,
    readinessScore,
    weeklyGain,
    predictedRange,
    aiInsight,
  ];
}

/// Cubit-assembled view-model for the Progress screen. Composes the persisted
/// progress models into the shape the five sections render — it is **not**
/// persisted (no table), it is rebuilt from the watched metrics + deterministic
/// snapshot on every change.
class ProgressDashboard extends Equatable {
  const ProgressDashboard({
    this.hero,
    this.subjects = const [],
    this.dailyScores = const [],
    this.streakDays = 0,
    this.weekHours = 0,
    this.avgSessionMinutes = 0,
    this.quizCount = 0,
    this.questionCount = 0,
    this.studyInsight,
  });

  /// Hero subject — nearest upcoming exam's subject, else lowest readiness.
  final MasterySubject? hero;

  /// Mastery-by-subject rows.
  final List<MasterySubject> subjects;

  /// Up to the last 14 daily quiz scores (oldest first, most recent last).
  final List<int> dailyScores;

  final int streakDays;
  final double weekHours;
  final int avgSessionMinutes;
  final int quizCount;
  final int questionCount;

  /// Global AI study-pattern insight (regenerated each refresh, not persisted).
  final String? studyInsight;

  /// No study data yet — drives the screen's friendly empty state.
  bool get isEmpty =>
      subjects.isEmpty &&
      dailyScores.isEmpty &&
      streakDays == 0 &&
      quizCount == 0 &&
      weekHours == 0;

  @override
  List<Object?> get props => [
    hero,
    subjects,
    dailyScores,
    streakDays,
    weekHours,
    avgSessionMinutes,
    quizCount,
    questionCount,
    studyInsight,
  ];
}
