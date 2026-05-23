# Flutter Architecture — AppFlight

> For the full configs API — Space system, navigation shortcuts, typography, theme tokens, extensions — see **[docs/conventions/CONFIGS.md](../conventions/CONFIGS.md)**.

## Guiding Principle

**Layer-first, not feature-first.** Code is organized by _what it is_ (UI, state, service, model) rather than _what it does_ (auth, notifications, distribution). This keeps each layer's concerns clear and prevents cross-layer leakage.

---

## Layer Map and Dependency Rules

```
┌─────────────────────────────────────────────┐
│  UI Layer       lib/ui/                     │  ← Renders, handles input
│  ├── screens/   (one folder per screen)     │
│  └── widgets/   (shared reusable widgets)   │
├─────────────────────────────────────────────┤
│  State Layer    lib/cubits/                 │  ← Business logic
│                 (Cubit per domain)          │
├─────────────────────────────────────────────┤
│  Service Layer  lib/services/               │  ← Infrastructure access
│                 (HTTP, Firebase, FCM, etc.) │
├─────────────────────────────────────────────┤
│  Core Layer     lib/core/models/            │  ← Plain data (Freezed)
├─────────────────────────────────────────────┤
│  Config Layer   lib/configs/               │  ← Theme, extensions, spacing
│  Helpers        lib/helpers/               │
└─────────────────────────────────────────────┘
```

**Dependency flow (strictly top-down):**
- UI → Cubit (reads state, calls methods)
- Cubit → Service / data_provider (API calls, Firebase)
- Service → Core models (shapes return data)
- Nothing in Core/Config reaches up to UI or Cubit

**Hard rules:**
- UI (`_state.dart`) must NOT call Firebase or HTTP directly
- Cubits must NOT import anything from `lib/ui/`
- Services are always Singletons accessed via `.ins`
- Never use `context.read<X>()` / `context.watch<X>()` — always use `X.c(context)` / `_ScreenState.s(context)`

---

## Ephemeral State vs App State

Two state tools are in play — they are NOT interchangeable:

| | Provider (`ChangeNotifier`) | Cubit |
|---|---|---|
| **What for** | UI-local state (toggles, loading indicators, form visibility) | Business logic, API data, Firebase |
| **Scope** | One screen | Whole app (registered at app root) |
| **File** | `lib/ui/screens/{screen}/_state.dart` | `lib/cubits/{name}/` (6 files) |
| **Accesses Firebase?** | Never | Yes, via `data_provider.dart` |

Provider `_state.dart` classes **delegate to Cubits** for anything beyond local UI:
```dart
void login(BuildContext context) {
  UserCubit.c(context).login(_formData);
}
```

---

## Route Names for Modals and Alerts

Every `showModalBottomSheet`, `showDialog`, and `showGeneralDialog` call **must** include a `routeSettings` with a `name`. This keeps the navigator history readable and enables route-aware tooling (analytics, back-button handling, navigator observers).

**Naming convention:**

```dart
// Bottom sheets
routeSettings: const RouteSettings(name: '/bottom-sheet/create-api-key'),

// Dialogs and alerts
routeSettings: const RouteSettings(name: '/alert/confirmation-alert'),
routeSettings: const RouteSettings(name: '/alert/api-key-created'),
```

| Type | Prefix |
|---|---|
| `showModalBottomSheet` | `/bottom-sheet/{sheet-name}` |
| `showDialog` / `showGeneralDialog` | `/alert/{alert-name}` |

Use kebab-case. The name should describe the content, not the action (e.g. `version-input` not `show-version-dialog`).

---

## Screen Anatomy

Every screen follows this exact structure:

```
lib/ui/screens/{screen_name}/
├── {screen_name}.dart     # Thin shell: BlocProvider + Screen widget
├── _state.dart            # ChangeNotifier ephemeral state
├── static/                # Only if screen has a form
│   ├── _form_keys.dart    # GlobalKey<FormBuilderState>
│   └── _form_data.dart    # Typed form data class
├── listeners/             # BlocListener or BlocConsumer
│   └── _{action}.dart     # e.g., _login.dart, _fetch_org.dart
└── widgets/               # Private widget classes for this screen
    └── _{widget}.dart     # e.g., _body.dart, _header.dart
```

The main `{screen_name}.dart` is a thin coordinator — it wires Providers, Cubits, and listeners but contains minimal build logic. Heavy UI goes in `widgets/`.

---

## Cubit Anatomy (6-file pattern, always generated via Hygen)

```
lib/cubits/{name}/
├── cubit.dart         # extends Cubit<XState> with _XEmitter, public methods + static .c()
├── state.dart         # Flat XState class — one CubitState<T> field per action
├── emitter.dart       # mixin _XEmitter on Cubit<XState> — private _actionLoading/Success/Failed
├── repo.dart          # Repository — orchestrates data_provider
├── data_provider.dart # Raw Firebase/HTTP calls (static methods)
└── mocks.dart         # Test/dev mock data
```

> Never create these files manually. Always use `hygen cubit nested <name>` — the generator wires up `CubitState<T>`, the mixin emitter, `.c()` accessor, and `XState.def()` automatically.

Data flows: `cubit.dart` → `repo.dart` → `data_provider.dart` → Firebase/HTTP → back up.

**State model:** every action in a cubit is a `CubitState<T>` field on `XState` — no sealed class hierarchy. `CubitState<T>` (from `lib/configs/cubit/`) carries `action`, `data`, `fault`, `meta` and provides `.toLoading()` / `.toSuccess()` / `.toFailed()` transitions plus `.isLoading` / `.isSuccess` / `.isFailed` getters and a `.when()` method for UI rendering.

**Accessing Cubits and Providers — never use `context.read` / `context.watch` directly:**

Every generated Cubit has a static `.c()` accessor:
```dart
// Read-only (no rebuild)
UserCubit.c(context).login(_formData);

// Reactive (triggers rebuild on state change)
final state = UserCubit.c(context, true).state;
```

Every `_ScreenState` (ChangeNotifier) has a static `.s()` accessor — same pattern:
```dart
// Read-only
_ScreenState.s(context).toggleLoading();

// Reactive
final isLoading = _ScreenState.s(context, true).isLoading;
```

Both are wrappers around `BlocProvider.of(context, listen: listen)` and `Provider.of(context, listen: listen)` respectively. Always use `.c()` / `.s()` — never raw `context.read` / `context.watch`.

---

## Key Models

All models use **Freezed** (immutable, `copyWith`, `fromJson`/`toJson`):

| Model | Path | Purpose |
|---|---|---|
| `UserData` | `core/models/user/` | Auth user profile |
| `Organization` | `core/models/organization/` | Org profile + type |
| `ApkDetail` | `core/models/distribution/` | APK metadata |
| `AppDetail` | `core/models/distribution/` | App (collection of APKs) |
| `ApiKey` / `ApiKeyCreated` | `core/models/api_key/` | CLI API key record; one-shot creation response carries the raw key |
| `Subscription` | `core/models/subscription/` | Subscription tier mirror (written by RC webhook) |
| `OrgTokenResponse` | `core/models/responses/` | Token generation response |
| `OrgVerifyResponse` | `core/models/responses/` | Verification result |

Run `dart run build_runner build --delete-conflicting-outputs` after any model change.

---

## Services (Singletons)

| Service | Path | Responsibility |
|---|---|---|
| `ApiService` | `services/http/api.dart` | Dio HTTP client |
| `FaultService` | `services/faults.dart` | Centralized error handling |
| `AppFcm` | `services/notifications/app_fcm.dart` | Firebase Cloud Messaging |
| `LocalNotifications` | `services/notifications/local.dart` | Local notification display |
| `AppCrashlytics` | `services/firebase/crash/` | Crash reporting |
| `AliceService` | `services/alice.dart` | HTTP debug logging (dev only) |

All services follow:
```dart
class FooService {
  static final FooService _instance = FooService._();
  FooService._();
  static FooService get ins => _instance;
}
```

---

## Multi-Flavor Setup

Three flavors, each with its own Firebase config:
- `stage` → `google-services-stage.json`
- `qa` → `google-services-qa.json`
- `prod` → `google-services.json` (bundle: `dev.mhmz.app_flight`)

Single entry point: `lib/main.dart`. The flavor is resolved at runtime via `AppFlavor.ins.init()` — no separate per-flavor entry files.

---

## Code Generation Tools

- **Freezed** — model immutability + JSON serialization
- **FlutterGen** — type-safe asset references (`lib/gen/assets/`)
- **Hygen** — cubit/screen/listener scaffolding (`_templates/`)
- **build_runner** — runs Freezed + JsonSerializable
