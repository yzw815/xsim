# Building Android APK - XSIM Cambodia

This guide will help you build an Android APK file from the Flutter app.

## Prerequisites

Before building, ensure you have:

1. ✅ Flutter SDK installed (`flutter --version`)
2. ✅ Android Studio or Android SDK installed
3. ✅ Java Development Kit (JDK) installed
4. ✅ Android device or emulator available

## Quick Build Commands

### 1. Build Debug APK (For Testing)

```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter build apk --debug
```

**Output location**: `build/app/outputs/flutter-apk/app-debug.apk`

### 2. Build Release APK (For Distribution)

```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter build apk --release
```

**Output location**: `build/app/outputs/flutter-apk/app-release.apk`

### 3. Build Split APKs (Smaller file sizes)

```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter build apk --split-per-abi
```

This creates separate APKs for different CPU architectures:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

**Output location**: `build/app/outputs/flutter-apk/`

## Step-by-Step Build Process

### Step 1: Clean Previous Builds

```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter clean
```

### Step 2: Get Dependencies

```bash
flutter pub get
```

### Step 3: Build the APK

For a standard release APK:

```bash
flutter build apk --release
```

### Step 4: Locate Your APK

The APK will be at:
```
/Users/yang/zeptosourcecode/xsim cambodia/app/build/app/outputs/flutter-apk/app-release.apk
```

## APK Types Explained

### Debug APK
- **Use**: Testing and development
- **Size**: Larger (includes debug symbols)
- **Performance**: Slower
- **Command**: `flutter build apk --debug`

### Release APK
- **Use**: Production/distribution
- **Size**: Optimized and smaller
- **Performance**: Fast
- **Command**: `flutter build apk --release`

### Split APKs
- **Use**: Reduce download size
- **Size**: Smallest (architecture-specific)
- **Performance**: Fast
- **Command**: `flutter build apk --split-per-abi`

## Installing the APK

### On Physical Device

1. **Enable USB Debugging** on your Android device:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times to enable Developer Options
   - Go to Settings → Developer Options
   - Enable "USB Debugging"

2. **Connect device via USB**

3. **Install APK**:
   ```bash
   flutter install
   ```

   Or manually:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

### On Emulator

1. **Start emulator**:
   ```bash
   flutter emulators --launch <emulator_id>
   ```

2. **Install APK**:
   ```bash
   flutter install
   ```

### Manual Installation

1. Copy the APK to your device
2. Open the APK file on your device
3. Allow installation from unknown sources if prompted
4. Tap "Install"

## Signing the APK (For Play Store)

For Google Play Store distribution, you need to sign your APK.

### 1. Create a Keystore

```bash
keytool -genkey -v -keystore ~/xsim-cambodia-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias xsim-cambodia
```

### 2. Create `key.properties`

Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=xsim-cambodia
storeFile=/Users/yang/xsim-cambodia-key.jks
```

### 3. Update `android/app/build.gradle.kts`

Add before `android {`:

```kotlin
// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

Add inside `android {`:

```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}

buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### 4. Build Signed APK

```bash
flutter build apk --release
```

## Troubleshooting

### Error: Gradle timeout

See `ANDROID_TROUBLESHOOTING.md` for solutions.

### Error: SDK not found

```bash
# Set Android SDK path
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### Error: Java version

Flutter requires Java 11 or higher:

```bash
# Check Java version
java -version

# Install Java 11+ if needed (using Homebrew)
brew install openjdk@17
```

### APK too large

Use split APKs:

```bash
flutter build apk --split-per-abi --release
```

## File Sizes (Approximate)

- **Debug APK**: ~40-60 MB
- **Release APK**: ~15-25 MB
- **Split APKs**: ~10-15 MB each

## Testing the APK

Before distribution, test your APK:

1. ✅ Install on multiple devices
2. ✅ Test all 6 authentication steps
3. ✅ Test language switching (English/Khmer)
4. ✅ Test OTP input functionality
5. ✅ Test on different Android versions
6. ✅ Check app performance

## Distribution Options

### 1. Direct Distribution
- Share the APK file directly
- Users install manually
- No Google Play Store approval needed

### 2. Google Play Store
- Requires signed APK/AAB
- Needs Google Play Developer account ($25 one-time fee)
- App review process (1-7 days)

### 3. Alternative App Stores
- Amazon Appstore
- Samsung Galaxy Store
- APKPure, etc.

## Building App Bundle (AAB) for Play Store

Google Play Store prefers AAB format:

```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

## Quick Reference

| Command | Output | Use Case |
|---------|--------|----------|
| `flutter build apk --debug` | Debug APK | Testing |
| `flutter build apk --release` | Release APK | Distribution |
| `flutter build apk --split-per-abi` | Split APKs | Smaller downloads |
| `flutter build appbundle` | AAB file | Play Store |

## Next Steps

1. Build your APK using the commands above
2. Test on physical devices
3. Sign for production (if distributing)
4. Distribute via your preferred method

## Support

For issues, refer to:
- `ANDROID_TROUBLESHOOTING.md`
- `SETUP.md`
- Flutter documentation: https://docs.flutter.dev/deployment/android

---

**Note**: The first build may take 5-10 minutes. Subsequent builds are faster.

