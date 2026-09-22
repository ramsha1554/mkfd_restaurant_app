# PHASES — MK Foods Restaurant

Living status, decisions and open questions — updated at the end of every phase.

---

## Phase 0 — Foundation & Design System — ✅ Done

**Scope:** Create project, baseline `pubspec.yaml` (only what this phase uses), `analysis_options.yaml`, folder skeleton from §4, README documenting Maps/Firebase placeholders, `AGENTS.md` capturing §4/§5/§10, `docs/Restaurant.md` (living copy of §6) and `docs/PHASES.md`. Build motion utilities, `AppLog`, media-URL resolver, `AppError`, `AppConfig`, `AppFormat`, and every design-system file and core widget from §5. Splash screen only, no networking.

**Files added / changed:**
- `pubspec.yaml` — baseline deps (excluding Phase 2/5/6 packages), `sdk: ^3.11.5`, assets `assets/images/` + `assets/audio/`
- `analysis_options.yaml` — include `package:flutter_lints/flutter.yaml`
- `lib/main.dart` — `setupLocator()` + `navigatorKey` + `AppTheme.light` + `SplashView`
- `lib/core/constants/app_config.dart` — `String.fromEnvironment('API_BASE_URL', defaultValue: …)` + `mediaOrigin`/`socketUrl` helpers
- `lib/core/utils/app_log.dart` — facade, 5 levels, `[LEVEL] [TAG] [CONTEXT] → MESSAGE {payload}`, no-op in release, never log token
- `lib/core/utils/app_format.dart` — `en_GB` currency £ + date/time helpers, `HH:mm` helpers
- `lib/core/utils/media_resolver.dart` — resolves `/uploads/...` against origin, not `/api/v1`
- `lib/core/utils/navigation.dart` — `navigatorKey`, `slideUpFadeRoute`, `slideRightFadeRoute`, `handleNotificationTap` stub
- `lib/core/error/app_error.dart` — `ApiException`, `NetworkException`, `AuthException`, `AppError.message`
- `lib/core/di/locator.dart` — `locator = GetIt.instance`, `setupLocator()` stub (Phase 1 wires real services)
- `lib/core/animations/app_durations.dart` — 100/200/300/450/600 ms with comments
- `lib/core/animations/app_curves.dart` — entrance/exit/state/tactile/panel
- `lib/core/animations/app_animations.dart` — `FadeIn`, `SlideIn`, `ScaleOnTap`, `StaggeredList`, `SkeletonCrossFade`
- `lib/ui/core/theme/app_colors.dart` — 15 tokens + `statusColor()` mapping
- `lib/ui/core/theme/app_spacing.dart` — 4/8/12/16/20/24/32 + screen padding + gaps
- `lib/ui/core/theme/app_radius.dart` — 8/12/16/20/24 + pill 999
- `lib/ui/core/theme/app_text_styles.dart` — Nunito Sans 7 styles 28→11pt via `google_fonts`
- `lib/ui/core/theme/app_icons.dart` — `AppIconSize` 16/20/24/28/32 + `AppIcon` helper
- `lib/ui/core/theme/app_theme.dart` — light theme using only tokens
- `lib/ui/core/widgets/primary_button.dart` — full-width + loading
- `lib/ui/core/widgets/secondary_button.dart`
- `lib/ui/core/widgets/app_card.dart` — 1px border, no shadow
- `lib/ui/core/widgets/app_badge.dart` — status-coloured badge + `AppBadge.status`
- `lib/ui/core/widgets/app_chip.dart` — pill chip + `AppChipGroup`
- `lib/ui/core/widgets/app_app_bar.dart`
- `lib/ui/core/widgets/app_bottom_sheet.dart` — drag handle + `AppBottomSheet.show`
- `lib/ui/core/widgets/app_dialog.dart` — confirm + destructive variant
- `lib/ui/core/widgets/app_snackbar.dart`
- `lib/ui/core/widgets/app_states.dart` — `AppLoadingState`, `AppSkeleton`, `AppEmptyState`, `AppErrorState`
- `lib/ui/features/splash/views/splash_view.dart` — branded splash with FadeIn/SlideIn
- `README.md`, `AGENTS.md`, `docs/Restaurant.md`, `docs/PHASES.md`
- `android/app/build.gradle.kts` — `applicationId`/`namespace` → `com.mokshasolutions.mkfoodsrestaurant`
- `android/app/src/main/kotlin/.../mkfoodsrestaurant/MainActivity.kt` — package fix
- `android/app/src/main/AndroidManifest.xml` — label → `MK Foods Restaurant`
- `ios/Runner/Info.plist` — display name → `MK Foods Restaurant`
- `ios/Runner.xcodeproj/project.pbxproj` — bundle ID → `com.mokshasolutions.mkfoodsrestaurant`
- Placeholders: `assets/images/.gitkeep`, `assets/audio/.gitkeep`, `docs/api_samples/.gitkeep`, `.example` secrets (see Decisions)

**Decisions:**
- Keep `sdk: ^3.11.5` per spec; Flutter 3.44.8/Dart 3.12.2 still satisfies `^3.11.5` (`<4.0.0`).
- Phase 0 `pubspec.yaml` includes only non-later-phase deps (`flutter_riverpod`, `get_it`, `freezed_annotation`, `json_annotation`, `dio`, `shared_preferences`, `flutter_secure_storage`, `google_fonts`, `intl`, `cupertino_icons` + dev `flutter_lints ^5.0.0`, `build_runner`, `freezed`, `json_serializable`). Maps/Socket/Firebase excluded until their phases (Working Protocol: add nothing earlier than the phase that needs it).
- Display name and bundle ID applied per proposed identifiers (§1) without underscore variant.
- Secrets via `.example` placeholders + gitignore: `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, `android/app/src/main/res/values/google_maps_api.xml` — real files never committed, README documents exact restore steps.
- Splash shows static branded content with `FadeIn` + `SlideIn.fromBottom`; no navigation logic yet — Phase 1 will add auth-state routing.

**Open questions carried (§9):** P1 role for restaurant owner + dev fixed OTP, P2 POST /restaurants response shape + `address.country`, P4 orders list sample + pickup verification + reject reason + single-order GET, P5 `order:new`/`order:assigned` payloads + restaurant-room join event, P6 push `type` values + Firebase project, P8 PATCH fields (delivery fee/coordinates), P9 earnings definition/shape. None block Phase 0; resolve before the phase shown.

**Post-Phase 0 clarification — 2026-09-22 (no phase advance, no commit/push per developer):**
- **P1 resolved per developer:** `role` for restaurant owner OTP is `"customer"` (developer message: "role is cutomer"), dev OTP is `000000`. Recorded for Phase 1 implementation; will still validate against real `POST /auth/request-otp` response saved to `docs/api_samples/` and keep nullable handling until proven across environments.
- **Repo bootstrap:** `git init`, `git remote add origin https://github.com/ramsha1554/mkfd_restaurant_app.git`, `git branch -M main` — no `git add`/`commit`/`push` performed as instructed.

**Verification:** see Phase 0 report.

---

## Phase 1 — Auth & Session — ✅ Done

**Scope:** `ApiEndpoints`, `ApiClient` (+ `uploadFile`) with logging + `QueuedInterceptor` (single refresh, queue, `onSessionExpired`, OTP/refresh excluded), `AuthStorageService` (`flutter_secure_storage` + `shared_preferences`), `ApiResponse`/`PaginationMeta`/`User`/`AuthData` (`freezed` + `JsonKey(_id)`), `AuthRepository` (`requestOtp`/`verifyOtp`/`refreshToken`/`logout`/`getMe` — defensive top-level vs `data` nesting, role `customer`, dev code `000000`), `AuthNotifier`/`AuthState` (`StateNotifier`, immutable `copyWith(clearX)`, `mounted` checks, `restoreSession` on cold start, `onSessionExpired` wiring, logout invalidates), root auth listener (`lib/main.dart:24` resets stack to sign-in), Welcome → phone entry (country selector `+44` default, E.164, validation) → 6-digit OTP (`OtpFields`, 60s timer, debug code shown only in `kDebugMode` via `SnackBar`) → placeholder `SignedInView` with logout.

**Files added / changed:**
- `lib/data/api/api_client.dart` — one `Dio` 15s, logging + auth `QueuedInterceptor`, envelope `ApiException`/`NetworkException`, `uploadFile(path, fieldName, file, extraFields)`
- `lib/data/api/api_endpoints.dart` — auth + user endpoints
- `lib/data/models/api_response.dart`, `pagination_meta.dart` (+ `.freezed/.g.dart`), `user.dart` (+ `.freezed/.g.dart`), `auth_data.dart` (+ `.freezed/.g.dart`)
- `lib/data/services/auth_storage_service.dart` — tokens secure, prefs for `userId/phone/isVerified/isNewUser`, `clearAll`
- `lib/data/repositories/auth_repository.dart` — pure, no UI/Riverpod
- `lib/core/di/locator.dart` — `AuthStorageService` → `ApiClient` → `AuthRepository` (order per §4)
- `lib/ui/features/auth/providers/auth_state.dart`, `auth_provider.dart` — `final authProvider = StateNotifierProvider<AuthNotifier, AuthState>`
- `lib/ui/features/auth/views/welcome_view.dart`, `phone_entry_view.dart`, `otp_view.dart`, `signed_in_view.dart`
- `lib/ui/features/auth/widgets/country_selector.dart`, `otp_fields.dart`
- `lib/ui/features/splash/views/splash_view.dart` — `ConsumerStateful`, `restoreSession` + `900ms` (`AppDurations.slowest+medium`) bootstrap, routes to `WelcomeView`/`SignedInView`, secondary unauth listener via `navigatorKey`
- `lib/main.dart` — `ProviderScope`, `setupLocator()` before `runApp`, root `ref.listen(authProvider)` resets to `WelcomeView` on `authenticated→unauthenticated`
- `test/widget_test.dart` — `AuthState.copyWith`, `AppFormat`, `AppConfig`, `Welcome` branding (4 tests)

**Decisions:**
- Role `customer` + dev OTP `000000` per developer 2026-09-22 clarification; interceptor still excludes OTP/refresh generically.
- Tokens defensive: verify `data` may be `Map` or nested `data.data`, `accessToken` may be `access_token` or top-level — handled in `ApiClient._refresh` + `AuthRepository.verifyOtp` with fallback map lookups.
- `Splash` delay `AppDurations.slowest + AppDurations.medium` (900ms) + `AppDurations.fast` (200ms) — no raw `Duration(milliseconds` outside `core/animations` (grep clean).
- `flutter_secure_storage` + `shared_preferences` both wrapped, `clearAll` on logout/sessionExpired; logout clears remote best-effort then local.
- `welcome` uses `slideRightFadeRoute` (linear flow), `SignedInView` uses placeholder + `SecondaryButton` logout + `PrimaryButton` stub.

**Open questions carried (§9):** P2 `POST /restaurants` shape + `address.country`, P4 orders list/pickup/reject/single GET, P5 socket payloads + room event, P6 push `type` + Firebase project, P8 PATCH fields, P9 earnings. **P1 closed.**

**Verification:** see Phase 1 report.

## Phase 2 — Restaurant Registration & Compliance Documents — Planned

## Phase 3 — App Shell & Store Controls — Planned

## Phase 4 — Orders (REST only) — Planned

## Phase 5 — Realtime & Alerts — Planned

## Phase 6 — Push Notifications — Planned

## Phase 7 — Menu Management — Planned

## Phase 8 — Profile, Hours, Documents, Settings — Planned

## Phase 9 — Earnings — Planned

## Phase 10 — Production-Readiness Audit & Release Prep — Planned
