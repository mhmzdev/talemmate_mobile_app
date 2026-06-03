part of '../create_account.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }

    return {
      _FormKeys.fullName: 'Muhammad Hamza',
      _FormKeys.email: 'hamza@cui.edu.pk',
      _FormKeys.password: 'Hamza@123',
      _FormKeys.confirm: 'Hamza@123',
      _FormKeys.termsAccepted: false,
    };
  }
}
