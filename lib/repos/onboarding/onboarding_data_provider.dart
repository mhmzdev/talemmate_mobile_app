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

  /// Persists the assembled onboarding payload to the local Drift DB. Accepts
  /// and returns Maps (ADR-013); the model↔table mapping lives in the DB layer
  /// (`AppDatabase.saveOnboardingData`), keeping this repo model-free.
  static Future<Map<String, dynamic>> complete(
    Map<String, dynamic> values,
  ) async {
    try {
      await AppDatabase.ins.saveOnboardingData(values);
      return {...values, 'step': 4};
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Failed to save your setup. Please try again.', st);
    }
  }
}
