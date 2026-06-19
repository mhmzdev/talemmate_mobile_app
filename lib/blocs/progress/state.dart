part of 'cubit.dart';

@immutable
class ProgressState extends Equatable {
  // --- nested states --- //
  final BlocState<ProgressDashboard> dashboard;

  // --- state data --- //

  const ProgressState({
    required this.dashboard,
  });

  ProgressState.def()
    : // root-def-constructor
      dashboard = BlocState();

  ProgressState copyWith({
    BlocState<ProgressDashboard>? dashboard,
  }) {
    return ProgressState(
      dashboard: dashboard ?? this.dashboard,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    dashboard,
  ];
}
