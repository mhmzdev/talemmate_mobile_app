part of 'cubit.dart';

@immutable
class PlanState extends Equatable {
  // --- nested states --- //
  final BlocState<WeekPlan> generate;
  final BlocState<WeekPlan> week;

  // --- state data --- //
  final Schedule? schedule;

  const PlanState({
    required this.generate,
    required this.week,
    this.schedule,
  });

  PlanState.def()
    : // root-def-constructor
      generate = BlocState(),
      week = BlocState(),
      schedule = null;

  PlanState copyWith({
    BlocState<WeekPlan>? generate,
    BlocState<WeekPlan>? week,
    Schedule? schedule,
  }) {
    return PlanState(
      generate: generate ?? this.generate,
      week: week ?? this.week,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    generate,
    week,
    schedule,
  ];
}
