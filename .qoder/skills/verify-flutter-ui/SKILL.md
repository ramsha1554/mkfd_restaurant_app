---
name: verify-flutter-ui
description: Mandatory UI/UX verification gate for Flutter work in this repo. Use after any change that touches lib/ui/**, theme tokens, or widgets, and before reporting a UI task complete. Runs the app (web/Chrome or device), inspects the browser/simulator with screenshots, forces Flutter layout errors to surface, tests overflow across screen sizes plus largest text scale, and blocks completion on analyze errors, RenderFlex overflow, or unverified screens.
when_to_use: Any Flutter UI change, restyle, new screen, widget edit, or respond like "done"/"looks good" for UI.
---

# Verify Flutter UI

A UI task is **not complete** until it has been seen rendering, at multiple sizes, with zero overflow. Code that compiles is not proof. Anything you have not screenshotted is unverified — say so explicitly.

## Non-negotiables

1. Never report a UI change as done without at least one screenshot per changed screen.
2. Never report done while `flutter analyze` has any error in `lib/`.
3. Never report done while any of these appear in runtime logs: `A RenderFlex overflowed`, `RenderBox was not laid out`, `Unbounded height/width`, `setState() called after dispose`, `A Timer is still pending`.
4. Always test the **smallest realistic viewport** (360x640) and the **largest text scale** (2.0). Most overflow in this app hides there.
5. If you cannot run the app (no device, no Chrome, build fails), stop and report the blocker. Do not substitute "reviewed the code".

## Workflow

### 1. Static gate (fast, always)
```bash
cd <project root>
flutter analyze
bash .qoder/skills/verify-flutter-ui/scripts/layout_guard.sh
```
`layout_guard.sh` flags the patterns that cause overflow in this codebase: unbounded `Column`s inside scrollables, `Row`s with fixed-width children, missing `Flexible`/`Expanded` around long text, `MediaQuery`-less fixed heights, and hard-coded sizes. Fix every finding before running the app. Exit code is non-zero on findings.

### 2. Build and run
```bash
# Preferred: web in Chrome for quick visual iteration and screenshots
flutter run -d chrome --web-port=5000

# Or a device/emulator if the change depends on platform behavior
flutter devices
flutter run -d <device-id>
```
Wait for `Flutter run key commands.` before interacting.

### 3. Drive the app in the browser
Use a browser automation MCP tool if available; otherwise open Chrome DevTools on the running page and resize the device toolbar. For each changed screen, capture:

| Viewport | Meaning |
|---|---|
| 360x640 (DPR 2) | Small Android — primary overflow target |
| 390x844 | iPhone 14 baseline |
| 768x1024 | Tablet portrait |
| 1280x800 | Desktop/web window |

For each viewport also repeat **once** with text scaled to 2.0 (`chrome://settings/fonts` or DevTools "Emulate CSS media feature prefers-reduced-motion"-adjacent zoom at 200%). Text zoom is the #1 overflow trigger.

Screenshot each state you changed, including: loading, empty, error, keyboard-open on forms, bottom sheet open, long text / long names, and Arabic or accented characters if the field accepts free text.

### 4. Surface layout errors
Flutter paints a yellow/black overflow banner by default, but in release-style builds it can be missed. Force it to be loud:
- Run in debug (`flutter run` default) — overflow stripes are enabled.
- In the terminal, watch for `RenderFlex overflowed by <N> pixels on the <side>`.
- In the browser console, same message appears via `FlutterError`.
- Optionally override to a fatal error while testing:
  ```dart
  // temporary only, remove before commit
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('LAYOUT_ERROR: ${details.exceptionAsString()}');
  };
  ```

Grep the run output and browser console for the patterns in Non-negotiables #3. Any hit = not done.

### 5. UX checks (not just layout)
Walk each changed screen and confirm:
- Every tappable target is >= 48x48 logical px.
- Primary action is visible and reachable without scrolling on 360x640 (or is pinned per §5).
- Loading state shows (buttons disable, spinner appears) during async work; no double-submit.
- Error state uses `AppError.message`, never raw exception text (§4).
- Empty state exists where lists can be empty.
- Back/close affordances exist on every pushed route.
- No text is clipped mid-word without ellipsis; `TextOverflow.ellipsis` used on single-line labels.
- Colours come from `AppColors`, spacing from `AppSpacing`, radii from `AppRadius`, text from `AppTextStyles` (§5). No raw literals.

### 6. Record evidence
Write a short verdict block in your response:
```
UI VERIFICATION
- Screens: <list>
- Viewports: 360x640, 390x844, 768x1024, 1280x800, text-scale 2.0
- analyze: 0 issues
- overflow/layout errors: none
- screenshots: <paths>
- unverified: <anything you could not check, or "none">
```
If a viewport or state was skipped, list it under `unverified`. Do not claim success for it.

## Common fixes for overflow seen in this repo

- Wrap long labels: `Expanded(child: Text(..., maxLines: 1, overflow: TextOverflow.ellipsis))`.
- Rows of chips: use `Wrap`, not `Row`.
- **`Flexible`/`Expanded` in a shrink-wrapped `Row` crashes** with *"children have non-zero flex but incoming width constraints are unbounded"*. Any `Row` with `mainAxisSize: MainAxisSize.min`, or a `Row` inside a horizontal scrollable / unconstrained `Row`, must not contain flex children. Ellipsis alone (`maxLines` + `overflow`) is enough there.
- Fixed `SizedBox(height:)` around text: replace with intrinsic height or `Flexible`.
- `Column` inside `SingleChildScrollView` is fine; `Column` inside `Column` inside a fixed height is not — give the inner one `Expanded`/`Flexible`.
- Bottom sheets: `MediaQuery.viewInsetsOf(context).bottom` for keyboard; do not hard-code padding.
- Images: always give `aspectRatio` or `fit: BoxFit.contain` inside constrained parents.

## Resources

- `scripts/layout_guard.sh` — static overflow-risk scanner. Run it, fix every finding.
- `references/overflow-checklist.md` — the exact widget patterns Flutter overflows on and the fix for each.
- `references/viewport-matrix.md` — which screens to shoot at which size for this app's phases.
