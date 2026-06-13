// ignore_for_file: unused_element

part of 'library_repo.dart';

/// Canned fixtures mirroring the real provider's Map-in/Map-out surface — used
/// by the LibraryCubit unit test. Kept per rule 12 (scaffold stays wired).
class _LibraryMocks {
  static Future<List<Map<String, dynamic>>> materials(String userId) async => [
    {
      'id': 'm1',
      'userId': userId,
      'name': 'Vectors.pdf',
      'kind': 'pdf',
      'fileSize': 2048576,
      'uploadedAt': '2026-06-10T10:00:00.000',
      'processingStatus': 'indexed',
      'subjectId': 's1',
      'metadata': '/local/m1.pdf',
      'colorHex': '#4A90D9',
      'indexedPageCount': 12,
    },
    {
      'id': 'm2',
      'userId': userId,
      'name': 'Scribbles.png',
      'kind': 'img',
      'fileSize': 512000,
      'uploadedAt': '2026-06-01T10:00:00.000',
      'processingStatus': 'indexed',
      'subjectId': null,
      'metadata': '/local/m2.png',
      'colorHex': null,
      'indexedPageCount': null,
    },
  ];

  static Future<List<Map<String, dynamic>>> subjects() async => [
    {
      'id': 's1',
      'code': 'MATH101',
      'name': 'Linear Algebra',
      'colorHex': '#4A90D9',
      'confidenceLevel': 0.6,
      'order': 0,
    },
  ];

  static Future<void> add(Map<String, dynamic> values) async {}

  static Future<void> remove(String id) async {}
}
