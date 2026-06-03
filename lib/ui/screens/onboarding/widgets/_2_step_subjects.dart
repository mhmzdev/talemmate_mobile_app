part of '../onboarding.dart';

class _StepSubjects extends StatelessWidget {
  const _StepSubjects();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);

    return Padding(
      padding: Space.h.t20,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(
                    'STEP 2 OF 4 · SUBJECTS',
                    style: AppText.l1b
                        .cl(AppTheme.c.subText)
                        .copyWith(letterSpacing: 1.2),
                  ),
                  Space.y.t08,
                  Text('Which subjects this term?', style: AppText.h1),
                  Space.y.t04,
                  Text(
                    'Add what you\'re studying so I can build a plan around your actual workload.',
                    style: AppText.b1.cl(AppTheme.c.subText),
                  ),
                  Space.y.t24,

                  for (int i = 0; i < state.subjects.length; i++) ...[
                    _SubjectEntry(
                      index: i,
                      draft: state.subjects[i],
                      state: state,
                    ),
                    Space.y.t12,
                  ],

                  GestureDetector(
                    onTap: () => _openAddSubjectModal(context, state),
                    child: Container(
                      padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.c.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 18, color: AppTheme.c.subText),
                          Space.x.t08,
                          Text(
                            'Add another subject',
                            style: AppText.b1.cl(AppTheme.c.subText),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (state.subjects.isNotEmpty) ...[
                    Space.y.t24,
                    const _SoFarCard(),
                  ],
                  Space.y.t24,
                ],
              ),
            ),
          ),
          Space.y.t12,
          AppButton(
            label: 'Continue',
            onTap: state.nextPage,
            mainAxisSize: MainAxisSize.max,
            size: .large,
            state: state.subjects.isEmpty ? .disabled : .def,
          ),
        ],
      ),
    );
  }

  void _openAddSubjectModal(BuildContext context, _ScreenState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: const RouteSettings(name: '/modal/add-subject'),
      builder: (_) => _AddSubjectModal(
        suggestedSubjects: _subjectSuggestions(
          state.selectedInstitutionChip,
          state.year,
        ),
        existingCodes: state.subjects
            .map((s) => s.codeCtrl.text.trim().toLowerCase())
            .toSet(),
        onAdd: (draft) => state.addSubjectDraft(draft),
      ),
    );
  }

}

class _SubjectEntry extends StatelessWidget {
  const _SubjectEntry({
    required this.index,
    required this.draft,
    required this.state,
  });

  final int index;
  final _SubjectDraft draft;
  final _ScreenState state;

  static String _confidenceLabel(double v) {
    if (v < 0.35) return 'Shaky';
    if (v < 0.7) return 'Getting there';
    return 'Confident';
  }

  static Color _confidenceColor(double v) {
    if (v < 0.35) return const Color(0xFFE05252);
    if (v < 0.7) return const Color(0xFFE09A2B);
    return const Color(0xFF4CAF50);
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final dotColor = Color(int.parse(draft.colorHex.replaceFirst('#', '0xFF')));
    return Container(
      padding: Space.sym(SpaceToken.t12, SpaceToken.t16),
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
              ),
              Space.x.t08,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
