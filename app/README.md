# XSIM Flutter App — Cambodia (Base)

Flutter mobile app for SIM-based OTP authentication with the Cambodia Government Portal.

---

## Quick Start

```bash
flutter pub get
flutter run -d chrome          # Fastest for dev
```

Other targets: `macos`, `ios`, `android`

---

## Project Structure

```
lib/
├── main.dart                              Entry point, MaterialApp with Material 3
├── translations.dart                      EN/KH string translations (~35 keys)
│
├── screens/
│   ├── auth_screen.dart                   StatefulWidget — manages all state & step routing
│   └── steps/
│       ├── step1_login.dart               Welcome screen + language toggle
│       ├── step2_phone.dart               Phone number entry (+855)
│       ├── step3_authenticating.dart       Loading screen, user clicks Next → sends OTP
│       ├── step4_flash_message.dart        OTP input — 4 TextFields, auto-focus, auto-validate
│       ├── step5_verifying.dart            Server verification checklist (animated)
│       └── step6_success.dart             Success screen + auth token
│
├── services/
│   ├── event_service.dart                 OTP send/verify + event tracking
│   └── log_service.dart                   In-memory structured logging
│
└── widgets/
    ├── flash_sms_popup.dart               Simulated flash SMS dialog (dummy OTP mode)
    └── status_bar.dart                    Status bar widget (deprecated, not shown in UI)
```

---

## How It Works

### State Management (`auth_screen.dart`)
- Single `StatefulWidget` holds: `_step` (1–6), `_language`, `_phoneNumber`, `_sentOtp`
- `_buildCurrentStep()` renders the widget for the current step
- Each step widget receives callbacks and data as props

### OTP Modes (`event_service.dart`)
- **`OtpMode.dummy`** (default) — generates a random 4-digit OTP locally, shows `FlashSmsPopup`
- **`OtpMode.realApi`** — calls the SODA Campaign API to send a real SMS OTP
- Switch modes via `EventService().setOtpMode(OtpMode.realApi)`

### Event Tracking
`EventService` tracks user journey with methods like:
`appOpened()` → `loginClicked()` → `phoneEntered()` → `otpRequested()` → `codeEntered()` → `verifying()` → `authSuccess()`

### Logging (`log_service.dart`)
- In-memory queue (max 500 entries) with levels: INFO, SUCCESS, ERROR, WARNING
- Categories: OTP, API, AUTH, SYSTEM
- OTP helpers: `otpSending()`, `otpSent()`, `otpVerified()`, `otpVerificationFailed()`
- Export: `exportLogs()` (string), `exportLogsAsJson()`

### Translations (`translations.dart`)
- Static map: `{ 'en': { ... }, 'km': { ... } }`
- Access: `Translations.get('en', 'loginBtn')` → `"Login"`
- Toggle between EN/KH at runtime

---

## Auth Flow

```
Step 1  Login           →  Language toggle, Login button
Step 2  Phone           →  +855 prefix, phone number validation
Step 3  Authenticating  →  Loading, click Next → sends OTP via EventService
    ↳ Dummy mode: FlashSmsPopup appears (YES → Step 4, NO → Step 2)
    ↳ Real mode: Waits for SMS, auto-advances to Step 4
Step 4  OTP Input       →  4-digit entry, auto-focus, auto-validate
Step 5  Verification    →  Animated checklist (signature, code, SIM, validity)
Step 6  Success         →  Auth token, dashboard / reset
```

---

## Design Tokens

```dart
final Color primaryBlue   = const Color(0xFF1E40AF);  // Buttons, headers
final Color darkBlue      = const Color(0xFF1E3A8A);  // Backgrounds
final Color successGreen  = const Color(0xFF16A34A);  // Success states
```

These are defined in `auth_screen.dart` and passed to step widgets as props.

---

## Build for Production

```bash
flutter build web                # → build/web/
flutter build apk                # → build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle          # → build/app/outputs/bundle/release/ (Play Store)
flutter build ios                # Needs Xcode + Apple Developer
flutter build macos              # Needs Xcode CLI tools
```

---

## Related

- **WAP (web version)**: `../wap/` — Next.js + TypeScript + Tailwind CSS
- **Other country variants**: `../app id/`, `../app kh/`, `../app my/`
- **Docs**: `SETUP.md`, `QUICK_START.md`, `STEP4_DESIGN.md`, `BUILD_ANDROID_APK.md`

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter 3.38.2 |
| Language | Dart |
| UI | Material Design 3 |
| State | StatefulWidget |
| HTTP | `package:http` |
| Platforms | iOS, Android, Web, macOS, Windows, Linux |
