part of 'cubit.dart';

@immutable
class OnboardingState extends Equatable {
  // --- nested states --- //
  final BlocState<OnboardingData> save;
  final BlocState<OnboardingData> complete;

  // --- state data --- //

  const OnboardingState({
    required this.save,
    required this.complete,
  });

  OnboardingState.def()
    : // root-def-constructor
      save = BlocState(),
      complete = BlocState();

  OnboardingState copyWith({
    BlocState<OnboardingData>? save,
    BlocState<OnboardingData>? complete,
  }) {
    return OnboardingState(
      save: save ?? this.save,
      complete: complete ?? this.complete,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    save,
    complete,
  ];
}
