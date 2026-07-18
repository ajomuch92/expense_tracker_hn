---
name: Expense Tracker HN
description: Effortless, offline expense tracking for everyday life in Honduras.
colors:
  fresh-mint: "#2DD4BF"
  fresh-mint-light: "#5EEAD4"
  ink: "#0F172A"
  paper: "#F8FAFC"
  surface-light: "#FFFFFF"
  divider-light: "#E2E8F0"
  outline-light: "#CBD5E1"
  ink-dark: "#F1F5F9"
  bg-dark: "#0B0F14"
  surface-dark: "#161B22"
  divider-dark: "#334155"
  danger: "#F87171"
  amber: "#FBBF24"
  action-light: "#000000"
  action-dark: "#FFFFFF"
typography:
  amount:
    fontFamily: "Roboto, system-ui, sans-serif"
    fontSize: "40px"
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: "normal"
  headline:
    fontFamily: "Roboto, system-ui, sans-serif"
    fontSize: "18px"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "normal"
  title:
    fontFamily: "Roboto, system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 700
    lineHeight: 1.3
    letterSpacing: "normal"
  body:
    fontFamily: "Roboto, system-ui, sans-serif"
    fontSize: "14px"
    fontWeight: 600
    lineHeight: 1.4
    letterSpacing: "normal"
  label:
    fontFamily: "Roboto, system-ui, sans-serif"
    fontSize: "11px"
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: "1.1px"
  caption:
    fontFamily: "Roboto, system-ui, sans-serif"
    fontSize: "12px"
    fontWeight: 400
    lineHeight: 1.3
    letterSpacing: "normal"
rounded:
  pill: "11px"
  icon: "12px"
  field: "14px"
  button: "16px"
  card: "20px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
components:
  button-primary:
    backgroundColor: "{colors.action-light}"
    textColor: "{colors.surface-light}"
    rounded: "{rounded.button}"
    padding: "16px 24px"
  button-outlined:
    textColor: "{colors.ink}"
    rounded: "{rounded.field}"
    padding: "14px 20px"
  card:
    backgroundColor: "{colors.surface-light}"
    textColor: "{colors.ink}"
    rounded: "{rounded.card}"
    padding: "16px"
  input:
    backgroundColor: "{colors.surface-light}"
    textColor: "{colors.ink}"
    rounded: "{rounded.field}"
    padding: "14px 16px"
  tab-selected:
    backgroundColor: "{colors.action-light}"
    textColor: "{colors.surface-light}"
    rounded: "{rounded.pill}"
    padding: "10px 12px"
  fab:
    backgroundColor: "{colors.fresh-mint}"
    textColor: "{colors.ink}"
    rounded: "{rounded.card}"
---

# Design System: Expense Tracker HN

## 1. Overview

**Creative North Star: "The Quiet Ledger"**

This is a personal money app that earns trust by getting out of the way. Surfaces are flat and calm, the type is a single clean sans, and the numbers — amounts, subtotals, the month's total — are the loudest thing on any screen. Nothing competes with them. The palette is almost entirely monochrome ink-on-paper, with a single Fresh Mint accent held in reserve for the one thing that matters at that moment (the selected period, the active nav tab, the add button). A ledger, not a dashboard: readable at a glance, precise, unhurried.

The system is deliberately austere in its chrome and generous in its whitespace. Cards carry no shadow; depth comes from tonal layering (a slightly off-white paper scaffold under pure-white cards in light mode, near-black under raised charcoal in dark mode). Corners are softly rounded (14–20px) so the app feels modern and approachable without turning playful. Action buttons invert to solid black (light) or white (dark) — maximum contrast, maximum confidence — because the moment of committing an expense should feel decisive.

It explicitly rejects the **cluttered spreadsheet**: no dense tables, no tiny cramped rows, no wall of numbers dumped on screen. Every view answers one question and filters or summarizes to get there. It is not a corporate banking app and not a gamified toy.

**Key Characteristics:**
- Monochrome base, one Fresh Mint signal color
- Flat surfaces, depth by tonal layering not shadow
- Numbers are the hero; chrome recedes
- Soft radii (14–20px), generous spacing
- High-contrast, decisive action buttons

## 2. Colors

An ink-on-paper monochrome foundation carrying a single mint accent; danger and amber appear only for their specific semantic roles.

### Primary
- **Fresh Mint** (#2DD4BF): The one voice color. Used sparingly — the active nav destination, selected/active affordances, the floating add button, chart segments, and the "See all" link. In dark mode it lightens to **Fresh Mint Light** (#5EEAD4) for contrast. It is never a background wash and never the primary action button.

### Neutral
- **Ink** (#0F172A): Primary text and numbers in light mode.
- **Paper** (#F8FAFC): Light-mode scaffold background — the surface behind cards.
- **Surface (light)** (#FFFFFF): Card, input, and nav-bar fill in light mode.
- **Ink (dark)** (#F1F5F9): Primary text in dark mode.
- **BG (dark)** (#0B0F14): Dark-mode scaffold background.
- **Surface (dark)** (#161B22): Card / input / nav fill in dark mode.
- **Divider** (#E2E8F0 light / #334155 @ 40% dark): Hairline separators between rows.
- **Outline** (#CBD5E1 light / #334155 dark): Outlined-button borders.
- **Action** (#000000 light / #FFFFFF dark): The inverted color of primary buttons and selected segmented-tab pills.

### Tertiary
- **Danger** (#F87171): Delete actions, amount validation errors, and negative signals only.
- **Amber** (#FBBF24): Reserved warning / attention accent.

### Named Rules
**The One Voice Rule.** Fresh Mint appears on at most one active element per screen region. Its rarity is what makes the active state instantly legible. If two mint things fight for attention, one of them is wrong.

**The Inverted-Action Rule.** The primary commit button is never mint — it is solid black (light) or white (dark). The brand color signals *state*; the action color signals *do it now*. Keep them separate.

## 3. Typography

**Display / Body / Label Font:** Roboto (Material 2021 stack, with system-ui, sans-serif fallback)

**Character:** One family, many weights. A neutral, highly legible geometric-humanist sans that stays invisible so the numbers read first. Hierarchy comes from weight and size, never from a second typeface.

### Hierarchy
- **Amount** (700, 40px, line-height 1.1): The centered amount entry on the add-expense screen and any headline monetary figure. The single largest thing in the app.
- **Headline** (700, 18px): App-bar screen titles.
- **Title** (700, 15px): Section headers ("Recent transactions"), category subtotals.
- **Body** (600, 14px): Transaction titles, list content, button text.
- **Label** (600, 11–12px, letter-spacing ~1.1px): Field labels ("Amount", "Category", "Date") — the one place tracking is widened for a quiet, precise cue.
- **Caption** (400, 12px, 50% ink opacity): Timestamps, secondary metadata under a transaction.

### Named Rules
**The One Family Rule.** Roboto only. Do not pair a second typeface; contrast is carried by weight (400 → 700) and size, not by mixing fonts.

## 4. Elevation

The system is flat by default. `elevation: 0` on app bars, cards, and buttons. Depth is communicated by **tonal layering**, not shadow: a slightly darker scaffold background sits behind lighter cards (Paper behind white in light mode; near-black behind charcoal in dark mode). Hairline dividers separate rows within a card.

### Shadow Vocabulary
- **FAB only** (Material default FAB elevation): The floating add button is the single element allowed to lift off the surface, because it floats above scrolling content and needs to read as reachable at all times.

### Named Rules
**The Flat-By-Default Rule.** Surfaces are flat at rest. If a card needs a shadow to feel separated, the tonal contrast between scaffold and surface is too weak — fix the background, don't add a shadow.

## 5. Components

### Buttons
- **Shape:** Softly rounded — 16px for the primary elevated button, 14px for outlined.
- **Primary:** Inverted solid fill — black on white text (light), white on black text (dark). Full-width, 16px vertical padding, 600 weight, 16px text. This is the "Save expense" commit.
- **Hover / Pressed:** Standard Material ink ripple; no color shift on the fill.
- **Outlined:** Transparent fill, 1px Outline border (#CBD5E1 / #334155), 14px radius — for secondary choices.

### Chips
- **Icon chip:** A 32–42px rounded square (10–12px radius) filled with the category color at 15% opacity, holding the category icon in full color. Used in transaction rows and category group headers.

### Cards / Containers
- **Corner Style:** 20px radius — the softest corners in the system.
- **Background:** Surface (white / #161B22). Flat.
- **Shadow Strategy:** None (see Elevation).
- **Border:** None; separated from scaffold by tonal contrast.
- **Internal Padding:** 12–24px depending on content density.

### Inputs / Fields
- **Style:** Filled with Surface color, 14px radius, no visible border (`BorderSide.none`), 16×14px content padding.
- **The amount field is special:** borderless and unfilled, centered, 40px bold, with the currency symbol as a prefix. It is the focal input, not a boxed field.
- **Focus:** Standard Material focus underline suppressed on filled fields; the fill and radius carry the shape.
- **Error:** Error text in Danger (#F87171) below the field.

### Navigation
- **Bottom NavigationBar:** Surface-colored, three destinations (Home, Categories, Settings). Selected destination uses a filled Fresh Mint indicator at 18% opacity with a mint icon and 700-weight mint label; unselected icons/labels sit at 50% ink opacity. Outlined icons at rest, rounded (filled) icons when selected.

### Segmented Period Tabs (signature)
A pill-group for period selection (Last week / Last month / This month) plus a calendar icon for custom range. The track is `surfaceContainerHighest` (or white @ 6% in dark) at 14px radius with 4px inset padding. The selected segment is a solid **black (light) / white (dark)** pill at 11px radius with inverted text, animated over 150ms. This is the app's most distinctive control — it echoes the Inverted-Action language for selection.

### Floating Action Button
Fresh Mint fill with an add icon. The one lifted, one mint, one always-present affordance — the physical embodiment of "capture-first".

## 6. Do's and Don'ts

### Do:
- **Do** keep Fresh Mint to one active element per region (The One Voice Rule).
- **Do** make the amount / total the largest, boldest thing on the screen.
- **Do** use solid black/white for the primary commit button and selected tab pills.
- **Do** rely on tonal layering (Paper behind Surface) for separation; keep `elevation: 0`.
- **Do** widen letter-spacing only on the small field labels (~1.1px); nowhere else.
- **Do** default to Lempira and Spanish; both are first-class, not afterthoughts.

### Don't:
- **Don't** build the **cluttered spreadsheet**: no dense tables, no tiny cramped rows, no dumping every number on screen at once. Filter and summarize instead.
- **Don't** add shadows to cards or app bars — if a surface needs one, fix the background contrast.
- **Don't** make the primary action button mint; the brand color signals state, not action.
- **Don't** introduce a second typeface; carry hierarchy with Roboto weights and sizes.
- **Don't** wash a background in Fresh Mint or use it as a large fill.
- **Don't** let corners go sharp (0px) or oversized; stay in the 14–20px band for containers.
