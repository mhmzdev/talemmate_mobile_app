part of 'quiz.dart';

enum QuizPhase { taking, results }

/// Ephemeral quiz-taking state: which question we're on, what's been answered
/// (and whether feedback is revealed), the display-only stopwatch, and the
/// taking→results phase. No Firebase/Drift here — generation + answer recording
/// delegate to [QuizCubit].
class _ScreenState extends ChangeNotifier {
  _ScreenState({required this.subjectId, this.topicId, this.sourceItemIds});

  final String subjectId;
  final String? topicId;
  final List<String>? sourceItemIds;

  /// Resolved at generation time so answer recording can reuse it.
  String? userId;

  QuizPhase phase = QuizPhase.taking;
  int cursor = 0;

  /// questionIndex → selected option (null = skipped). A present key means the
  /// question has been answered/skipped and its feedback is revealed.
  final Map<int, int?> answers = {};

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  bool _started = false;

  /// Whether the current question's feedback is revealed.
  bool get revealed => answers.containsKey(cursor);

  /// The option picked for the current question (null = skipped/unanswered).
  int? get selected => answers[cursor];

  /// Display-only elapsed time as `m:ss`.
  String get elapsedLabel {
    final secs = _stopwatch.elapsed.inSeconds;
    final m = secs ~/ 60;
    final ss = (secs % 60).toString().padLeft(2, '0');
    return '$m:$ss';
  }

  /// Kicks generation once (deferred past build) — safe to call every build.
  void startIfNeeded(BuildContext context) {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) _generate(context);
    });
  }

  void _generate(BuildContext context) {
    final userState = UserCubit.c(context).state;
    final uid = userState.user?.uid ?? userState.userData?.uid;
    if (uid == null) return;
    userId = uid;
    QuizCubit.c(context).generate(
      userId: uid,
      subjectId: subjectId,
      topicId: topicId,
      sourceItemIds: sourceItemIds,
    );
  }

  /// Re-runs generation after a failure.
  void retry(BuildContext context) {
    _started = false;
    startIfNeeded(context);
  }

  /// Starts the display stopwatch once the quiz is shown (idempotent).
  void startClock() {
    if (_stopwatch.isRunning) return;
    _stopwatch.start();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => notifyListeners(),
    );
  }

  /// Reveals feedback for the current question and remembers the pick. A no-op
  /// once the question is answered — picks are immutable.
  void pick(int index) {
    if (revealed) return;
    answers[cursor] = index;
    notifyListeners();
  }

  /// Marks the current question skipped (no selection) and reveals feedback.
  void skip() {
    if (revealed) return;
    answers[cursor] = null;
    notifyListeners();
  }

  /// Advances to the next question, or finishes onto the results phase.
  void next(int total) {
    if (cursor < total - 1) {
      cursor++;
    } else {
      phase = QuizPhase.results;
      _stopwatch.stop();
      _ticker?.cancel();
    }
    notifyListeners();
  }

  /// Number correct across answered questions, using [questions] as the key.
  int score(List<QuizQuestion> questions) {
    var n = 0;
    answers.forEach((qi, sel) {
      if (sel != null &&
          qi < questions.length &&
          sel == questions[qi].correctAnswerIndex) {
        n++;
      }
    });
    return n;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  // ignore: unused_element
  static _ScreenState s(BuildContext context, [bool listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);
}
