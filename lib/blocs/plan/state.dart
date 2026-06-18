part of 'cubit.dart';

@immutable
class PlanState extends Equatable {
  // --- nested states --- //
  final BlocState<WeekPlan> generate;
  final BlocState<WeekPlan> week;
  final BlocState<String> reasoning;

  // --- state data --- //
  final Schedule? schedule;

  const PlanState({
    required this.generate,
    required this.week,
    required this.reasoning,
    this.schedule,
  });

  PlanState.def()
    : // root-def-constructor
      generate = BlocState(),
      week = BlocState(),
      reasoning = BlocState(),
      schedule = null;

  PlanState copyWith({
    BlocState<WeekPlan>? generate,
    BlocState<WeekPlan>? week,
    BlocState<String>? reasoning,
    Schedule? schedule,
  }) {
    return PlanState(
      generate: generate ?? this.generate,
      week: week ?? this.week,
      reasoning: reasoning ?? this.reasoning,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    generate,
    week,
    reasoning,
    schedule,
  ];
}
