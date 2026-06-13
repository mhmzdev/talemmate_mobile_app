part of '../onboarding.dart';

class _SubjectDraft {
  final String id = const Uuid().v4();
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  double confidence = 0.5;
  String colorHex = '#6B6B85';

  void dispose() {
    codeCtrl.dispose();
    nameCtrl.dispose();
  }

  // Use the draft's stable [id] — exams reference a subject by this id
  // (`_ExamDraft.subjectId = subject.id`), and `Exams.subjectId` is a FK to
  // `Subjects.id`. Minting a fresh id here would break that reference and abort
  // the save transaction whenever an exam is present.
  Subject toSubject() => Subject(
    id: id,
    code: codeCtrl.text.trim(),
    name: nameCtrl.text.trim(),
    colorHex: colorHex,
    confidenceLevel: confidence,
    order: 0,
  );

  SubjectChipData toChipData() =>
      SubjectChipData(id: id, label: nameCtrl.text.trim(), colorHex: colorHex);
}
