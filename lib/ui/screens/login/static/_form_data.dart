part of '../login.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }

    return {
      _FormKeys.email: 'test@example.com',
      _FormKeys.password: 'Password123!',
    };
  }
}
