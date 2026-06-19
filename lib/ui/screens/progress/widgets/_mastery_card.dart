part of '../progress.dart';

/// Mastery-by-subject card — one [_MasteryRow] per subject, hairline-divided.
class _MasteryCard extends StatelessWidget {
  const _MasteryCard({required this.subjects});

  final List<MasterySubject> subjects;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final last = subjects.length - 1;
    return Container(
      padding: Space.sym(SpaceToken.t12, SpaceToken.t04),
      decoration: _cardDeco(),
      child: Column(
        children: subjects
            .asMap()
            .entries
            .map((e) => _MasteryRow(subject: e.value, isLast: e.key == last))
            .toList(),
      ),
    );
  }
}

/// One mastery row: name (+ optional "Weak" badge), mono pct, trend arrow, and
/// a meter (rose when weak).
class _MasteryRow extends StatelessWidget {
  const _MasteryRow({required this.subject, required this.isLast});

  final MasterySubject subject;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final trend = subject.trend;
    final arrow = trend > 0
        ? '↑'
        : trend < 0
        ? '↓'
        : '—';
    final arrowColor = trend > 0
        ? AppTheme.c.success
        : trend < 0
        ? AppTheme.c.error
        : AppTheme.c.subText;

    return Container(
      padding: Space.v.t12,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: AppTheme.c.border)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        subject.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.b1.cl(AppTheme.c.text),
                      ),
                    ),
                    if (subject.weak) ...[Space.x.t08, const _WeakBadge()],
                  ],
                ),
              ),
              Space.x.t08,
              Text(
                '${subject.readinessScore}%',
                style: AppText.b2.gm().cl(AppTheme.c.text),
              ),
              Space.x.t08,
              SizedBox(
                width: 14,
                child: Text(
                  arrow,
                  textAlign: TextAlign.center,
                  style: AppText.b2.cl(arrowColor),
                ),
              ),
            ],
          ),
          Space.y.t08,
          AppMeter(
            fraction: subject.readinessScore / 100,
            color: subject.weak ? AppTheme.c.error : AppTheme.c.text,
          ),
        ],
      ),
    );
  }
}

/// Small rose "Weak" badge.
class _WeakBadge extends StatelessWidget {
  const _WeakBadge();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Container(
      padding: Space.sym(SpaceToken.t08, SpaceToken.t04),
      decoration: BoxDecoration(
        color: AppTheme.c.error.withValues(alpha: 0.08),
        borderRadius: 999.radius(),
      ),
      child: Text(
        'WEAK',
        style: AppText.l1b.cl(AppTheme.c.error).copyWith(letterSpacing: 0.6),
      ),
    );
  }
}
