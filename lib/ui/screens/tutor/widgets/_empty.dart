part of '../tutor.dart';

/// Shown when no conversation is active: invites the student to pick a subject
/// and start a grounded chat. Offers history when prior conversations exist.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final hasHistory = ChatCubit.c(context, true).state.conversations.isNotEmpty;

    return Center(
      child: Padding(
        padding: Space.a.t32,
        child: Column(
          mainAxisSize: .min,
          children: [
            Container(
              padding: Space.a.t16,
              decoration: BoxDecoration(
                color: AppTheme.c.subBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.graduation_cap,
                size: SpaceToken.t32,
                color: AppTheme.c.accent,
              ),
            ),
            Space.y.t16,
            Text(
              'Your study tutor',
              style: AppText.h2.cl(AppTheme.c.text),
              textAlign: .center,
            ),
            Space.y.t08,
            Text(
              'Pick a subject and ask anything — answers are grounded in your '
              'own uploaded materials.',
              style: AppText.b2.cl(AppTheme.c.subText),
              textAlign: .center,
            ),
            Space.y.t24,
            AppButton(
              label: 'Choose a subject',
              icon: LucideIcons.plus,
              onTap: () => _SubjectPicker.show(context),
            ),
            if (hasHistory) ...[
              Space.y.t12,
              AppButton(
                label: 'Past conversations',
                icon: LucideIcons.history,
                style: .creamy,
                onTap: () => _History.show(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
