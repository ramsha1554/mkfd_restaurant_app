# MK Foods — UI Standards (reference)

Single source of truth for visual and interaction standards of this app. Every value below is an exact implementation value.
Section numbers are kept from the original audit, so some numbers are skipped.
`T/` = `ui/core/theme/`, `W/` = `ui/core/widgets/`, `A/` = `core/animations/` (source paths are for orientation only).
`NOT FOUND` = not defined; those items must be designed and added to `docs/UI_ADDITIONS.md`, never guessed.

---

## 1. Foundations

### 1.1 Colour tokens (`T/app_colors.dart`)

| Token | Hex | Line | Where used (observed) |
|---|---|---|---|
| primary | `#D33E11` | 6 | buttons, links, selected states, focus border, price accent, cart bar, ADD button, progress |
| primaryDark | `#A92F0B` | 7 | pressed button background (`app_button.dart:48`, `app_theme.dart:45`) |
| primaryLight | `#FFE9DE` | 8 | selected filter chip bg, linear progress track |
| onPrimary | `#FFFFFF` | 9 | text/icons on primary |
| primaryText | `#A92F0B` | 10 | accent text/icons, outlined button fg, selected nav, avatar initial |
| primaryBright | `#FF5722` | 11 | unused |
| secondary | `#FFB74D` | 12 | only in `ColorScheme.secondary` |
| onSecondary | `#1E1B18` | 13 | only in `ColorScheme` |
| accent / accentText / accentBg | `#0D9488` / `#0B5E57` / `#DDF5F1` | 14-16 | accent used once; text/bg unused |
| success | `#2E7D32` | 18 | delivered, paid, success toast |
| error | `#D81B3C` | 19 | cancelled, failed, input error border, destructive |
| info | `#2F80ED` | 20 | confirmed, refunded, info toast |
| warning | `#A66900` | 21 | pending payment, preparing, ready, min-order cart bar |
| rating | `#FFB400` | 22 | star icon |
| onError | `#FFFFFF` | 23 | text on error |
| successText / errorText / warningText / infoText | `#1B5E20` / `#A8112B` / `#6B4300` / `#1556A8` | 25-28 | badge/bubble foregrounds |
| successBg / errorBg / warningBg / infoBg | `#E6F4E7` / `#FDEAEE` / `#FFF4D6` / `#E8F1FD` | 30-33 | badge/bubble backgrounds |
| textPrimary | `#1E1B18` | 35 | body text, icons |
| textSecondary | `#6A615A` | 36 | secondary text, hint, inactive icons |
| textHint | `#9A9189` | 37 | 1 use |
| background | `#FFFBF5` | 39 | scaffold + app bar |
| surface | `#FFFFFF` | 40 | cards, inputs, sheets, dialogs, toasts |
| cardBorder | `#EBDFD3` | 41 | card/toast/snackbar border, skeleton base |
| cardBackground | `#F4EFE9` | 42 | disabled button bg, unselected chip bg, image placeholder |
| shadow | `#D9CCC0` | 43 | `BoxShadow` colour |
| borderStrong | `#8F867E` | 44 | input + outlined button border, unselected checkbox |
| divider | `#F0E6DB` | 46 | dividers, sheet handle |
| scrim | `#1E1B18` @ alpha `0x8C` (~55%) | 48 | modal/dialog barrier |
| darkBackground / darkSurface / darkBorder / onDark / onDarkMuted | `#1B1612` / `#26201B` / `#382F27` / `#FFF7F0` / `#D8CDC4` | 50-54 | **unused** |
| shimmerBase / shimmerHighlight | `#F5EFE6` / `#FEFDFB` | 56-57 | **unused** (skeleton uses cardBorder/surface) |
| promo / promoBg | `#E64A19` / `#FDECEF` | 59-60 | **unused** |
| dietVeg / dietNonVeg | `#1B8332` / `#8D2319` | 62-63 | **unused** |
| disabledControl | `#EADFD3` | 65 | disabled elevated button in theme only (`app_theme.dart:42`) |

Gradients: none in app UI except the skeleton shimmer `LinearGradient(cardBorder → surface → cardBorder)`, stops `0.35/0.5/0.65` (`W/app_skeleton.dart:68-76`).

**Opacity variants actually used** (all `withValues(alpha:)`; `withOpacity` count = 0):

| Base | Alpha | Purpose | Source |
|---|---|---|---|
| textPrimary | 0.05 | pressed highlight | `T/app_theme.dart:16` |
| primary | 0.2 | text selection | `T/app_theme.dart:108` |
| primary | 0.12 | avatar fill | `W/app_avatar.dart:30` |
| textSecondary | 0.3 | empty-state icon | `W/app_states.dart:35` |
| primaryLight | 0.5 | onboarding logo halo | `ui/features/auth/views/onboarding_screen.dart:59` |
| shadow | 0.2 | onboarding logo shadow | `ui/features/auth/views/onboarding_screen.dart:74` |

### 1.2 Status colour mapping

Order status (`ui/features/orders/utils/order_status.dart:65-92`, via `statusMeta`):

| Status | Label | Colour |
|---|---|---|
| delivered | Delivered | success |
| cancelled / rejected | Cancelled / Rejected | error |
| pending_payment | Awaiting Payment | warning |
| placed | Order Placed | success |
| confirmed | Confirmed | info |
| preparing | Preparing | warning |
| ready | Ready | warning |
| picked_up | Picked Up | primary |
| arrived_at_restaurant | Driver at restaurant | primary |
| on_the_way | On the Way | primary |
| default | raw status / `Unknown` | textSecondary |

Payment status (`order_status.dart:119-136`): paid→success, refunded→info, pending→warning, failed→error, other→textSecondary.

Orders list badge (`ui/features/orders/widgets/order_list_status_badge.dart:84-100`): `delivered` = solid success bg + onPrimary text; `cancelled/rejected` = solid error bg + onError text; **everything else** = "Live" with pulsing success dot, successText label, no background.

`AppStatusBadge` / `AppIconBubble` colour mapping (`W/app_badge.dart:15-24`, `W/app_icons.dart:57-66`): success→(successText on successBg), error→(errorText/errorBg), warning→(warningText/warningBg), info→(infoText/infoBg), primary/primaryDark→(primaryText on surface), else→(textSecondary on cardBackground).

Online/offline, document status, delivery-partner status: NOT FOUND in this app.

### 1.3 Typography

Loading: **bundled assets**, never fetched at runtime (`pubspec.yaml:57-67`). No `google_fonts` package.

| Family | Files | Weights declared |
|---|---|---|
| `DM Sans` (global default, `app_theme.dart:13`) | `DMSans-Regular/Medium/Bold.ttf` | 400 / 500 / 700 (`pubspec.yaml:59-65`) |
| `BricolageGrotesque` (display) | `BricolageGrotesque-Variable.ttf` | declared 700; code sets `FontVariation('wght', 700)` (`pubspec.yaml:66-68`) |

Display styles use `fontFamilyFallback: ['DM Sans']`. Constants: `AppFonts.heading='BricolageGrotesque'`, `AppFonts.body='DM Sans'` (`T/app_text_styles.dart:35,38`).

Named styles (`T/app_text_styles.dart`):

| Style | Font | Size | Weight | Colour | Height | Letter-spacing | Usage (count outside theme) | Line |
|---|---|---|---|---|---|---|---|---|
| display | Bricolage | 28 | 700 | textPrimary | 1.2 | -0.4 | onboarding headlines (9) | 44-53 |
| h1 | Bricolage | 22 | 700 | textPrimary | 1.25 | -0.7 | login titles (4) | 55-64 |
| h2 | Bricolage | 18 | 700 | textPrimary | 1.3 | -0.5 | app bar, sheet/dialog titles, empty/error titles (24) | 66-75 |
| cardTitle | DM Sans | 16 | 700 | textPrimary | 1.3 | -0.4 | list rows, toast title (13) | 80-86 |
| title | Bricolage | 16 | 700 | textPrimary | 1.3 | -0.1 | restaurant name (2) | 90-99 |
| body | DM Sans | 14 | 400 | textPrimary | 1.4 | -0.35 | body copy (69) | 101-107 |
| bodySecondary | DM Sans | 12 | 400 | textSecondary | 1.4 | -0.2 | secondary text (50) | 109-115 |
| caption | DM Sans | 12 | 500 | textSecondary | 1.3 | -0.2 | metadata, chip labels (38) | 117-123 |
| price | DM Sans | 14 | 700 | textPrimary | — | -0.35 | prices (3) | 125-130 |
| priceAccent | DM Sans | 14 | 700 | primary | — | -0.35 | (2) | 132-137 |
| eyebrow | DM Sans | 11 | 700 | textSecondary | — | -0.1 | (5) | 139-144 |
| badge | DM Sans | 11 | 700 | (set by caller) | — | -0.1 | badges, ADD (9) | 146-150 |
| sectionLabel | DM Sans | 12 | 700 | textPrimary | — | -0.2 | (4) | 152-157 |
| button | DM Sans | 16 | 700 | textPrimary | 1.2 | 0 | button labels (12) | 160-167 |
| priceLarge | DM Sans | 18 | 700 | textPrimary | 1.3 | 0 | bill total (2) | 170-177 |
| otpDigit | DM Sans | 22 | 700 | textPrimary | 1.25 | -0.7 | OTP digits (1) | 180-187 |

Type scale in code: 28 / 22 / 18 / 16 / 14 / 12 / 11. Only `h1/h2/display/title` use Bricolage. All other styles use DM Sans by theme default.

Inline `TextStyle(` outside the theme: **11 sites** (`grep`), almost all in `auth/views/phone_login_screen.dart`:

| Literal | Count | Examples |
|---|---|---|
| `fontSize: 14` | 3 | `phone_login_screen.dart:587`, `matched_dish_row.dart:72,97` |
| `fontSize: 11` | 3 | `phone_login_screen.dart:260`, `restaurant_detail_screen.dart:244,565` |
| `fontSize: 15` | 2 | `phone_login_screen.dart:496,671` |
| `fontSize: 12` | 2 | `phone_login_screen.dart:228`, `matched_dish_row.dart:84` |
| `fontSize: 10` | 2 | `phone_login_screen.dart:399`, `restaurant_detail_screen.dart:768` |
| `fontSize: 20` | 1 | `phone_login_screen.dart:541` (emoji flag) |
| `fontSize: 13` | 1 | `orders_screen.dart:283` ("Pay Now") |

Sizes 15, 13, 10, 20 are **not** in the declared scale.

### 1.4 Spacing scale (`T/app_spacing.dart:4-10`)

| xs | sm | md | lg | xl | xxl | xxxl |
|---|---|---|---|---|---|---|
| 4 | 8 | 12 | 16 | 20 | 24 | 32 |

Usage counts in `ui/`: sm 166, md 134, lg 97, xs 84, xxl 33, xl 27, xxxl 17.

Observed standards:

| Rule | Value | Source |
|---|---|---|
| Screen horizontal padding (lists, home) | `lg` 16 | `home_screen.dart:746,1008`, `orders_screen.dart:137` |
| Auth/onboarding horizontal padding | `xxl` 24 | `onboarding_screen.dart:30` |
| Card inner padding | `AppCard` lg 16; `AppCard.dense` md 12; order card md 12; menu tile md 12 | `W/app_card.dart:14,22`, `orders_screen.dart:191` |
| Gap between list cards | `md` 12 (bottom margin) | `orders_screen.dart:190`, `home_screen.dart:880` |
| Gap label → field | `sm` 8 | `checkout_screen.dart:831-851` |
| Sheet padding | L/R xxl 24, top md 12, bottom safe-area + lg 16 | `W/app_bottom_sheet.dart:36-41` |
| Dialog insets | h/v xxl 24; actions L16 T8 R16 B16 | `T/app_theme.dart:166-167` |
| Bottom bar padding | `lg` all | `checkout_screen.dart:745` |
| Min tap target | 48 (`AppScaleTap.minTapSize`) | `A/app_scale_tap.dart:17` |
| Card theme margin | h16 v6 (`sm - 2`) | `T/app_theme.dart:133` |

Avatar sizes: 16 / 30 / 56 (`T/app_avatar_sizes.dart`).

### 1.5 Radius scale (`T/app_spacing.dart:17-22`)

| sm | md | lg | xl | xxl | pill |
|---|---|---|---|---|---|
| 8 | 12 | 16 | 20 | 24 | 999 |

Usage: md 65, sm 25, pill 15, lg 9, xl 8, xxl 1.

| Element | Radius | Source |
|---|---|---|
| Buttons (primary, outlined, text) | md 12 | `W/app_button.dart:39,113`, `T/app_theme.dart:35,60,152` |
| Inputs | md 12 | `T/app_theme.dart:70-83` |
| Cards (`AppCard`, restaurant card, menu tile) | md 12 | `W/app_card.dart:27`, `restaurant_card.dart:41` |
| Order card | lg 16 | `orders_screen.dart:194` |
| Badges, ADD button, stepper | sm 8 | `W/app_badge.dart:36`, `restaurant_detail_screen.dart:850,876` |
| Filter chip, SOLD OUT | pill | `W/app_badge.dart:91`, `restaurant_detail_screen.dart:927` |
| Search bar | xxl 24 | `home_search_bar.dart:131` |
| Dialog | lg 16 | `T/app_theme.dart:162` |
| Bottom sheet (top corners) | xl 20 | `T/app_theme.dart:186`, `W/app_bottom_sheet.dart:96` |
| Toast / snackbar | xl 20 | `W/app_snackbar.dart:127`, `T/app_theme.dart:177` |
| Avatars, icon bubbles, checkbox | circle | `W/app_avatar.dart:31`, `W/app_icons.dart:75` |
| Menu item image | sm 8 | `restaurant_detail_screen.dart:713` |

### 1.6 Elevation, shadows, borders

| Item | Value | Source |
|---|---|---|
| Elevation | `0` everywhere (cards, buttons, app bar, dialog, sheet, snackbar, FAB). No non-zero `elevation:` in `ui/` | `T/app_theme.dart`, grep |
| App bar scrolled-under | `0`; with `enableTint`: 4 (6 if `strongTint`), tint colour primary | `W/app_app_bar.dart:39-41` |
| BoxShadow #1 (cart bar) | `shadow #D9CCC0`, blur 10, offset (0,4) | `cart_bottom_sheet.dart:63-69` |
| BoxShadow #2 (onboarding logo) | `shadow @0.2`, blur 16, offset (0,6) | `onboarding_screen.dart:72-78` |
| Card border | 1, cardBorder | `W/app_card.dart:28` |
| Input border | 1 borderStrong; focus 1.5 primary; error 1 error | `T/app_theme.dart:69-84` |
| Auth input border | 1.5 cardBorder | `auth_input_field.dart:44` |
| Outlined button border | 1.5 borderStrong | `T/app_theme.dart:56` |
| Badge border | 1, same as fg colour | `W/app_badge.dart:37` |
| Divider | thickness 1, divider colour | `T/app_theme.dart:189-192` |
| Sheet handle | 40×4, radius 2, divider colour | `W/app_bottom_sheet.dart:12-19` |
| Total row top border | 1.5 primary | `W/order_bill.dart:103` |
| Ripple | `NoSplash`; highlight `textPrimary@0.05` | `T/app_theme.dart:14-16` |

### 1.7 Iconography

| Item | Value | Source |
|---|---|---|
| Set | Material `Icons.*` (79 distinct), mostly `_outlined` variants for navigation/info; filled for star, check_circle, error | grep |
| Packages | `cupertino_icons ^1.0.8` (declared; no `CupertinoIcons` usage seen), `flutter_svg ^2.0.17` | `pubspec.yaml:14,19` |
| Size scale | 12, 14, 16, 18, 20, 24, 28, 32, 40, 48, 64 | `W/app_icons.dart:6-16` |
| Semantic sizes | `row` 24, `chevron` 16, `field` 20 | `W/app_icons.dart:18-22` |
| Default colour | textSecondary (inactive), textPrimary (app bar, rows), primary/primaryText (active) | `W/app_icons.dart:97`, `W/app_app_bar.dart:45-52` |
| Icon bubble | 64 default (icon 32); `.row`/`.badge` 44 (icon 20); circular, 1px border | `W/app_icons.dart:36,46,53` |
| Custom SVGs (24 files in `assets/icons/`) | order timeline glyphs tinted via `ColorFilter.mode(color, srcIn)`, 12px default | `order_details_screen.dart:543-585,977-981` |

### 1.8 Dark mode

Not supported. `AppColors` defines unused dark tokens (`darkBackground #1B1612`, `darkSurface #26201B`, `darkBorder #382F27`, `onDark #FFF7F0`, `onDarkMuted #D8CDC4`; `T/app_colors.dart:50-54`) but no theme consumes them.

### 1.9 Responsive rules

| Item | Finding | Source |
|---|---|---|
| Breakpoints | NOT FOUND | — |
| `LayoutBuilder` | auth screens (min-height scroll pattern), restaurant detail | `onboarding_screen.dart:23`, `restaurant_detail_screen.dart:373` |
| Text scaling | `MediaQuery.textScalerOf` used to size category strip and restaurant header | `menu_category_chips.dart:15-16` |
| Reduce motion | `MediaQuery.maybeDisableAnimationsOf` respected in scale-tap, skeleton, OTP, status badge, checkout | `A/app_scale_tap.dart:52` etc. |
| Safe area | `SafeArea` on auth screens, checkout bottom bar, cart bar (`top: false`), sheets add `padding.bottom` | `checkout_screen.dart:743`, `cart_bottom_sheet.dart:38` |
| Keyboard | `showAppSheet` pads by `viewInsets.bottom`; login `resizeToAvoidBottomInset: true` | `W/app_bottom_sheet.dart:102`, `phone_login_screen.dart:153` |
| OTP max width | 328 | `otp_code_field.dart:92` |
| Fixed price column | 90 wide, `FittedBox(scaleDown)` | `W/app_price_cell.dart:6` |

---

## 2. Motion

### 2.1 Durations & curves (`A/app_durations.dart`)

| Token | Value | Line |
|---|---|---|
| instant | 100ms | 4 |
| micro | 200ms | 5 |
| standard | 300ms | 6 |
| emphasis | 450ms | 7 |
| hero | 600ms | 8 |
| curve enter | `easeOutCubic` | 12 |
| curve exit | `easeInCubic` | 13 |
| curve inOut | `easeInOutCubic` | 14 |
| curve spring | `elasticOut` | 15 |
| curve panel | `decelerate` | 16 |

### 2.2 Reusable wrappers & transitions

| Item | Spec | Source |
|---|---|---|
| `AppFadeIn` | fade, default `standard`, `enter` curve, optional delay | `A/app_fade_in.dart` |
| `AppSlideIn` | fade+slide, default `up`, offset 0.18 (fraction), `standard`, `enter` | `A/app_slide_in.dart:19-20` |
| `AppStaggeredItem` | `AppSlideIn.up`, delay = `min(index,6) × 60ms` | `A/app_staggered_list.dart:9,16` (defined; **no usages found**) |
| `AppReveal` | `AnimatedSwitcher` standard, in `enter`, out `exit` | `A/app_reveal.dart` (no usages found) |
| `AppScaleTap` | scale 0.97 (default), forward `instant` 100ms, reverse `micro` 200ms, curve `inOut`, optional `pressedOpacity`, `minTapSize` 48, `Semantics(button)`; 25 usages | `A/app_scale_tap.dart` |
| `SlideUpPageRoute` | offset (0, 0.06) → 0, fade; in `emphasis` 450ms, out `standard` 300ms, slide curve `panel`, fade curve `enter` | `A/app_page_transitions.dart:4-22` |
| `SlideRightPageRoute` | offset (0.08, 0) → 0, fade; same durations/curves | `A/app_page_transitions.dart:24-41` |
| Default route | `MaterialPageRoute` (platform transition) for orders, checkout, profile, restaurant, addresses | `orders_screen.dart:145` etc. |
| Page transition usage | SlideRight: onboarding→login, login→OTP, OTP→profile setup. SlideUp: OTP/profile setup→Home, Home→Onboarding (logout) | grep |

### 2.3 Component motion

| Item | Spec | Source |
|---|---|---|
| Onboarding entrance | name `SlideIn.left` emphasis; logo `FadeIn` hero delay micro; headline `SlideIn.up` delay micro; CTA `SlideIn.up` delay 250ms | `onboarding_screen.dart:33-136` |
| Skeleton pulse | sliding gradient, 1300ms repeat, stopped under reduce-motion | `W/app_skeleton.dart:28` |
| Live badge dot | ring scale 1→2.2, opacity 0.5→0, 1200ms, reverse repeat, `inOut` | `order_list_status_badge.dart:27,41-42` |
| Toast | slide from (0,-1.2), `emphasis`, `enter`; auto-dismiss after `hero*6 + standard` = 3900ms; swipe up to dismiss | `W/app_snackbar.dart:57,99,101` |
| Filter chip | `AnimatedContainer` 200ms | `W/app_badge.dart:88` |
| Checkbox | `AnimatedContainer` 150ms | `W/playful_checkbox.dart:23` |
| OTP box | `AnimatedContainer` 120ms (0 under reduce-motion) | `otp_code_field.dart:150` |
| Cart bar | `AnimatedSwitcher` 220ms, slide from (0,0.3) + fade | `cart_bottom_sheet.dart:30-35` |
| `AppCrossFade` | `micro`, `inOut` | `W/app_button.dart:220-222` |
| Other literals | 180 (`menu_category_nav.dart:56`), 350 (`post_delivery_sheet.dart:263`), 400 (`restaurant_detail_screen.dart:139,150`), 1400 / 4500 (`order_details_screen.dart:1195,1421`), 2000 (`restaurant_detail_screen.dart:623`) | grep |
| Debounce | search 300ms | `search_provider.dart:108` |
| Lottie / Rive | **NOT FOUND** | pubspec |
| Haptics | `selectionClick` (filter chip, category chips, stepper −/+), `lightImpact` (ADD), `mediumImpact` (cart bar blocked by min order); 7 call sites | grep |
| Sounds | NOT FOUND | — |

---

## 3. Component specs

### 3.1 Primary button — `AppPrimaryButton` (`W/app_button.dart:9-83`)
Params: `label`, `onPressed`, `isLoading=false`, `icon?`, `height=52`. Full width.

| State | Background | Foreground |
|---|---|---|
| default | primary | onPrimary |
| pressed | primaryDark | onPrimary |
| disabled / loading | cardBackground (`#F4EFE9`) | textSecondary |
| loading content | 20×20 `CircularProgressIndicator` stroke 2, onPrimary | — |

Radius md 12, elevation 0, no splash/overlay. Label `AppTextStyles.button` (16/700), 1 line ellipsis. Icon 20 + gap 8 before label.
Note: theme-level `ElevatedButton` uses a *different* disabled colour (`disabledControl #EADFD3`, `app_theme.dart:42`).
```dart
AppPrimaryButton(label: 'Get Started', onPressed: () {...})
```

### 3.2 Secondary/outlined — `AppOutlinedButton` (`W/app_button.dart:85-134`)
Height 52, full width, border 1.5 borderStrong, radius 12, fg primaryText (disabled textSecondary), same label style. Loading spinner 20×20 in primaryText.

### 3.3 Text button
Theme only: fg primaryText, disabled textSecondary, radius md, padding h16 v8 (`T/app_theme.dart:146-156`). Dialog actions override fg to primary/error with no overlay (`W/app_dialogs.dart:43-53`). "Cancel" in order cards is a custom tappable `Text` in errorText with `AppScaleTap(pressedOpacity 0.6)` (`orders_screen.dart:252-266`).

### 3.4 Icon button
No shared widget. Pattern: `AppScaleTap` or `InkWell` around `Icon`, padding xs 4, e.g. sheet close (icon 20, textSecondary, `app_bottom_sheet.dart:60-67`), toast close (icon 16, `app_snackbar.dart:165-185`), stepper buttons (icon 12, `restaurant_detail_screen.dart:896-912`).

### 3.5 FAB
`FloatingActionButton.extended` on saved addresses: bg primary, elevation 0, icon `add` 20 onPrimary, label `AppTextStyles.button` onPrimary (`address_list_screen.dart:67-75`). Map picker uses plain `FloatingActionButton` (`map_address_picker_screen.dart:345`; styling not audited).

### 3.6 Text field
Two implementations:

| | Theme `InputDecorationTheme` (`T/app_theme.dart:65-86`) | `AuthInputField` (`auth_input_field.dart`) |
|---|---|---|
| Fill | surface | `fillColor ?? surface` |
| Border | 1 borderStrong, r12; focus 1.5 primary; error 1 error | container border 1.5 `borderColor ?? cardBorder`, r12, `InputBorder.none` inside; **no focus/error visual** |
| Content padding | h16 v12 | h16 v16 |
| Hint | body + textSecondary | body + textSecondary |
| Prefix icon | — | padded 12, 20px textSecondary, min 44×44 |
| Label / floating label / required `*` | **NOT FOUND** (hint-only fields; labels are separate `Text` above) | NOT FOUND |
| Error text style | NOT FOUND (errors are toasts) | NOT FOUND |
Cursor/selection: primary / primary@0.2 (`T/app_theme.dart:106-110`).

Phone field (`phone_login_screen.dart`): height 52, r12, border 1 borderStrong → 2 primary on focus, text 15/700, hint 14/400, prefix `phone_outlined` 20 (`:495-497,586-600`).

### 3.7 Dropdown / selector
No `DropdownButton`. Country code selector opens `showModalBottomSheet` (`country_picker_sheet.dart:14`, top radius 20 literal `:60`). Sort filter uses `RadioListTile` in a sheet (`filter_bottom_sheet.dart:82-91`).

### 3.8 OTP field — `OtpCodeField` (`otp_code_field.dart`)
6 boxes, height 56, max width 328, gap 8 (`AppSpacing.sm`), radius 12, fill surface. Border: active 2 primaryText, otherwise 1 cardBorder. Digit `otpDigit` (22/700). Blinking-cursor stand-in: 2×24 primary bar. Hidden transparent `TextField`, digits only, length 6, `AutofillHints.oneTimeCode`, long-press pastes digits. Semantics label `Verification code, N of 6 entered`.

### 3.9 Search bar — `HomeSearchBar` (`home_search_bar.dart`)
Height 52, h-padding 12, surface fill, radius xxl 24, **no border**. Leading `search` 20 textSecondary, hint `Search restaurants or dishes...` (bodySecondary), text `body`, max 100 chars, clear button `close` 20 via `AppScaleTap`.

### 3.10 Checkbox / radio / switch
`PlayfulCheckbox`: 24 circle, selected primary fill + `check` 14 onPrimary, unselected 2px borderStrong, 150ms (`W/playful_checkbox.dart`). Switch theme: selected thumb onPrimary, track primary (`T/app_theme.dart:111-124`). Radio: stock `RadioListTile` (not themed).

### 3.11 Chips
- `AppFilterChip` (`W/app_badge.dart:67-130`): pill; selected bg primaryLight / fg primaryText w700; unselected bg cardBackground / fg textSecondary w500; label `caption`; padding h12 v8; optional icon 14 + gap 4; haptic `selectionClick`. No border.
- Category chips (`menu_category_chips.dart`): item width 88; 56 circle icon (24), selected primary fill + onPrimary icon, unselected surface + 1px borderStrong + primaryText icon; label `caption` (w700 when selected), max 2 lines; strip height `56 + 4 + 2·12·scale·1.3`; h-padding 16, gap 8; first chip "All".

### 3.12 Badges / pills
`AppStatusBadge`: padding h8 v4, r8, 1px border in fg, label `badge`. `AppIconBadge` → 44 solid `AppIconBubble`. Orders list badge and "Live" dot (8×8) — see 1.2. `SOLD OUT` pill: cardBackground, pill radius, 1px borderStrong, badge/textSecondary (`restaurant_detail_screen.dart:921-935`).

### 3.13 Cards
- `AppCard` (`W/app_card.dart`): surface, r12, 1px cardBorder, padding 16 (`.dense` 12); with `onTap` wraps in `InkWell` with `Clip.antiAlias`.
- Restaurant card (`restaurant_card.dart`): surface, r12, 1px cardBorder, clip; image `AspectRatio 16/9`, info padding L12 T8 R12 B8; logo avatar 40 (1px cardBorder); name `title` max 2 lines; meta row icons 12 + `caption`; separator `·`; cuisine line `bodySecondary`, joined with ` • `, max 3 then `+N`. Wrapped in `AppScaleTap`.
- Order card: r16, md padding (`orders_screen.dart:189-196`).
- Menu item tile: r12, padding 12, image 104×104 r8, `ADD` button 72 wide (`restaurant_detail_screen.dart:706-728,845`).
- Tinted panel: `AppIconBubble`, `AppAvatar` (primary@0.12). No other tinted panel component found.

### 3.14 List tiles — `AppListRow` (`W/app_list_row.dart`)
Padding 16, leading + gap 12, title `cardTitle` (1 line), subtitle `bodySecondary` (2 lines, 2px gap), trailing + gap 8, optional chevron 16 textSecondary. InkWell radius 12.

### 3.15 Avatars / images
`AppAvatar(name,size,fontSize?)`: circle, primary@0.12 fill, 1px borderStrong, initial in `cardTitle` size `size*0.4` primaryText (`W/app_avatar.dart`). Home uses 40 inside 48 tap box. Network images: `Image.network` with `loadingBuilder`/`errorBuilder`, placeholder = cardBackground box (+18px primary spinner while loading), logo fallback = initial letter (`restaurant_card.dart:189-303`). Cover `BoxFit.cover`, 16:9. **No image caching package** (`cached_network_image` NOT FOUND).

### 3.16 App bar — `AppAppBar` (`W/app_app_bar.dart`)
Height `kToolbarHeight`, left-aligned title `h2` 1 line, bg background, fg textPrimary, icons 24, elevation 0, optional scroll tint (`enableTint`). Titles used: My Orders, Profile, Order Details, Saved Addresses, Add/Edit Address, Secure Checkout, Checkout, restaurant name.

### 3.17 Bottom navigation / tab bar
**Not defined.** `bottomNavigationBarTheme` is defined (`T/app_theme.dart:135-145`: surface bg, selected primaryText, unselected textSecondary, fixed, labels caption) but no `BottomNavigationBar`/`NavigationBar`/`TabBar` exists in `ui/`. Home is a single scrolling screen; orders/profile are pushed routes. `bottomNavigationBar:` slot hosts the cart bar and checkout CTA only.

### 3.18 Bottom sheet (`W/app_bottom_sheet.dart`)
`showAppSheet(context, title?, builder, showClose=false, isScrollControlled=true)`; bg surface, top radius 20, handle 40×4, padding L/R 24 T12 B(safe+16), title `h2`, close icon 20, content in `SingleChildScrollView`, lifted by keyboard inset. **Caveat:** only 4 other sheets use raw `showModalBottomSheet` (country picker, checkout, filter, address list) instead — see section 8.

### 3.19 Dialogs (`W/app_dialogs.dart`)
Theme: surface, r16, elevation 0, title `h2`, content `body`, barrier scrim (`T/app_theme.dart:157-168`).
- `showAppConfirmDialog(title,message,confirmLabel,isDestructive,cancelLabel='Cancel',icon=help_outline)`: title row icon 20 + gap 8, accent = error if destructive else primary; Cancel = default text button, Confirm = accent text button.
- `showAppMessageDialog(title,message,icon?,actionLabel='Done',...)`: optional 28px icon in 1px primaryText circle (padding 16).
- `showAppInputDialog`: `TextField` with hint, accent confirm.

### 3.20 Snackbar / toast — `AppSnackbar` (`W/app_snackbar.dart`)
Top overlay toast (not `SnackBar`): top = status bar + 12, L/R 16, surface, r20, 1px cardBorder, padding 16; 40px `AppIconBubble` (icon 20); title `cardTitle` (default `Success/Error/Info/Warning`), message `bodySecondary` max 3 lines; close icon 16. Icons: check_circle / error / info / warning_amber. API: `show`, `showSuccess`, `showError`, `showInfo`. Material `snackBarTheme` also defined (floating, surface, r20) but not used (`ScaffoldMessenger`/`SnackBar(` count 0).

### 3.20b Banners (offline, status)
Offline banner: NOT FOUND. Only a "No internet connection" title in the payment WebView (`payment_webview_screen.dart:30`). Minimum-order warning is the cart bar turning `warning` (`cart_bottom_sheet.dart:58`).

### 3.21 Loading indicators
`AppLoading(size=24,color=primary,strokeWidth=2)`; `AppSwapIcon` spinner replaces icon; `ProgressIndicatorTheme`: primary, track primaryLight (`T/app_theme.dart:101-105`). Pull-to-refresh `color: AppColors.primary` (`orders_screen.dart:125`).

### 3.22 Skeletons (`W/app_skeleton.dart`)
`SkeletonPulse` wrapper; shapes `SkeletonBox` (radius sm), `SkeletonCircle`, `SkeletonText` (h12), `SkeletonCard` (surface, r16, 1px cardBorder, padding 12); base colour cardBorder. Screens define their own composed skeletons (orders, home restaurant list, restaurant detail, order timeline).

### 3.23 Empty / error states (`W/app_states.dart`)
- `AppEmptyState(icon,title,message?,actionLabel?,onAction?)`: scrollable list, 32 top, icon 64 textSecondary@0.3, 16, title `h2` centred, 8, message `bodySecondary` (h-pad 24), 16, primary button (h-pad 32), 32 bottom.
- `AppErrorState(title='Something went wrong',description?,onRetry?)`: centred, padding 24, `error_outline` 48 error, title `h2`, description `bodySecondary`, button `Retry`.

### 3.24 Pagination / infinite scroll
NOT FOUND (no scroll-listener loaders).

### 3.25 Map widgets
`google_maps_flutter`. Route polyline: casing `surface` width 9 + line `primary` width 5, round joins/caps (`order_details_screen.dart:1619-1636`). Markers: default `BitmapDescriptor` hues — destination `hueRed`, driver `hueOrange` (`order_details_screen.dart:1743-1752`, `order_route_map.dart:122`). No custom marker assets.

### 3.26 Order / delivery cards
Order list card (3.13). Order details: timeline with SVG glyphs (`assets/icons/*.svg`), done step = successBg disc + successText glyph/line (width 2); current = primaryText 2px ring (`order_details_screen.dart:640-681,1235`). Driver card appears for `arrived_at_restaurant/picked_up/on_the_way` (`order_status.dart:154-158`). Bill: `OrderBillRows` (Subtotal, Delivery Fee, Total; Total row has 1.5 primary top border, `priceLarge`), `OrderItemRow` (`W/order_bill.dart`).

### 3.27 Rating widget
5 `Icons.star` / `star_border`; filled colour `rating #FFB400`, textSecondary if read-only (`post_delivery_sheet.dart:392-395`). Card rating shows `star` 12 + value `toStringAsFixed(1)`.

### 3.28 Price / currency
`£` + 2 decimals: `formatGbp` (`core/utils/money.dart:1`); `num.gbp` extension. Prices in a fixed-width 90px right-aligned `AppPriceCell` (`W/app_price_cell.dart`). Item stepper: ADD button (primary, r8, 72 wide, `badge` text "ADD") ↔ stepper (primary, min 72, `−`/`+` icons 12, count `bodySecondary` w700 onPrimary). Disabled add: cardBorder bg, "Add" caption.

### 3.29 Date/time (intl `DateFormat`)
`d MMM` (order list), `h:mm a` (delivered/since), `MMM d, h:mm a` (timeline), `yMMMM` (member since). Sources: `orders_screen.dart:217`, `order_details_screen.dart:748,1347`, `profile_screen.dart:302`. Distance: `formatDistance` (`core/utils/geo_utils.dart`, miles).

---

## 4. Layout & screen patterns

- **Scaffold**: `backgroundColor: AppColors.background` (15 of 17 `Scaffold`s; 2 use surface), `AppAppBar` for pushed screens, `SafeArea` on auth/bottom bars.
- **Scroll**: `ListView.builder` + `RefreshIndicator(color: primary)` for lists; `CustomScrollView`+slivers for home and restaurant detail; `SingleChildScrollView` + `LayoutBuilder` + `ConstrainedBox(minHeight)` + `IntrinsicHeight` for auth.
- **Form screen**: fields stacked, label as `bodySecondary` above field (checkout `_SectionCard`, `checkout_screen.dart:831-851`); primary action pinned in `bottomNavigationBar: SafeArea(Padding(16, AppPrimaryButton))` (`checkout_screen.dart:743-746`) on checkout; on auth screens CTA inside scroll body. Validation: **toast on submit** (e.g. `Please enter your name`, `Please enter the 6-digit code`), not inline errors; one `Form`/`validator` in add-address (`add_address_screen.dart:213,323,337`).
- **List screen**: cards with 12px bottom gap, no dividers between cards; empty → `AppEmptyState`; loading → skeleton.
- **Detail screen**: sliver header (cover + logo), category nav chips, menu tiles with `Divider(height:1, divider)`, bottom `CartBottomBar` (`restaurant_detail_screen.dart:66,280`).
- **Auth**: Onboarding → PhoneLogin (login/signup) → OTP → ProfileSetup → Home.
- **Modals**: confirm/destructive → `showAppConfirmDialog`; info → `showAppMessageDialog`; pickers/filters → bottom sheets; feedback → top toast.
- **Back button**: default Material back arrow in `AppBar` (`automaticallyImplyLeading: true`), icon 24 textPrimary.

---

## 5. Content & copy standards

| Item | Standard | Source |
|---|---|---|
| Currency | `£` prefix, 2 dp (`£12.50`), GBP only | `core/utils/money.dart:1` |
| Dates | see 3.29 (en-US default locale, 12-hour clock, `·` separator in `#123 · 4 Nov`) | `orders_screen.dart:217` |
| Phone | `+91 XXXXX XXXXX` driver formatting only; no general formatter | `order_status.dart:148-151` |
| Distance | miles (`${r.toInt()} mi` in filter) | grep |
| Buttons | Title Case, short verbs: `Get Started`, `Pay Now`, `Log Out`, `Clear & Add`, `Use My Current Location`, `Add Address`, `Retry`, `Open settings` (sentence case also appears) | grep |
| Titles | Title Case: `My Orders`, `Saved Addresses`, `Secure Checkout`; dialog titles sentence case w/ `?` for questions: `Log out?`, `Delete address?` | grep |
| Badges | UPPERCASE: `ADD`, `SOLD OUT` | `restaurant_detail_screen.dart` |
| Tone | friendly, plain, first-person plural, ends with period; apology-free ("Couldn't…" contractions) | grep |

**Success / error / info toasts (10 real examples each, from code):**

Success: `Order cancelled.` · `Address updated!` · `Address saved successfully!` · `Address deleted.` · `Profile updated.` · `Thanks for your feedback!` · `Payment completed. Confirming with restaurant…` · `Order placed!` (dialog) · defaults `Success` title.

Errors: `Please enter your name` · `Please enter the 6-digit code` · `Please enter your phone number` · `Please enter a valid mobile number` · `Name cannot be empty.` · `Couldn't open the dialer` · `Failed to save address` · `Failed to delete address.` · `You have already rated this order.` · `Payment cancelled.`

Info/warn: `This restaurant is currently closed.` · `Location permission is needed to use your current location.` · `Location services are off. Move the map to pick a spot.` · `Couldn't fetch your location. Move the map to select a delivery spot.` · `Couldn't find that location — try a different search` · `Payment expired. Your cart is still saved.` · `Payment cancelled. Your order is saved, you can pay from here.` · `$feature coming soon` · `Add ${shortfall} more <action>` (min-order, `money.dart:7`).

API error mapping (`core/error/app_error.dart:31-48,78`): `Your session expired. Please sign in again.` · `You don't have permission to do that.` · `We couldn't find that. Please try again.` · `Too many requests. Please wait a moment and try again.` · `This is taking longer than usual. Please try again.` · `Something went wrong on our side. Please try again in a moment.` · `Something went wrong. Please try again.`

Empty states (title / message): `No orders yet` / `Your order history will show up here.` · `No saved addresses` / `Save your home, office or other delivery addresses to order faster.` · `Your cart is empty` / `Add something tasty to get started.` · `Add a delivery address` / `We need your address to show restaurants near you.` · `No menu available` / `This restaurant hasn't added any items yet. Check back later!` · `No restaurants nearby yet`.

Loading wording: `Locating...` / `Finding your current location`. Skeletons otherwise.
Localisation: none; strings inline; British spelling mixed (`favourite` in login, `favorite` in onboarding — `phone_login_screen.dart` vs `onboarding_screen.dart:119`).

---

## 6. Assets

| Asset | Path | Used in |
|---|---|---|
| DM Sans Regular/Medium/Bold | `assets/fonts/DMSans-*.ttf` | global |
| Bricolage Grotesque variable | `assets/fonts/BricolageGrotesque-Variable.ttf` | display styles |
| Logo | `assets/images/MK-Tour-Logo.png` | onboarding, login, auth gate, login hero |
| Logo + tagline | `assets/images/MK-Tour-Logo-Tagline.png` | no usage found in `ui/` |
| Hero | `assets/images/rm.png` | login hero (precached `phone_login_screen.dart:42,57`) |
| Hero mixed | `assets/images/hero_mixed.png` | no usage found |
| SVG icons (24) | `assets/icons/`: 24 hour, bicycle, bread, call, coffee cup, delivery, delivery truck, donut, door delivery, fast food, food, food pack, food tray, french fries, location, menu, motorcycle, order, packaging, payment, pizza, plastic bag, shop, soft drink, time | timeline uses order, shop, time, food pack, location, plastic bag, motorcycle, door delivery; call (driver) (`order_details_screen.dart:543-585,861`); rest unused |
| Audio / Lottie | NOT FOUND | — |

App icon: `mipmap-*` launcher (`@mipmap/ic_launcher`), iOS `AppIcon.appiconset`; no `flutter_launcher_icons` config. Splash: Android `launch_background.xml` = plain white, no image; iOS `LaunchImage` + `LaunchScreen` storyboard; no `flutter_native_splash`. Android label `MK Foods`.

---

## 9. Ready-to-copy token block

```dart
import 'package:flutter/material.dart';

abstract final class C {
  static const primary = Color(0xFFD33E11);
  static const primaryDark = Color(0xFFA92F0B);
  static const primaryLight = Color(0xFFFFE9DE);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryText = Color(0xFFA92F0B);
  static const secondary = Color(0xFFFFB74D);
  static const success = Color(0xFF2E7D32);
  static const error = Color(0xFFD81B3C);
  static const info = Color(0xFF2F80ED);
  static const warning = Color(0xFFA66900);
  static const rating = Color(0xFFFFB400);
  static const successText = Color(0xFF1B5E20);
  static const errorText = Color(0xFFA8112B);
  static const warningText = Color(0xFF6B4300);
  static const infoText = Color(0xFF1556A8);
  static const successBg = Color(0xFFE6F4E7);
  static const errorBg = Color(0xFFFDEAEE);
  static const warningBg = Color(0xFFFFF4D6);
  static const infoBg = Color(0xFFE8F1FD);
  static const textPrimary = Color(0xFF1E1B18);
  static const textSecondary = Color(0xFF6A615A);
  static const background = Color(0xFFFFFBF5);
  static const surface = Color(0xFFFFFFFF);
  static const cardBorder = Color(0xFFEBDFD3);
  static const cardBackground = Color(0xFFF4EFE9);
  static const shadow = Color(0xFFD9CCC0);
  static const borderStrong = Color(0xFF8F867E);
  static const divider = Color(0xFFF0E6DB);
  static const scrim = Color(0x8C1E1B18);
}

abstract final class Sp { static const xs=4.0, sm=8.0, md=12.0, lg=16.0, xl=20.0, xxl=24.0, xxxl=32.0; }
abstract final class Rd { static const sm=8.0, md=12.0, lg=16.0, xl=20.0, xxl=24.0, pill=999.0; }
abstract final class Ic { static const s12=12.0,s14=14.0,s16=16.0,s18=18.0,s20=20.0,s24=24.0,s32=32.0,s40=40.0,s48=48.0,s64=64.0; }

abstract final class Dur {
  static const instant = Duration(milliseconds: 100);
  static const micro = Duration(milliseconds: 200);
  static const standard = Duration(milliseconds: 300);
  static const emphasis = Duration(milliseconds: 450);
  static const hero = Duration(milliseconds: 600);
}
abstract final class Crv {
  static const enter = Curves.easeOutCubic, exit = Curves.easeInCubic,
      inOut = Curves.easeInOutCubic, panel = Curves.decelerate;
}

const _display = TextStyle(fontFamily: 'BricolageGrotesque', fontFamilyFallback: ['DM Sans'],
    fontVariations: [FontVariation('wght', 700)], fontWeight: FontWeight.w700, color: C.textPrimary);
abstract final class T {
  static final display = _display.copyWith(fontSize: 28, height: 1.2, letterSpacing: -0.4);
  static final h1 = _display.copyWith(fontSize: 22, height: 1.25, letterSpacing: -0.7);
  static final h2 = _display.copyWith(fontSize: 18, height: 1.3, letterSpacing: -0.5);
  static final title = _display.copyWith(fontSize: 16, height: 1.3, letterSpacing: -0.1);
  static const cardTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.textPrimary, height: 1.3, letterSpacing: -0.4);
  static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: C.textPrimary, height: 1.4, letterSpacing: -0.35);
  static const bodySecondary = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: C.textSecondary, height: 1.4, letterSpacing: -0.2);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: C.textSecondary, height: 1.3, letterSpacing: -0.2);
  static const price = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: C.textPrimary, letterSpacing: -0.35);
  static const badge = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: -0.1);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.textPrimary, height: 1.2, letterSpacing: 0);
  static const priceLarge = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: C.textPrimary, height: 1.3, letterSpacing: 0);
  static const otpDigit = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: C.textPrimary, height: 1.25, letterSpacing: -0.7);
}
// Component constants
const kButtonHeight = 52.0, kInputHeight = 52.0, kOtpBoxHeight = 56.0, kMinTap = 48.0;
const kBorder = 1.0, kBorderStrong = 1.5, kPriceCellWidth = 90.0, kTapScale = 0.97;
```

---

## 10. One-page summary

```
BRAND      Warm food-delivery. Primary #D33E11 (pressed #A92F0B, tint #FFE9DE), text-accent #A92F0B.
           Secondary #FFB74D (barely used). Background #FFFBF5 (cream), surface #FFFFFF.
TEXT       #1E1B18 primary, #6A615A secondary.  BORDERS #EBDFD3 (cards), #8F867E (inputs), divider #F0E6DB.
STATUS     success #2E7D32, error #D81B3C, info #2F80ED, warning #A66900, rating #FFB400
           (each has Text + Bg tint pair for badges).
FONT       DM Sans (body/controls/prices) + Bricolage Grotesque (display only: display/h1/h2/title). Bundled assets.
SIZES      28 display · 22 h1 · 18 h2 · 16 card/button · 14 body/price · 12 caption · 11 badge
WEIGHTS    400 / 500 / 700. Tight negative letter-spacing (-0.1 … -0.7).
SPACING    4 · 8 · 12 · 16 · 20 · 24 · 32.  Screen padding 16 (auth 24). Card padding 12–16. Card gap 12.
RADIUS     8 · 12 · 16 · 20 · 24 · pill.  Buttons/inputs/cards 12. Badges 8. Sheets top 20. Dialog 16. Pill = chips only.
BUTTON     Height 52, full width, r12, 16/700, elevation 0, no ripple; pressed primaryDark; disabled #F4EFE9.
INPUT      Height 52, white fill, 1px #8F867E, r12, focus 1.5px primary, hint-only (no floating label), errors via toast.
CARD       White, 1px #EBDFD3, r12, no elevation/shadow (shadow only on floating cart bar: blur 10, y4).
ICON       Material outlined, sizes 12-64, row 24, field 20, chevron 16; 24 custom SVGs for order timeline.
MOTION     100/200/300/450/600ms; enter easeOutCubic; tap scale 0.97; page slide 6–8% + fade 450ms in/300ms out;
           skeleton pulse 1300ms; toast from top 450ms, stays 3.9s; honours reduce-motion.
HAPTICS    selectionClick (chips, stepper), lightImpact (ADD), mediumImpact (blocked cart).
CURRENCY   £0.00 (GBP).  DATES d MMM · h:mm a · MMM d, h:mm a.
NAV        Push routes (bottom nav / tabs: NOT DEFINED yet); AppBar left-aligned h2; top toast for feedback; bottom sheet for pickers.

5 RULES THAT MAKE IT "ON BRAND"
 1. Flat: elevation 0, 1px warm-grey borders, no ripples — depth comes from border + cream background.
 2. One accent: primary orange-red for actions/selection; deeper #A92F0B for accent text on white.
 3. Two fonts, two jobs: Bricolage for headlines/names only; DM Sans for everything functional.
 4. Everything from tokens: only 7 spacing, 6 radius, 7 type sizes — no raw hex.
 5. Soft, quick feedback: 0.97 press-scale, haptics, skeleton pulse, top toast; never a blocking spinner screen.
```
