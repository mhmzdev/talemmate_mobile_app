---
title: "Onboarding implementation — create account + 4-step flow + stepwise loader"
status: completed
created: 2026-05-24
completed: 2026-06-13
---

✅ COMPLETED — 2026-06-13 (verified via `docs/feat-checklist/onboarding-flow.md`: registration, 4-step flow, completion, and local persistence all green on emulators)

# Onboarding Implementation Plan

## Overview

Implement the complete new-user flow from account creation through the 4-step onboarding to the stepwise post-setup loader. Screens are fully mocked (v1 — no real Firebase registration or Drift persistence). All architecture follows existing login screen as the reference pattern.

---

## Current State Analysis

| What | State |
|---|---|
| `create_account` screen | Scaffold only — empty `_Body`, `_state.dart` has just `formKey`, no widgets or listeners |
| `UserCubit` | Has `login`, `init`, `fetch`, `update`, `forgot`, `logout`, `deleteAccount` — **no `register`** |
| `UserRepo` | Same action set — **no `register`** |
| Onboarding screen | Does not exist |
| `OnboardingCubit` + `OnboardingRepo` | Do not exist |
| Stepwise loader screen | Does not exist |
| `AppRoutes.onboarding` / `.stepwiseLoader` | Do not exist |
| `OnboardingData` model | ✅ Exists — `lib/core/models/onboarding/onboarding_data.dart` |
| `Subject`, `Exam`, `Schedule` models | ✅ Exist under `lib/core/models/` |
| `KeepAlivePageView` | ✅ Exists — `lib/ui/widgets/headless/keep_alive_page_view.dart` |
| Drift table + DAO for onboarding | ✅ Exist — `lib/core/db/` |

Key reference files:
- `lib/ui/screens/login/login.dart` — complete screen pattern to follow
- `lib/ui/screens/login/listeners/_login.dart:1` — BlocConsumer listener pattern
- `lib/ui/widgets/headless/keep_alive_page_view.dart:1` — keep-alive PageView wrapper
- `lib/core/models/onboarding/onboarding_data.dart:14` — data model for all 4 steps

---

## Desired End State

1. User taps "Create account" on login → `create_account` screen with full form, password strength, terms checkbox
2. Submit → `UserCubit.register()` (mocked) → success → push `onboarding`
3. Onboarding: 4-step non-swipeable `PageView`, back/continue navigation, "Skip" on steps 2–4
4. "Finish setup" on step 4 → `OnboardingCubit.complete()` (mocked) → push `stepwise_loader`
5. Stepwise loader: 4 animated setup steps complete sequentially → auto-navigates to `home`

---

## What We're NOT Doing

- Real Firebase Auth registration (mock only)
- Real file upload / OCR / embeddings in step 4 (mock file list only)
- Real Drift persistence of onboarding data (mock only)
- Password reset / forgot flow (separate feature)
- Anything past `home` navigation

---

## Implementation Approach

**create_account**: add `register` to `UserCubit` via `hygen cubit update`, then complete the existing scaffold with the form UI. The `_LoginListener`-equivalent for register navigates to `onboarding` on success instead of flashing a toast.

**Onboarding**: one screen file (`onboarding.dart`) hosts a `PageView` with 4 step pages. `_ScreenState` owns all ephemeral multi-step data (page controller, institution, subjects list, window toggles, daily target, exam list, file list). Steps use `KeepAlivePageView` wrappers so state is preserved on back-navigation. Each step page is a separate `_widget` file (all exceed 30 lines). `OnboardingCubit.complete()` is called with the assembled `OnboardingData` when "Finish setup" is tapped.

**Data flow**: `_ScreenState.buildData(userId)` assembles `OnboardingData` from all step fields when the user finishes. The cubit receives the model, the repo gets a raw Map per ADR-013 (repo purity).

**Stepwise loader**: pure UI screen — no cubit. `_ScreenState` uses a `Timer` to advance step states (pending → active → done) at fixed intervals, then calls `AppRoutes.home.pushReplace(context)` when all steps complete.

**No FormBuilder for onboarding**: the multi-step PageView with a dynamic subject list makes a single `GlobalKey<FormBuilderState>` impractical. Step 1 (institution) and step 2 (subject code/name fields) use `TextEditingController`s managed in `_ScreenState`. The `create_account` screen keeps its existing `FormBuilder` pattern.

---

## Phase 1 — Complete Create Account Screen

### Overview

Wire the existing `create_account` scaffold to `UserCubit.register`, add the form UI that matches the design (step header, password strength bar, terms checkbox, tagline), and make the success path navigate to onboarding.

### Changes Required

#### 1. Add `register` to UserCubit via hygen

```bash
hygen cubit update user --args "register:UserData"
```

**Injects into:**
- `lib/blocs/user/cubit.dart` — new `register(Map<String, dynamic> values)` async method
- `lib/blocs/user/state.dart` — new `BlocState<UserData> register` field
- `lib/repos/user/user_repo.dart` — new `register()` stub
- `lib/repos/user/user_data_provider.dart` — new `_UserProvider.register()` stub
- `lib/repos/user/user_mocks.dart` — mock data hook

**Manual fix — `user_mocks.dart`**: fill the `register` mock to return a `UserData` with `isOnboardingComplete: false`.

**Manual fix — `user_data_provider.dart`**: make `register(values)` return `Map<String, dynamic>` (per ADR-013) then have the cubit do `UserData.fromJson(raw)`. Keep consistent with existing methods.

#### 2. Add blocking listener for register

```bash
hygen screen consumer create_account --arg "user:register:register"
```

**Generated:** `lib/ui/screens/create_account/listeners/_register.dart`

**Manual fix — success path**: the generated listener uses `UIFlash.success(...)`. Replace with:
```dart
if (state.register.isSuccess) {
  AppRoutes.onboarding.pushReplace(context);
}
```

#### 3. Add widget files

```bash
hygen screen _widget create_account --widgets "tagline,password_strength"
```

**Generated:**
- `lib/ui/screens/create_account/widgets/_tagline.dart` — Islamic footer (same Arabic text as `lib/ui/screens/login/widgets/_tagline.dart`)
- `lib/ui/screens/create_account/widgets/_password_strength.dart` — 4-segment strength bar

#### 4. Implement `_state.dart`

**File:** `lib/ui/screens/create_account/_state.dart`

Add to `_ScreenState`:

```dart
// strength: 0–4 (none, weak, fair, strong, very strong)
int _passwordStrength = 0;
int get passwordStrength => _passwordStrength;

void onPasswordChanged(String? value) {
  if (value == null) return;
  _passwordStrength = _computeStrength(value);
  notifyListeners();
}

void submit(BuildContext context) {
  try {
    final form = formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    context.dismissKeyboard();
    UserCubit.c(context).register(form.value);
  } catch (e, st) {
    'create_account.submit error: $e\n$st'.appLog(level: AppLogLevel.error);
    UIFlash.error(context, 'Something went wrong. Please try again.');
  }
}

int _computeStrength(String password) {
  int score = 0;
  if (password.length >= 8) score++;
  if (password.contains(RegExp(r'[A-Z]'))) score++;
  if (password.contains(RegExp(r'[0-9]'))) score++;
  if (password.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
  return score;
}
```

**Note — T&C via FormBuilder, no separate bool**: `TermsAndPrivacyWidget` is wrapped in a `FormBuilderField<bool>`. No `_termsAccepted` field needed on `_ScreenState`; validation is handled by the form:

```dart
FormBuilderField<bool>(
  name: _FormKeys.termsAccepted,
  initialValue: false,
  validator: (value) =>
      value != true ? 'Please accept the Terms and Privacy Policy.' : null,
  builder: (field) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TermsAndPrivacyWidget(
        initialValue: field.value ?? false,
        onChanged: field.didChange,
      ),
      if (field.hasError) ...[
        Space.y.t04,
        Text(field.errorText!, style: AppText.b3.cl(AppTheme.c.error)),
      ],
    ],
  ),
)
```

#### 5. Implement the screen UI

**File:** `lib/ui/screens/create_account/create_account.dart`

UI structure (inside `_Body.build`):

```
SafeArea > Column(crossAxisAlignment: .stretch)
  ├─ Row: AppIconPainter + "TaleemMate" (same header as login)
  ├─ Space.y.t32
  ├─ Row: BackButton (left) + "01 / 03" mono text hardcoded (center) + SizedBox(36) (right)
  ├─ Space.y.t32
  ├─ "CREATE ACCOUNT" eyebrow label
  ├─ Space.y.t08
  ├─ "Let's set you up." h1
  ├─ "We'll calibrate your study plan after this. Takes about a minute." body text
  ├─ Space.y.t28
  ├─ AppFormTextInput (fullName)
  ├─ Space.y.t16
  ├─ AppFormTextInput (email, emailAddress keyboard)
  ├─ Space.y.t16
  ├─ AppFormTextInput (password, obscured, onChanged: → onPasswordChanged)
  ├─ Space.y.t08
  ├─ _PasswordStrength (strength: state.passwordStrength)
  ├─ Space.y.t16
  ├─ AppFormTextInput (confirm, obscured)
  ├─ Space.y.t24
  ├─ TermsAndPrivacyWidget (accepted: state.termsAccepted, onChanged: state.toggleTerms)
  ├─ Space.y.t24
  ├─ AppButton("Create account", onTap: () => state.submit(context), size: .large, mainAxisSize: .max)
  ├─ Space.y.t24
  ├─ Row: "Already have an account?" + AppTouch("Login" → AppRoutes.login.pushReplace)
  ├─ Spacer()
  └─ _Tagline()
```

**`_PasswordStrength`** widget renders 4 equal-width `Container`s in a `Row`. Segments fill from left; colour: empty = `AppTheme.c.divider`, strength 1 = red-ish, 2 = amber, 3 = green, 4 = bright green. Strength label ("Weak" / "Fair" / "Strong" / "Very Strong") rendered to the right. (< 30 lines total — no need for separate file, but hygen already created it.)

**`_FormKeys`** — add `termsAccepted`:
```dart
static const termsAccepted = 'termsAccepted';
```

**`overlayBuilders`** in `Screen`: `const [_RegisterListener()]`

### Hygen Commands

```bash
hygen cubit update user --args "register:UserData"
hygen screen consumer create_account --arg "user:register:register"
hygen screen _widget create_account --widgets "tagline,password_strength"
```

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new warnings/errors
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` — no conflicts

#### Manual Verification
- [ ] Form shows validation errors when submitted empty
- [ ] Password strength bar reacts as password is typed
- [ ] "Create account" is disabled/blocked when terms not accepted (UIFlash error)
- [ ] Submit triggers full-screen loader overlay
- [ ] On mock success → screen pushes to onboarding (placeholder screen acceptable here)
- [ ] "Login" link navigates back to login

**Implementation Note:** After Phase 1 passes all checks, pause before proceeding.

---

## Phase 2 — Onboarding Cubit + Repo Scaffold

### Overview

Generate the `OnboardingCubit` + `OnboardingRepo` 6-file structure and fill in mock implementations. No real persistence in v1.

### Changes Required

#### 1. Generate via hygen

```bash
hygen cubit nested onboarding --args "save:OnboardingData,complete:OnboardingData"
```

**Generated files:**
- `lib/blocs/onboarding/cubit.dart` — `OnboardingCubit` with `save()` + `complete()`
- `lib/blocs/onboarding/state.dart` — `OnboardingState`
- `lib/repos/onboarding/onboarding_repo.dart` — `OnboardingRepo`
- `lib/repos/onboarding/onboarding_data_provider.dart`
- `lib/repos/onboarding/onboarding_mocks.dart`
- `lib/repos/onboarding/onboarding_parser.dart`

Auto-injects into `lib/app.dart` under `// bloc-initiate-start`.

#### 2. Update `OnboardingData` model — add step 1 fields

**File:** `lib/core/models/onboarding/onboarding_data.dart`

The existing model is missing fields from the "About You" step. Add these fields:

```dart
@Default('') String name,
@Default('undergraduate') String educationLevel, // 'oLevels'|'matric'|'undergraduate'|'masters'
String? year,                                     // 'Y1'|'Y2'|'Y3'|'Y4'|null
@Default('passExams') String goal,               // 'passExams'|'understand'|'studyDaily'
```

Run after the model change:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. Manual fix — ADR-013 repo purity

**File:** `lib/repos/onboarding/onboarding_repo.dart`

Public methods must accept/return `Map<String, dynamic>`:
```dart
Future<Map<String, dynamic>> save(Map<String, dynamic> values) =>
    _OnboardingProvider.save(values);

Future<Map<String, dynamic>> complete(Map<String, dynamic> values) =>
    _OnboardingProvider.complete(values);
```

**File:** `lib/blocs/onboarding/cubit.dart`

Each method converts model → map before calling repo, map → model after:
```dart
Future<void> save(OnboardingData data) async {
  emit(state.copyWith(save: state.save.toLoading()));
  try {
    final raw = await OnboardingRepo.ins.save(data.toJson());
    emit(state.copyWith(save: state.save.toSuccess(data: OnboardingData.fromJson(raw))));
  } on Fault catch (e) {
    emit(state.copyWith(save: state.save.toFailed(fault: e)));
  }
}
```

#### 3. Fill mock data

**File:** `lib/repos/onboarding/onboarding_mocks.dart`

```dart
static Map<String, dynamic> completedOnboarding(String userId) => {
  'userId': userId,
  'step': 4,
  'subjects': [],
  'exams': [],
  'institution': 'NUST · School of EE & CS',
  'schedule': null,
  'uploadedMaterials': [],
};
```

**File:** `lib/repos/onboarding/onboarding_data_provider.dart`

`save(values)` → simulates a 300ms delay → returns `values` as-is.
`complete(values)` → simulates a 600ms delay → returns values merged with `{'step': 4}`.

### Hygen Commands

```bash
hygen cubit nested onboarding --args "save:OnboardingData,complete:OnboardingData"
```

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors
- [ ] `lib/app.dart` has `OnboardingCubit` in the `MultiBlocProvider`

#### Manual Verification
- [ ] App cold-starts without error after cubit auto-registration

---

## Phase 3 — Onboarding Screen (4-Step PageView)

### Overview

Create the `onboarding` screen with a 4-step `PageView`, `_ScreenState` holding all step data, and step page widgets for each step. Wire the `complete` action listener to navigate to `stepwise_loader` on success.

### Changes Required

#### 1. Generate screen scaffold

```bash
hygen screen new onboarding --formData false
```

**Generated + patched:**
- `lib/ui/screens/onboarding/onboarding.dart`
- `lib/ui/screens/onboarding/_state.dart`
- `lib/ui/screens/onboarding/widgets/_body.dart`
- `lib/router/routes.dart` — gains `static const onboarding = '/onboarding'`
- `lib/router/router.dart` — gains import + route mapping

#### 2. Add blocking listener for complete

```bash
hygen screen consumer onboarding --arg "onboarding:complete:complete"
```

**Generated:** `lib/ui/screens/onboarding/listeners/_complete.dart`

**Manual fix — success path**: replace `UIFlash.success(...)` with:
```dart
if (state.complete.isSuccess) {
  AppRoutes.stepwiseLoader.pushReplace(context);
}
```

#### 3. Add step page widget files

```bash
hygen screen _widget onboarding --widgets "1_step_about_you,2_step_subjects,3_step_schedule,4_step_material,so_far_card,add_subject_modal,file_item"
```

**Generated:**
- `_1_step_about_you.dart` — Step 1: name, institution, level, year, goal, tutor preview (widget class: `_StepAboutYou`)
- `_2_step_subjects.dart` — Step 2: subject list + "Add another subject" + so far card + inline `_SubjectEntry` (widget class: `_StepSubjects`)
- `_3_step_schedule.dart` — Step 3: time window toggles + daily target + exam list (widget class: `_StepSchedule`)
- `_4_step_material.dart` — Step 4: mock file upload + file list (widget class: `_StepMaterial`)
- `_so_far_card.dart` — recap card shown at the bottom of step 2 (widget class: `_SoFarCard`)
- `_add_subject_modal.dart` — bottom-sheet modal using `AppModalBase` with suggested courses (widget class: `_AddSubjectModal`)
- `_file_item.dart` — one file row in the "Added so far" list (widget class: `_FileItem`)

#### 4. Implement `_state.dart`

Helper classes (private, defined in `_state.dart`):

```dart
class _SubjectDraft {
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  double confidence = 0.5;
  String colorHex = '#6B6B85';

  void dispose() { codeCtrl.dispose(); nameCtrl.dispose(); }

  Subject toSubject() => Subject(
    id: const Uuid().v4(),
    code: codeCtrl.text.trim(),
    name: nameCtrl.text.trim(),
    colorHex: colorHex,
    confidenceLevel: confidence,
    order: 0,
  );
}

class _ExamDraft {
  String subjectId = '';
  DateTime date = DateTime.now().add(const Duration(days: 7));
  String label = '';

  Exam toExam() => Exam(id: const Uuid().v4(), subjectId: subjectId, date: date, label: label);
}
```

`_ScreenState` fields + methods:

```dart
class _ScreenState extends ChangeNotifier {
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final pageController = PageController();
  int currentStep = 0;

  // Step 1
  final institutionCtrl = TextEditingController();

  // Step 2
  final List<_SubjectDraft> subjects = [];

  // Step 3
  Set<String> enabledWindowIds = {};
  double dailyTargetHours = 3.5;
  final List<_ExamDraft> exams = [];

  // Step 4 — mocked files
  final List<Map<String, dynamic>> files = [
    {'type': 'PDF', 'name': 'CLRS — Chapter 7.pdf', 'size': '412 KB', 'status': 'indexed'},
    {'type': 'PDF', 'name': 'Forouzan slides L12.pdf', 'size': '8.1 MB', 'status': 'indexed'},
    {'type': 'IMG', 'name': 'OS lecture board (3)', 'size': '2.4 MB', 'status': 'processing'},
    {'type': 'NOTE', 'name': 'My recurrence notes.md', 'size': '3 KB', 'status': 'indexed'},
  ];

  void updateCurrentStep(int page) { currentStep = page; notifyListeners(); }

  void nextPage() => pageController.nextPage(
    duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  void prevPage() => pageController.previousPage(
    duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

  void addSubject() { subjects.add(_SubjectDraft()); notifyListeners(); }
  void removeSubject(int i) { subjects[i].dispose(); subjects.removeAt(i); notifyListeners(); }
  void setConfidence(int i, double v) { subjects[i].confidence = v; notifyListeners(); }

  void toggleWindow(String id) {
    enabledWindowIds.contains(id)
        ? enabledWindowIds.remove(id)
        : enabledWindowIds.add(id);
    notifyListeners();
  }
  void setDailyTarget(double v) { dailyTargetHours = v; notifyListeners(); }

  void addExam() { exams.add(_ExamDraft()); notifyListeners(); }

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
    final userId = UserCubit.c(context).state.init.data?.id ?? '';
    OnboardingCubit.c(context).complete(buildData(userId));
  }

  @override
  void dispose() {
    pageController.dispose();
    nameCtrl.dispose();
    institutionCtrl.dispose();
    for (final s in subjects) s.dispose();
    super.dispose();
  }
}
```

#### 5. Implement `_body.dart`

The main body renders a `Column` with:
1. `_StepHeader` — back arrow + "01 / 04" counter + skip button (inline Row, < 30 lines, no widget file needed)
2. `Expanded(child: PageView(physics: NeverScrollableScrollPhysics, ...))` with 4 `KeepAlivePageView` children

```dart
PageView(
  controller: state.pageController,
  physics: const NeverScrollableScrollPhysics(),
  onPageChanged: state.updateCurrentStep,
  children: const [
    KeepAlivePageView(child: _StepAboutYou()),
    KeepAlivePageView(child: _StepSubjects()),
    KeepAlivePageView(child: _StepSchedule()),
    KeepAlivePageView(child: _StepMaterial()),
  ],
)
```

Step header logic:
- Back arrow: `if (state.currentStep == 0)` → `AppRoutes.createAccount.pushReplace` (can't go back to sign-up) else → `state.prevPage()`
- Counter: `'${(state.currentStep + 1).toString().padLeft(2, '0')} / 04'` (01/04 … 04/04)
- Progress bar: 4-segment bar, `state.currentStep + 1` segments filled (matches the design's 4-tick progress indicator)
- Skip: shown on ALL steps (01/04 shows "Skip", 04/04 shows "Skip for now"). Taps `state.nextPage()` (step 3) or `state.finish(context)` (step 4).

#### 6. Implement step widgets

**`_StepAboutYou`** (step 1 — About You, confirmed from updated design):
- Eyebrow "STEP 1 OF 4 · ABOUT YOU"
- Title "Let's set the table."
- Subtitle "A few basics so your tutor knows how to talk to you. You can change any of this later."

**YOUR NAME**: editable text field wired to `state.nameCtrl`, pre-filled from `UserCubit.c(context).state.register.data?.name ?? ''`

**INSTITUTION**: text field wired to `state.institutionCtrl` + row of quick-pick pill chips:
- Chips: NUST (selected state = dark fill), FAST, LUMS, COMSATS, UET Lahore, PIEAS, "or type your own" (muted label, not a chip)
- Tapping a chip fills the text field and marks that chip selected
- User can ignore chips and type freely

**YOU'RE IN**: 2 × 2 grid of selection tiles (each is a bordered card that fills dark on selection):
- O / A Levels | Matric / FSc
- Undergraduate | Master's
- Selection stored in `state.educationLevel` (enum or String)

**YEAR** (conditional — shown only when Undergraduate or Master's selected):
- Pill chips: Y1, Y2, Y3, Y4
- Tapping selects that year; stored in `state.year`

**WHAT BRINGS YOU HERE?**: label row ("Pick one — sets the tone of your tutor") + 3 radio cards (each card: radio circle + bold title + muted subtitle):
- "Pass upcoming exams" / "Plan around midterms / finals"
- "Actually understand it" / "Build intuition, not just answers"
- "Study every day" / "Small consistent blocks"
- Selection stored in `state.goal` (enum or String)

**TUTOR PREVIEW** card (amber left border, "● TUTOR PREVIEW" chip label):
- Italic serif quote that changes based on `state.goal`:
  - Pass exams: *"Salaam, Hamza. We'll work backwards from your exam dates so nothing sneaks up. Once you add your subjects, I'll suggest where to start."*
  - Understand it: a different tutor tone (e.g. *"We'll focus on building real intuition…"*)
  - Study daily: *"Consistency is the goal — I'll plan small, manageable blocks every day."*
- Three goal quotes are hardcoded mock strings

- `Space.y.t24` + "Continue" `AppButton` → `state.nextPage()`

**`_ScreenState` additions for step 1**:
```dart
// Step 1 - About You
final nameCtrl = TextEditingController();
final institutionCtrl = TextEditingController();
String? selectedInstitutionChip;         // 'NUST' | 'FAST' | ...
String educationLevel = 'Undergraduate'; // default
String? year = 'Y3';                     // null = not applicable
String goal = 'passExams';              // 'passExams' | 'understand' | 'studyDaily'

void selectInstitutionChip(String chip) {
  selectedInstitutionChip = chip;
  institutionCtrl.text = chip;
  notifyListeners();
}
void setEducationLevel(String level) {
  educationLevel = level;
  if (level == 'oLevels' || level == 'matric') year = null;
  notifyListeners();
}
void setYear(String? y) { year = y; notifyListeners(); }
void setGoal(String g) { goal = g; notifyListeners(); }
```

**Dispose additions**:
```dart
nameCtrl.dispose();
institutionCtrl.dispose();
```

**`_StepSubjects`** (step 2):
- Eyebrow "STEP 2 OF 4 · ABOUT YOU"
- Title "Which subjects this term?"
- Subtitle from design
- `ListView` of `_SubjectEntry` widgets (one per `state.subjects[i]`)
- "Add another subject" ghost button → opens `_AddSubjectModal` via `showModalBottomSheet`
- `_SoFarCard`
- "Continue" `AppButton` → `state.nextPage()`

**`_SubjectEntry`** (per-subject row — inline in `_step_subjects.dart`, < 30 lines per entry):
- Colour dot (using `subject.colorHex`)
- Course code (mono label)
- Subject name
- Confidence label right-aligned ("Shaky" / "Getting there" / "Confident" with colour coding)
- `Slider(value: subject.confidence, onChanged: (v) => state.setConfidence(i, v))`

**Add Subject flow** — `showModalBottomSheet` from "Add another subject" button:

```dart
void openAddSubjectModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddSubjectModal(
      suggestedSubjects: _mockSuggestions(
        state.selectedInstitutionChip, state.year),
      onAdd: (draft) { state.addSubjectDraft(draft); },
    ),
  );
}
```

**`_AddSubjectModal`** (lives in `_step_subjects.dart` or a new `_widget` file if it exceeds 30 lines — it will, so extract it):

Uses `AppModalBase` as its outer container with `canPop: true`, `dragger: true`.

Inner content (passed as `child:`):
- Section heading "NEW SUBJECT" + subtitle "Add a course"
- CODE: labelled text field (`TextEditingController`)
- SUBJECT NAME: labelled text field (`TextEditingController`)
- TAG COLOR: row of colour dot chips (6–8 preset hex colours, one selected at a time)
- STARTING CONFIDENCE: label + slider (0–1) + confidence label
- SUGGESTED section:
  - 4 tappable suggestion rows: code chip + name + muted reason text
  - Suggestions are mocked per institution+year: e.g. for NUST+Y3 → CS-200 Discrete Math, MT-204 Linear Algebra, CS-370 Database Systems, HU-101 Communication Skills
  - Tapping a suggestion auto-fills CODE and SUBJECT NAME fields

`actions:` two buttons:
- `AppButton(label: 'Cancel', style: .creamy, onTap: () => Navigator.pop(context))`
- `AppButton(label: 'Add subject', onTap: () { /* validate, call onAdd, pop */ })`

**`_ScreenState` helper for adding**:
```dart
void addSubjectDraft(_SubjectDraft draft) {
  subjects.add(draft);
  notifyListeners();
}
```

**`_SoFarCard`** (step 2 recap):
- Section heading "SO FAR"
- 4 rows: Name (from `UserCubit`), Institution (from `state.institutionCtrl`), Midterms (from first exam date range or "–"), Daily window (from `state.dailyTargetHours` + derived window label)
- Subtle surface card with rounded corners

**`_StepSchedule`** (step 3):
- Eyebrow "STEP 3 OF 4 · YOUR RHYTHM"
- Title "When do you study best?"
- Subtitle from design
- 5 `_TimeWindowTile`s (inline widget, < 30 lines each) — checkbox + label + time range
  - `afterFajr` → "After Fajr · 05:30–07:00"
  - `morning` → "Morning · 09:00–12:00"
  - `afternoon` → "Afternoon · 14:00–16:00"
  - `evening` → "Evening · 16:30–19:00"
  - `afterIsha` → "After Isha · 21:00–23:00"
- "DAILY TARGET" label + `Slider(min: 0.5, max: 6.0, divisions: 11)` + formatted label ("3.5 hrs")
- "UPCOMING EXAMS" section heading
- Dynamic list of exam rows (subject picker + date picker)
- "Add exam" button → `state.addExam()`
- "Continue" `AppButton` → `state.nextPage()`

Note on `_TimeWindowTile`: it has 2 children (checkbox + text) which is below the 5-child threshold and under 30 lines — inline it in `_step_schedule.dart`.

**`_StepMaterial`** (step 4):
- Eyebrow "STEP 4 OF 4 · MATERIAL"
- Title "Bring your notes in."
- Subtitle from design
- Dashed "Tap to add files" upload area (tapping shows a `UIFlash.info` mock toast: "File upload coming soon")
- Source shortcut chips: Files / Photos / Drive (same mock toast on tap)
- "ADDED SO FAR" section heading
- `ListView` of `_FileItem` widgets from `state.files`
- Privacy note (small muted text)
- "Finish setup" `AppButton` → `state.finish(context)`
- "Skip for now" ghost/text button → `state.finish(context)` (same path)

**`_FileItem`**: type badge (PDF/IMG/NOTE/SLIDE) with colour from `CATALOGUE.md` colour map, name, size, status badge ("INDEXED" or gold spinner).

### Hygen Commands

```bash
hygen screen new onboarding --formData false
hygen screen consumer onboarding --arg "onboarding:complete:complete"
hygen screen _widget onboarding --widgets "1_step_about_you,2_step_subjects,3_step_schedule,4_step_material,so_far_card,add_subject_modal,file_item"
```

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors
- [ ] `AppRoutes.onboarding` route resolves to `OnboardingScreen`
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` — clean

#### Manual Verification
- [ ] Navigating create_account → onboarding works
- [ ] PageView does NOT swipe (physics: `NeverScrollableScrollPhysics`)
- [ ] Back arrow on step 1 pops to create_account; on steps 2–4 goes back one page
- [ ] Skip button visible on steps 2–4, hidden on step 1
- [ ] Institution field persists when navigating away from step 1 and back (KeepAlive)
- [ ] Adding a subject on step 2 renders a new entry row
- [ ] Confidence slider updates the label (Shaky / Getting there / Confident) in real time
- [ ] "So far" card updates when institution is typed
- [ ] Time window toggles turn on/off
- [ ] Daily target slider shows formatted value
- [ ] Tapping "Tap to add files" shows mock toast
- [ ] "Finish setup" triggers full-screen loader
- [ ] On mock complete success → pushes to stepwise_loader (placeholder acceptable)

---

## Phase 4 — Stepwise Loader Screen

### Overview

A pure-UI, timer-driven screen that animates through 4 "Finishing setup" steps, then pushes to home. No cubit.

### Changes Required

#### 1. Generate screen scaffold

```bash
hygen screen new stepwise_loader --formData false
```

**Generated + patched:**
- `lib/ui/screens/stepwise_loader/stepwise_loader.dart`
- `lib/ui/screens/stepwise_loader/_state.dart`
- `lib/ui/screens/stepwise_loader/widgets/_body.dart`
- `lib/router/routes.dart` — gains `static const stepwiseLoader = '/stepwise-loader'`
- `lib/router/router.dart` — gains import + route mapping

#### 2. Implement `_state.dart`

```dart
class _ScreenState extends ChangeNotifier {
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  // 0 = pending, 1 = active, 2 = done
  List<int> stepStates = [1, 0, 0, 0]; // first step starts active immediately
  Timer? _timer;
  int _activeIndex = 0;

  void startSequence(BuildContext context) {
    _timer = Timer.periodic(const Duration(milliseconds: 900), (t) {
      stepStates[_activeIndex] = 2; // mark current as done
      _activeIndex++;
      if (_activeIndex < stepStates.length) {
        stepStates[_activeIndex] = 1; // next becomes active
        notifyListeners();
      } else {
        t.cancel();
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 600), () {
          AppRoutes.home.pushReplace(context);
        });
      }
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
}
```

Call `state.startSequence(context)` from a `StatefulWidget` or `didChangeDependencies` equivalent. Use a `WidgetsBindingObserver` or `initState` override — since the screen uses `_ScreenState` (ChangeNotifier), trigger start from a one-time call inside `_Body.build` guarded by a `_started` flag.

Actually, use `initState` in a thin `StatefulWidget` wrapper or call it from a `Consumer` the first time `isInitial` is true. Simplest: add a `bool _sequenceStarted = false` flag in `_ScreenState`, start from `_Body.build` on first render.

#### 3. Implement `_body.dart`

```
Screen(child: SafeArea(child: Column(crossAxisAlignment: .stretch)
  ├─ Space.y.t48
  ├─ "STEP 4 OF 4 · PERSONALISING" eyebrow (top-left, mono, muted)
  ├─ Space.y.t12
  ├─ "Finishing setup" h1
  ├─ Space.y.t08
  ├─ "Building your study plan from what you've told us." body text (muted)
  ├─ Space.y.t48
  ├─ _StepRow × 4 (each row: icon + label)
  ├─ Spacer()
  └─ _LoaderFooter (صَبْر footer)
```

**`_StepRow`** (inline, < 30 lines):
- State 0 (pending): open circle icon, muted label
- State 1 (active): spinning indicator (small `CircularProgressIndicator`), normal label + amber "Working on it..." subtitle
- State 2 (done): filled check icon (green), label

Step labels:
1. "Saving your subjects"
2. "Indexing uploaded material"
3. "Calibrating today's plan"
4. "Almost there — readying your home screen"

**`_LoaderFooter`** (inline):
- *Patience — صَبْر — you'll be set up in a few seconds.*
- Muted, centred, italic serif for the Arabic word

### Hygen Commands

```bash
hygen screen new stepwise_loader --formData false
```

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors
- [ ] `AppRoutes.stepwiseLoader` route resolves correctly

#### Manual Verification
- [ ] Screen opens showing step 1 as "active" (spinner), steps 2–4 pending
- [ ] Steps advance one-by-one with ~900 ms between transitions
- [ ] Each completed step shows a checkmark
- [ ] After all 4 complete, app navigates to home ~600 ms later
- [ ] No back navigation is possible (home replaces the stack)
- [ ] Arabic صَبْر footer renders correctly (Nastaliq or system font fallback)

---

## Testing Strategy

### Unit Tests
- `OnboardingCubit`: test `save` and `complete` state transitions (loading → success, loading → failed)
- `UserCubit.register`: test register state transitions

### Widget Tests
- `CreateAccountScreen`: form validation, password strength bar reactivity, terms toggle, submit triggers cubit
- `OnboardingScreen`: back/forward page navigation, KeepAlive state preservation across page changes

### Manual Testing Steps
1. Cold start → login screen
2. Tap "Create account" → create_account screen
3. Fill form with weak password → verify strength bar
4. Submit without terms → verify error flash
5. Submit with valid data → loader → onboarding step 1
6. Navigate all 4 steps, go back on step 3, verify step 2 data still populated
7. "Finish setup" → loader → stepwise_loader
8. Watch all 4 loader steps complete → home

---

## Architecture Checklist
- [ ] `App.init(context)` called at top of every `build()`
- [ ] UI layer (`_state.dart`) does not call Firebase or HTTP directly — delegates to cubits
- [ ] Cubits do not import from `lib/ui/`
- [ ] State accessed via `OnboardingCubit.c(context)` / `_ScreenState.s(context)` — not `context.read<X>()`
- [ ] Firebase/HTTP exceptions converted to typed `Fault` subtypes before emitting cubit state
- [ ] All boilerplate generated via `hygen` — no hand-created screen/cubit/provider files
- [ ] `OnboardingRepo` public methods accept/return `Map<String, dynamic>` (ADR-013)
- [ ] Spacing uses `Space.x.t*` / `Space.y.t*` tokens only — no raw `SizedBox` or `Padding`
- [ ] No `FocusNode`s unless needed for programmatic focus
- [ ] Widget files only created for components ≥ 5 child widgets or ≥ 30 lines

---

## Design Clarifications (Resolved)

1. **Step counters**: create_account hardcodes `"01 / 03"`. Onboarding PageView uses its own `"01 / 04"` → `"04 / 04"` counter (page index + 1). These are independent indicators on separate screens.

2. **Step 1 "About You"** fields confirmed (from updated design + user images): YOUR NAME, INSTITUTION + quick-pick chips, YOU'RE IN grid, YEAR chips (conditional), WHAT BRINGS YOU HERE radio group, TUTOR PREVIEW card.

3. **Midterms in "So Far" card**: show `"–"` until step 3 exams are added. Live-updates once exams exist.

---

## References

- Design HTML: `TaleemMate.html` (screens: "00 · Sign up", "01 · Onboarding · 02/04 Subjects", "01 · Onboarding · 03/04 Schedule", "01 · Onboarding · 04/04 Material", "09b · Loading (Stepwise)")
- Feature scope: `docs/features/CATALOGUE.md` — sections 1 (Auth), 2 (Onboarding), 10 (Loading)
- ADR-013 (repo purity): `docs/architecture/DECISIONS.md`
- Reference screen: `lib/ui/screens/login/login.dart`
- Reference listener: `lib/ui/screens/login/listeners/_login.dart`
- KeepAlive helper: `lib/ui/widgets/headless/keep_alive_page_view.dart`
- OnboardingData model: `lib/core/models/onboarding/onboarding_data.dart`
