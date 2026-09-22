# MK Foods Restaurant 

---

## 1. Mission

MK Foods Restaurant is the restaurant-owner mobile app for the MK Foods food-delivery platform (Milton Keynes, UK; currency £). Three kinds of users share one backend — customers who place orders, drivers who deliver them, and restaurant owners who prepare them — and this document specifies only the restaurant-owner app, built from scratch.

A restaurant owner can: sign in with a phone OTP; register their restaurant and submit compliance documents for approval; open or close the store and mark it busy; receive new orders in real time and act on them (accept, reject, mark preparing, mark ready, verify the driver's pickup code); manage the menu (categories, items, photos, availability); edit their profile, opening hours and documents; and review earnings.

Proposed identifiers (confirm with the developer before creating the project): package name `mk_food_restaurant`, applicationId / bundle id `com.mokshasolutions.mkfoodsrestaurant`, display name "MK Foods Restaurant", internal log name `MKFoodsRestaurant`.

---

## 2. Working Protocol (read twice)

1. **One phase at a time.** Only the phase named in the developer's latest "Phase N" message is in scope. Never start, stub, or "prepare for" a later phase — no unused endpoints, models, providers, routes or packages beyond what the current phase needs.
2. **Kickoff.** Read this whole document first. Reply with (a) a plain-language summary of what you understood, at most 10 lines, and (b) any blocking questions, each with a proposed default. Then stop and wait for "Start Phase 0" — write no code before that.
3. **Each phase:** restate its scope and list the files you will create or change → ask only the questions that block this specific phase → implement → run every check in §10 → send the report in §12 → **stop and wait**. Never roll into the next phase, even a trivial-looking one.
4. **Earlier phases are frozen.** Touch their files only when the current phase genuinely requires it, and call out every such edit in the report. A defect found in a frozen phase gets reported; fix it only if it actually blocks the current phase.
5. **Never guess a backend contract.** Where §6 is unconfirmed, get a real sample response first (or temporarily log the raw body), save it under `docs/api_samples/`, and model the field as nullable until proven.
6. **Never fabricate a secret or platform config file** (Firebase config, signing keys, API keys). Use the placeholder/`.example` pattern in §4 and tell the developer exactly what to fill in.
7. **Dependencies:** use exactly the baseline versions in §4 for the phases that introduce them; no upgrades without approval. Add a package only if the current phase's roadmap entry names it, or you propose it first — name, reason, alternatives — and get approval.
8. **Small, reviewable diffs.** No drive-by refactors, renames or formatting churn outside the current phase.
9. **When this document is silent,** pick the option most consistent with §4–§7, record the decision and reasoning in `docs/PHASES.md`, and stop to ask only if the choice would be expensive to reverse.
10. Update `docs/PHASES.md` (status, decisions, open questions) and `docs/Restaurant.md` (whenever an open question in §9 is resolved) at the end of every phase.

---

## 3. Precedence

This document is the single specification. When it is silent on a decision: prefer whatever is most consistent with §4–§7; never assume an unconfirmed backend shape — get a real sample first; if a choice is cheap to reverse, decide and log it, otherwise ask.

---

## 4. Architecture

**Baseline dependencies** (add nothing earlier than the phase that needs it):
```yaml
environment:
  sdk: ^3.11.5

dependencies:
  flutter_riverpod: ^2.6.1
  get_it: ^8.0.0
  freezed_annotation: ^2.0.0
  json_annotation: ^4.0.0
  dio: ^5.4.0
  shared_preferences: ^2.3.4
  flutter_secure_storage: ^9.2.2
  google_fonts: ^6.2.1
  intl: ^0.19.0
  cupertino_icons: ^1.0.8
  google_maps_flutter: ^2.9.0            # from Phase 2
  geolocator: ^13.0.2                    # from Phase 2
  geocoding: ^3.0.0                      # from Phase 2
  socket_io_client: ^2.0.3+1             # from Phase 5
  firebase_core: ^2.24.0                 # from Phase 6
  firebase_messaging: ^14.6.0            # from Phase 6
  flutter_local_notifications: ^19.5.0   # from Phase 6

dev_dependencies:
  flutter_lints: ^5.0.0
  build_runner: ^2.0.0
  freezed: ^2.0.0
  json_serializable: ^6.0.0
```

**Folder layout:**
```
lib/
  main.dart
  firebase_options.dart              # developer-generated, Phase 6
  core/  animations/ constants/ di/ error/ network/ utils/
  data/
    api/          api_client.dart, api_endpoints.dart
    models/       freezed models + committed *.freezed.dart / *.g.dart
    repositories/ auth_, restaurant_, menu_, order_ repositories
    services/     auth_storage, socket, notification, fcm_token_manager, permission
  domain/         models/ use_cases/   (left empty until a rule needs them)
  ui/
    core/theme/   core/widgets/
    features/<feature>/{providers,views,widgets,models}
docs/             Restaurant.md, PHASES.md, api_samples/
```
Features: `splash, auth, setup, shell, orders, menu, restaurant, documents, earnings, settings`.

**Layers.** UI (widgets) → providers (Riverpod `StateNotifier`) → repositories → `ApiClient` / platform services. UI never touches Dio, sockets or storage directly. Repositories never import UI or Riverpod types; they return plain models or throw typed exceptions.

**Dependency injection.** `get_it` is the single service locator (`lib/core/di/locator.dart`, a global `locator = GetIt.instance`). One `setupLocator()`, called from `main()` before `runApp`, registers lazy singletons in order: `AuthStorageService` → `ApiClient` (built with that storage, token restored if present) → one repository per API area (`AuthRepository`, `RestaurantRepository`, `MenuRepository`, `OrderRepository`) → `SocketService`, `NotificationService`, `PermissionService`, `FcmTokenManager`. Providers read dependencies through `locator<T>()`; never instantiate a repository or service inline.

**State management.** Riverpod `StateNotifier` with immutable state classes only — no `AsyncNotifier`, no `riverpod_generator`. Every state class has an explicit `copyWith`, with a `clearX` boolean for any nullable field that must be settable back to null. Every notifier is exposed as `final xProvider = StateNotifierProvider<XNotifier, XState>((ref) => ...)`. Use `.autoDispose.family` for state scoped to one entity (an order's detail screen). Check `if (!mounted) return;` after every `await` before touching `state`. On logout, invalidate every provider holding user-scoped data.

**Networking.** One `ApiClient` wrapping one `Dio` instance (15s connect/receive timeouts). Two interceptors in order: a logging interceptor (see below), then an auth interceptor (`QueuedInterceptor`) that on a 401 refreshes the access token exactly once — concurrent 401s queue behind that single refresh — and retries with the new token, or calls an injected `onSessionExpired` callback if the refresh itself fails; the OTP and refresh endpoints are excluded from this logic. Every response follows one envelope, `{success, message, data, pagination?}`; a failed call throws a typed `ApiException` (status, message, status-string) or `NetworkException` — the UI never sees a raw `DioException`. File/photo uploads go through one shared `uploadFile(path, fieldName, file, extraFields)` helper.

**Data models.** `freezed` + `json_serializable`, one file per domain area under `data/models/`. Map the backend's `_id` to `id` via `@JsonKey`. Every field is nullable unless a confirmed real response proves it always present. Generated files are committed; regenerate with `dart run build_runner build --delete-conflicting-outputs` after any model change.

**Navigation.** Plain `Navigator` with one global `navigatorKey`, no routing package. Two custom `PageRouteBuilder`s: slide-up-and-fade for drilling into a detail screen, slide-in-from-the-right-and-fade for linear flows (auth, onboarding). A notification tap, from a cold start, background resume, or foreground tap, must push the same order-detail route through one shared function. One root-level listener on auth state resets the navigation stack to sign-in the moment a session ends.

**Storage & secrets.** Access/refresh tokens live only in `flutter_secure_storage`; everything else durable but non-sensitive (user id, phone, cached profile fields, the alert-mute flag) lives in `shared_preferences`; both are wrapped by one `AuthStorageService`. Platform secrets (Maps key, Firebase config) are never committed — check in a `.example` file with placeholders, gitignore the real one, document the exact setup steps in the README. The backend base URL is one compile-time constant via `String.fromEnvironment('API_BASE_URL', defaultValue: <dev URL>)`, never hardcoded a second time.

**Logging.** One facade, `AppLog` (`lib/core/utils/app_log.dart`), is the only place allowed to emit a log line — `print`/`debugPrint` are forbidden everywhere else. Five levels: `d, i, w, e, f`. Every line reads `[LEVEL] [TAG] [CONTEXT] → MESSAGE {payload}`, TAG from a fixed set (`API, AUTH, ORDER, MENU, STORE, DOCS, EARN, NAV, STATE, STORAGE, NOTIF, UI, GEO, APP, SOCKET`) — never free-form. Every `AppLog.e` in a catch block passes the exception and stack trace. No-op outside debug builds. Never log a token, refresh token or OTP code.

**Errors.** One `AppError.message(exception)` is the only place that turns an exception into user-facing text. The UI surfaces errors only through a small shared set of widgets — snackbar/toast, full-screen error state, empty state, loading state — never by rendering `error.toString()` or a raw status code.

**Realtime.** The socket is an accelerator on top of REST, never the source of truth — reconcile with a REST fetch on connect, reconnect, and app resume. One `SocketService` owns the connection (token-authenticated handshake, automatic reconnection, re-joining active rooms after reconnect, defensive payload normalisation) and exposes typed callbacks; nothing above it touches the socket client directly.

---

## 5. Design System

**Colour** — one `AppColors` class, no hex literal anywhere else:
- Primary `#F7941D`, primary-dark `#D87D0E` (depth/pressed), primary-light `#FFF5E9` (tinted fills)
- Success `#58CC02`, error `#E23744`, info `#1CB0F6`, warning `#F57C00`, rating `#FFC200`
- Text primary `#3C3C3C`, text secondary `#757575`, text hint `#BDBDBD`
- Background `#FAFAFA`, surface `#FFFFFF`, card border `#E5E5E5`, card fill `#F7F7F7`, divider `#E0E0E0`

**Spacing & radius** — one `AppSpacing` scale (4/8/12/16/20/24/32) and one `AppRadius` scale (8/12/16/20/24, plus a 999 "pill" reserved for filter chips only, never buttons). Screen edge padding is 20–24. No raw `EdgeInsets`/`BorderRadius.circular` numeric literal outside these two files.

**Typography** — `google_fonts` Nunito Sans; exactly seven named styles in `AppTextStyles`, 28pt display down to an 11pt eyebrow/badge size. No screen may write `TextStyle(fontSize: …)` directly.

**Icons** — Flutter's Material icon set only, `_outlined` variants preferred, every size from one shared named scale. No second icon package without approval.

**Motion** — one `AppDurations` scale (100/200/300/450/600 ms, each commented with when to use it) and one `AppCurves` set (ease-out for entrances, ease-in for exits, ease-in-out for state changes, an elastic curve reserved for small tactile feedback only, decelerate for large panel slides). Build reusable wrappers — fade-in, directional slide-in, scale-on-tap for every tappable card/button, a staggered entrance for API-loaded lists, a skeleton-to-content cross-fade — and use them everywhere instead of one-off `AnimationController`s. No standard, one-off interaction animates longer than 600 ms.

**Core widgets** — build once under `ui/core/widgets/`: a primary button (full-width, built-in loading state), a secondary/outlined button, a flat bordered card (1px border, no blurred shadow), a status/label badge, a pill filter chip, a consistent app bar, a bottom-sheet layout with a drag handle, a confirm dialog, a snackbar/toast, and the loading/empty/error state widgets above.

**Visual language** — light background; flat white cards with a thin border, not drop shadows; outlined inputs with floating labels and a `*` for required fields; pill choice chips; tinted panels for grouped secondary info; switch-style toggle rows; one full-width primary action pinned to the bottom of a form screen.

**Status colours** — `placed` = warning, `confirmed`/`preparing` = info, `ready`/`delivered` = success, `picked_up`/`on_the_way` = primary, `rejected`/`cancelled` = error. Apply this mapping everywhere a status shows.

---

## 6. Backend API Contract

*(persist as `docs/Restaurant.md` in Phase 0; correct it as facts are confirmed)*

**General.** Envelope: success → `{success: true, message, data, pagination?}`; failure → `{success: false, status: "fail", message}`. Ids are Mongo `_id` strings. Media fields return paths relative to the backend origin (`/uploads/...`) — resolve against the base URL's origin, not its `/api/v1` path. Timestamps are ISO-8601 UTC; render local time, `en_GB`, £.

Base URLs — development `https://supplier-prewar-corrosive.ngrok-free.dev/api/v1` (an ngrok tunnel; confirm it is still live before each phase, these rotate); production `https://api.mktours.co.uk/food/api/v1` (unconfirmed, verify before release). The socket server is the same origin without `/api/v1`.

**Auth**
- `POST /auth/request-otp` `{phone: E.164, role}` — confirm the correct `role` for a restaurant owner (§9, P1). Dev mode returns a fixed 6-digit code in `data.code`.
- `POST /auth/verify-otp` `{phone, code}` → `data: {user: {_id, phone, name?, role, isVerified, isNewUser}, accessToken, refreshToken}`. `403` = suspended account.
- `POST /auth/refresh-token` `{refreshToken}` → a new `accessToken` (refresh token may or may not rotate) — parse defensively, the pair may sit at the top level or nested under `data`. Refresh tokens last ~30 days, access tokens ~1 day.
- `POST /auth/logout` · `GET /users/me` · `PATCH /users/me` · `PATCH /users/me/fcm-token {fcmToken}`

**Restaurant**
- `GET /restaurants/my-restaurant` — `404` means this owner has no restaurant yet; that's the trigger into registration, not an error state.
- `POST /restaurants` `{name, description, cuisineType: [string], phone, email, address: {street, city, postcode, country}, longitude, latitude, minimumOrder, deliveryFee, preparationTime, operatingHours: {monday…sunday: {isOpen, open: "HH:mm", close: "HH:mm"}}}`
- `PATCH /restaurants/:id` — partial update (confirm whether delivery fee and coordinates are accepted here too — §9, P8; they are only proven to work at creation)
- `PATCH /restaurants/:id/status` — `{isOpen}` or `{isBusy}`
- `POST /restaurants/:id/image` — multipart, one field per call: `logo` or `coverImage`, never both together
- `GET /restaurants/:id/orders?page&limit&status`
- `GET /restaurants/:id/earnings` — shape unconfirmed (§9, P9); do not model until a real sample is captured
- `POST /restaurants/documents` — multipart `document` (pdf/jpg/png), `type`, optional `registrationNumber`, `hygieneRating` (0–5), `expiryDate`
- `GET /restaurants/my-documents` → `[{_id, type, status, registrationNumber?, expiryDate?, hygieneRating?}]`
- Restaurant fields: `_id, name, description, cuisineType[], phone, email, address, location (GeoJSON Point [lng,lat]), minimumOrder, deliveryFee, preparationTime, operatingHours, status (pending|approved|rejected — tolerate others), isOpen, isBusy, averageRating, totalRatings, logo, coverImage`.
- Onboarding requires five document types: `food_business_registration`, `fhrs_certificate`, `public_liability_insurance`, `proof_of_address`, `owner_id`. Three more can be added later: `haccp_certificate`, `bank_details_proof`, `vat_certificate`. Document status: `pending | approved | rejected | verified`.

**Menu**
- `GET /menu/restaurants/:restaurantId/menu` → categories with nested items. Parse defensively: the items array may be keyed `items`, `menuItems` or `products`; the categories array may be the top-level `data`, or nested under `data.data`/`data.categories`.
- `POST /menu/restaurants/:restaurantId/categories` `{name, description, sortOrder}` · `PATCH /menu/categories/:id` · `DELETE /menu/categories/:id` (also deletes every item inside — say so in the confirmation dialog)
- `POST /menu/categories/:categoryId/items` `{name, description, price, isAvailable, sortOrder}` · `PATCH /menu/menu-items/:id` · `DELETE /menu/menu-items/:id`
- `PATCH /menu/menu-items/:id/availability` — toggle, no body
- `POST /menu/menu-items/:id/image` — multipart `image` (jpg/jpeg/png/webp)

**Orders** (owner actions are all `PATCH`, no body except pickup verification)
- `/orders/:id/confirm` (accept; the backend then searches for a driver) · `/reject` (confirm whether it takes a reason — §9, P4) · `/preparing` · `/ready` · `/verify-pickup` `{code: "four digits"}`
- Status machine: `placed → confirmed → preparing → ready → picked_up → on_the_way → delivered`, with two terminal branches: `rejected` (owner only, from `placed`) and `cancelled` (customer or admin). An illegal transition returns `400` with a message like `Cannot transition from 'x' to 'y'.` — always surface that exact message.
- Order fields for the owner: `_id, orderNumber, status, createdAt, total (or totalAmount — read both), items: [{name (or menuItem.name), price, quantity}], customer: {name, phone}, paymentMethod (card|cash), driver / driverAssigned, deliveryAddress (a fullAddress string and/or street/city/postcode), specialInstructions`.
- Before Phase 4: capture a real sample of the orders-list response; confirm the exact pickup-verification flow and whether a single-order GET-by-id exists for an owner (§9, P4).

**Realtime (Socket.IO)**
- Handshake authenticates with the access token, both as `auth: {token}` and an `Authorization` header; websocket transport, reconnection enabled.
- The server auto-joins every socket to a personal room, `user:<userId>` — no client action needed.
- The app must join/leave a restaurant-scoped room around the connection lifecycle so the server knows which restaurant's orders to push here — confirm the exact event name and payload (§9, P5).
- Inbound events: `order:new` (full order object), `order:status-update` `{orderId, status}`, `order:assigned` `{orderId, driver}`. Normalise every payload defensively — it may arrive as a `Map` or as a single-item `List`.
- For an order-detail screen, emit `order:join`/`order:leave` with the `orderId` around that screen's lifecycle.

**Push (FCM)** — payload carries a `type` field; confirm the exact values used for a restaurant owner (§9, P6). Expect at minimum a new-order push, an order-cancelled push, a restaurant-approved push, a restaurant-rejected push and an account-suspended push, each carrying enough data (`orderId`/`orderNumber`, or nothing) to deep-link or refresh the right screen.

**Defaults** to pre-fill on registration: city "Milton Keynes", country "UK", preparation time 30 min, minimum order 0, delivery fee 0, hours Monday–Saturday 09:00–22:00, Sunday closed. Currency always £, dates always `en_GB` — centralise both in one formatting utility, never inline.

---

## 7. Product Rules

- Orders is the primary tab and the default screen for an approved restaurant after sign-in. Newly `placed` orders sort first and must visually stand out.
- Accepting is one tap; rejecting always asks for confirmation. Disable the relevant action the instant a request is in flight. On a `400` transition error, refetch that order — its state changed underneath the app.
- Always show a placed order's special instructions, the customer's phone with tap-to-call, and whether a driver is assigned.
- The realtime connection state (connected/offline) is always visible on the orders screen. The new-order alert sound has a persisted mute toggle.
- Offline: show the last known data behind a visible banner and disable actions — never let an action silently queue or appear to succeed.
- Design phone-first; nothing may visually break at ≥600dp even before tablet layouts are optimised.
- Pure logic — the order-status machine, formatters, payload normalisers — gets focused unit tests. No widget-test suite unless a phase explicitly asks for one.

---

## 8. Engineering Rules — Non-Negotiables

1. An order's initial status is `placed`, never `pending` — do not filter or count "new orders" by `pending`.
2. Any per-order socket-room subscription is owned by a lifecycle-aware provider (join on entering the detail screen, leave on disposal) — never by transient widget state, where a rebuild could duplicate the join or skip the leave.
3. Do not assume restaurant earnings reuse a delivery-fee ledger shape — model it strictly from a confirmed real response (§9, P9) before building Phase 9.
4. Paginated list metadata may be keyed `pagination` or `meta`, and an order total may be `total` or `totalAmount` — read both defensively until one canonical shape is confirmed, then simplify.
5. An order's delivery address may arrive as a single `fullAddress` string, as `street/city/postcode` parts, or both — prefer `fullAddress` when present, fall back to the parts.
6. `specialInstructions` must always be surfaced in the order-detail UI — never silently dropped.
7. Confirm the exact pickup-verification contract with the backend before Phase 4 implements it (§9, P4) — do not guess between a plain status change and a 4-digit code check.
8. Confirm which fields the profile-update endpoint actually accepts before adding delivery-fee or coordinate inputs to the post-onboarding edit screen (§9, P8).
9. Compliance-document upload has two distinct flows — a lightweight onboarding variant (file + type only) and a fuller one (file + type + registration number + hygiene rating + expiry date) — implement both, don't merge them.
10. A token-refresh response may return the new tokens at the top level or nested under `data` — parse defensively for both.
11. New-order alerts need a real bundled short audio asset plus a haptic fallback — never synthesise a tone at runtime as a stand-in for a proper notification sound.

---

## 9. Open Questions — resolve before the phase shown, never guess

- **P1:** the correct `role` value when a restaurant owner requests/verifies an OTP; whether the dev-mode OTP is still a fixed code.
- **P2:** does `POST /restaurants` return the created restaurant directly under `data`? Is `address.country` accepted?
- **P4:** a real sample of the orders-list response; the exact pickup-verification flow; whether `reject` accepts a reason; whether an owner can `GET` a single order by id.
- **P5:** the exact payload shapes for `order:new` and `order:assigned`; the restaurant-room join/leave event name and payload.
- **P6:** the exact `type` values and payload keys for restaurant-relevant push notifications; Firebase project registration for this app's application id.
- **P8:** which fields `PATCH /restaurants/:id` actually accepts (specifically delivery fee and coordinates).
- **P9:** the definition and exact response shape of restaurant earnings.

---

## 10. Definition of Done (every phase)

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze                    # zero issues
flutter test                       # any pure-logic tests added this phase
grep -rn "fontSize:" lib/ | grep -v app_text_styles.dart
grep -rnE "\bprint\(|debugPrint\(" lib/
grep -rn "Color(0x" lib/ | grep -v "ui/core/theme"
grep -rn "Duration(milliseconds" lib/ | grep -v "core/animations"
```
All greps return nothing (document any exception in `AGENTS.md`). No feature code outside the current phase's scope. Generated files committed. Manual verification steps written for the developer (≤10, runnable on an Android device against the development backend).

---

## 11. Roadmap (each phase is a separate developer prompt — never work ahead)

**Phase 0 — Foundation & Design System.** Create the project, the baseline `pubspec.yaml` (only what this phase uses), `analysis_options.yaml`, the folder skeleton from §4, a README documenting how to supply the Maps key and Firebase config, an `AGENTS.md` capturing §4/§5/§10, `docs/Restaurant.md` (a living copy of §6) and `docs/PHASES.md`. Build the motion utilities, `AppLog`, the media-URL resolver, `AppError`, `AppConfig`, `AppFormat`, and every design-system file and core widget from §5. Splash screen only, no networking.
*Done when:* `flutter analyze` and every §10 grep are clean; the app boots to splash on Android; every token in §5 exists as a named constant, nowhere as a literal.

**Phase 1 — Auth & Session.** `ApiEndpoints`, `ApiClient` (+ `uploadFile`), both interceptors, `AuthStorageService`, the `ApiResponse`/`PaginationMeta`/`User`/`AuthData`/OTP models, `AuthRepository`, `AuthNotifier` (restores a session on cold start; wires `onSessionExpired`), the root auth listener. Welcome screen → phone entry with a country-code selector → 6-digit OTP with a 60s resend timer (dev-mode code shown only in debug builds) → a placeholder "signed in" screen with working logout.
*Done when:* OTP sign-in works against the dev backend; a session survives a restart; one 401 triggers exactly one refresh-and-retry; a failed refresh returns to sign-in; logout clears both storages.

**Phase 2 — Restaurant Registration & Compliance Documents.** After sign-in, `GET /restaurants/my-restaurant`; `404` leads into a four-step wizard (basic info → address & location → pricing & timing → review) ending in `POST /restaurants` with default hours pre-filled. The location step supports current-position and address geocoding, with a map preview and a way to fine-tune the pin before saving. Then a five-document upload screen that resumes correctly if the owner leaves and returns, then a placeholder home screen. New: `Restaurant`, `DayHours`, `Document` models, `RestaurantRepository`. Propose for approval: `image_picker`, `file_picker`.
*Done when:* a new owner can register and upload all five documents; an existing owner skips straight past setup.

**Phase 3 — App Shell & Store Controls.** Bottom navigation (Orders, Menu, Earnings, More — non-Orders tabs are placeholders until their own phase), a header showing the restaurant name, Open/Closed and Busy toggles with an optimistic update that rolls back on failure, a status banner (pending approval / rejected / missing documents), one `RestaurantNotifier` as the single source of "my restaurant" data, pull-to-refresh, logout under "More".
*Done when:* toggles always reflect real server state and roll back correctly on failure; a cold start for an approved restaurant goes straight from splash to the shell.

**Phase 4 — Orders (REST only).** Status filter chips for every state in the machine, a paginated order list, pull-to-refresh, an order card, an order-detail screen (customer with tap-to-call, line items, totals, payment method, special instructions, driver info, status history if present), and the status-driven action sequence: accept/reject → mark preparing → mark ready → verify pickup code. A small, independently-tested `OrderStatus` helper. Foreground auto-refresh on an interval as a stopgap until Phase 5. First step: capture a real orders-list sample into `docs/api_samples/` and resolve P4.
*Done when:* an order can be driven from `placed` through a verified pickup entirely from the app; illegal transitions show the backend's own message.

**Phase 5 — Realtime & Alerts.** A `SocketService` (token handshake, reconnection, room re-join on reconnect, defensive payload normalisation) plus the restaurant-room join/leave from §6; merge `order:new`/`order:status-update`/`order:assigned` into orders state; reconcile via REST on connect, reconnect and resume; a persistent Live/Offline indicator; an in-app new-order alert (banner + haptic + bundled sound) with a persisted mute switch; the order-detail room join/leave via an `autoDispose.family` provider. Propose for approval: an audio-playback package, a wake-lock package.
*Done when:* an order placed elsewhere appears with an alert within a couple of seconds; going offline then online recovers missed orders.

**Phase 6 — Push Notifications.** Firebase init (developer supplies config), `FcmTokenManager` synced to `PATCH /users/me/fcm-token`, the permission flow, a high-importance Android channel with a custom sound for new orders, foreground display, correct background/terminated handling, tap-to-deep-link into the right order from any of the three states, restaurant-state refresh on approval/rejection/suspension pushes, token cleanup on logout.
*Done when:* a new-order push arrives backgrounded and fully closed; tapping either opens the right order; an approval push updates the banner without a manual refresh.

**Phase 7 — Menu Management.** The Menu tab parsed defensively per §6; category create/edit/delete (delete confirmation mentions items inside are removed too); item create/edit/delete; optimistic availability toggle; item photo upload; sort-order display; loading/empty/error states throughout. Propose for approval: an image-caching package.
*Done when:* full category/item CRUD works end to end against the dev backend.

**Phase 8 — Profile, Hours, Documents, Settings.** Restaurant profile editing (logo and cover photo as two separate uploads, core details, pricing/timing — resolve P8 before exposing delivery-fee/coordinate fields), a weekly opening-hours editor (switch + open/close pickers per day, `HH:mm`), a documents screen covering all eight types with expiry date, registration number and hygiene rating plus status badges, and a settings screen (alert-sound toggle, logout).
*Done when:* saved hours reload byte-for-byte identical; profile and documents screens are feature-complete against §6.

**Phase 9 — Earnings.** Resolve P9 first, then build summary cards, a ledger table and a simple trend chart. Propose for approval: a charting package.
*Done when:* figures reconcile with the backend for a real test restaurant.

**Phase 10 — Production-Readiness Audit & Release Prep.** Full audit (bugs, drift from §4–§7, security, dependency freshness, Android/iOS release configuration), a sweep of every offline/empty/error state, an accessibility and tablet-width sanity pass, unit tests for pure logic added so far, release configuration (signing placeholders, app icon, launch screen, versioning). Delivered as 10a, 10b, … — findings first, fixes only after approval.
*Done when:* the checklist in that phase's own prompt passes in full.

---

## 12. Phase Report Template

```
## Phase N report
- Scope delivered / deliberately not delivered
- Files added / changed (paths); edits to frozen phases called out
- Commands run and results (§10)
- Manual verification steps (≤10)
- Decisions made and why; deviations from this prompt
- Open questions / assumptions needing confirmation
- Docs updated (PHASES.md, Restaurant.md)
STOP — waiting for the next phase prompt.
```
