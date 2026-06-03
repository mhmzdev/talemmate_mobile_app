part of '../onboarding.dart';

class _AddSubjectModal extends StatefulWidget {
  const _AddSubjectModal({
    required this.suggestedSubjects,
    required this.existingCodes,
    required this.onAdd,
  });

  final List<Map<String, String>> suggestedSubjects;
  final Set<String> existingCodes;
  final ValueChanged<_SubjectDraft> onAdd;

  @override
  State<_AddSubjectModal> createState() => _AddSubjectModalState();
}

class _AddSubjectModalState extends State<_AddSubjectModal> {
  final _draft = _SubjectDraft();
  String _colorHex = '#6B6B85';
  bool _submitted = false;

  @override
  void dispose() {
    if (!_submitted) _draft.dispose();
    super.dispose();
  }

  void _fillFromSuggestion(Map<String, String> suggestion) {
    _draft.codeCtrl.text = suggestion['code'] ?? '';
    _draft.nameCtrl.text = suggestion['name'] ?? '';
    setState(() {});
  }

  void _submit() {
    final code = _draft.codeCtrl.text.trim();
    final name = _draft.nameCtrl.text.trim();
    if (code.isEmpty && name.isEmpty) return;
    if (code.isNotEmpty && widget.existingCodes.contains(code.toLowerCase())) {
      UIFlash.error(context, 'You\'ve already added a subject with this code.');
      return;
    }
    _draft.colorHex = _colorHex;
    _submitted = true;
    widget.onAdd(_draft);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final confidenceColor = _draft.confidence < 0.35
        ? const Color(0xFFE05252)
        : _draft.confidence < 0.7
        ? const Color(0xFFE09A2B)
        : const Color(0xFF4CAF50);

    return AppModalBase(
      dragger: true,
      canPop: true,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          // Header
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'NEW SUBJECT',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t04,
                    Text('Add a course', style: AppText.h1),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppTheme.c.subBackground,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppTheme.c.subText,
                  ),
                ),
              ),
            ],
          ),
          Space.y.t24,

          // CODE + SUBJECT NAME side by side
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'CODE',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t08,
                    TextField(
                      controller: _draft.codeCtrl,
                      style: AppText.b1,
                      decoration: _inputDec('e.g. CS-200'),
                    ),
                  ],
                ),
              ),
              Space.x.t12,
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'SUBJECT NAME',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t08,
                    TextField(
                      controller: _draft.nameCtrl,
                      style: AppText.b1,
                      decoration: _inputDec('e.g. Discrete Mathematics'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Space.y.t16,

          // TAG COLOR
          Text(
            'TAG COLOR',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          Wrap(
            spacing: 10,
            children: [
              for (final hex in _subjectColors)
                GestureDetector(
                  onTap: () => setState(() => _colorHex = hex),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: Color(int.parse(hex.replaceFirst('#', '0xFF'))),
                      border: Border.all(
                        color: _colorHex == hex
                            ? AppTheme.c.text
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Space.y.t16,

          // STARTING CONFIDENCE
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'STARTING CONFIDENCE',
                style: AppText.l1b
                    .cl(AppTheme.c.subText)
                    .copyWith(letterSpacing: 1.2),
              ),
              Text(
                _draft.confidence < 0.35
                    ? 'Shaky'
                    : _draft.confidence < 0.7
                    ? 'Getting there'
                    : 'Confident',
                style: AppText.b2.cl(confidenceColor),
              ),
            ],
          ),
          Slider(
            padding: Space.v.t16,
            value: _draft.confidence,
            onChanged: (v) => setState(() => _draft.confidence = v),
            activeColor: confidenceColor,
          ),

          // SUGGESTED section
          if (widget.suggestedSubjects.isNotEmpty) ...[
            const Divider(),
            Space.y.t08,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.c.accent),
                    borderRadius: 20.radius(),
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: AppTheme.c.accent,
                        ),
                      ),
                      Space.x.t04,
                      Text(
                        'SUGGESTED',
                        style: AppText.l1b
                            .cl(AppTheme.c.accent)
                            .copyWith(letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
                Space.x.t08,
                Text('Tap to fill', style: AppText.b2.cl(AppTheme.c.subText)),
              ],
            ),
            Space.y.t08,
            for (final s in widget.suggestedSubjects)
              GestureDetector(
                onTap: () => _fillFromSuggestion(s),
                child: Container(
                  margin: Space.b.t08,
                  padding: Space.sym(SpaceToken.t12, SpaceToken.t16),
                  decoration: BoxDecoration(
                    color: AppTheme.c.subBackground,
                    borderRadius: 10.radius(),
                    border: Border.all(color: AppTheme.c.border),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 52,
                        child: Text(
                          s['code'] ?? '',
                          style: AppText.b2.cl(AppTheme.c.subText),
                        ),
                      ),
                      Space.x.t12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(s['name'] ?? '', style: AppText.b1b),
                            Text(
                              s['reason'] ?? '',
                              style: AppText.b2.cl(AppTheme.c.subText),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.add,
                        size: 18,
                        color: AppTheme.c.subText,
                      ),
                    ],
                  ),
                ),
              ),
          ],

          Space.y.t16,
          // Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppButton(
                  label: 'Cancel',
                  style: .creamy,
                  onTap: () => Navigator.pop(context),
                  mainAxisSize: .max,
                  size: .large,
                ),
              ),
              Space.x.t12,
              Expanded(
                flex: 3,
                child: AppButton(
                  label: '+ Add subject',
                  onTap: _submit,
                  mainAxisSize: .max,
                  size: .large,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: AppText.b1.cl(AppTheme.c.subText),
    filled: true,
    fillColor: AppTheme.c.subBackground,
    border: OutlineInputBorder(
      borderRadius: 10.radius(),
      borderSide: BorderSide(color: AppTheme.c.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: 10.radius(),
      borderSide: BorderSide(color: AppTheme.c.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: 10.radius(),
      borderSide: BorderSide(color: AppTheme.c.accent),
    ),
    contentPadding: Space.sym(SpaceToken.t12, SpaceToken.t16),
  );
}
