part of '../create_account.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }

    return {
      _FormKeys.fullName: 'FullName',
      _FormKeys.email: 'Email',
      _FormKeys.password: 'Password',
      _FormKeys.confirm: 'Confirm',
    };
  }
}
