# AGENTS — Engineering Rules for AI / Human Contributors

This file captures §4, §5 and §10 of the product spec so every contributor (human or AI) has a single place to check non-negotiables.

---

## Architecture (§4)

- **Baseline dependencies** — exact versions pinned in `pubspec.yaml` (see `lib/core/constants/app_config.dart:4` for base URL). Add nothing earlier than the phase that needs it. Comments in the spec mark later-phase deps:
  - `google_maps_flutter ^2.9.0`, `geolocator ^13.0.2`, `geocoding ^3.0.0` — from Phase 2
  - `socket_io_client ^2.0.3+1` — from Phase 5
  - `firebase_core ^2.24.0`, `firebase_messaging ^14.6.0`, `flutter_local_notifications ^19.5.0` — from Phase 6
  - Dev: `flutter_lints ^5.0.0`, `build_runner ^2.0.0`, `freezed ^2.0.0`, `json_serializable ^6.0.0`
  - Do not upgrade without approval.

- **Folder layout** — `lib/main.dart`, `lib/core/{animations,constants,di,error,network,utils}`, `lib/data/{api,models,repositories,services}`, `lib/domain/{models,use_cases}`, `lib/ui/core/{theme,widgets}`, `lib/ui/features/<feature>/{providers,views,widgets,models}`, `docs/`.

- **Layers** — UI (widgets) → providers (Riverpod `StateNotifier`) → repositories → `ApiClient` / platform services. UI never touches Dio/sockets/storage directly. Repositories never import UI or Riverpod; they return plain models or throw typed exceptions.

- **DI** — `get_it` singleton `locator` in `lib/core/di/locator.dart:1`. One `setupLocator()` called from `main()` before `runApp`, registers in order: `AuthStorageService` → `ApiClient` → repositories → `SocketService`, `NotificationService`, `PermissionService`, `FcmTokenManager`. Providers read via `locator<T>()`; never instantiate inline.

- **State** — Riverpod `StateNotifier` with immutable state classes only. No `AsyncNotifier`, no `riverpod_generator`. Every state has explicit `copyWith` with `clearX` booleans for nullable fields. Exposed as `final xProvider = StateNotifierProvider<XNotifier, XState>(…)`. Use `.autoDispose.family` for per-entity state. Check `if (!mounted) return;` after every `await`. On logout invalidate every user-scoped provider.

- **Networking** — One `ApiClient` wrapping one `Dio` (15s timeouts). Two interceptors: logging then auth `QueuedInterceptor` that refreshes exactly once on 401, queues concurrent 401s, or calls `onSessionExpired`; OTP/refresh endpoints excluded. Envelope `{success,message,data,pagination?}`; failures throw `ApiException`/`NetworkException`; UI never sees `DioException`. One shared `uploadFile(path,fieldName,file,extraFields)`.

- **Models** — `freezed` + `json_serializable`, one file per domain area under `data/models/`. Map `_id` → `id` via `@JsonKey`. Nullable unless proven always present. Generated files committed; regenerate with `dart run build_runner build --delete-conflicting-outputs`.

- **Navigation** — Plain `Navigator` with one global `navigatorKey` (`lib/core/utils/navigation.dart:4`). Two `PageRouteBuilder`s: slide-up-and-fade for detail, slide-in-from-right-and-fade for linear flows. One shared function for notification taps (all three app states). One root-level auth listener resets stack to sign-in when session ends.

- **Storage & secrets** — Tokens only in `flutter_secure_storage`; non-sensitive durable state in `shared_preferences`; both wrapped by `AuthStorageService`. Platform secrets never committed — `.example` file + gitignore + README steps. Base URL is one compile-time constant via `String.fromEnvironment('API_BASE_URL', defaultValue: …)`.

- **Logging** — Facade `AppLog` (`lib/core/utils/app_log.dart:1`) is the only place that may emit a log line; `print`/`debugPrint` forbidden elsewhere. Five levels `d,i,w,e,f`. Format `[LEVEL] [TAG] [CONTEXT] → MESSAGE {payload}`, TAG from fixed set (`API,AUTH,ORDER,MENU,STORE,DOCS,EARN,NAV,STATE,STORAGE,NOTIF,UI,GEO,APP,SOCKET`). Every `AppLog.e` in a catch passes exception + stackTrace. No-op in release. Never log token/refresh/OTP.

- **Errors** — One `AppError.message(exception)` (`lib/core/error/app_error.dart:1`) is the only place that turns exceptions into user text. UI surfaces via snackbar/toast, full-screen error, empty, loading — never `error.toString()`.

- **Realtime** — Socket is accelerator on top of REST, never source of truth — reconcile on connect/reconnect/resume. One `SocketService` owns the connection; nothing above touches the client directly.

---

## Design System (§5)

- **AppColors** (`lib/ui/core/theme/app_colors.dart:1`) — Primary `#F7941D`, primary-dark `#D87D0E`, primary-light `#FFF5E9`, success `#58CC02`, error `#E23744`, info `#1CB0F6`, warning `#F57C00`, rating `#FFC200`, text `#3C3C3C/#757575/#BDBDBD`, background `#FAFAFA`, surface `#FFFFFF`, card border `#E5E5E5`, card fill `#F7F7F7`, divider `#E0E0E0`. No `Color(0x…)` outside this file. Status mapping uses `AppColors.statusColor`.

- **AppSpacing** (`lib/ui/core/theme/app_spacing.dart:1`) — scale 4/8/12/16/20/24/32, screen padding 20–24. No raw `EdgeInsets` literal outside this file.

- **AppRadius** (`lib/ui/core/theme/app_radius.dart:1`) — 8/12/16/20/24 + pill 999 (filter chips only, never buttons). No raw `BorderRadius.circular` literal outside this file.

- **AppTextStyles** (`lib/ui/core/theme/app_text_styles.dart:1`) — Google Fonts Nunito Sans, exactly seven named styles 28pt down to 11pt. No `TextStyle(fontSize: …)` outside this file.

- **Icons** — Material icon set only, `_outlined` preferred, sizes from `AppIconSize` (`lib/ui/core/theme/app_icons.dart:1`). No second icon package.

- **Motion** — `AppDurations` (`lib/core/animations/app_durations.dart:1`) 100/200/300/450/600 ms with comments, `AppCurves` (`lib/core/animations/app_curves.dart:1`) entrance/exit/state/tactile/panel. Reusable wrappers in `app_animations.dart`: fade-in, slide-in, scale-on-tap, staggered, skeleton cross-fade. No one-off `AnimationController`s. No interaction >600ms.

- **Core widgets** — `lib/ui/core/widgets/`: primary button (full-width + loading), secondary/outlined button, flat bordered card (1px, no shadow), badge, pill filter chip, app bar, bottom sheet with drag handle, confirm dialog, snackbar/toast, loading/empty/error.

- **Visual** — light background, flat white cards with thin border (no shadow), outlined inputs with floating labels + `*` for required, pill chips, tinted panels, switch toggle rows, full-width primary action pinned to form bottom.

---

## Definition of Done (§10)

Run every phase:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze                    # zero issues
flutter test                       # any pure-logic tests added this phase
grep -rn "fontSize:" lib/ | grep -v app_text_styles.dart
grep -rnE "\bprint\(|debugPrint\(" lib/ | grep -v app_log.dart
grep -rn "Color(0x" lib/ | grep -v "ui/core/theme"
grep -rn "Duration(milliseconds" lib/ | grep -v "core/animations"
```

All greps return nothing (document any exception here). No feature code outside current phase. Generated files committed.

---

## Working protocol

One phase at a time; kickoff summary; each phase restates scope → asks blocking questions → implements → runs §10 → sends §12 report → stops. Earlier phases frozen; touch only if current phase requires it and call it out. Never guess backend contract — capture real sample to `docs/api_samples/` and keep nullable. Never fabricate secrets — use `.example` placeholders. Use exact baseline dependency versions. Small reviewable diffs.

## Folder layout reminder

Keep `docs/Restaurant.md` as the living backend contract and `docs/PHASES.md` updated every phase (status, decisions, open questions).
