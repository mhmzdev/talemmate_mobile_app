import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam.freezed.dart';
part 'exam.g.dart';

@freezed
sealed class Exam with _$Exam {
  const Exam._();

  const factory Exam({
    required String id,
    required String subjectId,
    required DateTime date,
    String? label,
  }) = _Exam;

  factory Exam.fromJson(Map<String, Object?> json) =>
      _$ExamFromJson(json);

  int get daysUntil => date.difference(DateTime.now()).inDays;
}
