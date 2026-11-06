# Overflow checklist — the patterns that actually break in Flutter

Each item: symptom → cause → fix. Check every one against the screen you changed.

## 1. RenderFlex overflowed by N pixels on the right
Cause: `Row` children exceed available width (long text, fixed-width widgets).
Fix: wrap the growing child in `Expanded` or `Flexible`; add `maxLines` + `TextOverflow.ellipsis` to `Text`; replace `Row` of many items with `Wrap`.

## 2. RenderFlex overflowed on the bottom
Cause: `Column` inside a bounded height (card, `SizedBox`, `Expanded`, bottom sheet) with content taller than the box.
Fix: make the outer widget scrollable, or give the inner `Column` `mainAxisSize: MainAxisSize.min` and put it inside `SingleChildScrollView`/`ListView`.

## 3. Vertical viewport was given unbounded height
Cause: `ListView`/`SingleChildScrollView(Axis.vertical)` inside `Column` without `Expanded`.
Fix: wrap in `Expanded` (inside a bounded parent) or `shrinkWrap: true` + `physics: NeverScrollableScrollPhysics` if nested.

## 4. Horizontal viewport was given unbounded width
Cause: horizontal `ListView` inside `Row` without `Expanded`.
Fix: wrap in `Expanded` / `SizedBox(width: …)`.

## 5. RenderBox was not laid out
Cause: reading a size before layout, or a child of an unbounded parent needs bounded constraints (e.g. `IntrinsicHeight` misuse, `Spacer` in unbounded).
Fix: constrain the parent; remove `Spacer` from unbounded columns; use `mainAxisAlignment` instead.

## 6. Text clipped at 200% text scale
Cause: fixed-height containers around text, `SizedBox(height:)` rows, `maxLines` too low with large fonts, `FittedBox` hiding the issue.
Fix: remove fixed heights around text; use `IntrinsicHeight`; allow more `maxLines`; never use `FittedBox` to hide overflow on body text.

## 7. Keyboard covers the submit button
Cause: bottom padding based on `MediaQuery.size`, or no `SingleChildScrollView`.
Fix: wrap form in `SingleChildScrollView` with `padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom + …)`; pin the CTA with `SafeArea`.

## 8. Bottom sheet doesn't grow with content
Cause: fixed `height` on the sheet content.
Fix: let it size to content up to `MediaQuery.of(context).size.height * 0.9`; make content scrollable inside.

## 9. Grid items overflow
Cause: `GridView` with fixed `childAspectRatio` that doesn't hold text at 2.0 scale.
Fix: prefer `SliverGridDelegateWithMaxCrossAxisExtent`; test at both extremes; avoid fixed aspect ratios around text.

## 10. Long names / addresses
Cause: real data is longer than mock data.
Fix: always test with a 60-character name and a full UK address; ellipsis on single-line, wrap on multi-line.

## 11. Safe area / notch
Cause: content under status bar or home indicator.
Fix: `SafeArea` on every top-level scaffold body; check on a device with a notch.

## 12. RTL / elevation / shadows vs §5
Cause: design drift.
Fix: flat cards with 1px `AppColors` border, no `BoxShadow` (except allowed tokens); spacing from `AppSpacing`; radius from `AppRadius`.
