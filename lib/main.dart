import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taleemmate/app.dart';
import 'package:taleemmate/services/firebase/crash/crashlytics.dart';
import 'package:taleemmate/services/flavor/flavor.dart';

/// Toggle to connect to the local Firebase emulators instead of live Firebase.
///
/// The correct long-term approach is a dedicated local flavor (TODO); for now
/// flip this flag while building against the emulator suite.
const useFirebaseEmulators = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AppFlavor.init();

  /// @Important:
  /// Ports must stay in sync with `firebase.json` and `firebase emulators:start`.
  ///
  /// Host notes:
  ///   Android emulator → 10.0.2.2 (routes to host machine)
  ///   iOS simulator    → localhost
  ///   Physical device  → run `adb reverse tcp:<port> tcp:<port>`, then localhost
  if (useFirebaseEmulators) {
    final host = defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';

    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    FirebaseStorage.instance.useStorageEmulator(host, 9199);
  }

  /// Services
  // AppAlice.ins.init();
  await EnhancedCrashlytics.ins.init();
  // await AppPerformance.ins.init();
  // await FireRemoteConfig.ins.init();

  runApp(const TaleemMate());
}
