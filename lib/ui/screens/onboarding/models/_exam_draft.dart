part of '../onboarding.dart';

enum ExamType { midterm, finalExam, quiz, viva }

class _ExamDraft {
  String subjectId = '';
  String subjectName = '';
  String subjectColorHex = '#6B6B85';
  ExamType type = ExamType.midterm;
  DateTime date = DateTime.now().add(const Duration(days: 30));

  Exam toExam() => Exam(
    id: const Uuid().v4(),
    subjectId: subjectId,
    date: date,
    label: type.name.titleCase,
  );
}
