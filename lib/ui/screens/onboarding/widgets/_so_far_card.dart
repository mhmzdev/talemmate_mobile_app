part of '../onboarding.dart';

class _SoFarCard extends StatelessWidget {
  const _SoFarCard();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final state = _ScreenState.s(context, true);

    final institution = state.institutionCtrl.text.trim();
    final name = state.nameCtrl.text.trim();
    final firstExam = state.exams.isNotEmpty ? state.exams.first : null;
    final examStr = firstExam != null
        ? '${firstExam.date.day}/${firstExam.date.month}/${firstExam.date.year}'
        : '–';
    final windowStr = state.dailyTargetHours > 0
        ? '${state.dailyTargetHours.toStringAsFixed(1)} hrs/day'
        : '–';

    return Container(
      padding: Space.sym(SpaceToken.t16, SpaceToken.t16),
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: 12.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'SO FAR',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 1.2),
          ),
          Space.y.t12,
          _SoFarRow(label: 'Name', value: name.isEmpty ? '–' : name),
          Space.y.t08,
          _SoFarRow(
            label: 'Institution',
            value: institution.isEmpty ? '–' : institution,
          ),
          Space.y.t08,
          _SoFarRow(label: 'Midterms', value: examStr),
          Space.y.t08,
          _SoFarRow(label: 'Daily window', value: windowStr),
        ],
      ),
    );
  }
}

class _SoFarRow extends StatelessWidget {
  const _SoFarRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(label, style: AppText.b2.cl(AppTheme.c.subText)),
        Text(value, style: AppText.b2),
      ],
    );
  }
}
