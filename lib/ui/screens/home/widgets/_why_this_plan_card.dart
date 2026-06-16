part of '../home.dart';

/// Home "Why this plan" card — the AI's reasoning plus footer chips for the
/// nearest exam and today's available hours. Hidden when there's no reasoning.
class _WhyThisPlanCard extends StatelessWidget {
  const _WhyThisPlanCard();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final cubit = PlanCubit.c(context);
    final reasoning = cubit.week?.aiReasoning;
    if (reasoning == null || reasoning.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final nextExam = cubit.nextExam;
    final hours = cubit.state.schedule?.dailyTargetHours;

    final chips = <Widget>[
      if (nextExam != null)
        _InfoChip(
          icon: LucideIcons.flag,
          label: nextExam.daysUntil <= 0
              ? 'Exam today'
              : 'Exam in ${nextExam.daysUntil}d',
        ),
      if (hours != null)
        _InfoChip(
          icon: LucideIcons.clock,
          label: '${hours.toStringAsFixed(1)}h available',
        ),
    ];

    return AiReasoningCard(
      pillText: 'Why this plan',
      reasoning: reasoning,
      footer: chips.isEmpty
          ? null
          : Wrap(
              spacing: SpaceToken.t16,
              runSpacing: SpaceToken.t08,
              children: chips,
            ),
    );
  }
}

/// Small icon + label chip used in the reasoning card footer.
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Row(
      mainAxisSize: .min,
      children: [
        Icon(icon, size: SpaceToken.t16, color: AppTheme.c.subText),
        Space.x.t04,
        Text(label, style: AppText.b2.cl(AppTheme.c.subText)),
      ],
    );
  }
}
