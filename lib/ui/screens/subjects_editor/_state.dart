part of 'subjects_editor.dart';

/// One editable subject in the editor. Wraps a [Subject] with live text
/// controllers; [isNew] rows were added in this session (their [id] is freshly
/// minted).
class _SubjectDraft {
  _SubjectDraft({
    required this.id,
    required String code,
    required String name,
    required this.colorHex,
    required this.confidence,
    this.isNew = false,
  }) : codeCtrl = TextEditingController(text: code),
       nameCtrl = TextEditingController(text: name);

  factory _SubjectDraft.from(Subject s) => _SubjectDraft(
    id: s.id,
    code: s.code,
    name: s.name,
    colorHex: s.colorHex,
    confidence: s.confidenceLevel,
  );

  final String id;
  final TextEditingController codeCtrl;
  final TextEditingController nameCtrl;
  String colorHex;
  double confidence;
  final bool isNew;

  void dispose() {
    codeCtrl.dispose();
    nameCtrl.dispose();
  }

  Subject toSubject(int order) => Subject(
    id: id,
    code: codeCtrl.text.trim(),
    name: nameCtrl.text.trim(),
    colorHex: colorHex,
    confidenceLevel: confidence,
    order: order,
  );
}

class _ScreenState extends ChangeNotifier {
  _ScreenState(List<Subject> initial)
    : _drafts = initial.map(_SubjectDraft.from).toList(),
      _originalIds = initial.map((s) => s.id).toSet();

  // ignore: unused_element
  static _ScreenState s(BuildContext context, [bool listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  static const _uuid = Uuid();

  final List<_SubjectDraft> _drafts;
  final Set<String> _originalIds;
  final Set<String> _removedIds = {};

  List<_SubjectDraft> get drafts => List.unmodifiable(_drafts);

  Set<String> get existingCodes =>
      _drafts.map((d) => d.codeCtrl.text.trim().toLowerCase()).toSet();

  /// Adds a freshly-minted subject row from the add sheet.
  void addSubject({
    required String code,
    required String name,
    required String colorHex,
    required double confidence,
  }) {
    _drafts.add(
      _SubjectDraft(
        id: _uuid.v4(),
        code: code,
        name: name,
        colorHex: colorHex,
        confidence: confidence,
        isNew: true,
      ),
    );
    notifyListeners();
  }

  void removeAt(int index) {
    final draft = _drafts.removeAt(index);
    if (_originalIds.contains(draft.id)) _removedIds.add(draft.id);
    draft.dispose();
    notifyListeners();
  }

  void setConfidence(int index, double value) {
    _drafts[index].confidence = value;
    notifyListeners();
  }

  void setColor(int index, String hex) {
    _drafts[index].colorHex = hex;
    notifyListeners();
  }

  /// Subjects to upsert — re-ordered by their current position so the `order`
  /// column stays stable for Library grouping.
  List<Subject> get upserts =>
      _drafts.asMap().entries.map((e) => e.value.toSubject(e.key)).toList();

  List<String> get removedIds => _removedIds.toList();

  /// Every row carries a name — the minimum to persist each subject.
  bool get isValid => _drafts.every((d) => d.nameCtrl.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (final d in _drafts) {
      d.dispose();
    }
    super.dispose();
  }
}
