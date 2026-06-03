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

                  _AddTile(
                    label: 'Add another subject',
                    onTap: () => _openAddSubjectModal(context, state),
                  ),
                  Space.y.t24,
                ],
              ),
            ),
          ),
          Space.y.t12,
          AppButton(
            label: 'Continue',
            onTap: state.nextPage,
            mainAxisSize: .max,
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
