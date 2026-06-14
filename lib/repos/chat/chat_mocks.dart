// ignore_for_file: unused_element

part of 'chat_repo.dart';

class _ChatMocks {
  static Future<Map<String, dynamic>> send() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }

  static Future<Map<String, dynamic>> settings() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }
}
