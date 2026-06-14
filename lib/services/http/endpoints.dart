part of 'api.dart';

/// This is NOT being used; just for the sake of demonstration when there are
/// multiple versions of the same API.
/// The actual API being used is the one provided by ZenQuotes.
class Endpoints {
  Endpoints._();

  static final v1 = EPV1._();
  static final v2 = EPV2._();
}

class EPV1 {
  EPV1._();

  final quotes = '/v1/quotes';
}

class EPV2 {
  EPV2._();

  final quotes = '/v2/quotes';
  final quoteOfTheDay = '/v2/qod';
}
