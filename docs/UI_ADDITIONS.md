# UI_ADDITIONS.md

Components this app needs that `docs/UI_STANDARDS.md` does not define yet.

## Built

- **`AppBottomNav`** — `lib/ui/core/widgets/app_bottom_nav.dart`. Equal-width tabs in a surface bar (64 + safe area, 1px top `cardBorder`); 24 outlined icons, 12 labels (selected 700 `primaryText`, unselected 500 `textSecondary`), 48×48 minimum targets, optional primary count pill (11/700, 16 min width). Selected state is exposed to semantics.
- **`AppSwitchRow`** — `lib/ui/core/widgets/app_switch_row.dart`. Full-row switch (min height 48): title 14/700, caption 12 `bodySecondary`, 44×24 track with 20 thumb, on = `primary`, off = `cardBackground` with `borderStrong` outline, locked = disabled colours and no tap. Animated with `AppDurations.fast` / `AppCurves.state`, zero duration when reduce-motion is on.
- **`AppLiveBadge`** — `lib/ui/core/widgets/app_live_badge.dart`. Pill (8×4 padding, `rPill`), `successBg` fill, 1px `successText` at 20% alpha, 8px `success` dot pulsing over `AppDurations.pulse`, label 12/500 `successText`. Offline variant: `cardBackground`, `cardBorder`, dot and text `textHint`, label "Offline", no pulse. **Built, not shown until Phase 5** (live socket state).

## Not defined yet

- tabs — not defined
- offline banner — not defined
- required-field marker — not defined
- inline validation — not defined
- new-order alert overlay — not defined
