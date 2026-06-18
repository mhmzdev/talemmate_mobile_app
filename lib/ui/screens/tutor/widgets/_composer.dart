part of '../tutor.dart';

/// Bottom input row: a multi-line text field + a send button. The button is
/// disabled while empty or while a reply is in flight.
class _Composer extends StatelessWidget {
  const _Composer();

  /// Sends the composer's text, then clears it and dismisses the keyboard.
  /// No-ops on empty input or while a reply is in flight.
  void _submit(BuildContext context) {
    final screenState = _ScreenState.s(context);
    if (ChatCubit.c(context).state.send.isLoading) return;
    final text = screenState.controller.text;
    if (text.trim().isEmpty) return;
    ChatCubit.c(context).send(text);
    screenState.clearInput();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final screenState = _ScreenState.s(context, true);
    final sending = ChatCubit.c(context, true).state.send.isLoading;
    final canSend = screenState.hasText && !sending;

    return Container(
      padding: Space.sym(SpaceToken.t12, SpaceToken.t08),
      decoration: BoxDecoration(
        color: AppTheme.c.background,
        border: Border(top: BorderSide(color: AppTheme.c.border)),
      ),
      child: Row(
        crossAxisAlignment: .end,
        children: [
          Expanded(
            child: Container(
              padding: Space.sym(SpaceToken.t16, SpaceToken.t04),
              decoration: BoxDecoration(
                color: AppTheme.isDark
                    ? AppTheme.c.specBackground
                    : AppTheme.c.subBackground,
                borderRadius: 24.radius(),
                border: Border.all(color: AppTheme.c.border),
              ),
              child: TextField(
                controller: screenState.controller,
                minLines: 1,
                maxLines: 5,
                style: AppText.b1.cl(AppTheme.c.text),
                cursorColor: AppTheme.c.primary,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Ask your tutor…',
                  hintStyle: AppText.b1.cl(AppTheme.c.subText),
                ),
              ),
            ),
          ),
          Space.x.t08,
          AppTouch(
            key: const ValueKey('tutor_send'),
            onTap: canSend ? () => _submit(context) : () {},
            hasSplash: false,
            child: Container(
              padding: Space.a.t12,
              decoration: BoxDecoration(
                color: canSend ? AppTheme.c.primary : AppTheme.c.border,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.arrow_up,
                size: SpaceToken.t20,
                color: AppTheme.c.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
