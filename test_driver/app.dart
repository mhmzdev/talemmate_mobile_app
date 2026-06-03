import 'package:flutter_driver/driver_extension.dart';

import 'package:taleemmate/main.dart' as app;

/// Debug-only entrypoint that enables the Flutter Driver extension so the
/// Dart MCP server's `flutter_driver` tool can drive the app — tap, type,
/// scroll, navigate — like Playwright does for the web.
///
/// This file is NEVER used by release/store builds; those still launch
/// `lib/main.dart`. Launch this one explicitly (debug only):
///
///   flutter run --flavor stage -t test_driver/app.dart
///
/// The Dart MCP `launch_app` tool launches it the same way via `target`.
void main() {
  enableFlutterDriverExtension();
  app.main();
}
