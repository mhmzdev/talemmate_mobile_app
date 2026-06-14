part of '../tutor.dart';

/// Right-aligned bubble for the student's own turn.
class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final TutorMessage message;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppMedia.width * 0.82),
        child: Container(
          padding: Space.sym(SpaceToken.t16, SpaceToken.t12),
          decoration: BoxDecoration(
            color: AppTheme.c.primary,
            borderRadius: 16.radius(),
          ),
          child: Text(
            message.text,
            style: AppText.b1.cl(AppTheme.c.background),
          ),
        ),
      ),
    );
  }
}
