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

## Phase 2A — Restaurant registration flow — Done

**Scope delivered:** four-step registration shown by the restaurant gate when `GET /restaurants/my-restaurant` returns `404`. Step 1 captures name, phone (dial code from the auth session, pre-filled, sent as E.164; national format validated, UK `+44` requires `7\d{9}$` after normalisation), email, cuisines and description. Step 2 searches addresses through Photon, validates postcodes through postcodes.io, lets the owner adjust a Google Maps pin full screen and reverse-describes the point. Step 3 captures minimum order (text + quick chips) and preparation time (5-60 slider). Step 4 reviews the draft, confirms terms and submits `POST /restaurants`; the gate reloads on success. No document upload or approval screens (Phase 2B).

**Files added / changed:**
- `pubspec.yaml`, `pubspec.lock` — `google_maps_flutter ^2.9.0` (no OSM packages, no geolocator, no location permission)
- `android/app/src/main/AndroidManifest.xml` — `INTERNET` permission + `com.google.android.geo.API_KEY` meta-data
- `android/app/src/main/res/values/google_maps_api.xml` — local Android key (gitignored; `docs/google_maps_api.xml.example` committed)
- `ios/Flutter/Secrets.xcconfig` — local iOS key (gitignored; `Secrets.xcconfig.example` committed); `ios/Runner/AppDelegate.swift` calls `GMSServices.provideAPIKey`, `Info.plist` reads `$(GOOGLE_MAPS_API_KEY)`
- `lib/core/utils/uk_postcode.dart` — `isValidUkPostcode`, `normaliseUkPostcode`
- `lib/data/services/geocoding_service.dart` — `GeocodingService` interface, `ApiGeocodingService`, `AddressSuggestion`, `PostcodeLookupResult`, `PostcodeLookupStatus`; own plain `Dio`, never the auth token
- `lib/core/animations/app_durations.dart` — `geocoding`, `postcodeLookup`, `searchDebounce` (350ms), `postcodeDebounce` (400ms), `reverseDebounce` (500ms)
- `lib/core/di/locator.dart` — registers `GeocodingService`
- `lib/ui/core/widgets/app_stepper.dart` — four-segment registration header with step/total + label
- `lib/ui/core/widgets/app_text_field.dart` — `isRequired`, `prefix`, `suffix`, `inputFormatters`, `minLines`, `hasError`, `locked`, `showValidCheck`, `onSubmitted`, `onEditingComplete`, `textCapitalization`
- `lib/ui/core/widgets/app_chip.dart` — `trailingIcon` + `onTrailingTap` (removable "Remove <label>" semantics)
- `lib/domain/models/restaurant_registration.dart` — exact `POST /restaurants` payload builder
- `lib/ui/features/registration/utils/registration_validation.dart` — phone/postcode/email/name/cuisine/minimum-order/prep validators + `kSuggestedCuisines`
- `lib/ui/features/registration/models/registration_draft.dart` — UI draft, defaults, `toRequest()`
- `lib/ui/features/registration/providers/registration_state.dart`, `registration_provider.dart` — step state, debounced search/lookup with sequence guards, `selectAddress`, `describePoint`, per-step validation, submit
- `lib/data/api/api_endpoints.dart` — `createRestaurant = '/restaurants'`
- `lib/data/repositories/restaurant_repository.dart` — `createRestaurant(RestaurantRegistrationDraft)`
- `lib/ui/features/registration/views/register_step_one_view.dart`, `register_location_step_view.dart`, `register_pricing_step_view.dart`, `register_review_step_view.dart`, `registration_flow_view.dart`, `location_map_view.dart`
- `lib/ui/features/registration/widgets/registration_footer.dart`, `address_map_preview.dart`
- `lib/ui/features/shell/views/restaurant_gate_view.dart` — `none` opens the flow; submitted value reloads the restaurant; pending/rejected/unknown copy updated; logout invalidates registration
- Tests: `test/data/geocoding_service_test.dart`, `test/data/restaurant_registration_test.dart`, `test/ui/registration_provider_test.dart`, `test/ui/app_stepper_test.dart`, `test/ui/app_text_field_test.dart`
- `docs/PHASES.md`, `docs/UI_ADDITIONS.md`, `docs/Restaurant.md`, `design/SCREENS.md`

**Decisions:**
- Map rendering uses `google_maps_flutter` (Android + iOS) for both the preview and the full-screen picker; Photon and postcodes.io remain the only address/reverse services, so no Google Places/Geocoding billing.
- API keys stay out of git: Android reads `@string/google_maps_api_key` from the ignored `google_maps_api.xml`; iOS reads `$(GOOGLE_MAPS_API_KEY)` from the ignored `Secrets.xcconfig`. Keys must be restricted to the app bundle/package and registered SHA-1s.
- Address lookup uses Photon (`bbox` limited to Great Britain) and postcodes.io; both are unauthenticated third-party calls from a dedicated `Dio` with `MKFoodsRestaurant/1.0` user agent, never the owner token.
- Postcodes are validated locally first (`invalid_format` without network), then 404 -> `not_found`, network/server -> `failed`. Success fills city (admin district else region), postcode, latitude and longitude.
- The full-screen map satisfies reverse geocoding without owning the draft pin: `describePoint` only labels the point; the owner still confirms via "Use this location".
- Payload uses top-level `longitude` and `latitude`, `address.country = "UK"`, empty email as `""`, and no `deliveryFee`. Hours default to Mon-Sat 09:00-22:00 open and Sunday closed.
- Registration phone is dial-code aware: the step-1 prefix shows the dial code from the auth session (`country_code` persisted at verify-otp), pre-fills the national number from the session, and sends E.164 in `POST /restaurants` (`fullPhone`). UK `+44` validates as `^7\d{9}$` after normalisation.
- Validation uses `AppSnackbar.showError` + red field border, no inline error text; the step-2 postcode status line is the only inline exception.
- Draft defaults: city "Milton Keynes", minimum order 0, preparation time 30 min.
- The review step requires the terms/privacy checkbox before the submit button enables.

**Open questions / assumptions:**
- Confirm the real `POST /restaurants` success body and whether the backend recomputes `status` as `pending` immediately for the gate reload.
- `phone`, `email`, `address.country` and the operating-hours keys are assumptions based on the Phase 0 contract; confirm against a captured response in `docs/api_samples/`.
- Document upload and approval states remain Phase 2B.

**Verification:** see Phase 2A report.

## Phase 2B — Compliance documents & approval — Planned

**Scope to deliver:** document upload and status screens for the five required document types, using `POST /restaurants/documents` and `GET /restaurants/my-documents`, plus the approval/rejection surfaces that follow registration. Start only after Phase 2A is reviewed.

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

## Phase 4B — Order detail and pickup verification — ✅ Done

**Scope delivered:** order detail screen opened from any order card (pushed over the shell, no bottom nav, slide-right-fade), reading the order from the orders provider by id (active set and history) without a single-order GET; status-aware pinned action bar (reject/accept, start preparing, mark as ready, verify pickup); pickup verification sheet with a 4-digit code field; phone launcher behind a `PhoneLauncher` interface; driver call buttons wired on cards and detail; the missing ready-card verify action. REST only — no sockets, push, sound, Live badge or search.

**Files added / changed:**
- `pubspec.yaml`, `pubspec.lock` — `url_launcher ^6.3.3`
- `android/app/src/main/AndroidManifest.xml` — `<queries>` tel `DIAL` intent
- `ios/Runner/Info.plist` — `LSApplicationQueriesSchemes` `tel`
- `lib/data/services/phone_launcher.dart` — `PhoneLauncher` interface + `UrlPhoneLauncher` (`tel:`, external mode, returns false when it cannot start)
- `lib/core/di/locator.dart` — registers `PhoneLauncher`
- `lib/ui/features/orders/providers/phone_launcher_provider.dart`, `lib/ui/features/orders/widgets/order_call_button.dart` — call button behind the interface
- `lib/ui/features/auth/widgets/otp_code_field.dart` — `length` parameter (default 6), boxes and input follow it
- `lib/data/api/api_endpoints.dart` — `orderVerifyPickup(id)`
- `lib/data/repositories/order_repository.dart` — `verifyPickup(id, code)` → `PATCH /orders/:id/verify-pickup` with `{pickupCode}`
- `lib/ui/features/orders/providers/orders_provider.dart` — `verifyPickup` through the shared in-flight action runner (applies a returned order, refreshes the active set when none is returned, returns the exact backend message)
- `lib/ui/core/widgets/app_section_card.dart` — `AppCard` plus optional uppercase eyebrow
- `lib/ui/core/widgets/app_info_banner.dart` — prominent variant with optional title/trailing
- `lib/core/animations/app_durations.dart` — `countdown` (1s) and detail animation durations
- `lib/ui/features/orders/widgets/pickup_sheet.dart` — `showVerifyPickupSheet`
- `lib/ui/features/orders/views/order_detail_view.dart` — full detail screen, action bar and acceptance countdown
- `lib/ui/features/orders/views/orders_tab_view.dart` — detail entry and pickup-sheet wiring
- `lib/ui/features/orders/widgets/app_order_card.dart` — `onTap`, verify-pickup action, driver call button
- `test/support/fake_phone_launcher.dart`, `test/support/order_fixtures.dart`, `test/ui/otp_code_field_test.dart`, `test/ui/order_detail_view_test.dart`, `test/ui/orders_provider_test.dart`
- `docs/PHASES.md`, `docs/UI_ADDITIONS.md`, `docs/Restaurant.md`

**Decisions:**
- Detail reads from the provider only; the owner single-order GET is unconfirmed and unused. If the id is no longer in state, the screen shows `AppErrorState` "Order not found" with a retry that refreshes the lists and the app bar back arrow.
- `verifyPickup` sends `pickupCode` (what the working website sends), not the contract's `code`. `pickupCode` is never parsed into UI state, displayed, logged or persisted; the owner types the code the driver reads out.
- Earnings show only food subtotal, commission (API value or derived 15%) and payout. Total, delivery, driver and platform fees are never displayed as such.
- Accepting from the detail screen keeps the screen open and updates the action bar from provider state; rejecting closes the sheet and pops the screen.
- The server decides late acceptance: the countdown reaching zero shows "Time to respond has run out" while actions stay enabled.
- Call buttons go through `PhoneLauncher`; a call that cannot start shows "Could not open the phone app".
- Payment badge mapping: `cash` → "Cash"; `payment_link` + `paid` → "Paid online"; other `payment_link` states → "Online · <status>"; unknown methods show the raw value.
- Commission and payout derive client-side from `orderMoney` until the backend returns explicit fields.

**Snapped values:**
- Customer address icon 16 (`AppIconSize.xs`) in `primary` (design says 16 primary).
- Payout panel radius 12 (`AppRadius.rSm`) and padding 12 (`AppSpacing.md`).
- Pickup-sheet body uses 14 `body` secondary instead of `bodySecondary` 12 (design says 14).
- Pinned action bar and sheet buttons use the core defaults (52); card actions use 44. Detail reject/accept split 35/65.
- All values use existing tokens; no raw hex, font size, weight or duration introduced.

**Open questions / assumptions:**
- Confirm the verify-pickup response returns the updated order; when it does not, the app refreshes the active set.
- Confirm whether `commissionRate`, `commissionAmount`, `restaurantPayout`, `driverWaiting` and `driverArrived` become first-class API fields; the app derives them for now.
- Pickup verification does not currently receive realtime updates (Phase 5); refresh and polling are the only reconciliation.

**Verification:** see Phase 4B report.

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

