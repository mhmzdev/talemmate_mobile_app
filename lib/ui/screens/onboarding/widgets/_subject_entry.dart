part of '../onboarding.dart';

class _SubjectEntry extends StatelessWidget {
  const _SubjectEntry({
    required this.index,
    required this.draft,
    required this.state,
  });

  final int index;
  final _SubjectDraft draft;
  final _ScreenState state;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final dotColor = _hexColor(draft.colorHex);
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
                padding: const EdgeInsets.only(top: 3),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(shape: .circle, color: dotColor),
                ),
              ),
              Space.x.t08,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      draft.codeCtrl.text,
                      style: AppText.b2.cl(AppTheme.c.subText),
                    ),
                    Text(draft.nameCtrl.text, style: AppText.b1b),
                  ],
                ),
              ),
              Text(
                _confidenceLabel(draft.confidence),
                style: AppText.b2.cl(_confidenceColor(draft.confidence)),
              ),
              Space.x.t08,
              GestureDetector(
                onTap: () => state.removeSubject(index),
                child: Icon(
                  Icons.close,
                  size: SpaceToken.t24,
                  color: AppTheme.c.subText,
                ),
              ),
            ],
          ),
          Slider(
            padding: Space.v.t16,
            value: draft.confidence,
            onChanged: (v) => state.setConfidence(index, v),
            activeColor: _confidenceColor(draft.confidence),
          ),
        ],
      ),
    );
  }
}
