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

## Phase 3 — App Shell & Store Controls — ✅ Done

**Scope delivered:** App shell with four-tab bottom navigation (Orders, Menu, Earnings, More), Orders screen with restaurant header + store open/Busy switch rows + pull-to-refresh + empty state, placeholders for the remaining tabs, restaurant data layer (`GET /restaurants/my-restaurant`, `PATCH /restaurants/:id/status`), post-login gate that routes approved owners to the shell and shows pending/rejected/no-restaurant/error states, logout from More + gate, and Phase 3 widget/provider tests. Live connection badge was built but is not shown until Phase 5.

**Files added / changed:**
- `lib/ui/core/widgets/app_bottom_nav.dart` — stroke icons, selected `primaryText` + 700 label, label 12/500 base, badge support, 48+ targets
- `lib/ui/core/widgets/app_switch_row.dart` — title + caption, 44×24 switch, `locked` state, 48 min height, reduce-motion aware
- `lib/ui/core/widgets/app_live_badge.dart` — tiny green `Live` / muted `Offline` badge with pulsing dot (built, not shown until Phase 5)
- `lib/data/models/restaurant.dart` (+ `.freezed.dart`, `.g.dart`) — `RestaurantModel`, `RestaurantAddress`, `RestaurantLocation`; `_id` → `id`; nullable fields
- `lib/data/repositories/restaurant_repository.dart` — fetch my restaurant (404 → none), defensive status PATCH parse
- `lib/data/api/api_endpoints.dart` — `myRestaurant`, `restaurantStatus(id)`
- `lib/core/di/locator.dart` — registers `RestaurantRepository`
- `lib/ui/features/shell/providers/restaurant_state.dart`, `restaurant_provider.dart` — load/refresh, optimistic `setOpen`/`setBusy` with rollback
- `lib/ui/features/shell/providers/shell_provider.dart` — selected tab index
- `lib/ui/features/shell/views/app_shell.dart` — `IndexedStack`, bottom nav, back-to-Orders behaviour
- `lib/ui/features/shell/views/orders_tab_view.dart` — header block, store controls card, pull-to-refresh, empty state, skeleton
- `lib/ui/features/shell/views/menu_tab_view.dart`, `earnings_tab_view.dart`, `more_tab_view.dart` — Phase 4/7/8 placeholders; More has destructive logout confirm + app version
- `lib/ui/features/shell/widgets/store_controls_card.dart` — Store open + Busy switches, divider, close-store confirmation, snackbar errors
- `lib/ui/features/shell/views/restaurant_gate_view.dart` — approved → shell; none/pending/rejected/unknown/error placeholders; skeleton while loading; logout
- `lib/core/constants/app_config.dart` — `appVersion = '1.0.0'` (no new dependency)
- `lib/ui/features/splash/views/splash_view.dart` — routes to gate instead of the removed placeholder
- `lib/ui/features/auth/views/otp_view.dart` — routes to gate after verification
- `lib/ui/features/auth/views/signed_in_view.dart` — deleted (replaced by gate/shell)
- `test/ui/app_bottom_nav_test.dart`, `app_switch_row_test.dart`, `app_live_badge_test.dart`, `restaurant_provider_test.dart` — Phase 3 tests
- `test/widget_test.dart` — stale Welcome branding assertions updated to current copy; pumped entrance timers

**Decisions:**
- Gate treats `pending` / `rejected` as explicit placeholders; `none` (404) as “set up restaurant”; any other status as awaiting approval; only `approved` (case-insensitive) enters the shell. Phase 2 registration flows remain planned, so those placeholders are informational for now.
- Turning “Store open” off asks for confirmation; turning Busy on/off does not. Both toggles update optimistically, lock while in flight, and roll back on failure with an `AppSnackbar`.
- Pull-to-refresh reloads silently (keeps current dashboard on failure) and shows a snackbar; errors never replace a loaded restaurant with an error screen.
- Shell tab index lives in `ShellNotifier`; `IndexedStack` preserves each tab, and system back on any tab returns to Orders before leaving the shell.
- App version is a compile-time constant in `AppConfig`; `package_info_plus` is intentionally not added.
- `docs/UI_STANDARDS.md` is referenced but missing from the repo; components were built from `design/SCREENS.md`, `design/stitch/` and existing tokens.
- Snapped to the token scale: live badge padding 10×6 → 8×4, dot/gap 8/6 → 8/4; store-controls `AppCard` padding 14 → 12; nav labels use `AppTextStyles.caption` 12/500; switch row caption uses `AppTextStyles.bodySecondary`.
- Phase 1 `splash_view.dart` and `otp_view.dart` were touched only to route to the new gate; `signed_in_view.dart` was removed.

**Open questions / assumptions:**
- `PATCH /restaurants/:id/status` response shape is still unconfirmed. The repository parses `data` as a restaurant when present; on an ack-only body it returns `null` and the notifier keeps the optimistic value. Confirm the real shape and whether Busy is auto-cleared server-side.
- `GET /restaurants/my-restaurant` real sample not captured (no backend available this phase). Model follows the contract; nested `address`/`location` remain nullable.
- `isBusy` is documented for both the restaurant and the status endpoint, so Busy is shown. Confirm every restaurant response actually includes it.
- Status values beyond `pending` / `approved` / `rejected` are treated as awaiting approval.
- `docs/UI_STANDARDS.md` must be restored or the reference removed from `AGENTS.md`.

**Verification:** see Phase 3 report.

## Phase 4A — Orders (REST only) — ✅ Done

## Phase 4B — Pickup verification & order detail — Planned

**Phase 4A scope delivered:** owner order list backed by REST with a real active set (fan-out per status), server-side paginated history, live filter-chip counts, 30-second foreground polling, pull-to-refresh, optimistic per-status actions (accept, start preparing, mark ready, reject), reject-reason sheet, offline/stale banners, order-number badge on the Orders tab, and tests. Socket, push, sound, Live badge, order detail and pickup verification remain for Phase 4B/5.

**Files added / changed:**
- `lib/data/models/order.dart` (+ `.freezed.dart`, `.g.dart`) — `OrderModel`, `OrderStatus`, customer/driver/item/status-event/address models; defensive normaliser for alternate field names; `_id` → `id`
- `lib/data/repositories/order_repository.dart` — active/history paging, confirm/preparing/ready/reject, per-order parse guard, exact API errors
- `lib/data/api/api_endpoints.dart` — restaurant orders, confirm, preparing, ready, reject
- `lib/data/models/pagination_meta.dart` — nullable `pages`/`hasNextPage`/`hasPrevPage` + `hasNext`
- `lib/core/di/locator.dart` — registers `OrderRepository`
- `lib/core/utils/app_format.dart` — `timeAgo`, `shortName`
- `lib/core/animations/app_durations.dart` — `poll` (30s)
- `lib/ui/core/theme/app_colors.dart` — legacy `pending` status mapping
- `lib/ui/core/widgets/app_card.dart` — optional border colour/width
- `lib/ui/core/widgets/primary_button.dart` — `destructive` variant
- `lib/ui/core/widgets/app_info_banner.dart`, `app_offline_banner.dart` — new banners
- `lib/ui/features/orders/models/order_filter.dart`, `utils/order_money.dart` — chip/status sets and money/driver derivation
- `lib/ui/features/orders/providers/orders_state.dart`, `orders_provider.dart` — active/history state, counts, paging, polling guard, actions, `isStale`/`isOffline`
- `lib/ui/features/orders/views/orders_tab_view.dart` — full Orders screen (replaces shell placeholder)
- `lib/ui/features/orders/widgets/app_order_card.dart`, `order_filter_bar.dart`, `reject_order_sheet.dart`
- `lib/ui/features/shell/views/app_shell.dart` — imports the new screen, Orders badge from `ordersProvider`
- `lib/ui/features/shell/views/orders_tab_view.dart` — deleted
- `lib/ui/features/shell/views/more_tab_view.dart` — invalidates `ordersProvider` on logout
- `test/support/order_fixtures.dart`, `test/data/order_model_test.dart`, `test/ui/orders_provider_test.dart`, `test/ui/app_order_card_test.dart`, `test/ui/order_filter_bar_test.dart`, `test/ui/reject_order_sheet_test.dart`, `test/ui/app_info_banner_test.dart`, `test/ui/app_offline_banner_test.dart`, `test/ui/primary_button_test.dart`
- `docs/api_samples/orders_list.json` — real sample (5 orders)
- `docs/Restaurant.md`, `docs/UI_ADDITIONS.md` — contract and component notes

**Decisions:**
- The active set is seven parallel `status` queries (`placed`, `confirmed`, `preparing`, `ready`, `arrived_at_restaurant`, `picked_up`, `on_the_way`, limit 50). Individual failures keep previous data for those statuses and mark the list stale; all failing surfaces an error.
- Chips map New=`placed`; Preparing=`confirmed`+`preparing`; Ready=`ready`+`arrived_at_restaurant`; Picked up=`picked_up`+`on_the_way`; History All / Delivered / Cancelled load pages of 25 (Cancelled merges `cancelled`+`rejected`). Any underlying truncated status renders `N+`.
- Polling runs every 30s only while the Orders tab is selected and the app is foreground; resume, tab select, pull-to-refresh and successful actions refresh immediately. No sockets this phase.
- Actions update optimistically, lock per order while in flight, roll back on failure and surface the exact API message. Reject sends the selected chip plus optional details as one `reason` string.
- Cards show “Subtotal” for live orders and derived “Payout” for delivered orders; total/delivery/driver fees are never shown. Driver-waiting banners use `arrived_at_restaurant`/`driverWaiting`/`driverArrived`.
- `isOffline` is set from `NetworkException` failures; the offline banner locks every card action while last-known orders remain visible.
- `pickupCode` is never parsed into UI state, displayed or logged.

**Open questions / assumptions:**
- Confirm the reject body key is `reason` and the exact response shape.
- Confirm `status` filtering and limits above 10 behave as assumed; the sample only proves the envelope/pagination and an unfiltered page.
- `rejected`, `expired` and `failed` statuses were not in the sample; verify their display and history behaviour.
- Commission/payout fields are absent from the sample; the app derives 15% client-side. Confirm server fields before production payouts.
- `payment_link` and unknown payment methods are displayed as raw values; confirm intended copy.
- Pickup verification (`verify-pickup`) and the single-order detail screen are Phase 4B; the body key may be `code` or `pickupCode`.

**Verification:** see Phase 4A report.

## Phase 5 — Realtime & Alerts — Planned

## Phase 6 — Push Notifications — Planned

## Phase 7 — Menu Management — Planned

## Phase 8 — Profile, Hours, Documents, Settings — Planned

## Phase 9 — Earnings — Planned

## Phase 10 — Production-Readiness Audit & Release Prep — Planned

## Phase 0.5-A — Tokens & Theme
- Files changed: pubspec.yaml, assets/fonts/*, lib/ui/core/theme/app_colors.dart, lib/ui/core/theme/app_text_styles.dart, lib/ui/core/theme/app_theme.dart
- Decisions: Replaced tokens with MK Foods standard; removed google_fonts; added DM Sans/BricolageGrotesque bundled fonts; statusColor replaced by statusMeta returning (label, fg, bg); theme rebuilt to Material 3 per spec.
- Old?new style-name mapping: heading?h1/h2/display as appropriate (AppTextStyles.heading removed), bodyLarge removed ? use button/body/cardTitle per context, bodySmall removed ? use bodySecondary/caption, displaySecondary/headingSecondary/bodyHint/bodySmallHint/captionPrimary removed (use color overrides), cardFill removed (use cardBackground).
- Status: Done


## Phase 0.5-B — Core widgets
- Files changed: lib/core/animations/app_scale_tap.dart, lib/ui/core/widgets/primary_button.dart, lib/ui/core/widgets/secondary_button.dart, lib/ui/core/widgets/app_card.dart, lib/ui/core/widgets/app_badge.dart, lib/ui/core/widgets/app_chip.dart, lib/ui/core/widgets/app_app_bar.dart, lib/ui/core/widgets/app_bottom_sheet.dart, lib/ui/core/widgets/app_dialog.dart, lib/ui/core/widgets/app_snackbar.dart, lib/ui/core/widgets/app_states.dart, lib/ui/core/widgets/app_text_field.dart
- API changes: Added AppPrimaryButton/AppOutlinedButton/AppScaleTap/AppStatusBadge/AppFilterChip/showAppSheet/showAppConfirmDialog/showAppMessageDialog/AppSnackbar (overlay top toast), AppIconBubble/AppLoading/AppSkeleton/AppEmptyState/AppErrorState/AppTextField; kept PrimaryButton/SecondaryButton aliases.
- Call-site edits: Updated to new APIs where used; existing code remains compatible via aliases.
- Decisions: Elevation 0, flat borders, no ripples; reduce-motion supported; statusMeta used for badges.
- Status: Done

