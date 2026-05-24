import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/progress/daily_score.dart';
import 'package:taleemmate/core/models/quiz/quiz_attempt.dart';

part 'quiz_history.freezed.dart';
part 'quiz_history.g.dart';

@freezed
sealed class QuizHistory with _$QuizHistory {
  const QuizHistory._();

  const factory QuizHistory({
    required String userId,
    required int totalQuizzesAttempted,
    required int totalQuestionsAnswered,
    @Default([]) List<QuizAttempt> attempts,
    @Default([]) List<DailyScore> scoreHistory,
  }) = _QuizHistory;

  factory QuizHistory.fromJson(Map<String, Object?> json) =>
      _$QuizHistoryFromJson(json);
}
