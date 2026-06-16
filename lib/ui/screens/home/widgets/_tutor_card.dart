part of '../home.dart';

/// Home tutor prompt — a gold-edged card inviting the student into the grounded
/// tutor. Tapping the faux input opens the Tutor tab. (No voice input — the app
/// has no speech-to-text.)
class _TutorCard extends StatelessWidget {
  const _TutorCard();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppEdgeCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              const AppAiPill(text: 'Tutor'),
              Flexible(
                child: Text(
                  'Grounded in your material',
                  overflow: TextOverflow.ellipsis,
                  style: AppText.b2.cl(AppTheme.c.subText),
                ),
              ),
            ],
          ),
          Space.y.t12,
          Text(
            'Ask anything from your uploaded notes.',
            style: AppText.h3.cl(AppTheme.c.text).fra(),
          ),
          Space.y.t12,
          GestureDetector(
            onTap: () => AppRoutes.tutor.pushReplace(context),
            child: Container(
              padding: Space.a.t12,
              decoration: BoxDecoration(
                color: AppTheme.c.background,
                borderRadius: 12.radius(),
                border: Border.all(color: AppTheme.c.border),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.sparkles,
                    size: SpaceToken.t20,
                    color: AppTheme.c.accent,
                  ),
                  Space.x.t12,
                  Expanded(
                    child: Text(
                      'Explain TCP slow start with an example',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.b2.cl(AppTheme.c.subText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
