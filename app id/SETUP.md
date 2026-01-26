# Flutter Mobile App - Quick Setup Guide

## ✅ Installation Complete!

Flutter has been successfully installed and your mobile app is ready to run.

## 🚀 Running the App

### Option 1: Web (Chrome) - Fastest
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d chrome
```

### Option 2: macOS Desktop App
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d macos
```

### Option 3: iOS Simulator (Requires Xcode)
```bash
# First, install Xcode from App Store
# Then open Xcode and install iOS Simulator
open -a Simulator

# Once simulator is running:
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d ios
```

### Option 4: Android Emulator (Requires Android Studio)
```bash
# First, install Android Studio
brew install --cask android-studio

# Set up Android SDK and create an emulator
# Then run:
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d android
```

## 📱 Hot Reload

While the app is running, you can make changes to the code and press:
- **`r`** - Hot reload (fast refresh)
- **`R`** - Hot restart (full restart)
- **`q`** - Quit

## 🛠️ Useful Commands

```bash
# Navigate to app directory
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"

# Check Flutter installation
flutter doctor

# List available devices
flutter devices

# List available emulators
flutter emulators

# Clean build cache
flutter clean

# Update dependencies
flutter pub get

# Build for production
flutter build web          # Web
flutter build macos        # macOS
flutter build ios          # iOS (requires Xcode)
flutter build apk          # Android APK
flutter build appbundle    # Android App Bundle
```

## 📂 Project Structure

```
/Users/yang/zeptosourcecode/xsim cambodia/
├── app/                         # Flutter mobile app (THIS FOLDER)
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── translations.dart   # English & Khmer translations
│   │   ├── screens/
│   │   │   ├── auth_screen.dart   # Main state management
│   │   │   └── steps/             # Individual step screens
│   │   │       ├── step1_login.dart
│   │   │       ├── step2_phone.dart
│   │   │       ├── step3_authenticating.dart
│   │   │       ├── step4_flash_message.dart
│   │   │       ├── step5_verifying.dart
│   │   │       └── step6_success.dart
│   │   └── widgets/
│   │       └── status_bar.dart    # Reusable components
│   ├── pubspec.yaml               # Dependencies
│   ├── analysis_options.yaml      # Linting rules
│   ├── README.md                  # This file
│   └── SETUP.md                   # Setup instructions
│
└── wap/                         # Next.js web version
    ├── app/
    │   ├── page.tsx            # Web version of auth flow
    │   ├── layout.tsx
    │   └── globals.css
    └── ...
```

## 🎨 Customization

### Change Colors
Edit `lib/screens/auth_screen.dart`:
```dart
final Color primaryBlue = const Color(0xFF1E40AF);
final Color darkBlue = const Color(0xFF1E3A8A);
final Color successGreen = const Color(0xFF16A34A);
```

### Add/Edit Translations
Edit `lib/translations.dart` for both English and Khmer text.

### Modify Flow
Each step is in `lib/screens/steps/` - edit individual files to customize.

## 🐛 Troubleshooting

### If you see "No devices found"
```bash
# For web
flutter config --enable-web

# For macOS desktop
flutter config --enable-macos-desktop

# Check what's enabled
flutter config
```

### If dependencies fail
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter clean
flutter pub get
```

### Check Flutter health
```bash
flutter doctor -v
```

## 📱 Building for Mobile Devices

### iOS (Requires Mac + Xcode)
1. Install Xcode from App Store
2. Open Xcode and accept license
3. Install iOS Simulator: `xcode-select --install`
4. Run: `flutter run -d ios`

### Android
1. Install Android Studio: `brew install --cask android-studio`
2. Open Android Studio → SDK Manager → Install Android SDK
3. Create AVD (Android Virtual Device)
4. Run: `flutter run -d android`

## 🌐 Current Status

✅ Flutter installed (v3.38.2)
✅ App structure created
✅ Ready to run on: Chrome, macOS Desktop

🔄 Optional: iOS Simulator, Android Emulator

## 📖 Quick Start

1. **Install dependencies:**
   ```bash
   cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run -d chrome
   ```

3. **Try hot reload** by editing any file in `lib/`

4. **Test the 6-step authentication flow:**
   - Initial login screen
   - Phone number input
   - Authenticating animation
   - SIM flash message popup
   - Server verification
   - Success screen

5. **Toggle between English and Khmer**

6. **Customize colors, text, or flow as needed**

## 🆘 Need Help?

- Flutter Documentation: https://docs.flutter.dev
- Flutter Samples: https://flutter.github.io/samples/
- Widget Catalog: https://docs.flutter.dev/ui/widgets

Enjoy your Flutter mobile app! 🎉
