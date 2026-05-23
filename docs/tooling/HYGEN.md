# Hygen — TaleemMate Code Generation

Templates live in `_templates/`. Never create screen, cubit, or provider files manually — always use generators.

---

## All Generators

| Command | Purpose |
|---|---|
| `hygen screen new <name>` | Create a full screen (root + state + widgets + routes) |
| `hygen screen consumer <name>` | Add a BlocConsumer listener to an existing screen |
| `hygen screen listener <name>` | Add a BlocListener (no UI block) to an existing screen |
| `hygen screen _widget <name>` | Add a private widget file to an existing screen |
| `hygen cubit nested <name>` | Create a new cubit + repo (full 6-file structure) |
| `hygen cubit update <name>` | Inject new action modules into an existing cubit |
| `hygen provider new <name>` | Create an app-level ChangeNotifier provider |

All generators support non-interactive mode — see each section for `--flag` usage.

---

## `screen new` — Create a screen

```bash
hygen screen new <name>

# Non-interactive
hygen screen new <name> --formData false
hygen screen new <name> --formData true --formKeys "email,password" --widgets "header,body"
```

**Generated files:**

| File | Always? |
|---|---|
| `lib/ui/screens/<name>/<name>.dart` | Yes — screen root with `App.init`, `ChangeNotifierProvider<_ScreenState>`, `_Body` |
| `lib/ui/screens/<name>/_state.dart` | Yes — `_ScreenState extends ChangeNotifier` with `.s(context)` accessor |
| `lib/ui/screens/<name>/static/_form_keys.dart` | Only if `--formData true` |
| `lib/ui/screens/<name>/static/_form_data.dart` | Only if `--formData true` |
| `lib/ui/screens/<name>/widgets/_body.dart` | Yes |
| `lib/ui/screens/<name>/widgets/_<widget>.dart` | One per widget name |

Also patches `lib/router/router.dart` (import + route entry) and `lib/router/routes.dart` (constant).

**Known behaviour:** widget files are generated via shell commands from `zzshell.ejs.t`. If the sub-shell fails (e.g. in CI), the `part` declarations are still added to the screen root but the widget files won't exist — run `hygen screen _widget` manually to recover.

---

## `screen consumer` — BlocConsumer listener

Generates a listener that shows a full-screen loading overlay and handles success/error flash messages.

```bash
hygen screen consumer <screen_name>

# Non-interactive  (arg format: cubitName:moduleField:listenerNameSuffix)
hygen screen consumer <screen_name> --arg "notification:fetch:fetch"
```

**Generated file:** `lib/ui/screens/<name>/listeners/_<suffix>.dart`

```dart
class _FetchListener extends StatelessWidget {
  const _FetchListener();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listenWhen: (a, b) => a.fetch != b.fetch,
      listener: (_, state) {
        if (state.fetch.isFailed) UIFlash.error(context, state.fetch.errorMessage);
        if (state.fetch.isSuccess) UIFlash.success(context, 'Request completed successfully');
      },
      builder: (context, state) {
        return FullScreenLoader(loading: state.fetch.isLoading);
      },
    );
  }
}
```

Also injects `import` statements for the cubit, state, `flutter_bloc`, `FullScreenLoader`, and `UIFlash` into the screen root.

Use `consumer` when the operation should **block the UI** (submit, delete, update).

---

## `screen listener` — BlocListener (no overlay)

Same prompt format as `consumer`, generates a `BlocListener` with `SizedBox.shrink()` as child — no loading UI.

```bash
hygen screen listener <screen_name>

# Non-interactive
hygen screen listener <screen_name> --arg "notification:fetch:fetch"
```

Use `listener` for **background operations** (background fetch, navigation, non-blocking sync).

| Template | Loading overlay | Use case |
|---|---|---|
| `consumer` | Yes (`FullScreenLoader`) | Submit, delete, any blocking action |
| `listener` | No | Background fetch, navigation triggers |

---

## `screen _widget` — Add a widget to an existing screen

```bash
hygen screen _widget <screen_name> --widgets "<widget1>,<widget2>"
```

**Generated:** `lib/ui/screens/<screen>/widgets/_<widget>.dart` (one per widget name)

Also injects `part 'widgets/_<widget>.dart'` into the screen root file.

---

## `cubit nested` — Create a new cubit

Creates the full cubit + repo structure and auto-registers in `lib/app.dart`.

```bash
hygen cubit nested <name>

# Non-interactive (format: module:ModelName,module:ModelName)
hygen cubit nested <name> --args "fetch:UserData,update:UserData"
```

**Generated structure:**

```
lib/blocs/<name>/
  cubit.dart          # Cubit class with .c(context) accessor and one method per module
  state.dart          # <Name>State with BlocState<T> field per module

lib/repos/<name>/
  <name>_repo.dart          # Repository — orchestrates data_provider
  <name>_data_provider.dart # Raw Firebase/HTTP calls
  <name>_mocks.dart         # Mock data for tests/dev
  <name>_parser.dart        # Response parsing logic
```

Also injects into `lib/app.dart`:
- `import 'blocs/<name>/cubit.dart'` (under `// bloc-imports-start`)
- `BlocProvider(create: (_) => <Name>Cubit())` (under `// bloc-initiate-start`)

**Generated cubit pattern:**

```dart
class NotificationCubit extends Cubit<NotificationState> {
  static NotificationCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<NotificationCubit>(context, listen: listen);

  NotificationCubit() : super(NotificationState.def());

  Future<void> fetch() async {
    emit(state.copyWith(fetch: state.fetch.toLoading()));
    try {
      final data = await NotificationRepo.ins.fetch();
      emit(state.copyWith(fetch: state.fetch.toSuccess(data: data)));
    } on Fault catch (e) {
      emit(state.copyWith(fetch: state.fetch.toFailed(fault: e)));
    }
  }

  void reset() => emit(NotificationState.def());
}
```

---

## `cubit update` — Add modules to an existing cubit

Injects new action methods into an existing cubit without overwriting anything.

```bash
hygen cubit update <existing_name>

# Non-interactive
hygen cubit update <existing_name> --args "delete:NotificationData,archive:NotificationData"
```

**Requires:** the cubit must have been created by `hygen cubit nested` (injection markers must be present). Will not work on hand-written cubits lacking the markers.

Updates:
- `lib/blocs/<name>/cubit.dart` — new async method + inline emission helpers
- `lib/blocs/<name>/state.dart` — new `BlocState<T>` field, constructor param, copyWith, equatable props
- `lib/repos/<name>/` — all four repo files

---

## `provider new` — Create an app-level provider

```bash
hygen provider new <name>
```

**Generated:** `lib/providers/<name>.dart` — `<Name>Provider extends ChangeNotifier` with `.s(context)` accessor.

Also injects:
- Import into `lib/app.dart` (under `// provider-imports-start`)
- `ChangeNotifierProvider(create: (_) => <Name>Provider())` (under `// provider-initiate-start`)

---

## Full Workflow Example

```bash
# 1. Create the screen
hygen screen new notification --formData false --widgets "header,list"

# 2. Create the cubit
hygen cubit nested notification --args "fetch:NotificationData,markRead:NotificationData"

# 3. Add blocking listener (fetch action)
hygen screen consumer notification --arg "notification:fetch:fetch"
# → Fix the BlocConsumer generic types manually after generation

# 4. Add navigation listener (mark-read, no overlay)
hygen screen listener notification --arg "notification:markRead:mark_read"

# 5. Add a new widget later
hygen screen _widget notification --widgets "empty_state"

# 6. Later: add delete action to the cubit
hygen cubit update notification --args "delete:NotificationData"
```

---

## build_runner

Run after any `@freezed` model change or after adding/removing assets.

```bash
# One-shot
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode during active model work
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## Freezed Model Pattern

```dart
// lib/core/models/<name>/<name>.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<name>.freezed.dart';
part '<name>.g.dart';

@freezed
sealed class MyModel with _$MyModel {
  const MyModel._();

  const factory MyModel({
    required String id,
    required String name,
    String? optionalField,
    @Default(false) bool isActive,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);
}
```

All models live in `lib/core/models/<name>/`. Run build_runner after changes.

---

## Asset Management (FlutterGen)

1. Place asset file in `assets/` or a subdirectory
2. Declare the path in `pubspec.yaml` under `flutter: assets:`
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. Reference via `Assets.app.appLogo` instead of string paths

Generated refs: `lib/gen/assets/assets.gen.dart`, `lib/gen/assets/fonts.gen.dart`
