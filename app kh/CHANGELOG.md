# Changelog

## [1.0.2+3] - 2026-02-27

### Changed
- **Step 6 (Success)**: Removed "Proceed To Dashboard" button — app now ends at the Success screen
  - "Back To Home" is now the only action (promoted to filled/primary button style)
  - Prevents Google Play "not fully functional" rejection caused by non-interactive Dashboard UI

### Removed
- **`onProceed` callback** from `Step6Success` widget — no longer needed

### Added
- **App Icon**: `assets/images/xsim logo.png` set as app icon for Android and iOS
  - Added `flutter_launcher_icons ^0.14.1` dev dependency
  - Generated all Android mipmap sizes (mdpi → xxxhdpi)
  - Generated all iOS AppIcon sizes (20pt → 1024pt)

### Files Modified
- `lib/screens/steps/step6_success.dart` — remove Dashboard button, promote Back To Home
- `lib/screens/auth_screen.dart` — remove `onProceed` Dashboard navigation
- `pubspec.yaml` — add `flutter_launcher_icons`, bump version to `1.0.2+3`
- `android/app/src/main/res/mipmap-*/ic_launcher.png` — new app icon
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` — new app icon (all sizes)

> ℹ️ `step7_dashboard.dart` is intentionally kept in the codebase but is unreachable from the UI.

## [1.0.3] - 2024-11-19


### Added
- **Platform Support**: Created all platform-specific files (Android, iOS, macOS, Windows, Linux, Web)
  - Android support with proper AndroidManifest.xml
  - iOS support with Xcode project files
  - macOS Desktop support
  - Windows Desktop support
  - Linux Desktop support
  - Web support with HTML/JS files
  - Total: 126 platform files created

### Fixed
- Resolved "AndroidManifest.xml could not be found" error
- Resolved "No macOS desktop project configured" error
- App now runs on all supported platforms

### Files Created
- `android/` - Complete Android project structure
- `ios/` - Complete iOS project structure
- `macos/` - Complete macOS project structure
- `windows/` - Complete Windows project structure
- `linux/` - Complete Linux project structure
- `web/` - Complete Web project structure

## [1.0.2] - 2024-11-19

### Changed
- **Step 4 - OTP Input**: Completely redesigned Step 4 from phone mockup popup to normal page
  - Added 4-digit OTP input fields (one digit per box)
  - Auto-focus next field when digit is entered
  - Real-time validation when all 4 digits are entered
  - Back button to return to previous step
  - Continue button to manually submit
  - Error message for incorrect OTP
  - Blue info box showing expected code (for demo - remove in production)
  - Matches layout style of Step 1, 2, and 3

### Files Modified
- `lib/screens/steps/step4_flash_message.dart` - Complete redesign with OTP input

## [1.0.1] - 2024-11-19

### Removed
- **Status Bar**: Removed the status bar widget (time, battery, signal icons) from all screens
  - Removed `StatusBarWidget` import from `auth_screen.dart`
  - Removed status bar display from main app layout
  - Removed status bar simulation from Step 4 (Flash Message popup)
  - Removed notch simulation from Step 4 (Flash Message popup)

### Changed
- Cleaner UI without system status indicators
- More space for content on all screens

### Files Modified
- `lib/screens/auth_screen.dart` - Removed StatusBarWidget usage
- `lib/screens/steps/step4_flash_message.dart` - Removed status bar and notch simulation

## [1.0.0] - 2024-11-19

### Added
- Initial release of Cambodia Government Portal XSIM Authentication mobile app
- 6-step authentication flow
- Bilingual support (English & Khmer)
- Cross-platform support (iOS, Android, Web, Desktop)
- Smooth animations and auto-transitions
- SIM-based authentication simulation

