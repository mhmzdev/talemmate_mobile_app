part of '../login.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }

    return {
      _FormKeys.email: 'test@taleemmate.com',
      _FormKeys.password: 'test1234',
    };
  }
}
