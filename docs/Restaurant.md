# Backend API Contract — MK Foods Restaurant

Living copy of §6. Correct it as facts are confirmed with real responses saved under `docs/api_samples/` (keep nullable until proven).

---

## General

- Envelope: success → `{success: true, message, data, pagination?}`; failure → `{success: false, status: "fail", message}`.
- Ids are Mongo `_id` strings (map `_id` → `id` via `@JsonKey`).
- Media fields return paths relative to backend origin (`/uploads/...`) — resolve against base URL's origin, not its `/api/v1` path (see `MediaResolver`).
- Timestamps are ISO-8601 UTC; render local time, `en_GB`, £ via `AppFormat`.

Base URLs:
- Development: `https://supplier-prewar-corrosive.ngrok-free.dev/api/v1` (ngrok tunnel — confirm it is still live before each phase, these rotate)
- Production: `https://api.mktours.co.uk/food/api/v1` (unconfirmed — verify before release)
- Socket server is same origin without `/api/v1`

---

## Auth

- `POST /auth/request-otp` `{phone: E.164, role}` — developer confirmed 2026-09-22: `role = "customer"` (message "role is cutomer"), will validate against real sample saved to `docs/api_samples/` before Phase 1. Dev mode fixed code `000000` (updated from spec's placeholder).
- `POST /auth/verify-otp` `{phone, code}` → `data: {user: {_id, phone, name?, role, isVerified, isNewUser}, accessToken, refreshToken}`. `403` = suspended account.
- `POST /auth/refresh-token` `{refreshToken}` → new `accessToken` (refresh may or may not rotate) — parse defensively, pair may sit at top level or nested under `data`. Refresh ~30d, access ~1d.
- `POST /auth/logout` · `GET /users/me` · `PATCH /users/me` · `PATCH /users/me/fcm-token {fcmToken}`

---

## Restaurant

- `GET /restaurants/my-restaurant` — `404` means owner has no restaurant yet; trigger into registration, not an error state.
- `POST /restaurants` `{name, description, cuisineType: [string], phone, email, address: {street, city, postcode, country}, longitude, latitude, minimumOrder, deliveryFee, preparationTime, operatingHours: {monday…sunday: {isOpen, open: "HH:mm", close: "HH:mm"}}}`
- `PATCH /restaurants/:id` — partial update (confirm whether delivery fee and coordinates are accepted here too — §9 P8; only proven at creation)
- `PATCH /restaurants/:id/status` — `{isOpen}` or `{isBusy}`
- `POST /restaurants/:id/image` — multipart, one field per call: `logo` or `coverImage`, never both together
- `GET /restaurants/:id/orders?page&limit&status`
- `GET /restaurants/:id/earnings` — shape unconfirmed (§9 P9); do not model until real sample captured
- `POST /restaurants/documents` — multipart `document` (pdf/jpg/png), `type`, optional `registrationNumber`, `hygieneRating` (0–5), `expiryDate`
- `GET /restaurants/my-documents` → `[{_id, type, status, registrationNumber?, expiryDate?, hygieneRating?}]`
- Restaurant fields: `_id, name, description, cuisineType[], phone, email, address, location (GeoJSON Point [lng,lat]), minimumOrder, deliveryFee, preparationTime, operatingHours, status (pending|approved|rejected — tolerate others), isOpen, isBusy, averageRating, totalRatings, logo, coverImage`.
- Onboarding requires five document types: `food_business_registration`, `fhrs_certificate`, `public_liability_insurance`, `proof_of_address`, `owner_id`. Three more can be added later: `haccp_certificate`, `bank_details_proof`, `vat_certificate`. Document status: `pending | approved | rejected | verified`.

---

## Menu

- `GET /menu/restaurants/:restaurantId/menu` → categories with nested items. Parse defensively: items array may be keyed `items`, `menuItems` or `products`; categories array may be top-level `data`, or nested under `data.data`/`data.categories`.
- `POST /menu/restaurants/:restaurantId/categories` `{name, description, sortOrder}` · `PATCH /menu/categories/:id` · `DELETE /menu/categories/:id` (also deletes every item inside — say so in confirmation dialog)
- `POST /menu/categories/:categoryId/items` `{name, description, price, isAvailable, sortOrder}` · `PATCH /menu/menu-items/:id` · `DELETE /menu/menu-items/:id`
- `PATCH /menu/menu-items/:id/availability` — toggle, no body
- `POST /menu/menu-items/:id/image` — multipart `image` (jpg/jpeg/png/webp)

---

## Orders (owner actions are all PATCH, no body except reject and pickup verification)

- **Confirmed 2026-11-06** from `docs/api_samples/orders_list.json`: `GET /restaurants/:id/orders?page&limit&status` returns `{success, message, data: [order], pagination: {total, page, limit, pages, hasNextPage, hasPrevPage}}`; the sample used `limit=10` and `page=1`. `status` filtering and `limit` values above 10 still need confirmation.
- `/orders/:id/confirm` (accept; backend then searches for a driver) · `/orders/:id/reject` body `{reason: <non-empty string>}` · `/orders/:id/preparing` · `/orders/:id/ready` · `/orders/:id/verify-pickup` (Phase 4B; confirm whether the body key is `code` or `pickupCode`).
- Status machine: `placed → confirmed → preparing → ready → picked_up → on_the_way → delivered`, with `arrived_at_restaurant` between `ready` and `picked_up`, and terminal branches `rejected` (owner only, from `placed`) and `cancelled` (customer/admin). `pending_payment` can appear in history before `placed`. The sample also showed `cancelled` payment flows; tolerate `expired`/`failed` if returned. Illegal transitions return `400` with a message like `Cannot transition from 'x' to 'y'.` — always surface that exact message.
- Order fields (confirmed by sample unless noted): `_id, orderNumber, restaurant (id), status, createdAt, updatedAt, actualDeliveryTime?, estimatedDeliveryTime?, pickupCode, rejectionReason?, cancellationReason?, acceptanceExpiresAt?, paymentExpiresAt?, idempotencyKey?, specialInstructions, items: [{menuItem (id string), name, price, quantity, itemTotal}], customer: {_id, name, phone}, driver: {_id, name, phone} | null, deliveryAddress: {label?, fullAddress, location: {type, coordinates}}, subtotal, deliveryFee, driverFee, platformFee, total, paymentMethod (card|cash|payment_link — keep unknown raw), paymentStatus (pending|paid|failed), statusHistory: [{status, timestamp, note}]`.
- `commissionRate`, `commissionAmount`, `restaurantPayout`, `driverWaiting`, `driverArrived` were **not present** in the sample. The app derives payout client-side as `subtotal × 15%` (or `platformFee` when present) until the backend supplies explicit values. Confirm the real field names before showing payouts in production.
- Never display, log or persist `pickupCode` — it is only used by the Phase 4B pickup-verification flow.
- Single-order `GET /orders/:id` for owners is still unconfirmed; Phase 4A does not use it.

---

## Realtime (Socket.IO)

- Handshake authenticates with access token, both as `auth: {token}` and `Authorization` header; websocket transport, reconnection enabled.
- Server auto-joins every socket to personal room, `user:<userId>` — no client action needed.
- App must join/leave a restaurant-scoped room around connection lifecycle so server knows which restaurant's orders to push — confirm exact event name and payload (§9 P5).
- Inbound events: `order:new` (full order object), `order:status-update` `{orderId, status}`, `order:assigned` `{orderId, driver}`. Normalise every payload defensively — it may arrive as `Map` or single-item `List`.
- For order-detail screen, emit `order:join`/`order:leave` with `orderId` around that screen's lifecycle.

---

## Push (FCM)

Payload carries `type` field; confirm exact values used for restaurant owner (§9 P6). Expect at minimum: new-order push, order-cancelled push, restaurant-approved push, restaurant-rejected push and account-suspended push, each carrying enough data (`orderId`/`orderNumber`, or nothing) to deep-link or refresh right screen.

---

## Defaults to pre-fill on registration

City "Milton Keynes", country "UK", preparation time 30 min, minimum order 0, delivery fee 0, hours Monday–Saturday 09:00–22:00, Sunday closed. Currency always £, dates always `en_GB` — centralise both in one formatting utility, never inline.
