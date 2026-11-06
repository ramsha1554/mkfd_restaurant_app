---
name: Warm Editorial Flat
colors:
  surface: '#fff8f4'
  surface-dim: '#e0d9d3'
  surface-bright: '#fff8f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#faf2ed'
  surface-container: '#f4ece7'
  surface-container-high: '#eee7e1'
  surface-container-highest: '#e9e1dc'
  on-surface: '#1e1b18'
  on-surface-variant: '#5b413a'
  inverse-surface: '#33302c'
  inverse-on-surface: '#f7efea'
  outline: '#8f7068'
  outline-variant: '#e3beb5'
  surface-tint: '#b22c00'
  primary: '#ac2a00'
  on-primary: '#ffffff'
  primary-container: '#d33e11'
  on-primary-container: '#fffaf9'
  inverse-primary: '#ffb5a1'
  secondary: '#ad320e'
  on-secondary: '#ffffff'
  secondary-container: '#fd6a43'
  on-secondary-container: '#611300'
  tertiary: '#675850'
  on-tertiary: '#ffffff'
  tertiary-container: '#817067'
  on-tertiary-container: '#fffaf8'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbd1'
  primary-fixed-dim: '#ffb5a1'
  on-primary-fixed: '#3b0800'
  on-primary-fixed-variant: '#881f00'
  secondary-fixed: '#ffdbd1'
  secondary-fixed-dim: '#ffb4a1'
  on-secondary-fixed: '#3c0800'
  on-secondary-fixed-variant: '#881f00'
  tertiary-fixed: '#f4ded3'
  tertiary-fixed-dim: '#d7c2b8'
  on-tertiary-fixed: '#241913'
  on-tertiary-fixed-variant: '#52443c'
  background: '#fff8f4'
  on-background: '#1e1b18'
  surface-variant: '#e9e1dc'
typography:
  display:
    fontFamily: Bricolage Grotesque
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 38px
  headline-lg:
    fontFamily: Bricolage Grotesque
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Bricolage Grotesque
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Bricolage Grotesque
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: DM Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: DM Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: DM Sans
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-md:
    fontFamily: DM Sans
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
  label-sm:
    fontFamily: DM Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.3px
  numeric-table:
    fontFamily: DM Sans
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system is tailored specifically for the fast-paced, high-heat reality of independent hospitality management in Milton Keynes, UK. The tone balances reliable operational utility with the artisanal, tactile warmth of independent British food craft. It avoids sterile corporate SaaS aesthetics while completely eschewing gratuitous ornamentation, artificial skeuomorphism, or floaty drop shadows.

The aesthetic philosophy is **Strict Warm Flatness**:
- **Utilitarian & Grounded:** Clean structural borders, distinct tactile grouping, zero elevation blurs, and complete reliance on precise borders, spatial density, and disciplined color roles.
- **Warm Culinary Heritage:** Base surfaces avoid clinical cold whites and corporate blues, grounding the tool in deep warm creams, natural unbleached cardboards, and rich roasted terracotta accents.
- **Direct & Legible Under Pressure:** High contrast, deliberate bounding containers, and sharp character typography tailored for fast scanning on handheld POS terminals and kitchen-side mobile devices.

## Colors

The palette is strictly calibrated to create visual certainty across shifts. All interactions rely on solid fills and calibrated outlines; no color gradients, dynamic Material You tonal shifts, or unassigned purple accents are permitted.

### Brand & Interactive Actions
- **Primary Action:** `#D33E11` (Deep terracotta vermilion for primary interactive triggers, active tabs, and primary controls)
- **Primary Pressed / Hover:** `#A92F0B` (Dark roasted terracotta for pressed states, active drawer selections, and inline text links)
- **Primary Tint:** `#FFE9DE` (Soft warm peach tint for active chip backgrounds, subtle item selections, and highlight callouts)
- **Accent Text / Links:** `#A92F0B`

### Surfaces & Boundaries
- **Page Canvas:** `#FFFBF5` (Warm clotted cream background for zero glare on long operational shifts)
- **Layered Surfaces (Cards, Bottom Sheets, Modals, Inputs):** `#FFFFFF` (Pure white containers)
- **Card Borders:** `#EBDFD3` (Subtle boundary line separating white cards from the warm cream canvas)
- **Input & Outlined Action Borders:** `#8F867E` (High-visibility mid-neutral outline for high tactile affordance)
- **Dividers & Structural Hairlines:** `#F0E6DB` (Soft internal separators between order line items)
- **Disabled Fill & Unselected Neutral Surfaces:** `#F4EFE9` (Inactive tabs, disabled buttons, counter backdrops)

### Typography Tokens
- **Text Primary:** `#1E1B18` (Charcoal peat black for maximum legibility on menu items, quantities, and totals)
- **Text Secondary:** `#6A615A` (Muted roasted umber for timestamps, modifiers, and secondary metadata)
- **Text Hint / Placeholder:** `#9A9189` (Soft stone for input prompts, inactive counters, and disabled copy)

### Semantic Feedback Matrix
Status communication relies on strict paired foreground/background sets along with standalone solid badges:
- **Success:** `#1B5E20` text on `#E6F4E7` container | Solid badge: `#2E7D32`
- **Error / Void / Alert:** `#A8112B` text on `#FDEAEE` container | Solid badge: `#D81B3C`
- **Warning / Hold:** `#6B4300` text on `#FFF4D6` container | Solid badge: `#A66900`
- **Info / Logistics:** `#1556A8` text on `#E8F1FD` container | Solid badge: `#2F80ED`
- **Rating & Stars:** `#FFB400`

## Typography

The typographic hierarchy combines the artisanal British personality of **Bricolage Grotesque** with the immaculate tabular rhythm of **DM Sans**.

### Font Pairing Logic
- **Bricolage Grotesque (Headings & Primary Quantities):** Utilized exclusively for primary screen titles, table section headers, revenue rollups, and category cards. Its expressive rhythmic curves deliver distinction without sacrificing scannability.
- **DM Sans (Body, Functional Labels, Data Tables):** Used for all interactive form elements, modifiers, order timestamps, table grid identifiers, and body copy. It retains neutral proportions and remains legible under glare.

### Application Guidelines
- Never set body paragraphs, sub-modifiers, or tabular input values in Bricolage Grotesque.
- Financial figures, bill receipts, and operational timers must leverage tabular lining figures (`font-variant-numeric: tabular-nums`) within DM Sans.
- Keep letter spacing locked to tight or neutral scales; do not apply excessive tracking to lowercase body copy.

## Layout & Spacing

The layout is optimized for handheld mobile screens (smartphones and handheld POS readers) utilizing a high-density, touch-reliable fluid grid.

### Mobile Grid Architecture
- **Screen Margins:** Fixed `16px` (`margin`) screen edges to ensure interactive elements never brush device bezels.
- **Internal Column Grid:** 4-column fluid mobile grid with `12px` gutters (`gutter`). On tablet viewports, the grid expands to 8 columns with `16px` gutters.
- **Vertical Rhythm:** Root rhythm adheres to a strict 4px base increment (`0.25rem` / `space-xs`), with most operational containers employing internal paddings of `12px` (`space-md`) or `16px` (`space-lg`).

### Touch Targets
- All primary triggers, modifier checkboxes, and ticket actions maintain a minimum bounding box of `48px x 48px`, regardless of visual icon size.

## Elevation & Depth

This design system implements **Pure Flat Boundary Separation**. Drop shadows, elevation blurs, outer glows, and skeuomorphic bevels are strictly forbidden.

### Structural Depth Principles
1. **Zero Shadow Rule:** `box-shadow: none` is globally mandated across cards, floating snackbars, bottom sheets, tooltips, and dialog modals.
2. **Crisp 1px Boundaries:** Visual stacking is communicated exclusively through outline contrast:
   - Primary surface separation relies on `#EBDFD3` borders bordering white containers (`#FFFFFF`) against the `#FFFBF5` canvas.
   - Interactive surfaces in focus or active editing rely on `#8F867E` or `#D33E11`.
3. **Overlays and Sheets:** Bottom sheets and modal alerts employ a flat scrim overlay of `rgba(30, 27, 24, 0.45)` with a solid `#FFFFFF` sheet defined by a top border hairline of `1px solid #EBDFD3`.
4. **Dividers:** Sub-item separation uses hairline borders (`1px solid #F0E6DB`). Never use double borders or inset grooves.

## Shapes

The shape hierarchy is strictly bound to numeric corner radii based on component function:

- **12px Radius (`rounded-12`):** Primary interactive and structural units. Applied to all content cards, order sheets, text input fields, bottom sheet top corners, dialog containers, and standard primary/secondary buttons.
- **8px Radius (`rounded-8`):** Status badges, tag labels, numeric notification counter boxes, and inline alerts.
- **Pill Radius (`rounded-full`):** Reserved exclusively for dynamic filter chips and contextual category toggles. Never apply pill radii to action buttons or form text fields.
- **Checkboxes:** 4px radius on small 20px boxes.
- **Radio Controls:** 100% circle with concentric solid dot indicators.

## Components

### Buttons
- **Primary Action Button:** 
  - Height: `48px`. Corner radius: `12px`.
  - Fill: `#D33E11`. Text: `#FFFFFF` (DM Sans, `label-lg`). Border: none.
  - Active/Pressed State: Fill switches instantly to `#A92F0B`.
  - Disabled State: Fill `#F4EFE9`, text `#9A9189`.
- **Secondary / Outlined Action Button:**
  - Height: `48px`. Corner radius: `12px`.
  - Fill: `#FFFFFF`. Text: `#1E1B18`. Border: `1px solid #8F867E`.
  - Pressed: Fill `#FFE9DE`, border `#A92F0B`, text `#A92F0B`.
- **Destructive Button:**
  - Fill: `#FDEAEE`. Text: `#A8112B`. Border: `1px solid #FDEAEE`.
  - Pressed: Fill `#D81B3C`, text `#FFFFFF`.

### Filter Chips
- Height: `36px`. Corner radius: `9999px` (Pill shape strictly reserved).
- **Unselected:** Fill `#FFFFFF`, border `1px solid #EBDFD3`, text `#6A615A`.
- **Selected:** Fill `#FFE9DE`, border `1px solid #D33E11`, text `#A92F0B` (DM Sans `label-md`).

### Cards & Ticket Modules
- Background: `#FFFFFF`. Corner radius: `12px`. Border: `1px solid #EBDFD3`.
- Internal Padding: `16px`. Zero drop shadow.
- Header: Bricolage Grotesque (`headline-sm`), primary text `#1E1B18`.
- Divider between summary and action footer: `1px solid #F0E6DB`.

### Input Fields
- Height: `48px`. Corner radius: `12px`.
- Background: `#FFFFFF`. Border: `1px solid #8F867E`.
- Padding: `0 16px`. Text: `#1E1B18` (`body-md`).
- Placeholder Text: `#9A9189`.
- Focus State: Border switches to `2px solid #D33E11` (inset or tight boundary, no ambient glow).
- Error State: Border switches to `1.5px solid #D81B3C`, helper copy `#A8112B`.

### Badges & Status Indicators
- Height: `24px`. Corner radius: `8px`. Padding: `2px 8px`. Font: DM Sans `label-sm`.
- **Kitchen Ready / Success:** Background `#E6F4E7`, Text `#1B5E20`.
- **Delayed / Warning:** Background `#FFF4D6`, Text `#6B4300`.
- **Cancelled / Urgency:** Background `#FDEAEE`, Text `#A8112B`.
- **Info / Delivery:** Background `#E8F1FD`, Text `#1556A8`.

### Checkboxes & Radios
- Size: `20px x 20px`.
- **Checkbox:** `4px` corner radius. Unchecked: `1.5px solid #8F867E`, fill `#FFFFFF`. Checked: solid `#D33E11` with `#FFFFFF` checkmark icon.
- **Radio:** Circular. Unchecked: `1.5px solid #8F867E`, fill `#FFFFFF`. Checked: `2px solid #D33E11` with solid `#D33E11` concentric center dot (8px diameter).

### Operational Line Items & Lists
- Row layout: Flat list on `#FFFFFF` surfaces separated by `1px solid #F0E6DB`.
- Touch state: Tapping an order item triggers a flash fill of `#FFE9DE` before navigation or drawer expansion.