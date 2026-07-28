═══════════════════════════════════════════════════════════
DESIGN CONTRACT — PolicyPal Luxury Re-Design — July 2026
═══════════════════════════════════════════════════════════

SITE TYPE: Luxury Fintech & AI Insurance Vault (High-Engineering Editorial Grade)

ONE BOLD CHOICE:
  "Atmospheric Deep Ink Black canvas with Pearl Aqua frosted-glass containers, 
   Burnt Caramel & Golden Orange glowing accents, and non-generic Playfair Display + 
   Plus Jakarta Sans typography."

TYPOGRAPHY CONTRACT:
  Display font: Playfair Display / Cormorant Garamond (Serif, 800 weight, tracking -0.03em)
  Body font: Plus Jakarta Sans (Clean geometric sans, 400/500 weight, line-height 1.7)
  Mono font: JetBrains Mono / Space Mono (for policy numbers, monetary values, timestamps)
  Display size: clamp(48px, 6vw, 84px)
  Display weight: 800
  Body size: 16px - 18px

COLOUR CONTRACT (User Palette Enforced):
  --ink-black: #001219 (Primary background canvas & deep surfaces)
  --dark-teal: #005f73 (Secondary container fills & gradient stops)
  --dark-cyan: #0a9396 (Subtle borders & active navigation glow)
  --pearl-aqua: #94d2bd (Primary text accent, high-contrast badges & links)
  --vanilla-custard: #e9d8a6 (Subtle warm highlights & active indicator text)
  --golden-orange: #ee9b00 (Primary Action CTA buttons & high-value metrics)
  --burnt-caramel: #ca6702 (Hover states & warm glowing borders)
  --rusty-spice: #bb3e03 (Warning indicators & secondary CTA fills)
  --oxidized-iron: #ae2012 (Alert badges & critical status indicators)
  --brown-red: #9b2226 (Deep alert container borders)

MOTION CONTRACT:
  Library: Framer Motion (Web) / AnimatedContainer & Hero (Flutter)
  Hero: Staggered reveal with smooth opacity scaling & floating ambient glow backdrop.
  Interactions: Subtle 1.02x scale on hover, glassmorphic border shift, smooth tab transitions.

FILE STRUCTURE:
  Web (Next.js 14 App Router in /web):
    - src/app/globals.css (Tokens & luxury CSS properties)
    - src/app/layout.js (Fonts & Root Layout)
    - src/app/page.js (Hero, Features, AI Claims Preview, Comparison Engine, Waitlist CTA)
    - src/components/Navbar.jsx
    - src/components/Hero.jsx
    - src/components/VaultShowcase.jsx
    - src/components/AiClaimsDemo.jsx
    - src/components/ComparisonSection.jsx
    - src/components/ContactForm.jsx
    - src/components/Footer.jsx
  Mobile (Flutter App in /app):
    - lib/utils/app_theme.dart (Enforces Ink Black, Pearl Aqua, Golden Orange luxury palette)
    - lib/widgets/policy_card.dart
    - lib/widgets/disclaimer_banner.dart
    - lib/screens/home/home_screen.dart
    - lib/screens/policy_vault/policy_detail_screen.dart
    - lib/screens/claims/claim_result_screen.dart

BANNED FOR THIS PROJECT:
  ❌ Pure white #ffffff or gray-100 backgrounds
  ❌ Standard blue-500 or indigo-600 buttons
  ❌ Generic Inter font display headers
  ❌ Boring 3-column white card SaaS templates
═══════════════════════════════════════════════════════════
