part of '../subjects_editor.dart';

/// Bottom sheet for adding a new subject. Captures the editor [_ScreenState] in
/// [show] (the modal route sits outside the editor's provider scope) and
/// dispatches the new row to it on submit.
class _AddSubjectSheet extends StatefulWidget {
  const _AddSubjectSheet({required this.state});

  final _ScreenState state;

  static Future<void> show(BuildContext context) {
    final state = _ScreenState.s(context);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: const RouteSettings(name: '/modal/add-subject'),
      builder: (_) => _AddSubjectSheet(state: state),
    );
  }

  @override
  State<_AddSubjectSheet> createState() => _AddSubjectSheetState();
}

class _AddSubjectSheetState extends State<_AddSubjectSheet> {
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String _colorHex = '#6B6B85';
  double _confidence = 0.5;

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _codeCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      UIFlash.error(context, 'Give the subject a name.');
      return;
    }
    if (code.isNotEmpty && widget.state.existingCodes.contains(code.toLowerCase())) {
      UIFlash.error(context, 'You\'ve already added a subject with this code.');
      return;
    }
    widget.state.addSubject(
      code: code,
      name: name,
      colorHex: _colorHex,
      confidence: _confidence,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppModalBase(
      dragger: true,
      title: 'Add a subject',
      subtitle: 'It\'ll be weighted into your study plan.',
      actions: [
        AppButton(label: 'Add subject', mainAxisSize: .max, onTap: _submit),
        AppButton(
          label: 'Cancel',
          style: .creamy,
          mainAxisSize: .max,
          onTap: () => Navigator.pop(context),
        ),
      ],
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _codeCtrl,
                  style: AppText.b1,
                  decoration: _editorInputDec('Code'),
                ),
              ),
              Space.x.t12,
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _nameCtrl,
                  style: AppText.b1,
                  textCapitalization: .words,
                  decoration: _editorInputDec('Subject name'),
                ),
              ),
            ],
          ),
          Space.y.t16,
          Text(
            'TAG COLOUR',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t08,
          _ColorDots(
            selected: _colorHex,
            onSelect: (hex) => setState(() => _colorHex = hex),
          ),
          Space.y.t16,
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
                _confidenceLabel(_confidence),
                style: AppText.b2.cl(_confidenceColor(_confidence)),
              ),
            ],
          ),
          Slider(
            padding: Space.v.t08,
            value: _confidence,
            onChanged: (v) => setState(() => _confidence = v),
            activeColor: _confidenceColor(_confidence),
          ),
        ],
      ),
    );
  }
}
