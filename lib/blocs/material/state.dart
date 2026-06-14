part of 'cubit.dart';

@immutable
class MaterialState extends Equatable {
  // --- nested states --- //
  final BlocState<LibraryItem> process;

  // --- state data --- //

  const MaterialState({
    required this.process,
  });

  MaterialState.def()
    : // root-def-constructor
      process = BlocState();

  MaterialState copyWith({
    BlocState<LibraryItem>? process,
  }) {
    return MaterialState(
      process: process ?? this.process,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    process,
  ];
}
