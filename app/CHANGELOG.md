# Changelog

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

