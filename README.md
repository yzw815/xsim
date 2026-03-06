# XSIM — SIM-Based OTP Authentication System

A SIM-based OTP authentication system for government portals, targeting Southeast Asian countries (Cambodia, Indonesia, Malaysia).

## Architecture

```
┌──────────────┐     ┌──────────────────────┐     ┌──────────────────┐
│  Flutter App  │────▶│  Cloudflare Workers   │◀────│   Web Portal     │
│  (Mobile)     │     │  (API Server)         │     │  (Cloudflare     │
│              │     │                      │     │   Pages)         │
│  Firebase FCM │◀────│  FCM HTTP v1 API      │     │                  │
└──────────────┘     └──────────────────────┘     └──────────────────┘
```

## Live URLs

| Component | URL |
|---|---|
| API Server | https://xsim-otp-server.yangzw.workers.dev |
| Web Portal | https://xsim-portal.pages.dev |
| Android App | Google Play Store (`com.zeptomobile.xsim.kh`) |
| iOS App | Apple App Store (`com.zeptomobile.xsim-cambodia`) |

## Project Structure

```
xsim/
├── app kh/          # Flutter app (Cambodia variant)
│   ├── lib/
│   │   ├── screens/
│   │   │   ├── auth_screen.dart          # Main auth flow controller
│   │   │   ├── demo_selector_screen.dart # Choose App Demo or Web Portal Demo
│   │   │   └── steps/
│   │   │       ├── step1_login.dart      # Login screen (App Demo)
│   │   │       ├── step2_phone.dart      # Phone input
│   │   │       ├── step3_authenticating.dart
│   │   │       ├── step4_flash_message.dart
│   │   │       ├── step5_success.dart
│   │   │       └── register_screen.dart  # Phone registration (Web Portal Demo)
│   │   ├── services/
│   │   │   ├── event_service.dart        # OTP events (real API / dummy mode)
│   │   │   ├── notification_service.dart # FCM + server registration
│   │   │   └── log_service.dart          # In-memory logging
│   │   └── main.dart
│   ├── android/                          # Android config
│   └── ios/                              # iOS config
├── server/          # Local Node.js server (Express + firebase-admin)
├── server-cf/       # Cloudflare Workers server (Hono + KV + FCM HTTP v1)
├── web/             # Web portal (static HTML/CSS/JS)
├── app/             # Flutter app (default variant)
├── app id/          # Flutter app (Indonesia variant)
├── app my/          # Flutter app (Malaysia variant)  
└── wap/             # Next.js web app
```

## App Demo Modes

### 📱 App Demo (Original)
5-step SIM authentication flow:
1. Login → 2. Phone Input → 3. Authenticating → 4. OTP Display → 5. Success

### 🌐 Web Portal Demo
Push notification OTP flow:
1. Register phone number in app
2. Open web portal → Enter phone → Request OTP
3. App receives push notification with OTP
4. Enter OTP on web portal → Verified!

## Development

### Run Local Server
```bash
cd server
npm install
node index.js
```

### Run Flutter App
```bash
cd "app kh"
flutter pub get
flutter run
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

### Build Release APK/AAB (Android)
```bash
cd "app kh"
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Build IPA (iOS)
```bash
cd "app kh"
flutter build ipa --release
# Output: build/ios/ipa/xsim_kh.ipa
# Upload via Transporter app
```

## Configuration

### Firebase
- Project ID: `xsimkh`
- Service account key: `server/serviceAccountKey.json`
- Cloudflare secret: `FIREBASE_SERVICE_ACCOUNT`

### Signing
- **Android**: `app kh/android/key.properties` → `app kh/android/keystore/release.jks`
- **iOS**: Automatic signing, Team ID `8RNHGXKXP4`

### Bundle IDs
- **Android**: `com.zeptomobile.xsim.kh`
- **iOS**: `com.zeptomobile.xsim-cambodia`
