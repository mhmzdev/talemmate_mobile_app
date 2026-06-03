part of '../onboarding.dart';

class _SubjectSuggestions extends StatelessWidget {
  const _SubjectSuggestions({required this.suggestions, required this.onFill});

  final List<Map<String, String>> suggestions;
  final ValueChanged<Map<String, String>> onFill;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const Divider(),
        Space.y.t08,
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.c.accent),
                borderRadius: 20.radius(),
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: AppTheme.c.accent,
                    ),
                  ),
                  Space.x.t04,
                  Text(
                    'SUGGESTED',
                    style: AppText.l1b
                        .cl(AppTheme.c.accent)
                        .copyWith(letterSpacing: 1.2),
                  ),
                ],
              ),
            ),
            Space.x.t08,
            Text('Tap to fill', style: AppText.b2.cl(AppTheme.c.subText)),
          ],
        ),
        Space.y.t08,
        for (final s in suggestions)
          GestureDetector(
            onTap: () => onFill(s),
            child: Container(
              margin: Space.b.t08,
              padding: Space.sym(SpaceToken.t12, SpaceToken.t16),
              decoration: BoxDecoration(
                color: AppTheme.c.subBackground,
                borderRadius: 10.radius(),
                border: Border.all(color: AppTheme.c.border),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Text(
                      s['code'] ?? '',
                      style: AppText.b2.cl(AppTheme.c.subText),
                    ),
                  ),
                  Space.x.t12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(s['name'] ?? '', style: AppText.b1b),
                        Text(
                          s['reason'] ?? '',
                          style: AppText.b2.cl(AppTheme.c.subText),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.add, size: 18, color: AppTheme.c.subText),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
