import 'package:dio/dio.dart';
import 'package:taleemmate/core/models/quotes/quote.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:taleemmate/services/http/api.dart';

part 'quotes_mocks.dart';
part 'quotes_parser.dart';
part 'quotes_data_provider.dart';

class QuotesRepo {
  static final QuotesRepo _instance = QuotesRepo._();
  QuotesRepo._();

  static QuotesRepo get ins => _instance;

  /// --- repo functions --- ///

  Future<Quote> today() => _QuotesProvider.today();
}
