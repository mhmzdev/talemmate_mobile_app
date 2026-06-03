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

  static const _goalTitles = [
    'Pass upcoming exams',
    'Actually understand it',
    'Study every day',
  ];
  static const _goalSubs = [
    'Plan around midterms / finals',
    'Build intuition, not just answers',
    'Small consistent blocks',
  ];

  static const _tutorPreviews = {
    OnboardingGoal.passExams:
        '"Salaam. We\'ll work backwards from your exam dates so nothing sneaks up on you. Once you add your subjects, I\'ll suggest where to start."',
    OnboardingGoal.understand:
        '"Let\'s build real intuition — not just answers. We\'ll slow down where it matters and make sure each concept clicks before moving on."',
    OnboardingGoal.studyDaily:
        '"Consistency is the goal. I\'ll plan small, manageable blocks every day so studying becomes a habit, not a sprint."',
  };

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
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
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
                        for (final chip in _institutions)
                          _InstitutionChip(
                            label: chip,
                            selected: state.selectedInstitutionChip == chip,
                            onTap: () => state.selectInstitutionChip(chip),
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
                        children: [
                          for (final y in _years)
                            _YearChip(
                              label: y,
                              selected: state.year == y,
                              onTap: () => state.setYear(y),
                            ),
                        ],
                      ),
                    ],

                    Space.y.t24,

                    // WHAT BRINGS YOU HERE?
                    Text(
                      'WHAT BRINGS YOU HERE?',
                      style: AppText.l1b
                          .cl(AppTheme.c.subText)
                          .copyWith(letterSpacing: 1.2),
                    ),
                    Space.y.t04,
                    Text(
                      'Pick one — sets the tone of your tutor',
                      style: AppText.b2.cl(AppTheme.c.subText),
                    ),
                    Space.y.t08,
                    ...OnboardingGoal.values.map((goal) {
                      final index = OnboardingGoal.values.indexOf(goal);
                      return Column(
                        children: [
                          _GoalCard(
                            goalKey: goal,
                            title: _goalTitles[index],
                            subtitle: _goalSubs[index],
                            selected: state.goal == goal,
                            onTap: () => state.setGoal(goal),
                          ),
                          Space.y.t08,
                        ],
                      );
                    }),

                    Space.y.t16,

                    // TUTOR PREVIEW
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.c.subBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(
                          left: BorderSide(color: Color(0xFFE09A2B), width: 3),
                        ),
                      ),
                      padding: Space.sym(SpaceToken.t16, SpaceToken.t16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE09A2B,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '● TUTOR PREVIEW',
                              style: AppText.l1b
                                  .cl(const Color(0xFFE09A2B))
                                  .copyWith(letterSpacing: 1.0),
                            ),
                          ),
                          Space.y.t12,
                          Text(
                            _tutorPreviews[state.goal] ??
                                _tutorPreviews[OnboardingGoal.passExams]!,
                            style: AppText.b1
                                .cl(AppTheme.c.text)
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
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
              mainAxisSize: MainAxisSize.max,
              size: .large,
            ),
          ],
        ),
      ),
    );
  }
}

class _InstitutionChip extends StatelessWidget {
  const _InstitutionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.text : AppTheme.c.subBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.c.text : AppTheme.c.border,
          ),
        ),
        child: Text(
          label,
          style: AppText.b2.cl(
            selected ? AppTheme.c.background : AppTheme.c.text,
          ),
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppProps.medium,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.text : AppTheme.c.specBackground,
          borderRadius: 8.radius(),
          border: Border.all(
            color: selected ? AppTheme.c.text : AppTheme.c.border,
          ),
        ),
        child: Text(
          label,
          style: AppText.b2
              .cl(
                selected ? AppTheme.c.background : AppTheme.c.text,
              )
              .w(6),
          textAlign: .center,
        ),
      ),
    );
  }
}

class _YearChip extends StatelessWidget {
  const _YearChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppProps.medium,
        padding: Space.sym(16, 4),
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.c.accent : AppTheme.c.border,
          ),
        ),
        child: Text(
          label,
          style: AppText.b2.cl(selected ? Colors.white : AppTheme.c.text),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goalKey,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final OnboardingGoal goalKey;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: Space.sym(12, 16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.subBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppTheme.c.accent : AppTheme.c.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppTheme.c.accent : AppTheme.c.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.c.accent,
                        ),
                      ),
                    )
                  : null,
            ),
            Space.x.t12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.b1b),
                  Text(subtitle, style: AppText.b2.cl(AppTheme.c.subText)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
