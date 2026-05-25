# Nyzora Wallpaper 4K

Premium HD & 4K wallpaper app for Android and iOS. Tagline: **Walls That Speak**.

## Features

- Unsplash, Wallhaven (SFW `purity=100`), and Peapix feeds
- AMOLED dark theme, glassmorphism UI, Riverpod state
- Favorites (Hive), search, categories, download & set wallpaper
- Dynamic color extraction on detail screen

## Setup

1. Install Flutter SDK `>=3.38.0`
2. Get API keys: [Unsplash](https://unsplash.com/developers), [Wallhaven](https://wallhaven.cc/help/api)
3. Run with keys:

```bash
cd wallie_4k_wallpapers
flutter pub get
flutter run \
  --dart-define=UNSPLASH_KEY=your_unsplash_access_key \
  --dart-define=WALLHAVEN_KEY=your_wallhaven_api_key
```

Optional dev keys file (gitignored): `lib/core/constants/env.dart`

## Release (Play Store)

Signing uses `android/keystore.properties` and `android/nyzora-wallpaper-production.keystore` (gitignored). After those files exist:

```bash
# AAB (Play Store upload)
cd android && ./gradlew :app:bundleRelease && cd ..
# Output: build/app/outputs/bundle/release/app-release.aab

# APK (local testing)
cd android && ./gradlew :app:assembleRelease && cd ..
# Output: build/app/outputs/apk/release/app-release.apk
```

Or via Flutter (requires Android cmdline-tools for AAB symbol check):

```bash
flutter build appbundle --release \
  --dart-define=UNSPLASH_KEY=your_key \
  --dart-define=WALLHAVEN_KEY=your_key
```

Before submission:

- Host Privacy Policy URL and update `AppConstants.privacyPolicyUrl`
- Generate icons: `dart run flutter_launcher_icons`
- Generate splash: `dart run flutter_native_splash:create`
- `targetSdk 35`, signed AAB, Data Safety form, content rating (IARC)
- Closed testing: 14 days, minimum 12 testers (new developer accounts)

## Package

`com.nyzora.wallpaper`
