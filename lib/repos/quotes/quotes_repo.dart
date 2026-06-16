import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:taleemmate/core/models/quotes/quote.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:taleemmate/services/http/api.dart';

part 'quotes_mocks.dart';
part 'quotes_parser.dart';
part 'quotes_data_provider.dart';

class QuotesRepo {
  static QuotesRepo _instance = QuotesRepo._();
  QuotesRepo._();

  static QuotesRepo get ins => _instance;

  /// Test seam — swap in a mock repo so cubit unit tests never hit the network.
  /// Production code only reads [ins]; never call this setter outside tests.
  @visibleForTesting
  static set ins(QuotesRepo repo) => _instance = repo;

  /// --- repo functions --- ///

  Future<Quote> today() => _QuotesProvider.today();
}
