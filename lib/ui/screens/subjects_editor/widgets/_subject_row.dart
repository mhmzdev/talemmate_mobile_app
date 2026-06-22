part of '../subjects_editor.dart';

/// One editable subject card: name + code fields, a confidence slider with a
/// live label, a colour picker, and a remove affordance.
class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.index, required this.draft});

  final int index;
  final _SubjectDraft draft;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context);

    return Container(
      padding: Space.sym(SpaceToken.t12, SpaceToken.t16),
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: 10.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: Space.t.t08,
                child: SubjectSwatch(colorHex: draft.colorHex, size: 10),
              ),
              Space.x.t12,
              Expanded(
                child: TextField(
                  controller: draft.nameCtrl,
                  style: AppText.b1b,
                  decoration: _editorInputDec('Subject name'),
                ),
              ),
              Space.x.t08,
              AppTouch(
                onTap: () => state.removeAt(index),
                hasSplash: false,
                child: Padding(
                  padding: Space.t.t04,
                  child: Icon(
                    LucideIcons.x,
                    size: SpaceToken.t20,
                    color: AppTheme.c.subText,
                  ),
                ),
              ),
            ],
          ),
          Space.y.t08,
          SizedBox(
            width: 140,
            child: TextField(
              controller: draft.codeCtrl,
              style: AppText.b2,
              decoration: _editorInputDec('Code e.g. CS-200'),
            ),
          ),
          Space.y.t08,
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'CONFIDENCE',
                style: AppText.l1b
                    .cl(AppTheme.c.subText)
                    .copyWith(letterSpacing: 1.2),
              ),
              Text(
                _confidenceLabel(draft.confidence),
                style: AppText.b2.cl(_confidenceColor(draft.confidence)),
              ),
            ],
          ),
          Slider(
            padding: Space.v.t08,
            value: draft.confidence,
            onChanged: (v) => state.setConfidence(index, v),
            activeColor: _confidenceColor(draft.confidence),
          ),
          Space.y.t04,
          _ColorDots(
            selected: draft.colorHex,
            onSelect: (hex) => state.setColor(index, hex),
          ),
        ],
      ),
    );
  }
}
