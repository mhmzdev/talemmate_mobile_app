part of '../login.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }

    return {
      _FormKeys.email: 'hamza.verify6@cui.edu.pk',
      _FormKeys.password: 'Hamza@123',
    };
  }
}
