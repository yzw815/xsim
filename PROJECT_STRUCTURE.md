# XSIM — Project Structure

XSIM is a **SIM-based OTP authentication system** for government portals, targeting
**Cambodia (KH)**, **Indonesia (ID)**, and **Malaysia (MY)**.

Two platforms: **Flutter mobile apps** and a **Next.js web app (WAP)**.

---

## 📂 Repository Layout

```
xsim/
│
├── app/                  📱 Flutter — Base app (Cambodia)
├── app id/               📱 Flutter — Indonesia variant
├── app kh/               📱 Flutter — Cambodia variant (Play Store build)
├── app my/               📱 Flutter — Malaysia variant
│
├── wap/                  🌐 Next.js web app
│
├── app-release.apk       📦 Pre-built Android APK
│
├── PROJECT_STRUCTURE.md  ← You are here
├── FINAL_SUMMARY.md      Project completion summary
├── PLATFORM_COMPARISON.md Flutter vs WAP comparison
├── OTP_INTEGRATION.md    OTP integration docs
├── OTP_QUICK_REFERENCE.md OTP quick reference
├── DEMO_MONITOR_GUIDE.md Demo monitoring guide
└── DEMO_QUICK_START.md   Demo quick start
```

---

## 📱 Flutter App Structure (base `app/` — 6 steps)

```
app/lib/
├── main.dart                              Entry point, MaterialApp setup
├── translations.dart                      EN/KH string translations (~35 keys)
│
├── screens/
│   ├── auth_screen.dart                   Main StatefulWidget — state manager & step routing
│   └── steps/                             One widget per authentication step
│       ├── step1_login.dart               Welcome screen + language toggle
│       ├── step2_phone.dart               Phone number entry (+855)
│       ├── step3_authenticating.dart       Loading / "Check Flash Message"
│       ├── step4_flash_message.dart        OTP input (4 individual TextFields)
│       ├── step5_verifying.dart            Server verification checklist
│       └── step6_success.dart              Success + auth token
│
├── services/
│   ├── event_service.dart                 OTP send/verify, event tracking, API/dummy modes
│   └── log_service.dart                   In-memory log queue (max 500 entries)
│
└── widgets/
    ├── flash_sms_popup.dart               Simulated flash SMS dialog (dummy mode)
    └── status_bar.dart                    Status bar widget (deprecated)
```

---

## 📱 app kh — Cambodia Variant (Play Store build)

`app kh/` is the primary **Google Play Store** build target. Same structure as base app
but has an extra `step7_dashboard.dart` that is **present in code but not reachable**
in the active user flow.

```
app kh/lib/screens/steps/
├── step1_login.dart           Welcome (Cambodia coat of arms, red/blue title)
├── step2_phone.dart           Phone entry (+855)
├── step3_authenticating.dart  Authenticating / flash message
├── step4_flash_message.dart   OTP input (4 boxes)
├── step5_verifying.dart       Verification checklist
├── step6_success.dart         Success → "Back To Home" (only button — ends flow here)
└── step7_dashboard.dart       Dashboard UI — code kept, NOT reachable from UI
```

> `step7_dashboard.dart` was removed from navigation to pass Google Play review
> ("not fully functional" rejection). The code is preserved for future use.

### app kh — Build Info

| Item | Value |
|------|-------|
| Package name | `com.zeptomobile.xsim.kh` |
| Version | `1.0.2+3` |
| Signing key | `android/keystore/release.jks` |
| App icon source | `assets/images/xsim logo.png` |
| AAB output | `build/app/outputs/bundle/release/app-release.aab` |

### app kh — Design Tokens

| Token | Hex | Usage |
|-------|-----|-------|
| Primary Blue | `#33568F` | Buttons, text |
| Dark Blue | `#1F4181` | Title text |
| Cambodia Red | `#CE2E30` | "Cambodia" title word |
| Success Green | `#16A34A` | Step 6 checkmarks |
| Error Red | `#EF4444` | OTP errors |
| Gray background | `#DBDBDB` | Steps 1, 5, 6 |
| Light blue-gray background | `#F3F6FA` | Steps 2, 3, 4 |

---

## 🔐 Active Authentication Flow (6 steps — all variants)

```
Step 1: Login
  ↓  [Login button]
Step 2: Phone Entry
  ↓  [Next]
Step 3: Authenticating (loading → triggers OTP send to phone)
  ↓  [Flash SMS popup: YES]         [NO → back to Step 2]
Step 4: OTP Input (enter 4-digit code)
  ↓  [Correct OTP → auto or manual submit]
Step 5: Verification (animated checklist)
  ↓  [Auto-advance]
Step 6: Success ("Access Granted")
  ↓  [Back To Home → resets all state → Step 1]
```

| Step | Screen | Key Behavior |
|------|--------|-------------|
| 1 | Login | Cambodia coat of arms, language toggle, Login button |
| 2 | Phone | +855 prefix, phone number input, SIM info |
| 3 | Authenticating | Loading state, "Check Flash Message", Next → triggers OTP send |
| 4 | OTP Input | 4 individual boxes, auto-focus, auto-validate, backspace nav |
| 5 | Verification | Animated checklist (signature, code, SIM, validity) |
| 6 | Success | "Access Granted", auth token badge, **"Back To Home"** only |

> ⚠️ **Step 4 info box**: Shows "Enter code: XXXX" in demo/dummy mode — remove for production.

---

## 🌐 WAP Structure (Next.js)

```
wap/
├── app/
│   ├── page.tsx              Main page — all 6 auth steps in one component (~26KB)
│   ├── layout.tsx            App layout wrapper
│   ├── globals.css           Global Tailwind styles
│   ├── api/                  Backend API routes
│   └── demo-monitor/         Monitoring display page
│
├── components/               shadcn/ui components + theme provider
├── hooks/                    React hooks
├── lib/                      Utility functions
├── styles/                   Additional style files
│
├── package.json              Dependencies (pnpm)
├── next.config.mjs           Next.js config
├── tsconfig.json             TypeScript config
└── components.json           shadcn/ui config
```

---

## 🌍 Country Variants

Each variant is a **full copy** of the base `app/` — no shared code between variants.
Changes must be replicated manually across all copies.

| Variant | Directory | Package ID | Version | Notes |
|---------|-----------|-----------|---------|-------|
| Cambodia (base) | `app/` | — | — | Primary development target |
| Indonesia | `app id/` | — | — | Title mislabeled "xsim kh" ⚠️ |
| Cambodia (Play Store) | `app kh/` | `com.zeptomobile.xsim.kh` | `1.0.2+3` | Active Play Store build |
| Malaysia | `app my/` | — | — | — |

---

## 🚀 Quick Start

### Build signed AAB (app kh — Play Store)
```bash
cd "app kh"
flutter pub get
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Run for development
```bash
cd "app kh"    # or app / "app id" / "app my"
flutter pub get
flutter run -d chrome
```

### Regenerate app icon
```bash
cd "app kh"
flutter pub run flutter_launcher_icons
```

### WAP
```bash
cd wap
pnpm install
pnpm dev      # → http://localhost:3000
```

---

## 📚 Per-Variant Documentation

Each Flutter variant contains these docs:

| File | Purpose |
|------|---------|
| `README.md` | Project overview |
| `SETUP.md` | Setup instructions |
| `QUICK_START.md` | Quick start commands |
| `CHANGELOG.md` | Version history |
| `STEP4_DESIGN.md` | OTP input design docs |
| `BUILD_ANDROID_APK.md` | Android build guide |
| `ANDROID_TROUBLESHOOTING.md` | Android troubleshooting |
| `IOS_SETUP.md` | iOS setup guide |
| `FIX_XCODE.md` | Xcode fix instructions |
