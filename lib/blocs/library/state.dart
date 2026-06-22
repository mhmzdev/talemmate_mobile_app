part of 'cubit.dart';

@immutable
class LibraryState extends Equatable {
  // --- session --- //
  /// Signed-in user's uid for the active session (ADR-014). Set via [initUid]
  /// on login / session-resume; cleared via [resetUid] on logout.
  final String? userId;

  // --- state data --- //
  /// All subjects, for grouping materials into per-subject sections.
  final List<Subject> subjects;

  // --- nested states --- //
  final BlocState<List<LibraryItem>> load;
  final BlocState<LibraryItem> add;
  final BlocState<LibraryItem> remove;

  /// Commit of a batch of subject edits from the Subjects editor — the signal
  /// the editor listens on (pop / offer-to-regenerate).
  final BlocState<Subject> saveSubject;

  const LibraryState({
    required this.userId,
    required this.subjects,
    required this.load,
    required this.add,
    required this.remove,
    required this.saveSubject,
  });

  LibraryState.def()
    : // root-def-constructor
      userId = null,
      subjects = const [],
      load = BlocState(),
      add = BlocState(),
      remove = BlocState(),
      saveSubject = BlocState();

  LibraryState copyWith({
    String? userId,
    List<Subject>? subjects,
    BlocState<List<LibraryItem>>? load,
    BlocState<LibraryItem>? add,
    BlocState<LibraryItem>? remove,
    BlocState<Subject>? saveSubject,
  }) {
    return LibraryState(
      userId: userId ?? this.userId,
      subjects: subjects ?? this.subjects,
      load: load ?? this.load,
      add: add ?? this.add,
      remove: remove ?? this.remove,
      saveSubject: saveSubject ?? this.saveSubject,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    userId,
    subjects,
    load,
    add,
    remove,
    saveSubject,
  ];
}
