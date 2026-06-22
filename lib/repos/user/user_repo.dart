import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:taleemmate/services/firebase/collections.dart';

part 'user_mocks.dart';
part 'user_parser.dart';
part 'user_data_provider.dart';

class UserRepo {
  static UserRepo _instance = UserRepo._();
  UserRepo._();

  static UserRepo get ins => _instance;

  /// Test seam — swap in a mock repo so cubit unit tests never hit Firebase.
  /// Production code only reads [ins]; never call this setter outside tests.
  @visibleForTesting
  static set ins(UserRepo repo) => _instance = repo;

  /// --- repo functions --- ///

  Stream<User?> authChanges() => _UserProvider.authChanges();

  User? get currentUser => _UserProvider.currentUser;

  Future<User> register(Map<String, dynamic> values) =>
      _UserProvider.register(values);

  Future<User> login(Map<String, dynamic> values) =>
      _UserProvider.login(values);

  Future<Map<String, dynamic>> fetchProfile(String uid) =>
      _UserProvider.fetchProfile(uid);

  Future<void> completeOnboarding(String uid, [Map<String, dynamic>? extra]) =>
      _UserProvider.completeOnboarding(uid, extra);

  Future<void> logout() => _UserProvider.logout();

  // --- not wired to any UI yet; kept (mocked) for upcoming features --- //

  Future<Map<String, dynamic>> fetch() => _UserProvider.fetch();

  Future<Map<String, dynamic>> update(String uid, Map<String, dynamic> fields) =>
      _UserProvider.update(uid, fields);

  Future<Map<String, dynamic>> forgot() => _UserProvider.forgot();

  Future<Map<String, dynamic>> deleteAccount() => _UserProvider.deleteAccount();
}
