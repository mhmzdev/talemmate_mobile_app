part of '../onboarding.dart';

class _TutorPreview extends StatelessWidget {
  const _TutorPreview();

  static const _gold = Color(0xFFE09A2B);

  static const _previews = {
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

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: 12.radius(),
        border: const Border(left: BorderSide(color: _gold, width: 3)),
      ),
      padding: Space.sym(SpaceToken.t16, SpaceToken.t16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.15),
              borderRadius: 4.radius(),
            ),
            child: Text(
              '● TUTOR PREVIEW',
              style: AppText.l1b.cl(_gold).copyWith(letterSpacing: 1.0),
            ),
          ),
          Space.y.t12,
          Text(
            _previews[state.goal] ?? _previews[OnboardingGoal.passExams]!,
            style: AppText.b1.cl(AppTheme.c.text).copyWith(fontStyle: .italic),
          ),
        ],
      ),
    );
  }
}
