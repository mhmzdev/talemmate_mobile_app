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

  Subject toSubject() => Subject(
    id: const Uuid().v4(),
    code: codeCtrl.text.trim(),
    name: nameCtrl.text.trim(),
    colorHex: colorHex,
    confidenceLevel: confidence,
    order: 0,
  );
}
