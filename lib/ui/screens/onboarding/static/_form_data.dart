part of '../onboarding.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }

    return {
      _FormKeys.name: 'Muhammad Hamza',
      _FormKeys.institution: 'NUST',
    };
  }
}
