# Cambodia Government Portal - XSIM Authentication Mobile App

A Flutter mobile application for Cambodia Government Portal authentication using XSIM technology.

## 📱 Features

- 🇰🇭 **Bilingual Support**: English & Khmer with language toggle
- 🔐 **6-Step Authentication Flow**:
  1. Initial login screen
  2. Phone number input (+855 prefix)
  3. Authenticating (loading animation)
  4. SIM flash message popup with challenge code
  5. Server verification
  6. Success screen with auth token
- 📱 **Cross-Platform**: Runs on iOS, Android, Web, macOS, Windows, Linux
- 💫 **Smooth Animations**: Auto-transitions and loading states
- 🎨 **Modern UI**: Clean, professional design matching Cambodia government branding

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+ (already installed via Homebrew)
- Dart 3.0+

### Installation

1. Navigate to the app directory:
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
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

## 📂 Project Structure

```
app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── translations.dart            # English & Khmer translations
│   ├── screens/
│   │   ├── auth_screen.dart        # Main state management
│   │   └── steps/                  # Individual step screens
│   │       ├── step1_login.dart    # Initial login
│   │       ├── step2_phone.dart    # Phone input
│   │       ├── step3_authenticating.dart  # Loading
│   │       ├── step4_flash_message.dart   # SIM popup
│   │       ├── step5_verifying.dart       # Verification
│   │       └── step6_success.dart         # Success
│   └── widgets/
│       └── status_bar.dart         # Reusable status bar
├── pubspec.yaml                     # Dependencies
├── analysis_options.yaml            # Linting rules
├── README.md                        # This file
└── SETUP.md                         # Detailed setup guide
```

## 🎨 Customization

### Colors
Edit `lib/screens/auth_screen.dart`:
```dart
final Color primaryBlue = const Color(0xFF1E40AF);
final Color darkBlue = const Color(0xFF1E3A8A);
final Color successGreen = const Color(0xFF16A34A);
```

### Translations
Edit `lib/translations.dart` to modify or add translations for both English (`en`) and Khmer (`km`).

### Logo
Replace the logo URL in step files with your own asset:
```dart
Image.asset('assets/images/logo.png', height: 80, width: 80)
```

## 🔧 Development

### Hot Reload
While running, press:
- `r` - Hot reload (instant refresh)
- `R` - Hot restart (full restart)
- `q` - Quit

### Common Commands
```bash
# Check Flutter installation
flutter doctor

# List available devices
flutter devices

# Clean build cache
flutter clean

# Update dependencies
flutter pub get
```

## 📦 Building for Production

### Web
```bash
flutter build web --release
# Output: build/web/
```

### macOS
```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/
```

### iOS
```bash
flutter build ios --release
# Requires Xcode and Apple Developer account
```

### Android
```bash
# APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# App Bundle (for Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

## 🌐 Related Projects

This Flutter mobile app is part of the XSIM Cambodia project:

- **Web Version**: `/Users/yang/zeptosourcecode/xsim cambodia/wap/`
  - Built with Next.js + React
  - Same authentication flow
  - Browser-based access

- **Mobile Version**: `/Users/yang/zeptosourcecode/xsim cambodia/app/` (this folder)
  - Built with Flutter
  - Native iOS/Android apps
  - Better performance

## 🔐 Authentication Flow

1. **Step 1 - Login**: User sees welcome screen with language toggle
2. **Step 2 - Phone Input**: User enters mobile number (+855)
3. **Step 3 - Authenticating**: Loading state (3s auto-advance)
4. **Step 4 - Flash Message**: SIM card popup with challenge code (YES/NO)
5. **Step 5 - Verifying**: Server verification (3s auto-advance)
6. **Step 6 - Success**: Authentication complete with token

## 📖 Documentation

- [SETUP.md](./SETUP.md) - Detailed setup and troubleshooting guide
- [Flutter Documentation](https://docs.flutter.dev)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

## 🛠️ Tech Stack

- **Framework**: Flutter 3.38.2
- **Language**: Dart 3.10.0
- **UI**: Material Design 3
- **State Management**: StatefulWidget
- **Platforms**: iOS, Android, Web, macOS, Windows, Linux

## 🆘 Support

For issues or questions:
1. Check [SETUP.md](./SETUP.md) for troubleshooting
2. Run `flutter doctor -v` to diagnose issues
3. Visit [Flutter Documentation](https://docs.flutter.dev)

## 📄 License

This project is created for Cambodia Government Portal authentication.

---

**Happy Coding!** 🎉
