import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taleemmate/app.dart';
import 'package:taleemmate/services/firebase/crash/crashlytics.dart';
import 'package:taleemmate/services/flavor/flavor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await AppFlavor.init();

  /// Services
  // AppAlice.ins.init();
  // await EnhancedCrashlytics.ins.init();
  // await AppPerformance.ins.init();
  // await FireRemoteConfig.ins.init();

  runApp(const TaleemMate());
}
