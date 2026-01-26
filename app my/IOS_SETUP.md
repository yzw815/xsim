# iOS Setup Guide

## Current Status

❌ **iOS Simulator NOT installed**
✅ **macOS Desktop** - Running now!
✅ **Chrome Web** - Available

## Why iOS Doesn't Work

You need the full **Xcode app** (not just Command Line Tools) to run iOS simulators.

## 📱 Install Xcode for iOS Development

### Step 1: Install Xcode from App Store

1. Open **App Store**
2. Search for **"Xcode"**
3. Click **"Get"** or **"Install"**
4. Wait for download (Xcode is ~15GB, takes 30-60 minutes)

**OR** Use command line:

```bash
# Install Xcode via mas (Mac App Store CLI)
brew install mas
mas install 497799835  # Xcode App Store ID
```

### Step 2: Accept Xcode License

After Xcode installs:

```bash
sudo xcodebuild -license accept
```

### Step 3: Install iOS Simulators

```bash
# Install iOS runtime
sudo xcodebuild -downloadPlatform iOS

# Or open Xcode manually:
# Xcode → Settings → Platforms → iOS → Download
```

### Step 4: Set Xcode Path

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### Step 5: Verify Setup

```bash
flutter doctor
```

Should show:
```
[✓] Xcode - develop for iOS and macOS
    ✓ Xcode at /Applications/Xcode.app/Contents/Developer
    ✓ CocoaPods version 1.x.x
```

### Step 6: List Available Simulators

```bash
xcrun simctl list devices available
```

Or:

```bash
flutter emulators
```

### Step 7: Open iOS Simulator

```bash
open -a Simulator
```

Or:

```bash
flutter emulators --launch apple_ios_simulator
```

### Step 8: Run Flutter App on iOS

```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d ios
```

## 🚀 Quick Alternative: Use What You Have Now

While Xcode downloads, use these options:

### Option 1: macOS Desktop (CURRENTLY RUNNING)
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d macos
```

**Pros:**
- ✅ Native macOS app
- ✅ Fast performance
- ✅ No setup needed
- ✅ Full Flutter features

### Option 2: Chrome Web
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d chrome
```

**Pros:**
- ✅ Instant preview
- ✅ Hot reload
- ✅ Developer tools
- ✅ No installation needed

### Option 3: Android Emulator (Already Installed!)

You have Android emulators ready:

```bash
# List available Android emulators
flutter emulators

# Launch an Android emulator
flutter emulators --launch Pixel_9a

# Run app on Android
flutter run -d android
```

## 🤔 Do You Really Need iOS Simulator?

**Consider this:**
- macOS Desktop app looks and works almost identically to iOS
- Chrome web version is fastest for development
- Android emulator is already available
- iOS Simulator requires 15GB+ download

**iOS Simulator is only needed if:**
- You need to test iOS-specific features (Face ID, Touch ID, etc.)
- You're building for App Store submission
- You need to test on exact iPhone screen sizes

## 📊 Comparison

| Platform | Status | Performance | Setup Time |
|----------|--------|-------------|------------|
| **macOS Desktop** | ✅ Ready | ⭐⭐⭐⭐⭐ Excellent | None |
| **Chrome Web** | ✅ Ready | ⭐⭐⭐⭐ Great | None |
| **Android** | ✅ Ready | ⭐⭐⭐⭐ Great | None |
| **iOS Simulator** | ❌ Not Ready | ⭐⭐⭐ Good | 1-2 hours |

## 🎯 Recommended Workflow

1. **Development**: Use **macOS Desktop** or **Chrome** (fastest)
2. **Testing**: Use **Android emulator** (already installed)
3. **iOS Testing**: Only install Xcode if you specifically need iOS features

## 🆘 Troubleshooting

### After Installing Xcode, iOS Still Doesn't Work?

```bash
# Run Flutter doctor
flutter doctor -v

# Check iOS setup
flutter doctor --android-licenses
sudo xcodebuild -license accept

# Install CocoaPods
sudo gem install cocoapods

# Clean Flutter
flutter clean
flutter pub get
```

### Can't Open Simulator?

```bash
# Find Simulator app
find /Applications/Xcode.app -name "Simulator.app"

# Open directly
open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app
```

### Simulator Boots But App Won't Install?

```bash
# Reset Flutter
flutter clean
flutter pub get

# Reset iOS simulator
flutter emulators --launch apple_ios_simulator
```

## 📖 Additional Resources

- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [Xcode Download](https://developer.apple.com/xcode/)
- [iOS Simulator Guide](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)

---

## ✅ Current Recommendation

**Keep using macOS Desktop or Chrome for now!**

The app is running on macOS Desktop right now, which gives you:
- Native performance
- Full Flutter features
- Hot reload
- All the same UI/UX as iOS

Install Xcode only if you specifically need iOS-specific testing later.

