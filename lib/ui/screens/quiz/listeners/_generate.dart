part of '../quiz.dart';

/// Drives the quiz screen from [QuizCubit.generate]: a full-screen loader while
/// building, an error flash on failure (the body shows the retry). Success needs
/// no navigation — the body swaps in the question view. Flash/effects live here,
/// never in `_state.dart`, per the state-driven-navigation convention.
class _GenerateListener extends StatelessWidget {
  const _GenerateListener();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizCubit, QuizState>(
      listenWhen: (a, b) => a.generate != b.generate,
      listener: (_, state) {
        if (state.generate.isFailed) {
          UIFlash.error(context, state.generate.errorMessage);
        }
      },
      builder: (context, state) {
        return FullScreenLoader(
          loading: state.generate.isLoading,
          title: 'Building your quiz…',
          subtitle: 'Writing questions from your material.',
        );
      },
    );
  }
}
