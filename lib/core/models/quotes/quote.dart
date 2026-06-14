import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

@freezed
sealed class Quote with _$Quote {
  const factory Quote({
    required String q,
    String? a,
    String? i,
    required String date,
  }) = _Quote;

  factory Quote.fromJson(Map<String, Object?> json) => _$QuoteFromJson(json);
}
