part of 'cubit.dart';

@immutable
class QuotesState extends Equatable {
  // --- nested states --- //
  final BlocState<Quote> today;

  // --- state data --- //
  final Quote? todayQuote;

  const QuotesState({
    required this.today,
    this.todayQuote,
  });

  QuotesState.def()
    : // root-def-constructor
      today = BlocState(),
      todayQuote = null;

  QuotesState copyWith({
    BlocState<Quote>? today,
    Quote? todayQuote,
  }) {
    return QuotesState(
      today: today ?? this.today,
      todayQuote: todayQuote ?? this.todayQuote,
    );
  }

  @override
  List<Object?> get props => [
    // root-state-props
    today,
    todayQuote,
  ];
}
