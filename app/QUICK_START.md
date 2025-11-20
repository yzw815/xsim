# XSIM Auth App - Quick Start Guide

## 🚀 Fastest Way to Run the App

### Option 1: Chrome (RECOMMENDED ⭐)
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d chrome
```
- ✅ Instant start (10 seconds)
- ✅ No setup needed
- ✅ Hot reload works
- ✅ Perfect for development

### Option 2: macOS Desktop
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d macos
```
- ✅ Native macOS app
- ✅ Fast (30 seconds)
- ✅ Full Flutter features
- ✅ Great for testing

### Option 3: Android Emulator
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d emulator-5554
```
- ⚠️ Currently has Gradle download issue
- ⏱️ First build takes 5+ minutes
- 📱 See ANDROID_TROUBLESHOOTING.md for fixes

## 🎨 What You'll See

The app has a 6-step authentication flow:

1. **Login Screen** - Welcome + Language toggle (EN/KH)
2. **Phone Input** - Enter +855 phone number
3. **Authenticating** - Loading animation (auto-advances)
4. **OTP Input** - Enter 4-digit code (NEW DESIGN!)
5. **Verifying** - Server verification (auto-advances)
6. **Success** - Authentication complete!

## 🔄 Hot Reload

While the app is running, make changes to code and press:
- `r` - Hot reload (instant refresh)
- `R` - Hot restart (full restart)
- `q` - Quit

## 📂 Project Structure

```
app/
├── lib/
│   ├── main.dart              # Entry point
│   ├── translations.dart      # EN/KH text
│   ├── screens/
│   │   ├── auth_screen.dart   # State management
│   │   └── steps/             # 6 step screens
│   │       ├── step1_login.dart
│   │       ├── step2_phone.dart
│   │       ├── step3_authenticating.dart
│   │       ├── step4_flash_message.dart  ⭐ NEW OTP INPUT
│   │       ├── step5_verifying.dart
│   │       └── step6_success.dart
│   └── widgets/
│       └── status_bar.dart
├── android/                   # Android files
├── ios/                       # iOS files
├── macos/                     # macOS files
├── web/                       # Web files
└── windows/                   # Windows files
```

## 🎯 Common Tasks

### Run on different platforms
```bash
flutter run -d chrome         # Web
flutter run -d macos          # macOS
flutter run -d emulator       # Android
```

### Clean build
```bash
flutter clean
flutter pub get
```

### Check available devices
```bash
flutter devices
```

### Update dependencies
```bash
flutter pub get
```

## 🐛 Troubleshooting

### Android Build Fails?
→ See `ANDROID_TROUBLESHOOTING.md`
→ Use Chrome instead: `flutter run -d chrome`

### iOS Not Available?
→ See `IOS_SETUP.md`
→ Use macOS instead: `flutter run -d macos`

### Hot Reload Not Working?
→ Press `R` for hot restart
→ Or stop and run again

## 📖 Documentation

- `README.md` - Complete project overview
- `SETUP.md` - Detailed Flutter setup
- `IOS_SETUP.md` - iOS simulator setup
- `ANDROID_TROUBLESHOOTING.md` - Fix Android issues
- `STEP4_DESIGN.md` - OTP input design docs
- `CHANGELOG.md` - Version history

## ✅ Current Status

- ✅ Flutter 3.38.2 installed
- ✅ Chrome ready
- ✅ macOS ready
- ✅ Android emulator running (Gradle issue)
- ❌ iOS needs Xcode

## 💡 Tips

1. **Use Chrome for daily development** - It's the fastest
2. **Test on macOS occasionally** - Native app experience
3. **Fix Android when you have time** - See troubleshooting guide
4. **iOS is optional** - Only needed for App Store

## 🎉 You're Ready!

Run this now:
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d chrome
```

The app will open in Chrome and you can start testing the new OTP input feature! 🚀

