part of '../tutor.dart';

/// Surfaces send failures as a flash. Success is silent — the user + AI turns
/// arrive through the Drift message stream, not this listener.
class _SendListener extends StatelessWidget {
  const _SendListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (a, b) => a.send != b.send,
      listener: (context, state) {
        if (state.send.isFailed) {
          UIFlash.error(context, state.send.errorMessage);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
