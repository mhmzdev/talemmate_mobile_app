part of 'cubit.dart';

@immutable
class QuizState extends Equatable {
  // --- nested states --- //
  final BlocState<Quiz> generate;

  // --- state data --- //

  const QuizState({
    required this.generate,
  });

  QuizState.def()
    : // root-def-constructor
      generate = BlocState();

  QuizState copyWith({
    BlocState<Quiz>? generate,
  }) {
    return QuizState(
      generate: generate ?? this.generate,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    generate,
  ];
}
