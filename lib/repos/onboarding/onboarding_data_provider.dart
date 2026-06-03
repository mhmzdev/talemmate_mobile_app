part of 'onboarding_repo.dart';

class _OnboardingProvider {
  static Future<Map<String, dynamic>> save(Map<String, dynamic> values) async {
    try {
      return await _OnboardingMocks.save(values);
    } catch (e, st) {
      if (e is Fault) rethrow;
      if (e is DioException) throw HttpFault.fromDioException(e, st);
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<Map<String, dynamic>> complete(
    Map<String, dynamic> values,
  ) async {
    try {
      return await _OnboardingMocks.complete(values);
    } catch (e, st) {
      if (e is Fault) rethrow;
      if (e is DioException) throw HttpFault.fromDioException(e, st);
      throw UnknownFault('Something went wrong!', st);
    }
  }
}
