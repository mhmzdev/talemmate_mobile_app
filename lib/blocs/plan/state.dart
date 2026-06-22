part of 'cubit.dart';

@immutable
class PlanState extends Equatable {
  // --- nested states --- //
  final BlocState<WeekPlan> generate;
  final BlocState<WeekPlan> week;
  final BlocState<String> reasoning;

  /// Commit of a batch of Schedule-editor edits (windows + target + exams) —
  /// the signal the editor listens on (pop / offer-to-regenerate).
  final BlocState<Schedule> saveSchedule;

  // --- state data --- //
  final Schedule? schedule;

  const PlanState({
    required this.generate,
    required this.week,
    required this.reasoning,
    required this.saveSchedule,
    this.schedule,
  });

  PlanState.def()
    : // root-def-constructor
      generate = BlocState(),
      week = BlocState(),
      reasoning = BlocState(),
      saveSchedule = BlocState(),
      schedule = null;

  PlanState copyWith({
    BlocState<WeekPlan>? generate,
    BlocState<WeekPlan>? week,
    BlocState<String>? reasoning,
    BlocState<Schedule>? saveSchedule,
    Schedule? schedule,
  }) {
    return PlanState(
      generate: generate ?? this.generate,
      week: week ?? this.week,
      reasoning: reasoning ?? this.reasoning,
      saveSchedule: saveSchedule ?? this.saveSchedule,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    generate,
    week,
    reasoning,
    saveSchedule,
    schedule,
  ];
}
