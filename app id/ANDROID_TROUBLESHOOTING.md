# Android Build Troubleshooting

## Current Issue: Gradle Download Timeout

### Problem
```
Exception in thread "main" java.lang.RuntimeException: Timeout of 120000 reached waiting for exclusive access to file: /Users/yang/.gradle/wrapper/dists/gradle-8.14-all/c2qonpi39x1mddn7hk5gh9iqj/gradle-8.14-all.zip
```

### Root Cause
- Gradle is trying to download a 100MB+ file
- Download is slow or interrupted
- File lock is preventing retries

## ✅ Quick Solution: Use Chrome or macOS Instead

**Recommended for now:**
```bash
# Chrome (fastest, no Gradle needed)
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d chrome

# macOS Desktop (native, no Gradle needed)
flutter run -d macos
```

Both work perfectly and give you the same app experience!

## 🔧 Fix Android Build (Multiple Solutions)

### Solution 1: Manual Gradle Download (Recommended)

Download Gradle manually and extract it:

```bash
# Create Gradle directory
mkdir -p ~/.gradle/wrapper/dists/gradle-8.14-all/c2qonpi39x1mddn7hk5gh9iqj/

# Download Gradle directly
curl -L https://services.gradle.org/distributions/gradle-8.14-all.zip \
  -o ~/.gradle/wrapper/dists/gradle-8.14-all/c2qonpi39x1mddn7hk5gh9iqj/gradle-8.14-all.zip

# Extract it
cd ~/.gradle/wrapper/dists/gradle-8.14-all/c2qonpi39x1mddn7hk5gh9iqj/
unzip gradle-8.14-all.zip

# Try building again
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter run -d emulator-5554
```

### Solution 2: Use Homebrew Gradle

Install Gradle via Homebrew and configure Flutter to use it:

```bash
# Install Gradle
brew install gradle

# Check version
gradle --version

# Update android/gradle/wrapper/gradle-wrapper.properties
# Change distributionUrl to use local Gradle
```

### Solution 3: Increase Timeout

Edit `android/gradle.properties` and add:

```properties
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m
systemProp.org.gradle.internal.http.socketTimeout=180000
systemProp.org.gradle.internal.http.connectionTimeout=180000
```

### Solution 4: Use Different Gradle Version

Edit `android/gradle/wrapper/gradle-wrapper.properties`:

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10-all.zip
```

### Solution 5: Clean Everything and Retry

```bash
# Kill all Gradle processes
pkill -9 java

# Remove all Gradle cache
rm -rf ~/.gradle

# Remove Android build cache
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter clean
rm -rf android/.gradle
rm -rf android/build
rm -rf build

# Rebuild
flutter pub get
flutter run -d emulator-5554
```

## 🌐 Network Issues

If you have slow internet or network restrictions:

### Use VPN or Different Network
```bash
# Try on different WiFi or mobile hotspot
# Or use VPN if corporate firewall is blocking
```

### Use Gradle Mirror (China)
Edit `android/build.gradle.kts`:

```kotlin
repositories {
    maven { url = uri("https://maven.aliyun.com/repository/google") }
    maven { url = uri("https://maven.aliyun.com/repository/jcenter") }
    maven { url = uri("https://maven.aliyun.com/repository/public") }
    google()
    mavenCentral()
}
```

## 📱 Alternative: Use Physical Device

Connect your Android phone via USB:

```bash
# Enable Developer Options on phone
# Enable USB Debugging
# Connect phone via USB

# Check if detected
flutter devices

# Run on phone
flutter run
```

No Gradle download needed if you have a physical device!

## ⚡ Fastest Development Workflow

**Use Chrome for development:**
- ✅ Instant builds (no Gradle)
- ✅ Hot reload works perfectly
- ✅ All features work
- ✅ Easy debugging

**Test on Android occasionally:**
- Only when you need to test Android-specific features
- Or before final release

## 🎯 Recommended: Chrome + macOS

For the Cambodia XSIM Auth app, you don't need Android-specific features, so:

1. **Daily Development**: Use Chrome (`flutter run -d chrome`)
2. **Testing**: Use macOS Desktop (`flutter run -d macos`)
3. **Final Testing**: Fix Gradle and test on Android before release

## 📊 Comparison

| Platform | Setup Time | Build Time | Gradle Needed? |
|----------|------------|------------|----------------|
| **Chrome** | 0 min | 10 sec | ❌ No |
| **macOS** | 0 min | 30 sec | ❌ No |
| **Android** | 5-10 min | 3-5 min | ✅ Yes |

## 🆘 Still Having Issues?

### Check Gradle Daemon
```bash
# Check if Gradle daemon is running
ps aux | grep gradle

# Stop all Gradle daemons
gradle --stop
```

### Check Disk Space
```bash
# Make sure you have enough space
df -h ~

# Gradle needs ~500MB for download
```

### Check Internet Connection
```bash
# Test download speed
curl -o /dev/null https://services.gradle.org/distributions/gradle-8.14-all.zip

# If slow, try on different network
```

### Use Android Studio

If all else fails, open the project in Android Studio:

1. Open Android Studio
2. Open `android/` folder as project
3. Let Android Studio download Gradle
4. Then return to command line

## ✅ Current Status

- ✅ **Chrome**: Working perfectly (CURRENTLY RUNNING)
- ✅ **macOS**: Available, no issues
- ❌ **Android**: Gradle download timeout
- ❓ **iOS**: Needs Xcode installation

**Recommendation**: Keep using Chrome for now. It's faster and has no setup issues!

---

## 📖 Resources

- [Flutter Android Setup](https://docs.flutter.dev/get-started/install/macos#android-setup)
- [Gradle Documentation](https://docs.gradle.org/)
- [Fix Gradle Issues](https://stackoverflow.com/questions/tagged/gradle)

