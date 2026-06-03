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
    final confidenceColor = _confidenceColor(_draft.confidence);

    return AppModalBase(
      dragger: true,
      canPop: true,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const _ModalHeader(eyebrow: 'NEW SUBJECT', title: 'Add a course'),
          Space.y.t24,

          // CODE + SUBJECT NAME side by side
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                flex: 2,
                child: _ModalTextField(
                  label: 'CODE',
                  controller: _draft.codeCtrl,
                  hint: 'e.g. CS-200',
                ),
              ),
              Space.x.t12,
              Expanded(
                flex: 3,
                child: _ModalTextField(
                  label: 'SUBJECT NAME',
                  controller: _draft.nameCtrl,
                  hint: 'e.g. Discrete Mathematics',
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
          _TagColorPicker(
            selected: _colorHex,
            onSelect: (hex) => setState(() => _colorHex = hex),
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
                _confidenceLabel(_draft.confidence),
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

          if (widget.suggestedSubjects.isNotEmpty)
            _SubjectSuggestions(
              suggestions: widget.suggestedSubjects,
              onFill: _fillFromSuggestion,
            ),

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
}
