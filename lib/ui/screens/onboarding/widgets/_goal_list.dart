part of '../onboarding.dart';

class _GoalList extends StatelessWidget {
  const _GoalList();

  static const _titles = [
    'Pass upcoming exams',
    'Actually understand it',
    'Study every day',
  ];

  static const _subs = [
    'Plan around midterms / finals',
    'Build intuition, not just answers',
    'Small consistent blocks',
  ];

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
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
                title: _titles[index],
                subtitle: _subs[index],
                selected: state.goal == goal,
                onTap: () => state.setGoal(goal),
              ),
              Space.y.t08,
            ],
          );
        }),
      ],
    );
  }
}
