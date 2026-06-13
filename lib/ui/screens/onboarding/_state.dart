part of 'onboarding.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  _ScreenState() {
    // Seed the controllers (debug prefill / empty in prod) before the first
    // build so the Step-1 validity gate is correct from frame one.
    final seed = _FormData.initialValues();
    nameCtrl.text = seed[_FormKeys.name] as String? ?? '';
    institutionCtrl.text = seed[_FormKeys.institution] as String? ?? '';
    if (institutionCtrl.text.isNotEmpty) {
      selectedInstitutionChip = institutionCtrl.text;
    }
  }

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

  // Step 4 — Material (local references; no remote upload yet)
  final List<LibraryItem> materials = [];

  /// Subject that newly-picked materials attach to. Defaults to the first
  /// subject so the "ADD TO SUBJECT" selector is satisfied out of the box.
  String? selectedMaterialSubjectId;

  /// The effective attach-to subject id (explicit selection, else first).
  String? get materialSubjectId =>
      selectedMaterialSubjectId ?? (subjects.isEmpty ? null : subjects.first.id);

  _SubjectDraft? get _materialSubject {
    final id = materialSubjectId;
    if (id == null) return null;
    for (final s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  void selectMaterialSubject(String id) {
    selectedMaterialSubjectId = id;
    notifyListeners();
  }

  /// Display name for a material's subject (for the file row's pill).
  String? subjectNameFor(String? subjectId) {
    if (subjectId == null) return null;
    for (final s in subjects) {
      if (s.id == subjectId) return s.nameCtrl.text.trim();
    }
    return null;
  }

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

  // --- step validation gates (G8) --- //

  /// Step 1 requires a name and an institution before advancing.
  bool get isStep1Valid =>
      nameCtrl.text.trim().isNotEmpty && institutionCtrl.text.trim().isNotEmpty;

  /// Step 3 requires at least one study window selected.
  bool get isStep3Valid => enabledWindowIds.isNotEmpty;

  // Step 4 helpers — local file references only (no Firebase Storage yet).
  // Each picked item attaches to [materialSubjectId] so the Library can group
  // material by subject.
  bool _requireSubject(BuildContext context) {
    if (materialSubjectId != null) return true;
    UIFlash.error(context, 'Add a subject in Step 2 first, then attach material.');
    return false;
  }

  Future<void> addFiles(BuildContext context) async {
    if (!_requireSubject(context)) return;
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return; // user cancelled
      materials.addAll(
        result.files.map(
          (f) => _materialFrom(
            name: f.name,
            sizeBytes: f.size,
            path: f.path,
            ext: f.extension,
          ),
        ),
      );
      notifyListeners();
    } catch (e, st) {
      'onboarding.addFiles error: $e\n$st'.appLog(level: AppLogLevel.error);
      if (context.mounted) UIFlash.error(context, 'Could not add those files.');
    }
  }

  Future<void> addImages(BuildContext context) async {
    if (!_requireSubject(context)) return;
    try {
      final images = await ImagePicker().pickMultiImage();
      if (images.isEmpty) return;
      final items = await Future.wait(
        images.map(
          (x) async => _materialFrom(
            name: x.name,
            sizeBytes: await x.length(),
            path: x.path,
            ext: 'img',
          ),
        ),
      );
      materials.addAll(items);
      notifyListeners();
    } catch (e, st) {
      'onboarding.addImages error: $e\n$st'.appLog(level: AppLogLevel.error);
      if (context.mounted) UIFlash.error(context, 'Could not add those photos.');
    }
  }

  Future<void> captureImage(BuildContext context) async {
    if (!_requireSubject(context)) return;
    try {
      final shot = await ImagePicker().pickImage(source: ImageSource.camera);
      if (shot == null) return;
      materials.add(
        _materialFrom(
          name: shot.name,
          sizeBytes: await shot.length(),
          path: shot.path,
          ext: 'img',
        ),
      );
      notifyListeners();
    } catch (e, st) {
      'onboarding.captureImage error: $e\n$st'.appLog(level: AppLogLevel.error);
      if (context.mounted) UIFlash.error(context, 'Could not capture a photo.');
    }
  }

  void removeMaterial(String id) {
    materials.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  LibraryItem _materialFrom({
    required String name,
    required int sizeBytes,
    String? path,
    String? ext,
  }) {
    final subject = _materialSubject;
    return LibraryItem(
      id: const Uuid().v4(),
      userId: '', // filled with the real uid in buildData()
      name: name,
      kind: _kindForExtension(ext),
      fileSize: sizeBytes,
      uploadedAt: DateTime.now(),
      processingStatus: ProcessingStatus.indexed, // mocked until real indexing
      metadata: path,
      subjectId: subject?.id, // attach to the selected subject (FK to subjects)
      colorHex: subject?.colorHex, // so the file row shows the subject color
    );
  }

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
    uploadedMaterials: materials.map((m) => m.copyWith(userId: userId)).toList(),
  );

  void finish(BuildContext context) {
    try {
      final userCubit = UserCubit.c(context);
      final userId =
          userCubit.state.user?.uid ?? userCubit.state.userData?.uid ?? '';
      final inst = institutionCtrl.text.trim();
      userCubit.completeOnboarding({if (inst.isNotEmpty) 'institution': inst});
      OnboardingCubit.c(context).complete(buildData(userId));
    } catch (e, st) {
      'onboarding.finish error: $e\n$st'.appLog(level: AppLogLevel.error);
    }
  }

  /// Confirms before tearing down the session from inside onboarding.
  void confirmSignOut(BuildContext context) {
    showAppAlert(
      context,
      icon: const Icon(LucideIcons.log_out),
      title: 'Sign out of TaleemMate?',
      subtitle:
          'Your study material and progress stay saved on this device. '
          'You can sign back in anytime.',
      actions: [
        AppAlertAction(label: 'Cancel', onTap: () => Navigator.pop(context)),
        AppAlertAction(
          label: 'Sign out',
          isDestructive: true,
          onTap: () => _signOut(context),
        ),
      ],
      routeName: 'confirm-sign-out',
    );
  }

  /// Dispatches the logout action only. Navigation away from onboarding is a
  /// side effect of the `UserState.logout` transition and is handled by
  /// [_LogoutListener] — this layer never navigates as a result of state.
  void _signOut(BuildContext context) {
    Navigator.pop(context); // dismiss the alert
    UserCubit.c(context).logout();
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
