// ignore_for_file: unused_element

part of 'progress_repo.dart';

class _ProgressMocks {
  static Future<Map<String, dynamic>> dashboard() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }
}
