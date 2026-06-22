part of 'schedule_editor.dart';

/// One editable exam in the editor.
class _ExamDraft {
  _ExamDraft({
    required this.id,
    required this.subjectId,
    required this.date,
    this.label,
  });

  factory _ExamDraft.from(Exam e) => _ExamDraft(
    id: e.id,
    subjectId: e.subjectId,
    date: e.date,
    label: e.label,
  );

  final String id;
  String subjectId;
  DateTime date;
  String? label;

  Exam toExam() => Exam(
    id: id,
    subjectId: subjectId,
    date: date,
    label: label,
  );
}

class _ScreenState extends ChangeNotifier {
  _ScreenState({
    required Schedule? schedule,
    required List<Exam> exams,
    required this.subjects,
  }) : _scheduleId = schedule?.id,
       _enabledWindowIds = {...?schedule?.enabledWindowIds},
       _dailyTargetHours = schedule?.dailyTargetHours ?? 2.0,
       _examDrafts = exams.map(_ExamDraft.from).toList(),
       _originalExamIds = exams.map((e) => e.id).toSet();

  // ignore: unused_element
  static _ScreenState s(BuildContext context, [bool listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  static const _uuid = Uuid();

  /// All subjects, for the exam subject-picker + resolving an exam row's name.
  final List<Subject> subjects;

  final String? _scheduleId;
  final Set<String> _enabledWindowIds;
  double _dailyTargetHours;
  final List<_ExamDraft> _examDrafts;

  /// Loaded exam ids — anything no longer present is a removal on save.
  final Set<String> _originalExamIds;

  /// True once a schedule row exists to write to (always the case post-onboarding).
  bool get hasSchedule => _scheduleId != null;

  List<String> get enabledWindowIds => _enabledWindowIds.toList();
  bool isWindowEnabled(String id) => _enabledWindowIds.contains(id);
  double get dailyTargetHours => _dailyTargetHours;
  List<_ExamDraft> get examDrafts => List.unmodifiable(_examDrafts);

  Subject? subjectById(String id) {
    for (final s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  void toggleWindow(String id) {
    if (!_enabledWindowIds.remove(id)) _enabledWindowIds.add(id);
    notifyListeners();
  }

  void setDailyTarget(double value) {
    _dailyTargetHours = value;
    notifyListeners();
  }

  void addExam({
    required String subjectId,
    required DateTime date,
    String? label,
  }) {
    _examDrafts.add(
      _ExamDraft(
        id: _uuid.v4(),
        subjectId: subjectId,
        date: date,
        label: label,
      ),
    );
    notifyListeners();
  }

  void removeExamAt(int index) {
    _examDrafts.removeAt(index);
    notifyListeners();
  }

  // --- commit payload ----------------------------------------------------

  List<Exam> get upsertExams => _examDrafts.map((d) => d.toExam()).toList();

  List<String> get removeExamIds {
    final current = _examDrafts.map((d) => d.id).toSet();
    return _originalExamIds.where((id) => !current.contains(id)).toList();
  }

  /// At least one study window stays selected — mirrors the onboarding Step-3 gate.
  bool get isValid => _enabledWindowIds.isNotEmpty;
}
