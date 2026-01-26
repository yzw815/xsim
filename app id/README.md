# Indonesia Government Portal - XSIM Authentication Mobile App

A Flutter mobile application for Indonesia Government Portal authentication using XSIM technology.

## Features

- **Bilingual Support**: English & Bahasa Indonesia with language toggle
- **6-Step Authentication Flow**:
  1. Initial login screen with Garuda Pancasila emblem
  2. Phone number input (+62 prefix)
  3. Authenticating (loading animation)
  4. SIM flash message popup with challenge code
  5. Server verification
  6. Success screen with auth token
- **Cross-Platform**: Runs on iOS, Android, Web, macOS, Windows, Linux
- **Smooth Animations**: Auto-transitions and loading states
- **Modern UI**: Clean, professional design matching Indonesia government branding

## Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+

### Installation

1. Navigate to the app directory:
```bash
cd "/Users/yang/zeptosourcecode/xsim/app id"
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# Web (Chrome) - Fastest for development
flutter run -d chrome

# macOS Desktop
flutter run -d macos

# iOS Simulator (requires Xcode)
flutter run -d ios

# Android Emulator (requires Android Studio)
flutter run -d android
```

## Project Structure

```
app id/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── translations.dart            # English & Bahasa Indonesia translations
│   ├── screens/
│   │   ├── auth_screen.dart        # Main state management
│   │   └── steps/                  # Individual step screens
│   │       ├── step1_login.dart    # Initial login (Garuda Pancasila)
│   │       ├── step2_phone.dart    # Phone input (+62)
│   │       ├── step3_authenticating.dart  # Loading
│   │       ├── step4_flash_message.dart   # SIM popup
│   │       ├── step5_verifying.dart       # Verification
│   │       ├── step6_success.dart         # Success
│   │       └── step7_dashboard.dart       # Dashboard with KTP
│   └── widgets/
│       └── status_bar.dart         # Reusable status bar
├── assets/
│   └── images/
│       ├── indonesia_garuda_pancasila.png  # National emblem
│       ├── indonesia_ktp_card.png          # KTP ID card
│       └── ...
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

## Authentication Flow

1. **Step 1 - Login**: User sees welcome screen with Garuda Pancasila emblem and language toggle
2. **Step 2 - Phone Input**: User enters mobile number (+62)
3. **Step 3 - Authenticating**: Loading state (3s auto-advance)
4. **Step 4 - Flash Message**: SIM card popup with challenge code (YES/NO)
5. **Step 5 - Verifying**: Server verification (3s auto-advance)
6. **Step 6 - Success**: Authentication complete with token
7. **Step 7 - Dashboard**: View KTP (Kartu Tanda Penduduk) and profile

## Building for Production

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
# Requires Xcode and Apple Developer account
```

## App Icon for Play Store

The app uses the **Garuda Pancasila** (Indonesia's national emblem) as the logo.

**Location**: `assets/images/indonesia_garuda_pancasila.png`

For Play Store upload, you need:
- **App Icon**: 512 x 512 px PNG
- **Feature Graphic**: 1024 x 500 px

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **UI**: Material Design 3
- **State Management**: StatefulWidget
- **Platforms**: iOS, Android, Web, macOS, Windows, Linux

## Indonesia-Specific Features

- **Phone Prefix**: +62 (Indonesia country code)
- **National Emblem**: Garuda Pancasila
- **ID Card**: KTP (Kartu Tanda Penduduk) with NIK (Nomor Induk Kependudukan)
- **Languages**: English and Bahasa Indonesia
- **Colors**: Red (#FF0000) and White - Indonesia flag colors

## License

This project is created for Indonesia Government Portal authentication.

---

**Bhinneka Tunggal Ika** - Unity in Diversity
