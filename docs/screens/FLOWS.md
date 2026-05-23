# Screens & User Flows — TaleemMate

## All Screens

| Screen | Path | Status | Purpose |
|---|---|---|---|
| `splash` | `ui/screens/splash/` | Scaffold | App init, auth check, initial routing |
| `login` | `ui/screens/login/` | Scaffold | Email + password login |
| `create_account` | `ui/screens/create_account/` | Scaffold | New user registration |
| `home` | `ui/screens/home/` | Scaffold | Main dashboard |
| `library` | `ui/screens/library/` | Scaffold | Content library / course browser |
| `tutor` | `ui/screens/tutor/` | Scaffold | AI tutor chat interface |
| `plan` | `ui/screens/plan/` | Scaffold | Study plan / schedule |
| `progress` | `ui/screens/progress/` | Scaffold | Learning progress tracker |

---

## Core User Flows

### 1. New User — Registration

```
splash → create_account → (auth) → home
```

### 2. Returning User

```
splash → (check auth state) → home         (authenticated)
                            → login        (not authenticated)
```

### 3. Login

```
login → (Firebase Auth) → home
```

### 4. Main App Navigation

The five main tabs are rendered via `BottomBar` inside the `Screen` widget:

```
home ↔ library ↔ tutor ↔ plan ↔ progress
```

All five routes share the same `BottomBar` — it appears automatically when any of these routes is on top.

---

## Splash Screen — Routing Priority

The splash screen drives session-restore routing. Priority order:

1. User is authenticated → `/home`
2. User is not authenticated → `/login`

---

## Screen File Requirements

### If the screen has a form

```
{screen}/
├── {screen}.dart
├── _state.dart           # holds formKey
├── static/
│   ├── _form_keys.dart   # string constants
│   └── _form_data.dart   # debug prefill
├── listeners/            # BlocConsumer / BlocListener
│   └── _{action}.dart
└── widgets/
    └── _body.dart
```

Pass `keyboardHandler: true` on the `Screen` widget for any screen with text fields.

### If the screen is view-only

```
{screen}/
├── {screen}.dart
├── _state.dart
└── widgets/
    └── _body.dart
```

---

## Hygen — Generating Screens

```bash
# New screen (screen.dart + _state.dart + optional static/ + widgets/)
hygen screen new <screen_name>

# Add a BlocConsumer with loading overlay
hygen screen consumer <screen_name>

# Add a BlocListener (no loading UI)
hygen screen listener <screen_name>

# Add a private widget to a screen
hygen screen _widget <widget_name>
```
