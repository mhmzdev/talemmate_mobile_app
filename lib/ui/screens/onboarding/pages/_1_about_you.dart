part of '../onboarding.dart';

class _StepAboutYou extends StatelessWidget {
  const _StepAboutYou();

  static const _institutions = [
    'NUST',
    'FAST',
    'LUMS',
    'COMSATS',
    'UET',
    'PIEAS',
  ];

  static const _years = ['Y1', 'Y2', 'Y3', 'Y4'];

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);

    return Padding(
      padding: Space.h.t20,
      child: FormBuilder(
        initialValue: _FormData.initialValues(),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'STEP 1 OF 4 · ABOUT YOU',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t08,
                    Text('Let\'s set the table.', style: AppText.h1),
                    Space.y.t04,
                    Text(
                      'A few basics so your tutor knows how to talk to you. You can change any of this later.',
                      style: AppText.b1.cl(AppTheme.c.subText),
                    ),
                    Space.y.t24,

                    // YOUR NAME
                    Text(
                      'YOUR NAME',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t08,
                    AppFormTextInput(
                      name: _FormKeys.name,
                      controller: state.nameCtrl,
                      disposeController: false,
                      placeholder: 'Your name',
                      textCapitalization: .words,
                      textInputAction: .next,
                      onChanged: (_) => state.refresh(),
                    ),
                    Space.y.t24,

                    // INSTITUTION
                    Text(
                      'INSTITUTION',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t08,
                    AppFormTextInput(
                      name: _FormKeys.institution,
                      controller: state.institutionCtrl,
                      disposeController: false,
                      placeholder: 'Search or type your institution',
                      onChanged: (_) => state.refresh(),
                    ),
                    Space.y.t12,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: .center,
                      children: [
                        ..._institutions.map(
                          (chip) => _InstitutionChip(
                            label: chip,
                            selected: state.selectedInstitutionChip == chip,
                            onTap: () => state.selectInstitutionChip(chip),
                          ),
                        ),
                        Text(
                          'or type your own',
                          style: AppText.b2.cl(AppTheme.c.subText),
                        ),
                      ],
                    ),
                    Space.y.t24,

                    // YOU'RE IN
                    Text(
                      'YOU\'RE IN',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t08,
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 4,
                      children: EducationLevel.values
                          .map(
                            (level) => _LevelTile(
                              label: level.displayName,
                              selected: state.educationLevel == level,
                              onTap: () => state.setEducationLevel(level),
                            ),
                          )
                          .toList(),
                    ),

                    // YEAR (conditional)
                    if (state.educationLevel.hasYear) ...[
                      Space.y.t16,
                      Text(
                        'YEAR',
                        style: AppText.l1b
                            .cl(AppTheme.c.subText)
                            .copyWith(letterSpacing: 1.2),
                      ),
                      Space.y.t08,
                      Wrap(
                        spacing: 8,
                        children: _years
                            .map(
                              (y) => _YearChip(
                                label: y,
                                selected: state.year == y,
                                onTap: () => state.setYear(y),
                              ),
                            )
                            .toList(),
                      ),
                    ],

                    Space.y.t24,
                    const _GoalList(),
                    Space.y.t16,
                    const _TutorPreview(),
                    Space.y.t24,
                  ],
                ),
              ),
            ),
            Space.y.t12,
            AppButton(
              label: 'Continue',
              onTap: () {
                if (state.isStep1Valid) state.nextPage();
              },
              state: state.isStep1Valid ? .def : .disabled,
              mainAxisSize: .max,
              size: .large,
            ),
          ],
        ),
      ),
    );
  }
}
