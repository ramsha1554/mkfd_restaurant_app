# UI_ADDITIONS.md

Components this app needs that `docs/UI_STANDARDS.md` does not define yet.

## Built

- **`AppBottomNav`** — `lib/ui/core/widgets/app_bottom_nav.dart`. Equal-width tabs in a surface bar (64 + safe area, 1px top `cardBorder`); 24 outlined icons, 12 labels (selected 700 `primaryText`, unselected 500 `textSecondary`), 48×48 minimum targets, optional primary count pill (11/700, 16 min width). Selected state is exposed to semantics.
- **`AppSwitchRow`** — `lib/ui/core/widgets/app_switch_row.dart`. Full-row switch (min height 48): title 14/700, caption 12 `bodySecondary`, 44×24 track with 20 thumb, on = `primary`, off = `cardBackground` with `borderStrong` outline, locked = disabled colours and no tap. Animated with `AppDurations.fast` / `AppCurves.state`, zero duration when reduce-motion is on.
- **`AppLiveBadge`** — `lib/ui/core/widgets/app_live_badge.dart`. Pill (8×4 padding, `rPill`), `successBg` fill, 1px `successText` at 20% alpha, 8px `success` dot pulsing over `AppDurations.pulse`, label 12/500 `successText`. Offline variant: `cardBackground`, `cardBorder`, dot and text `textHint`, label "Offline", no pulse. **Built, not shown until Phase 5** (live socket state).
- **`AppInfoBanner`** — `lib/ui/core/widgets/app_info_banner.dart`. Inline banner with warning/info/error/success tones, radius 8, 1px foreground tint, 8×12 padding, 16px icon, 12/500 text and optional trailing action. Used for stale-order and driver-waiting notices.
- **`AppOfflineBanner`** — `lib/ui/core/widgets/app_offline_banner.dart`. Warning-tinted banner (radius 12, 12 padding, `cloud_off` 20) with title "You're offline" and body "Showing last known orders. Actions are locked until the connection returns."
- **`AppPrimaryButton` destructive variant** — `lib/ui/core/widgets/primary_button.dart`. Adds a `destructive` flag that swaps the fill/text to the error palette for irreversible actions such as rejecting an order.
- **`AppSectionCard`** — `lib/ui/core/widgets/app_section_card.dart`. `AppCard` with an optional small uppercase eyebrow label (11/700 `textSecondary`, letter-spaced) above the content.
- **Pickup sheet** — `lib/ui/features/orders/widgets/pickup_sheet.dart`. `showAppSheet` title "Verify pickup code" (`h2`), 14 secondary body, centred 4-box `OtpCodeField(length: 4)`, primary "Verify pickup" disabled until four digits with loading, and a "Cancel" text button. Failure keeps the sheet open, clears the boxes and shows the backend message; success closes it and confirms.
- **Order detail screen** — `lib/ui/features/orders/views/order_detail_view.dart`. Order number app bar with status badge, header/customer/items/earnings/driver cards, prominent special-instructions and reason banners, acceptance countdown and a status-aware pinned action bar. Opened from any order card with no bottom nav.
- **4-length code field** — `lib/ui/features/auth/widgets/otp_code_field.dart`. `OtpCodeField` gained a `length` parameter (default 6); the OTP screen keeps six digits while pickup verification uses four.

## Not defined yet

- tabs — not defined
- required-field marker — not defined
- inline validation — not defined
- new-order alert overlay — not defined
