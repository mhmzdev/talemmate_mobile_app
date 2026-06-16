part of '../home.dart';

/// Home daily reminder — the day's quote with a gold accent bar. Hidden until a
/// quote is loaded ([QuotesCubit]).
class _DailyReminder extends StatelessWidget {
  const _DailyReminder();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final quote = QuotesCubit.c(context, true).state.today.data;
    if (quote == null) return const SizedBox.shrink();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: AppTheme.c.accent,
              borderRadius: 999.radius(),
            ),
          ),
          Space.x.t12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '“${quote.q}”',
                  style: AppText.h3
                      .cl(AppTheme.c.text)
                      .fra()
                      .copyWith(fontStyle: .italic),
                ),
                if (quote.a != null) ...[
                  Space.y.t08,
                  Text(
                    '— ${quote.a}',
                    style: AppText.b2.cl(AppTheme.c.subText).fra(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
