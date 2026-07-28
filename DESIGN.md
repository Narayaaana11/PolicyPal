# PolicyPal Luxury Design System (`DESIGN.md`)

## Section 1 — Visual Theme & Atmosphere
PolicyPal delivers an ultra-premium, institutional-grade dark fintech atmosphere. Built for discerning policyholders, the visual language relies on an atmospheric Ink Black canvas, deep teal container fills, frosted-glass borders, and high-visibility Golden Orange action accents. Typography combines regal Playfair Display headers with clean Plus Jakarta Sans body hierarchy.

## Section 2 — Color Palette & Roles

| Token | Hex | Role |
|-------|-----|------|
| `--color-ink-black` | `#001219` | Primary Canvas & Page Background |
| `--color-dark-teal` | `#005F73` | Surface Gradient Stops & Fills |
| `--color-dark-cyan` | `#0A9396` | Frosted Glass Borders & Active Rings |
| `--color-pearl-aqua` | `#94D2BD` | Secondary Text, Badges & Metadata |
| `--color-vanilla-custard` | `#E9D8A6` | Highlight Indicators & Warm Subtitles |
| `--color-golden-orange` | `#EE9B00` | Primary Action CTAs & Key Metrics |
| `--color-burnt-caramel` | `#CA6702` | Button Hover & Warm Accent Fills |
| `--color-rusty-spice` | `#BB3E03` | Secondary Warnings & Badges |
| `--color-oxidized-iron` | `#AE2012` | Critical Legal Disclaimers & Alert Borders |
| `--color-brown-red` | `#9B2226` | Deep Alert Surface Containers |

## Section 3 — Typography Rules

| Role | Font | Size | Weight | Line Height | Tracking |
|------|------|------|--------|-------------|----------|
| Display | Playfair Display | 32px | 800 | 1.15 | -0.03em |
| H1 | Playfair Display | 26px | 800 | 1.20 | -0.02em |
| H2 | Playfair Display | 20px | 700 | 1.25 | -0.01em |
| Body | Plus Jakarta Sans | 15px | 400 | 1.60 | 0.00em |
| Caption | Plus Jakarta Sans | 13px | 500 | 1.40 | 0.01em |
| Mono / Numbers | JetBrains Mono | 14px | 700 | 1.20 | 0.02em |

## Section 4 — Component Styling

### Primary Action Button
- Background: Gradient from `#EE9B00` (Golden Orange) to `#CA6702` (Burnt Caramel)
- Text Color: `#001219` (Ink Black, Bold 700)
- Border Radius: 12px
- Padding: 16px × 24px
- Elevation: 4dp shadow with gold ambient glow

### Vault Card Container
- Background: `#00222E` (Deep Teal Fill)
- Border: 1px solid `#0A9396` (Dark Cyan)
- Border Radius: 16px
- Padding: 16px × 20px

### AI Disclaimer Alert Banner
- Background: `#1A0809` (Deep Oxidized Fills)
- Border: 1px solid `#AE2012` (Oxidized Iron)
- Text Color: `#E9D8A6` (Vanilla Custard)

## Section 5 — Layout Principles
- Spacing scale: 8px base grid (8px, 12px, 16px, 24px, 32px, 48px).
- Density: Data-dense, clean metadata formatting with high contrast metrics.

## Section 6 — Depth & Elevation
- Level 0 (Canvas): Flat Ink Black (`#001219`).
- Level 1 (Card): `#00222E` with 1px Dark Cyan border.
- Level 2 (Modal / Sheet): `#001A24` with 2px Golden Orange border glow.

## Section 7 — Do's and Don'ts
- ✅ DO: Use high-contrast Golden Orange for all primary action paths.
- ✅ DO: Display mandatory legal disclaimers prominently on all AI guidance views.
- ❌ DON'T: Use plain white backgrounds (`#FFFFFF`) or generic blue SaaS buttons.
- ❌ DON'T: Hide policy exclusions in small print; use distinct red warning icons.

## Section 8 — Agent Prompt Guide
- "Build a policy detail screen using PolicyPal DESIGN.md dark luxury tokens."
