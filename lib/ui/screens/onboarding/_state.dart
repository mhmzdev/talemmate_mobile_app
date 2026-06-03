part of 'onboarding.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final pageController = PageController();
  int currentStep = 0;

  // Step 1 — About You
  final nameCtrl = TextEditingController();
  final institutionCtrl = TextEditingController();
  String? selectedInstitutionChip;
  EducationLevel educationLevel = .undergraduate;
  String? year = 'Y3';
  OnboardingGoal goal = .passExams;

  // Step 2 — Subjects
  final List<_SubjectDraft> subjects = [];

  // Step 3 — Schedule
  Set<String> enabledWindowIds = {};
  double dailyTargetHours = 3.5;
  final List<_ExamDraft> exams = [];

  // Step 4 — Material (mocked)
  final List<Map<String, dynamic>> files = [
    {
      'type': 'PDF',
      'name': 'CLRS — Chapter 7.pdf',
      'size': '412 KB',
      'status': 'indexed',
    },
    {
      'type': 'PDF',
      'name': 'Forouzan slides L12.pdf',
      'size': '8.1 MB',
      'status': 'indexed',
    },
    {
      'type': 'IMG',
      'name': 'OS lecture board (3)',
      'size': '2.4 MB',
      'status': 'processing',
    },
    {
      'type': 'NOTE',
      'name': 'My recurrence notes.md',
      'size': '3 KB',
      'status': 'indexed',
    },
  ];

  void updateCurrentStep(int page) {
    currentStep = page;
    notifyListeners();
  }

  void nextPage() => pageController.nextPage(
    duration: 300.milliseconds,
    curve: Curves.easeInOut,
  );

  void prevPage() => pageController.previousPage(
    duration: 300.milliseconds,
    curve: Curves.easeInOut,
  );

  // Step 1 helpers
  void selectInstitutionChip(String chip) {
    selectedInstitutionChip = chip;
    institutionCtrl.text = chip;
    notifyListeners();
  }

  void setEducationLevel(EducationLevel level) {
    educationLevel = level;
    if (!level.hasYear) year = null;
    notifyListeners();
  }

  void setYear(String? y) {
    year = y;
    notifyListeners();
  }

  void setGoal(OnboardingGoal g) {
    goal = g;
    notifyListeners();
  }

  // Step 2 helpers
  void addSubject() {
    subjects.add(_SubjectDraft());
    notifyListeners();
  }

  void addSubjectDraft(_SubjectDraft draft) {
    subjects.add(draft);
    notifyListeners();
  }

  void removeSubject(int i) {
    subjects[i].dispose();
    subjects.removeAt(i);
    notifyListeners();
  }

  void setConfidence(int i, double v) {
    subjects[i].confidence = v;
    notifyListeners();
  }

  void setSubjectColor(int i, String hex) {
    subjects[i].colorHex = hex;
    notifyListeners();
  }

  // Step 3 helpers
  void toggleWindow(String id) {
    if (enabledWindowIds.contains(id)) {
      enabledWindowIds.remove(id);
    } else {
      enabledWindowIds.add(id);
    }
    notifyListeners();
  }

  void setDailyTarget(double v) {
    dailyTargetHours = v;
    notifyListeners();
  }

  void addExamDraft(_ExamDraft draft) {
    exams.add(draft);
    notifyListeners();
  }

  void refresh() => notifyListeners();

  OnboardingData buildData(String userId) => OnboardingData(
    userId: userId,
    step: 4,
    name: nameCtrl.text.trim(),
    institution: institutionCtrl.text.trim(),
    educationLevel: educationLevel,
    year: year,
    goal: goal,
    subjects: subjects.map((s) => s.toSubject()).toList(),
    exams: exams.map((e) => e.toExam()).toList(),
    schedule: Schedule(
      id: const Uuid().v4(),
      userId: userId,
      dailyTargetHours: dailyTargetHours,
      enabledWindowIds: enabledWindowIds.toList(),
    ),
    uploadedMaterials: const [],
  );

  void finish(BuildContext context) {
    final userId = UserCubit.c(context).state.init.data?.uid ?? '';
    OnboardingCubit.c(context).complete(buildData(userId));
  }

  @override
  void dispose() {
    pageController.dispose();
    nameCtrl.dispose();
    institutionCtrl.dispose();
    for (final s in subjects) {
      s.dispose();
    }
    super.dispose();
  }
}
