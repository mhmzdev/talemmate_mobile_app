// ignore_for_file: unused_element

part of 'user_repo.dart';

class _UserMocks {
  static Future<Map<String, dynamic>> init() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }

  static Future<Map<String, dynamic>> login() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
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
