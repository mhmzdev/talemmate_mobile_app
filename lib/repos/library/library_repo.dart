import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/services/fault/faults.dart';

part 'library_mocks.dart';
part 'library_parser.dart';
part 'library_data_provider.dart';

/// Drift-backed repo for the app-wide materials module (ADR-013): public
/// methods take/return `Map`/`List<Map>`/primitives only — the cubit does the
/// `LibraryItem.fromJson` / `Subject.fromJson` conversion.
class LibraryRepo {
  static final LibraryRepo _instance = LibraryRepo._();
  LibraryRepo._();

  static LibraryRepo get ins => _instance;

  /// --- repo functions --- ///

  Future<List<Map<String, dynamic>>> materials(String userId) =>
      _LibraryProvider.materials(userId);

  Future<List<Map<String, dynamic>>> subjects(String userId) =>
      _LibraryProvider.subjects(userId);

  Future<void> add(Map<String, dynamic> values) => _LibraryProvider.add(values);

  // Single-primitive param — ADR-013 exception.
  Future<void> remove(String id) => _LibraryProvider.remove(id);
}
