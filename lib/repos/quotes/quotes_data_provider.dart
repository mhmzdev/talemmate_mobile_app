part of 'quotes_repo.dart';

class _QuotesProvider {
  static Future<Quote> today() async {
    try {
      final response = await Api().ins.get('/today');
      final _ = response.data as List;
      final mockResponse = await _QuotesMocks.today();
      return Quote.fromJson(mockResponse.first as Map<String, Object?>);
    } catch (e, st) {
      if (e is DioException) {
        throw HttpFault.fromDioException(e, st);
      }
      throw UnknownFault('Something went wrong!', st);
    }
  }
}
