# XSIM Cambodia WAP - Changelog

## [3.0.0] - 2024-11-20

### Changed - Rebranding & Cleanup
- **Project Name**: Changed from "my-v0-project" to "xsim-cambodia-wap"
- **Metadata**: Updated title to "XSIM Cambodia - Authentication"
- **Description**: Updated to "XSIM Cambodia Government Portal Authentication System"
- **Version**: Bumped to 1.0.0 (production-ready)

### Removed
- v0 branding and references from all files
- Placeholder images: `placeholder-logo.png`, `placeholder-logo.svg`, `placeholder-user.jpg`, `placeholder.jpg`, `placeholder.svg`
- v0 generator metadata

### Added
- Comprehensive README.md with project documentation
- Professional branding for XSIM Cambodia

### UI Improvements
- Standardized logo sizes (64x64px) across all pages
- Vertically centered layout for better visual balance
- More spacious and centered content

## [2.0.0] - 2024-11-19

### Changed - Major UI Update to Match Flutter App

#### Step 4 - Complete Redesign
- **Removed**: Phone mockup popup with YES/NO buttons
- **Added**: Clean OTP input page matching Flutter design
  - 4 individual input boxes for OTP digits
  - Auto-focus to next box when typing
  - Auto-validate when all 4 digits entered
  - Blue info box showing expected code (for demo)
  - Red error message for incorrect code
  - Back button to return to Step 2
  - Continue button to manually submit
  - Matches layout of Steps 1, 2, 3

#### Status Bar Removed
- Removed simulated status bar (time, battery, signal icons) from all screens
- Cleaner, more spacious UI
- Matches Flutter app design

### Features
- ✅ 4-digit OTP input with individual boxes
- ✅ Auto-focus next field on digit entry
- ✅ Auto-validate when complete
- ✅ Backspace moves to previous field
- ✅ Real-time validation
- ✅ Error messages for incorrect OTP
- ✅ Info box showing expected code (demo mode)
- ✅ Responsive design
- ✅ Keyboard-friendly (numeric input mode on mobile)

### Technical Details
- Added `otpValues` state array for 4 digits
- Added `otpError` state for validation messages
- Added auto-focus logic between input fields
- Added backspace navigation
- Added real-time validation on input completion
- Removed phone mockup container and YES/NO buttons
- Removed status bar component

### UI/UX Improvements
- Consistent layout across all steps
- Better keyboard accessibility
- Clearer error messaging
- More mobile-friendly input method
- Matches Flutter app exactly

## [1.0.0] - 2024-11-19

### Initial Features
- 6-step authentication flow
- Bilingual support (English & Khmer)
- Responsive design
- Auto-transitions on Steps 3 and 5
- Modern UI with Tailwind CSS
- shadcn/ui components

