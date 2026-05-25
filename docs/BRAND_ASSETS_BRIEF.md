# Nyzora Wallpaper 4K — Brand & Asset Creative Brief

Use this document when generating assets in Midjourney, DALL·E, Leonardo, Ideogram, Firefly, or similar tools. Copy the **Master Brand Summary** and the relevant **Prompt Block** for each asset type.

---

## 1. Project Overview

| Field | Value |
|--------|--------|
| **App name** | Nyzora Wallpaper 4K |
| **Tagline** | Walls That Speak |
| **Package ID** | `com.nyzora.wallpaper` |
| **Category** | Personalization / Wallpapers |
| **Platform** | Android (primary), iOS |
| **Positioning** | Premium HD & 4K wallpaper app — curated, fast, dark-first, production-quality |

### What the app does
- Browse trending, latest, and category wallpapers (Nature, Space, Abstract, Animals, City, and more)
- Daily picks from Bing / Spotlight-style feeds
- Search across Unsplash, Wallhaven, and curated sources
- Download in HD / Full HD / 4K
- Favorites, categories, AMOLED-friendly UI
- Set wallpapers on device (Android)

### Target audience
- Ages 16–35, phone-first users who care about home-screen aesthetics
- Users who want **high-resolution**, **portrait** wallpapers (phone lock/home screens)
- Dark-mode and AMOLED enthusiasts
- People who browse Pinterest/Behance/Unsplash for inspiration but want one dedicated app

### Brand personality
- **Premium** but approachable (not corporate, not childish)
- **Modern & minimal** — clean UI, lots of negative space on black
- **Bold accents** — violet/indigo glow on dark surfaces
- **Immersive** — wallpapers are the hero; UI stays out of the way
- **Trustworthy** — polished, no clutter, no aggressive gamification

### What we are NOT
- Not cartoonish or mascot-heavy
- Not neon cyberpunk overload (accent only, not full aesthetic)
- Not stock-photo generic “mountain sunset” cliché as the *logo*
- Not busy gradients with 5+ colors in the icon

---

## 2. Color System (use these exact values)

### Primary brand colors (accents)
| Role | Hex | RGB | Usage |
|------|-----|-----|--------|
| **Primary accent** | `#7C3AED` | 124, 58, 237 | Buttons, active nav, badges, icon highlights |
| **Secondary accent** | `#4F46E5` | 79, 70, 229 | Gradient end, secondary UI |
| **Brand gradient** | `#7C3AED` → `#4F46E5` | top-left to bottom-right | Logo, chips, featured elements |

### Backgrounds (default theme: dark / AMOLED)
| Role | Hex | Usage |
|------|-----|--------|
| **App background** | `#000000` | True black AMOLED |
| **Surface** | `#0D0D0D` | Cards, panels |
| **Surface variant** | `#141414` | Icon buttons, chips (inactive) |
| **Hero gradient top** | `#0D0D2B` | Header / splash fade |
| **Hero gradient bottom** | `#000000` | Fade to black |

### Text
| Role | Hex |
|------|-----|
| Primary text | `#F8F8F8` |
| Secondary text | `#9B9BA0` |
| Tertiary / muted | `#5A5A60` |

### Supporting accents (optional in marketing, not required in icon)
| Name | Hex |
|------|-----|
| Cyan | `#06B6D4` |
| Amber | `#F59E0B` |
| Emerald | `#10B981` |
| Rose | `#F43F5E` |

### Light mode (secondary)
| Role | Hex |
|------|-----|
| Background | `#F0F0F5` |
| Surface | `#FFFFFF` |
| Primary text | `#0D0D1A` |

### Category mood colors (for featured/marketing imagery only)
- **Nature:** `#134E5E` → `#71B280`
- **Space:** `#0F0C29` → `#302B63`
- **Abstract:** `#8E2DE2` → `#4A00E0`
- **Neon:** `#0D0221` → `#1A0533`

---

## 3. Typography (for any text in graphics)

| Use | Font | Style |
|-----|------|--------|
| UI / body | **Plus Jakarta Sans** | Clean, geometric, friendly |
| Headlines / display | **Space Grotesk** | Tech-forward, slightly futuristic |

**In generated images:** If text appears, prefer geometric sans-serif similar to Space Grotesk. App name spelling: **Nyzora** (not Nyzorra, Nizora, or Nyxora).

---

## 4. UI & Visual Language (for consistency)

- **Shape language:** Rounded rectangles (12–16px radius feel), pill chips, soft cards
- **Effects:** Subtle glass blur on nav bar; soft purple glow on active elements (`#7C3AED` at ~20% opacity blur)
- **Iconography in app:** Material rounded style; home uses a simple wallpaper/grid motif
- **Imagery in app:** Full-bleed portrait wallpapers, staggered grids, horizontal carousels
- **Overall feel:** Apple-quality dark app meets Unsplash curation — calm, premium, violet accent

---

## 5. Asset Specifications

### A. App icon (required outputs)

| Platform | Size | Notes |
|----------|------|--------|
| **Master icon** | **1024 × 1024 px** | PNG, no transparency for iOS master |
| **Android adaptive foreground** | **1024 × 1024 px** | Subject centered in **66% safe zone**; transparent PNG |
| **Android adaptive background** | Solid `#000000` | No image needed if AI only does foreground |

**Design rules for icon:**
- Readable at **29×29 px** (must survive tiny size)
- Simple symbol: 1 main idea (e.g. stylized “N”, wallpaper frame, or abstract portal/window)
- Works on **pure black** `#000000` background
- Primary colors: violet `#7C3AED` and indigo `#4F46E5` gradient
- No fine text, no “4K” tiny letters, no photographic wallpaper inside icon (too busy)
- Avoid Android/iOS default green or Material blue

**Post-processing:** Save as `assets/images/app_icon.png` and `assets/images/app_icon_foreground.png`, then run:
```bash
dart run flutter_launcher_icons
```

---

### B. Splash logo (optional refresh)

| Spec | Value |
|------|--------|
| Size | **512 × 512 px** or **1024 × 1024 px** PNG |
| Background | Transparent or designed for `#000000` |
| File | `assets/images/splash_logo.png` |

Centered mark only — same as icon symbol, can be slightly more detailed.

---

### C. Google Play Feature Graphic (featured image)

| Spec | Value |
|------|--------|
| Size | **1024 × 500 px** (required) |
| Format | PNG or JPG (24-bit, no alpha required) |
| Safe zone | Keep logo and text inside center **80%**; edges may crop on some devices |

**Content suggestions:**
- Left or center: app icon symbol + wordmark **“Nyzora”** or **“Nyzora 4K”**
- Tagline: **“Walls That Speak”** (optional, small)
- Right side: collage of **3–4 vertical phone wallpaper previews** (abstract, space, nature) with rounded corners
- Background: deep black `#000000` with subtle violet glow `#7C3AED` / indigo mist
- Mood: premium, cinematic, dark

**Avoid:** Play Store badge clones, “Free Download” text, cluttered 10-image grids, white backgrounds.

---

### D. Promo / social (optional)

| Asset | Size |
|--------|------|
| Square post | 1080 × 1080 px |
| Story | 1080 × 1920 px |
| Screenshot frame | Use real app UI on `#000000` background |

---

## 6. AI Prompt Templates

Replace `[STYLE]` with your tool’s style tokens. Generate **4–8 variants**, then pick the cleanest at small size.

### App icon — Prompt A (abstract mark)
```
App icon design for a premium mobile wallpaper app named "Nyzora". 
Minimal flat vector logo mark: stylized letter N formed by two overlapping vertical wallpaper panels or window frames. 
Gradient from electric violet #7C3AED to deep indigo #4F46E5. 
Pure black background #000000. 
Rounded geometric shapes, subtle soft glow, no text, no photograph. 
Material Design 3 quality, centered, symmetrical, high contrast. 
1024x1024, icon style, professional app store icon --no realistic photo, no tiny details, no white background
```

### App icon — Prompt B (portal / frame)
```
Minimal app icon, abstract rounded rectangle portal frame with inner gradient sky hint (purple to indigo only). 
Symbol for 4K HD wallpapers app. Colors #7C3AED and #4F46E5 on #000000 black. 
Flat modern vector, glossy subtle highlight, iOS app icon quality, centered, simple silhouette readable at small size --no text, no clutter, no cartoon
```

### App icon — Prompt C (wallpaper sheet)
```
Sleek app icon: three stacked rounded cards suggesting wallpaper layers, top card with soft violet-indigo gradient abstract waves. 
Dark luxury aesthetic, black background, accent colors #7C3AED #4F46E5. 
Minimal vector, premium personalization app, 1024x1024 --no words, no realistic landscape photo
```

### Google Play Feature Graphic — Prompt
```
Google Play feature banner 1024x500, dark premium mobile app marketing. 
Brand "Nyzora Wallpaper 4K", tagline "Walls That Speak". 
Black background #000000, violet glow #7C3AED, indigo #4F46E5 accents. 
Left: glowing minimal app logo. Right: three vertical smartphone wallpaper previews in rounded frames (space galaxy, abstract purple waves, nature mountains). 
Modern sans-serif typography, Space Grotesk style, clean layout, lots of negative space, no Play Store UI, no badges --ar 1024:500
```

### Negative prompt (use when supported)
```
text errors, misspelled Nyzora, white background, busy collage, stock watermark, 
low resolution, blurry, 3D mascot character, anime face, Apple logo, Android robot, 
green blue default colors, bevel emboss 2000s style, photographic noise in icon
```

---

## 7. Reference Keywords for Image Tools

**Include:** premium, minimal, dark mode, AMOLED black, violet gradient, indigo, geometric, vector icon, app store, wallpaper layers, portrait phone, 4K quality, cinematic, modern UI, glassmorphism hint, soft glow

**Exclude:** cluttered, playful cartoon, light pastel background, corporate stock photo, rainbow overload, skeuomorphic leather texture

---

## 8. Checklist Before Importing Into Project

- [ ] Icon readable at thumbnail size
- [ ] Works on `#000000` background (Android adaptive)
- [ ] Colors match `#7C3AED` / `#4F46E5` (adjust in Figma if needed)
- [ ] No embedded text “4K” unless large and intentional
- [ ] Feature graphic is exactly **1024×500**
- [ ] Export PNG, sRGB color profile
- [ ] Place files:
  - `assets/images/app_icon.png`
  - `assets/images/app_icon_foreground.png`
  - `assets/images/splash_logo.png` (optional)
- [ ] Run `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`

---

## 9. One-Line Elevator Pitch (for AI context)

> **Nyzora Wallpaper 4K** is a premium dark-mode Android wallpaper app that delivers curated HD and 4K portrait backgrounds with a violet–indigo accent on true black, built for users who want a beautiful, fast, minimal home-screen experience.

---

*Document version: 1.0 — aligned with `app_colors.dart`, `app_constants.dart`, and Play Store asset requirements.*
