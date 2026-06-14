// ignore_for_file: unused_element

part of 'material_repo.dart';

class _MaterialMocks {
  static Future<Map<String, dynamic>> extract(Map<String, dynamic> item) {
    return Future.value({
      ...item,
      'processingStatus': 'indexed',
      'indexedPageCount': 1,
    });
  }
}
