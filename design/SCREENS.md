# SCREENS.md — Implementation specs for the approved Stitch designs

Read this together with `docs/UI_STANDARDS.md` (visual source of truth) and `docs/Restaurant.md` (API contract).
Designs live in `design/stitch/<slug>/` as `screen.png` (look) and `code.html` (measurements and variant states).

**Rule zero:** build in Flutter with existing tokens and core widgets. Never convert or copy the HTML. Where Stitch used a value that is not a token, snap to the nearest token (tables below say which).

| Slug (folder after rename) | Original export folder | Phase | Variants inside the HTML |
|---|---|---|---|
| `orders` | `mk_foods_restaurant_orders_2` (`_1` is an identical duplicate; delete it) | 3 shell + 4 orders | offline state ("Simulate: Go Offline" button) |
| `order_detail` | `mk_foods_restaurant_order_detail_mk1042` | 4 orders | reject bottom sheet ("Preview Reject Sheet" button) |
| `new_order_alert` | `mk_foods_restaurant_new_order_alert` | 5 realtime | bottom sheet + compact top banner (Bottom Sheet / Top Banner switch) |
| `menu` | `mk_foods_restaurant_menu` | 7 menu | delete-category dialog ("Preview Dialog" button) |
| `earnings` | `mk_foods_restaurant_earnings` | 9 earnings | empty state ("Populated / Empty state" switch) |
| `DESIGN.md` | `warm_editorial_flat/DESIGN.md` | — | reference only; never authoritative |

---

## A. Global rules (apply to every screen)

### A1. Corrections that apply everywhere
| Stitch used | Use instead |
|---|---|
| Page background `#FFF8F4` (Stitch "surface") | `AppColors.background` `#FFFBF5` |
| Primary `#AC2A00` (Stitch "primary", e.g. Accept bar, active nav) | `AppColors.primary` `#D33E11`; accent text `primaryText` `#A92F0B` |
| Material 3 tonal tokens (`surface-container-*`, `tertiary` `#675850`, `outline-variant`, `on-surface-variant`) | `textSecondary` `#6A615A`, `cardBorder` `#EBDFD3`, `cardBackground` `#F4EFE9`, `divider` `#F0E6DB` |
| Font weight 600 | 700 for headings/labels, 500 for medium captions (allowed weights: 400/500/700) |
| Headline sizes 32/26/22 | `display` 28, `h1` 22, `h2` 18, `title` 16 |
| Header backdrop blur / header shadow (alert screen) | flat header, no blur, no shadow |
| Button heights 44 / 48 / 52 mixed | 52 for pinned bars, sheets and dialogs; 44 only for the two inline buttons inside order cards (`AppPrimaryButton(height: 44)`); FAB 48 |
| Sheet radius 16 | 20 (`showAppSheet`) |
| Switch off-track `#E0D9D3` (not a token) | open decision D3 |
| Money in plain figures | use tabular figures (`FontFeature.tabularFigures()`) on price styles so columns align |

### A2. Stitch inventions: do NOT build these
Profile avatar button in every header; "Preview …" / "Simulate …" / "Populated | Empty" switchers; "Kitchen Terminal MK-04"; "Accept & Fire" and "Fired to Kitchen!"; "ORDER TOTAL £28.40" bar (it contradicts the £28.50 subtotal); "First time patron"; "Station Note" card with photo; address thumbnail photo in the customer card; "Table / Deliver" label; "Table 4" and "Live POS" mock rows in the alert screen; "Direct BACS transfer"; "Transferred weekly to your registered UK bank account" (unverified claim); "Account #MK-4891"; "+£1.15 vs last mo" and "100% completed" (no data source); the menu screen's top bar titled "Orders" (a Stitch mistake; the bar says "Menu").

### A3. Shell: bottom navigation (new core widget `AppBottomNav`, Phase 3)
- Height 64 + bottom safe area; background `surface`; top border 1px `cardBorder`; no shadow, no indicator pill.
- 4 tabs, equal width, min touch 48×48: **Orders** (`receipt_long`), **Menu** (`restaurant_menu`), **Earnings** (`payments`), **More** (`more_horiz`); icon 24 outlined, label 12.
- Selected: icon and label `primaryText`, label weight 700. Unselected: `textSecondary`, weight 500.
- Orders tab shows a count badge for new orders (Stitch did not draw it; add as a small `primary` dot/count, to be confirmed in design review).

### A4. Shared widgets this design needs (log each in `docs/UI_ADDITIONS.md`)
`AppBottomNav`, `AppSwitchRow` (label + caption + switch 44×24, thumb 20, on = `primary`, locked state), `AppLiveBadge` (Live / Offline), `AppOfflineBanner`, `AppInfoBanner` (tinted inline banner with icon: special instructions, driver waiting; warning/info/error pairs, radius 8, padding 8–12), `AppSectionCard` (card with small uppercase eyebrow label), `AppBarChart` (CustomPaint, no new package), `NewOrderAlertSheet`. Existing widgets to reuse: `AppAppBar`, `AppCard`, `AppStatusBadge`, `AppFilterChip`, `AppPrimaryButton`, `AppOutlinedButton`, `showAppSheet`, `showAppConfirmDialog`, `AppSnackbar` (top toast), `AppIconBubble`, `AppEmptyState`, `AppErrorState`, `AppSkeleton`, `AppTextField`.

### A5. Status badge mapping
Use the single mapping from `app_colors.dart` (placed → warning, confirmed/preparing → info, ready/delivered → success, picked_up/on_the_way/arrived_at_restaurant → primary, driver_waiting → warning, pending_payment → info, rejected/cancelled/expired/failed → error). Stitch is inconsistent (Ready is warning on the Orders screen but success in the alert screen). See decision D1.

### A6. Required states for every screen
Loading (`AppSkeleton`), empty (`AppEmptyState`), error with retry (`AppErrorState`), offline (banner, disabled actions). Stitch only designed some of these; the rest follow the standard.

---

## B. Orders (`orders`)

**Purpose:** home tab; live order queue. **Entry:** app shell, tab 1. **Phase:** shell in 3, list and actions in 4.

### Layout, top to bottom (16 side padding, 12 gap between cards)
1. **AppAppBar** (title "Orders", `h2`). No avatar. In Stitch the title row has a `storefront` icon (primary, 28); optional.
2. **Restaurant header row:** restaurant name (`h2`, 18) + caption 12 secondary (Stitch shows "Milton Keynes · Central"; "Central" is invented, so use the real address/city or omit). Right: sound button 40×40 circle (surface, 1px `cardBorder`, icon 20, `volume_up`/`volume_off`) and `AppLiveBadge` (pill, padding 10×6, fill `successBg`, 1px border `successText`@20%, 8px pulsing dot `success`, text 12/500 `successText`).
3. **Store controls card** (`AppCard`, padding 14): two `AppSwitchRow`s side by side separated by a 1px `divider`. "Store open" / caption "Accepting orders" (off: "Paused / Closed"); "Busy mode" / caption "Standard prep" (on: Stitch says "+15m prep buffer"; confirm with the API, D5). Titles 14/700, captions 12 secondary.
4. **Filter chips** (horizontal scroll, gap 8): All, New, Preparing, Ready, Picked up, Delivered, Cancelled, each with a count when > 0 ("New (2)"). `AppFilterChip`: padding 12×8, label 13; selected = `primaryLight` fill, `primaryText`, 700; unselected = `cardBackground`, `textSecondary`, 500; no border.
5. **Order cards** (`AppCard` padding 16, internal gap 12). Structure:
   - Header: `#MK1042` (Bricolage 16/700) + "3m ago" (12 secondary); right: `AppStatusBadge` (uppercase 11/700).
   - Customer first name + initial, 14/700. Items summary, 14, e.g. "2× Chicken Tikka Masala, 1× Garlic Naan" (truncate after ~3 lines).
   - Optional `AppInfoBanner` (warning): `stylus_note` 16 + "Special instructions: …" 12/500. Show whenever the order has instructions.
   - 1px `divider`, then row: label "SUBTOTAL" (12, uppercase, letter-spaced, secondary) + value 16/700.
   - Actions by status:
     - **new:** card border 1.5px `primary`; `Accept` (primary, height 44, `check_circle` 18, flex) + `Reject` (outlined, height 44, padding 16).
     - **preparing:** `Mark as ready` (primary, full width, height 44, `room_service`).
     - **ready:** `AppInfoBanner` (warning) "Driver is waiting · Daniel" with `two_wheeler` icon and a 32px round call button; then `Verify pickup code` (outlined, full width, height 44, `pin` icon). Banner only when the driver has arrived (`driver:arrived-at-restaurant` / `arrived_at_restaurant`, `driver_waiting`).
     - **delivered / cancelled / others:** no buttons. Footer row reads "PAYOUT TOTAL" with a `check_small` 16 `success` icon and the payout amount (use `restaurantPayout`, not the subtotal). Drop Stitch's 95% opacity.
6. **Footer:** `sync` icon 14 + "Last updated just now" (12 secondary), centred, 24 bottom padding.
7. `AppBottomNav` (A3).

### Offline variant
- `AppOfflineBanner` under the header: fill `warningBg`, 1px `warningText`@30%, radius 12, padding 12, `cloud_off` 20; title "You're offline" (`sectionLabel`), body "Showing last known orders. New actions are locked until connection restores." (12).
- `AppLiveBadge` turns grey: fill `cardBackground`, 1px `cardBorder`, dot and text `textHint`, label "Offline", no pulse.
- All card buttons disabled (fill `cardBackground`, text `textSecondary`, border `cardBorder`); Store open and Busy mode locked. The sound toggle still works.
- Stitch's "Simulate" button is a preview control; the real trigger is connectivity + socket state.

### Data (confirm names in `docs/Restaurant.md`)
Order id/number, status, created time, customer name, items (name, quantity, per-item note), special instructions, food subtotal, restaurant payout, driver name/phone/arrival, store open and busy flags. Filter counts come from the same list, not separate calls.

---

## C. Order detail (`order_detail`)

**Purpose:** one order in full. **Entry:** tap an order card. **Phase:** 4. No bottom nav; back arrow.

### Layout (scrolling, 16 padding, 12 gaps, bottom padding clears the pinned bar)
1. **AppAppBar:** back, title "#MK1042" (`h2`), `AppStatusBadge` right.
2. **Header card:** `schedule` icon + "Placed 3m ago · 4 Nov · 2:15 PM"; right badge "Card" (info pair), only if the API returns the payment method.
3. **Customer card** (`AppSectionCard`, eyebrow "CUSTOMER DETAILS"): name (`title`), phone 12 secondary, round 48 call button (`cardBackground` fill, `call` icon, `primaryText`); address row with `location_on` 16 `primary`, full address, up to 2 lines. No photo.
4. **Special instructions panel** (always shown when present): `AppInfoBanner` warning variant, larger: padding 16, icon bubble 40 (white-ish on `warningBg`), bold label "Special instructions" and the text in quotes. Must stay visually prominent.
5. **Items card:** title "Order items (4)" (`h2`). Rows: quantity ("2×", `primaryText`, 16/700) + name (16/700) + price right (16/700, tabular); optional italic note under the name ("Extra spicy", 12 secondary, small flame icon); rows separated by 1px `divider`.
6. **Earnings breakdown card:** title "Earnings breakdown" (`h2`), caption "Restaurant payout" right. Rows: "Food subtotal" (14) / amount; "Commission (15%)" / "−£4.28" in `errorText`; then payout panel (`cardBackground` fill, radius 12, padding 12): "Your payout" (14/700) and amount in Bricolage ~28/700 `primaryText`. Footnote "Delivery and customer fees are not included in your payout." (12 secondary). Use `commissionAmount` and `restaurantPayout` from the API; never recompute. Percentage label from the API if present.
7. **Driver card:** info pair, `AppIconBubble.row` with `hourglass_empty`, title "No driver assigned yet" (`info` text, 14/700), caption "A driver is searched after you accept." Once assigned: name, phone, call button, and a banner when the driver is waiting.
8. **Pinned bottom bar:** `surface`, 1px top `cardBorder`, padding 16, safe-area aware. `Reject` (`AppOutlinedButton`, ~35% width, `close` icon) + `Accept order` (`AppPrimaryButton`, ~65% width, `check_circle`), both height 52. Stitch drew Reject as a soft grey fill; use the standard outlined button (D2). Drop "ORDER TOTAL" and "Accept & Fire".
9. Status-aware bar: new → Reject/Accept; preparing → `Mark as ready`; ready → `Verify pickup code`; later states → no bar.

### Reject sheet (variant, `order_reject_sheet`)
`showAppSheet` over a 55% scrim: title "Reject this order?" (`h2`, Stitch used 22), body "Choose a reason. The customer will be notified immediately." (14 secondary); wrap of reason chips (`AppFilterChip`, height 36: Too busy, Item unavailable, Closing soon, Other; single select); label "Add details (optional)" + `AppTextField` (height 52, standard border; Stitch drew it borderless; placeholder "e.g., Kitchen at capacity or out of ingredients", **empty by default**, Stitch's prefilled text is demo data); destructive `Reject order` (fill `error`, text `onError`, `do_not_disturb_on` icon, height 52) then text button "Keep order & return". Spinner state: "Rejecting…". **API rule:** a reason is required; send the selected chip (plus details appended) as `reason`. Disable the button until a chip is chosen.

---

## D. New-order alert (`new_order_alert`)

**Purpose:** interrupt the owner when a new order arrives. **Entry:** socket `new order` event or FCM tap. **Phase:** 5 (needs the realtime layer). Shown over any screen. The screenshot is a broken render; implement from this spec and the HTML.

### Variant 1: bottom sheet (default)
Scrim `scrim` token (55%). Sheet: `surface`, top radius 20, 1px `cardBorder` top/side border, padding 16, max height ~65% of the screen, scrollable, drag handle 40×4 (`borderStrong`).
1. **Icon bubble:** 64px circle `primaryLight` with `notifications_active` 28 `primary`, a 80px halo ring behind it (pulse animation; static under reduce-motion).
2. Title "New order!" (`display` 28), caption "#MK1042 · just now" (14 secondary).
3. **Summary card** (`AppCard` padding 14): "3 items · Aisha K." (15/700) + type label right ("Delivery"); first 2 items (14), then "+1 more (Pilau Rice)" (12 secondary); divider; row "Your payout" / amount (`priceLarge`, `primary`).
4. `AppInfoBanner` warning: `priority_high` 18 + "Special instructions: …" (only when present).
5. Buttons stacked, gap 8: `Accept order` (primary 52, `check`), `View details` (outlined 52, `receipt_long`), `Reject` (text button, `errorText`). Reject opens the reject sheet.
6. Sound row: `volume_up` 16 + "Sound alert on · Tap to mute".
Behaviour: sound plays while visible; Accept calls the API and closes; View details opens `order_detail`; multiple orders queue (show "+N more new orders").

### Variant 2: compact banner (`new_order_banner`)
Top toast style: white card, 1px `cardBorder`, radius 20, padding 10 (left 14, right 12), 40px `primaryLight` circle with the bell, text "New order #MK1042 · £24.22", `View` action. Appears when the owner is on another tab; auto-dismiss rules follow `AppSnackbar` (swipe up to dismiss). Use `AppSnackbar`'s overlay machinery with a custom action.

---

## E. Menu (`menu`)

**Purpose:** manage categories and items. **Entry:** tab 2. **Phase:** 7.

### Layout
1. **AppAppBar** titled **"Menu"** (not "Orders"). The big "Menu" heading plus "MK Central" caption in Stitch duplicates the bar; keep one heading (D6). Right/below: `Add category` small outlined button (height 40, `add` 18). Drop the "Preview Dialog" button.
2. **Category chips** (scroll): All, Starters, Mains…; selected chip may show a 6px `primary` dot before the label (`AppFilterChip` icon slot).
3. **Category header:** name (`h1`/`h2`), caption "4 items" (12 secondary), right `edit` and `more_vert` icons (24, touch 48). Overflow menu: Rename, Delete.
4. **Item tile** (`AppCard` padding 12): 72×72 image (radius 8, cached network image with placeholder/error); middle: name (`cardTitle` 16/700), description (2 lines, 12 secondary), price (`priceAccent`, `primary`, 14/700); right: switch 44×24 + caption "Available" (12). 
5. **Sold-out item:** image dimmed/greyscale with a `block` icon overlay; name followed by a "SOLD OUT" pill (`cardBackground` fill, 1px `borderStrong`, 11/700, radius 8); switch off, caption "Unavailable". The API field for availability is `isAvailable`-style; confirm in `docs/Restaurant.md`.
6. **FAB:** extended, `+ Add item`, height 48, fill `primary`, `onPrimary` label, radius 12, no shadow, positioned 16 from the right and above the bottom nav (Stitch uses a 1px darker border; skip).
7. `AppBottomNav`, Menu selected.

### Delete category dialog (variant, `menu_delete_dialog`)
`showAppConfirmDialog`-style, destructive: radius 16, padding 20, 1px `cardBorder`; 40px circle `errorBg` with `delete_forever` 22 `errorText`; title "Delete Mains?" (`h2`, Stitch 22); body "This also deletes the 4 items inside it. This can't be undone." (14 secondary); actions `Cancel` (outlined, height 44) and `Delete` (fill `error`, height 44). **Check the API:** only say "also deletes the items" if the backend really cascades (D4).

### Data
Categories (id, name, order), items (id, name, description, price, image, available, category). Item create/edit form is not designed yet (Phase 7 prerequisite).

---

## F. Earnings (`earnings`)

**Purpose:** payout totals and history. **Entry:** tab 3. **Phase:** 9.

### Layout
1. **AppAppBar** "Earnings". Stitch also shows a `notifications` icon: omit unless there is a notifications screen.
2. **Total card** (`AppCard`, padding 16): label "Total earnings" (14 secondary); amount (Bricolage, `display` 28, tabular); divider; `info` 16 icon + "Net balance after 15% platform commission" (12 secondary; take the percentage from the API). The "This month · Nov" pill only if the API supports a period filter; otherwise omit (D7).
3. **Two stat cards** side by side: "Avg. per order" and "Total orders" (value 20/700). Subtext lines like "+£1.15 vs last mo" and "100% completed" have no data source; omit.
4. **Chart card** "Last 7 days" (`h2`) with "Weekly payout: £412.80" right: `AppBarChart` (CustomPaint): 7 bars, width ≈ 26/320 of the width, radius 4, fill `primary`; dashed gridlines `divider`; solid baseline `cardBorder`; day labels 11 secondary (peak day label bold); peak callout pill above the tallest bar (`primaryLight` fill, 1px `cardBorder`, radius 8, 11/700 `primaryText`). Data: payout per day for the last 7 days. If the API has no daily series, derive it client-side from the earnings entries or drop the card (D7).
5. **Payout history:** header "Payout history" (`h2`) + caption "5 recent delivered orders". Rows (`AppCard` padding 14): left `#MK1030` (`cardTitle`) + date (12 secondary); right: "Order £22.00 · Comm. −£3.30" (12 secondary / `errorText`) and **`+£18.70`** (16/700 `successText`, tabular). Use `orderAmount`, `commissionAmount`, `restaurantPayout`. Pagination/"load more" is not designed; add a simple "Load more" text button at the bottom.
6. **Info note card:** `info` icon in a 32px `infoBg` circle + "Payouts appear here after orders are delivered." Drop the second sentence about weekly bank transfers until the business confirms it.
7. `AppBottomNav`, Earnings selected.

### Empty state (variant, `earnings_empty`)
`AppEmptyState`-based: 96px circle (`cardBackground`, 1px `cardBorder`) with a 56px `account_balance_wallet` icon at 30% opacity; title "No earnings yet" (`h2`); message "Your payouts will show up here after your first delivered order." (max width ~280, centred). Optional tip card below: `storefront` icon + "Kitchen ready?" + "Make sure menu items are switched on in the Menu tab to start receiving orders." (optional; D8).

### Data
`summary.totalEarnings`, entries/orders list with `orderAmount`, `commissionAmount`, `restaurantPayout`, order number and date. Endpoint: `/restaurants/my-restaurant/earnings` (the plan's `/restaurants/:id/earnings` is wrong).

---

## G. Open decisions (answer before the matching phase)

| # | Decision | Recommendation |
|---|---|---|
| D1 | Ready badge colour: warning (Orders screen) or success (alert screen, our mapping) | Keep success from the single mapping; the "driver is waiting" banner already carries the warning |
| D2 | Reject button on detail: Stitch soft grey fill vs standard outlined | Standard `AppOutlinedButton` |
| D3 | Switch off-track colour (`#E0D9D3` is not a token) | Add one token (for example `switchOff`) or use `cardBorder` with a 1px `borderStrong` outline; decide when building `AppSwitchRow` |
| D4 | Does deleting a category delete its items in the backend? | Check `docs/Restaurant.md`; word the dialog to match |
| D5 | What does Busy mode actually do (the "+15m prep buffer" caption)? | Confirm the API; if unknown, caption "Busy" / "Standard prep" only |
| D6 | Menu screen heading: app bar title vs large heading | App bar title "Menu" only |
| D7 | Period pill and 7-day chart: does the API give them? | Build only what the API supports; otherwise derive client-side or drop |
| D8 | Keep the "Kitchen ready?" tip in the earnings empty state? | Optional; low priority |

## H. Build order across phases
Phase 3: `AppBottomNav`, `AppLiveBadge`, `AppSwitchRow`, shell with placeholder tabs. Phase 4: order card + list, detail, reject sheet, offline banner. Phase 5: alert sheet, banner, sound. Phase 7: menu list, item tile, delete dialog (+ item form to be designed). Phase 9: earnings, `AppBarChart`, empty state. Design still missing: registration wizard, documents, More hub, item form, opening hours, profile, settings.
