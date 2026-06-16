// ignore_for_file: unused_element

part of 'plan_repo.dart';

class _PlanMocks {
  static Future<Map<String, dynamic>> generate() {
    return Future.value({'status': 200, 'message': 'mock', 'data': {}});
  }
}
