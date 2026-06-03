// ignore_for_file: unused_element

part of 'user_repo.dart';

class _UserMocks {
  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> values,
  ) async {
    await 1.0.seconds.delay;
    return {
      'uid': 'mock-user-002',
      'fullName': values['fullName'] as String? ?? 'New User',
      'email': values['email'] as String? ?? '',
      'isOnboardingComplete': false,
    };
  }

  static Future<Map<String, dynamic>> init() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await 1.2.seconds.delay;

    if (email != 'test@taleemmate.com' || password != 'test1234') {
      throw UnknownFault('Incorrect email or password.', StackTrace.current);
    }

    return {
      'uid': 'mock-user-001',
      'fullName': 'Test User',
      'email': email,
      'isOnboardingComplete': true,
    };
  }

  static Future<Map<String, dynamic>> update() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }

  static Future<Map<String, dynamic>> fetch() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }

  static Future<Map<String, dynamic>> forgot() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }

  static Future<Map<String, dynamic>> logout() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }

  static Future<Map<String, dynamic>> deleteAccount() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }
}
