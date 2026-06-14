part of '../tutor.dart';

/// Left-aligned "tutor is thinking" bubble, shown while a reply is in flight.
/// Reuses the shared [AppProgressDots] pulse used by the full-screen loader.
class _Typing extends StatelessWidget {
  const _Typing();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: Space.b.t12,
        padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
        decoration: BoxDecoration(
          color: AppTheme.c.subBackground,
          borderRadius: 16.radius(),
          border: Border.all(color: AppTheme.c.border),
        ),
        child: AppProgressDots(color: AppTheme.c.subText),
      ),
    );
  }
}
