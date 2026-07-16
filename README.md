# XSIM — SIM-Based OTP Authentication System

A SIM-based OTP authentication system for government portals. Each country variant is a standalone Flutter app with localized branding, translations, and (optionally) real flash SMS gateway integration.

## Architecture

```
┌──────────────────┐      ┌────────────────────────┐      ┌──────────────────┐
│  Flutter App     │─────▶│  OTP Gateway            │      │  Web Portal      │
│  (Mobile)        │      │  (gw1.ultronvodatz.com) │      │  (Cloudflare     │
│                  │      │                         │      │   Pages)         │
│  Firebase FCM    │◀─────│  Cloudflare Workers     │      │                  │
└──────────────────┘      │  (API Server)           │◀─────└──────────────────┘
                          └────────────────────────┘
```

## Country Variants

| Variant | Directory | Package ID | Languages | OTP Mode | Status |
|---------|-----------|------------|-----------|----------|--------|
| Cambodia | `app kh/` | `com.zeptomobile.xsim.kh` | English, Khmer | Dummy + Push Notification | Production (Play Store + App Store) |
| Indonesia | `app id/` | `com.zeptomobile.xsim.id` | English, Bahasa Indonesia | Dummy | Built |
| Malaysia | `app my/` | `com.zeptomobile.xsim.my` | English, Malay | Dummy | Built |
| **Ethiopia** | **`app et/`** | **`com.zeptomobile.xsim.et`** | **English, Amharic** | **Real Flash SMS (gateway)** | **Active development** |

### Ethiopia (`app et/`) — Latest

The most actively developed variant. Key features:

- **Real OTP via flash SMS gateway** (`gw1.ultronvodatz.com`)
- **Early OTP trigger** — OTP fires immediately after login, no extra tap
- **Editable country prefix** — test with different country numbers (+251 ET, +255 TZ, etc.)
- **In-app log viewer** — debug FAB shows all API requests/responses with share/copy
- **Ethiopian branding** — national emblem, Fayda ID card, Amharic translations
- **Custom XSIM app icon** for Android and iOS
- **TestFlight + APK builds** available (v1.0.0+4)

See [`app et/README.md`](app%20et/README.md) for full details.

## Project Structure

```
xsim/
├── app kh/          # Flutter app — Cambodia variant
│   ├── lib/
│   │   ├── screens/
│   │   │   ├── auth_screen.dart          # Main auth flow controller
│   │   │   ├── demo_selector_screen.dart # Choose App Demo or Web Portal Demo
│   │   │   └── steps/                    # Step screens
│   │   ├── services/
│   │   │   ├── event_service.dart        # OTP events (real API / dummy mode)
│   │   │   ├── notification_service.dart # FCM + server registration
│   │   │   └── log_service.dart          # In-memory logging
│   │   └── main.dart
│   ├── android/                          # Android config
│   └── ios/                              # iOS config
│
├── app et/          # Flutter app — Ethiopia variant (ACTIVE)
│   ├── lib/
│   │   ├── screens/
│   │   │   ├── auth_screen.dart          # Main flow (early OTP trigger)
│   │   │   ├── log_viewer_screen.dart    # In-app API/OTP log viewer
│   │   │   └── steps/                    # 7-step auth flow
│   │   ├── services/
│   │   │   ├── event_service.dart        # Real OTP via gateway API
│   │   │   └── log_service.dart          # In-memory logging
│   │   └── main.dart
│   ├── assets/
│   │   ├── images/ethiopia_emblem.png    # National emblem
│   │   └── icon/app_icon.png            # XSIM app icon
│   ├── android/                          # Package: com.zeptomobile.xsim.et
│   └── ios/                              # Bundle: com.zeptomobile.xsim.et
│
├── app id/          # Flutter app — Indonesia variant
├── app my/          # Flutter app — Malaysia variant
├── app/             # Flutter app — Default/base variant
├── server/          # Local Node.js server (Express + firebase-admin)
├── server-cf/       # Cloudflare Workers server (Hono + KV + FCM HTTP v1)
├── web/             # Web portal (static HTML/CSS/JS)
└── wap/             # Next.js web app
```

## Live URLs

| Component | URL |
|-----------|-----|
| API Server | https://xsim-otp-server.yangzw.workers.dev |
| Web Portal | https://xsim-portal.pages.dev |
| Android App (KH) | Google Play Store (`com.zeptomobile.xsim.kh`) |
| iOS App (KH) | Apple App Store (`com.zeptomobile.xsim-cambodia`) |
| iOS App (ET) | TestFlight (`com.zeptomobile.xsim.et`) |

## Development

### Run Flutter App (any variant)

```bash
cd "app et"    # or "app kh", "app id", "app my"
flutter pub get
flutter run
```

### Build Release APK

```bash
cd "app et"
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build IPA for TestFlight

```bash
cd "app et"
flutter build ipa --release
# Output: build/ios/ipa/XSIM Ethiopia.ipa
# Upload via Transporter app
```

### Deploy Server (Cloudflare Workers)

```bash
cd server-cf
npm install
wrangler deploy
```

### Deploy Web Portal (Cloudflare Pages)

```bash
cd web
wrangler pages deploy . --project-name xsim-portal
```

## OTP Modes

| Mode | Description | Used By |
|------|-------------|---------|
| `dummy` | Shows OTP in an in-app popup (no real SMS) | KH, ID, MY |
| `realApi` | Sends OTP via flash SMS gateway | **ET** |
| Push Notification | OTP via Firebase FCM push | KH (Web Portal Demo) |

### Flash SMS Gateway (Real API)

- **Endpoint**: `POST https://gw1.ultronvodatz.com/send/campaign/msisdn`
- **Body**: `{ "msisdn": "255745721380", "type": 1, "message": "Your verification code is ..." }`
- **Note**: Gateway has per-MSISDN rate limiting; wait between retries to same number

## Configuration

### Firebase (Cambodia variant)
- Project ID: `xsimkh`
- Service account key: `server/serviceAccountKey.json`
- Cloudflare secret: `FIREBASE_SERVICE_ACCOUNT`

### Signing
- **Android (KH)**: `app kh/android/key.properties` → `app kh/android/keystore/release.jks`
- **Android (ET)**: Debug signing (no keystore yet)
- **iOS**: Automatic signing, Team ID `8RNHGXKXP4`

### Bundle IDs
| Variant | Android | iOS |
|---------|---------|-----|
| Cambodia | `com.zeptomobile.xsim.kh` | `com.zeptomobile.xsim-cambodia` |
| Indonesia | `com.zeptomobile.xsim.id` | `com.zeptomobile.xsim.id` |
| Ethiopia | `com.zeptomobile.xsim.et` | `com.zeptomobile.xsim.et` |
