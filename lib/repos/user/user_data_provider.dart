part of 'user_repo.dart';

class _UserProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<User?> authChanges() => _auth.authStateChanges();

  static User? get currentUser => _auth.currentUser;

  static Future<User> register(Map<String, dynamic> values) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: values['email'] as String,
        password: values['password'] as String,
      );
      final user = cred.user!;
      await _firestore.collection(FireCollections.users).doc(user.uid).set({
        'uid': user.uid,
        'fullName': (values['fullName'] as String?)?.trim() ?? '',
        'email': values['email'] as String,
        'isOnboardingComplete': false,
      });
      return user;
    } on FirebaseAuthException catch (e, s) {
      throw FirebaseAuthFault.fromFirebaseAuthException(e, s);
    } on FirebaseException catch (e, s) {
      throw FirebaseFault.fromFirebase(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<User> login(Map<String, dynamic> values) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: values['email'] as String,
        password: values['password'] as String,
      );
      return cred.user!;
    } on FirebaseAuthException catch (e, s) {
      throw FirebaseAuthFault.fromFirebaseAuthException(e, s);
    } on FirebaseException catch (e, s) {
      throw FirebaseFault.fromFirebase(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<Map<String, dynamic>> fetchProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(FireCollections.users)
          .doc(uid)
          .get();
      return doc.data() ?? <String, dynamic>{};
    } on FirebaseException catch (e, s) {
      throw FirebaseFault.fromFirebase(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<void> completeOnboarding(
    String uid,
    Map<String, dynamic>? extra,
  ) async {
    try {
      await _firestore.collection(FireCollections.users).doc(uid).set({
        'isOnboardingComplete': true,
        ...?extra,
      }, SetOptions(merge: true));
    } on FirebaseException catch (e, s) {
      throw FirebaseFault.fromFirebase(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e, s) {
      throw FirebaseAuthFault.fromFirebaseAuthException(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  // --- not wired to any UI yet; mocked until the real features land --- //

  static Future<Map<String, dynamic>> fetch() async {
    try {
      return await _UserMocks.fetch();
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  /// Merge-writes [fields] onto `users/{uid}` and returns the fresh profile map.
  /// Used by the Profile editors (e.g. institution) to persist a partial update.
  static Future<Map<String, dynamic>> update(
    String uid,
    Map<String, dynamic> fields,
  ) async {
    try {
      await _firestore
          .collection(FireCollections.users)
          .doc(uid)
          .set(fields, SetOptions(merge: true));
      // Mirror the institution into the local onboarding row so offline
      // surfaces stay consistent with `users/{uid}` (no-op if no local row).
      if (fields.containsKey('institution')) {
        await AppDatabase.ins.updateInstitution(
          uid,
          fields['institution'] as String?,
        );
      }
      return await fetchProfile(uid);
    } on FirebaseException catch (e, s) {
      throw FirebaseFault.fromFirebase(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<Map<String, dynamic>> forgot() async {
    try {
      return await _UserMocks.forgot();
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      return await _UserMocks.deleteAccount();
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }
}
