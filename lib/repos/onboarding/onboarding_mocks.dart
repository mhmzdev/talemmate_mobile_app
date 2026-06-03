// ignore_for_file: unused_element

part of 'onboarding_repo.dart';

class _OnboardingMocks {
  static Future<Map<String, dynamic>> save(Map<String, dynamic> values) async {
    await 0.3.seconds.delay;
    return values;
  }

  static Future<Map<String, dynamic>> complete(
    Map<String, dynamic> values,
  ) async {
    await 0.6.seconds.delay;
    return {...values, 'step': 4};
  }

  static Map<String, dynamic> completedOnboarding(String userId) => {
    'userId': userId,
    'step': 4,
    'subjects': [],
    'exams': [],
    'institution': 'NUST · School of EE & CS',
    'schedule': null,
    'uploadedMaterials': [],
  };
}
