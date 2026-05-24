# Firebase — TaleemMate

TaleemMate uses Firebase for auth, AI, and observability only. All learning content and user progress is stored locally via Drift (SQLite) — **not** in Firestore. No custom backend server or Cloud Functions exist.

### What Firebase is and is not used for (v1)

| In scope | Out of scope |
|---|---|
| Firebase Auth — sign in / sign up / session | Storing lessons, exercises, or progress in Firestore |
| Firebase AI (Gemini) — AI tutoring responses | Any Cloud Functions or custom backend logic |
| Crashlytics — crash reporting | Real-time sync of learning data (deferred to a future release) |
| Remote Config — feature flags | |

If you are implementing a feature that reads or writes learning content, progress, or exercises — use Drift, not Firestore. See ADR-012.

---

## Firebase Services in Use

| Service | Package | Version | Purpose |
|---|---|---|---|
| Firebase Core | `firebase_core` | 4.2.1 | Initialization |
| Firebase Auth | `firebase_auth` | 6.1.2 | Sign in, sign up, session management |
| Firebase AI | `firebase_ai` | 3.6.0 | Gemini model integration — AI tutoring features |
| Firebase Crashlytics | `firebase_crashlytics` | 5.0.5 | Crash reporting |
| Firebase Performance | `firebase_performance` | 0.11.1+2 | Request and trace monitoring |
| Firebase Remote Config | `firebase_remote_config` | 6.1.1 | Feature flags and remote settings |

---

## Multi-Flavor Setup

Three flavors, each with its own Firebase project and bundle ID:

| Flavor | Bundle suffix | Environment |
|---|---|---|
| `stage` | `.stage` | Active development — debug logging |
| `qa` | `.qa` | Stakeholder testing — prod-like config |
| `prod` / `taleemmate` | (root bundle) | Customer-facing |

Flavor is resolved at runtime via `AppFlavor.init()` — no separate per-flavor entry files.

**Useful getters:**
```dart
AppFlavor.isStage
AppFlavor.isQa
AppFlavor.isProd
AppFlavor.isProdRelease   // isProd && kReleaseMode
AppFlavor.isProduction    // isProd || isQa
```

---

## Firebase Auth

Authentication uses `firebase_auth`. Errors are mapped to user-friendly messages by `FirebaseAuthFault`:

```dart
// In a cubit data_provider / repo
try {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
} on FirebaseAuthException catch (e, st) {
  throw FirebaseAuthFault.fromFirebaseAuthException(e, st);
}
```

`FirebaseAuthFault` handles: `user-not-found`, `wrong-password`, `invalid-credential`, `email-already-in-use`, `invalid-email`, `weak-password`, `user-disabled`, `too-many-requests`, `requires-recent-login`, `network-request-failed`.

---

## Firebase AI (Gemini)

`firebase_ai` provides the Gemini model integration for AI tutoring. Use it inside cubits, never in `_state.dart` or widgets directly.

---

## Error Handling for Firebase

Always catch Firebase exceptions and convert them to typed `Fault` subtypes before emitting cubit state:

| Exception | Fault to throw |
|---|---|
| `FirebaseAuthException` | `FirebaseAuthFault.fromFirebaseAuthException(e, st)` |
| `FirebaseException` | `FirebaseFault.fromFirebase(e, st)` |
| `DioException` (HTTP) | `HttpFault.fromDioException(e, st)` |
| Unknown | `Fault.fromObjectAndStackTrace(object, st)` |

See `lib/services/fault/faults.dart` for all subtypes.

---

## Performance Monitoring

`firebase_performance_dio` interceptor is wired to the `dio` client automatically — all HTTP requests are traced without manual instrumentation.

For custom traces, use `AppPerformance` (configured but currently commented out in `main.dart` while Firebase init is pending).

---

## Remote Config

Feature flags and remote settings are managed via `FireRemoteConfig`. Access values after the service initialises; defaults should be set in the Firebase console.

---

## Crashlytics

`EnhancedCrashlytics` (from `lib/services/firebase/crash/`) wraps `firebase_crashlytics`. All caught errors should be logged before the fault is emitted:

```dart
e.appLog(level: AppLogLevel.error, tag: 'ContextTag');
```

The `.appLog()` extension (from `lib/services/logging/app_log.dart`) handles both console output and Crashlytics reporting based on the current flavor.
