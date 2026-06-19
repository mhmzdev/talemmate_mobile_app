// ignore_for_file: unused_element

part of 'quiz_repo.dart';

class _QuizMocks {
  static Future<Map<String, dynamic>> generate() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }
}
