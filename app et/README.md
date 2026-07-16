# XSIM Ethiopia - Government Portal Authentication App

A Flutter mobile application for Ethiopia Government Portal authentication using XSIM flash SMS technology. This app demonstrates SIM-based OTP verification via a real SMS gateway.

## Features

- **Bilingual Support**: English & Amharic with language toggle
- **Real Flash SMS OTP**: Sends OTP via gateway API (`gw1.ultronvodatz.com`) — not a dummy popup
- **7-Step Authentication Flow**:
  1. Login screen with Ethiopian national emblem
  2. Phone number input (editable prefix, default +255)
  3. Authenticating — spinner while OTP is sent
  4. OTP entry — user enters the code received via flash SMS
  5. Verifying (auto-advance)
  6. Success screen
  7. Dashboard with Fayda National ID card
- **Early OTP Trigger**: OTP is sent immediately when the user clicks Continue on the login screen (no extra tap required)
- **Editable Country Prefix**: Users can change the prefix (e.g. +251 Ethiopia, +255 Tanzania) for testing
- **In-App Log Viewer**: Debug FAB button shows all API requests, responses, and OTP events with share/copy functionality
- **Custom App Icon**: XSIM branded icon for both Android and iOS

## App Identifiers

| Platform | Identifier |
|----------|------------|
| Android  | `com.zeptomobile.xsim.et` |
| iOS      | `com.zeptomobile.xsim.et` |
| Display Name | XSIM Ethiopia |
| Current Version | 1.0.0+4 |

## Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Xcode (for iOS builds)
- Android Studio (for Android builds)

### Run

```bash
cd "app et"
flutter pub get

# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Chrome (web)
flutter run -d chrome
```

## Project Structure

```
app et/
├── lib/
│   ├── main.dart                        # App entry point
│   ├── translations.dart                # English & Amharic translations
│   ├── screens/
│   │   ├── auth_screen.dart             # Main flow controller & state management
│   │   ├── log_viewer_screen.dart       # In-app API/OTP log viewer
│   │   └── steps/
│   │       ├── step1_login.dart         # Login with Ethiopia emblem
│   │       ├── step2_phone.dart         # Phone input (editable prefix + number)
│   │       ├── step3_authenticating.dart # Spinner while OTP sends
│   │       ├── step4_flash_message.dart # OTP code entry (4 digits)
│   │       ├── step5_verifying.dart     # Verification animation
│   │       ├── step6_success.dart       # Auth success
│   │       └── step7_dashboard.dart     # Dashboard with Fayda ID card
│   ├── services/
│   │   ├── event_service.dart           # OTP generation, API calls, verification
│   │   └── log_service.dart             # In-memory log storage
│   └── widgets/
│       └── flash_sms_popup.dart         # Flash SMS popup (dummy mode only)
├── assets/
│   ├── images/
│   │   └── ethiopia_emblem.png          # Ethiopian national emblem
│   └── icon/
│       └── app_icon.png                 # XSIM app icon (1024px)
├── android/
│   └── app/
│       ├── build.gradle.kts             # Package: com.zeptomobile.xsim.et
│       └── src/main/
│           ├── AndroidManifest.xml      # Label: XSIM Ethiopia
│           └── kotlin/.../MainActivity.kt
├── ios/
│   ├── Runner/Info.plist                # Bundle: com.zeptomobile.xsim.et
│   └── Runner.xcodeproj/project.pbxproj # Team: 8RNHGXKXP4
├── pubspec.yaml                         # Dependencies & icon config
└── README.md                            # This file
```

## OTP Gateway Integration

The app sends real OTP messages via the XSIM gateway:

- **Endpoint**: `POST https://gw1.ultronvodatz.com/send/campaign/msisdn`
- **Request Body**:
  ```json
  {
    "msisdn": "255745721380",
    "type": 1,
    "message": "Your verification code is 1234. It will expire in 5 minutes. Keep this code confidential."
  }
  ```
- **MSISDN Format**: Digits only (no `+` or spaces)
- **Timeout**: 30 seconds
- **Rate Limiting**: The gateway has per-MSISDN cooldown; repeated requests to the same number may hang/timeout

### OTP Flow

1. User clicks **Continue** on login screen
2. App generates a random 4-digit OTP client-side
3. App sends OTP to gateway API with the entered phone number
4. User receives flash SMS on their phone
5. User enters OTP code in the app
6. App verifies locally (compares entered code with generated code)

### OTP Modes

Configured in `event_service.dart`:
- `OtpMode.realApi` (default) — sends via gateway
- `OtpMode.dummy` — shows in-app popup (for offline testing)

## Authentication Flow

```
Step 1 (Login) ──Continue──▶ Step 3 (Authenticating) ──OTP sent──▶ Step 4 (Enter OTP)
                                     │                                    │
                                     │ (on failure)                       │ (correct OTP)
                                     ▼                                    ▼
                              Step 2 (Edit Phone)               Step 5 (Verifying)
                                     │                                    │
                                     │ Continue                           ▼
                                     └──────▶ Step 3              Step 6 (Success)
                                                                          │
                                                                          ▼
                                                                  Step 7 (Dashboard)
```

## Building for Production

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS IPA (for TestFlight)
```bash
flutter build ipa --release
# Output: build/ios/ipa/XSIM Ethiopia.ipa
# Upload via Transporter app to App Store Connect
```

### Regenerate App Icons
```bash
dart run flutter_launcher_icons
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `http` | HTTP client for OTP gateway API |
| `google_fonts` | Custom typography |
| `share_plus` | Share logs from log viewer |
| `cupertino_icons` | iOS-style icons |
| `flutter_launcher_icons` | App icon generation (dev) |

## Signing

- **Android**: Uses debug signing (no keystore configured yet)
- **iOS**: Automatic signing, Team ID `8RNHGXKXP4`

## Related Variants

| Variant | Directory | Country | Status |
|---------|-----------|---------|--------|
| Cambodia | `app kh/` | KH | Original, dual-demo mode |
| Indonesia | `app id/` | ID | Dummy OTP |
| Malaysia | `app my/` | MY | Dummy OTP |
| **Ethiopia** | **`app et/`** | **ET** | **Real OTP via gateway** |
