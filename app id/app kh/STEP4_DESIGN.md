# Step 4 - OTP Input Design

## Overview
Step 4 has been redesigned from a phone mockup popup to a normal full-page layout matching Steps 1, 2, and 3.

## Layout Structure

```
┌─────────────────────────────────────┐
│  ← (Back Button)                    │
│                                     │
│         🏛️ (Logo)                   │
│                                     │
│    Confirm Your Login Code          │
│    (Title - Bold, Large)            │
│                                     │
│    Please check the Flash           │
│    (Subtitle)                       │
│                                     │
│         [SPACER]                    │
│                                     │
│    ┌───┐ ┌───┐ ┌───┐ ┌───┐        │
│    │ 1 │ │ 2 │ │ 3 │ │ 4 │        │
│    └───┘ └───┘ └───┘ └───┘        │
│    (4 OTP Input Boxes)             │
│                                     │
│    ╔════════════════════════════╗  │
│    ║ ℹ️ Enter code: 1234        ║  │
│    ╚════════════════════════════╝  │
│    (Info hint - blue box)          │
│                                     │
│         [SPACER]                    │
│                                     │
│    ┌─────────────────────────────┐ │
│    │       Continue              │ │
│    └─────────────────────────────┘ │
│              ▬▬▬                   │
│         (Bottom bar)               │
└─────────────────────────────────────┘
```

## Features

### 1. OTP Input Fields (4 boxes)
- **Size**: 64x64 pixels each
- **Spacing**: 8px between boxes
- **Style**: 
  - Rounded corners (12px radius)
  - Light gray border when inactive
  - Blue border when focused
  - Light gray background
  - Center-aligned large numbers (32px, bold)

### 2. Auto-Focus Behavior
- When user enters a digit, focus automatically moves to next box
- When user deletes, focus moves back to previous box
- Only accepts numbers (0-9)
- One digit per box maximum

### 3. Validation
- **Auto-submit**: When all 4 digits are entered, automatically validates
- **Manual submit**: User can press Continue button
- **Success**: Proceeds to Step 5 (Verification)
- **Error**: Shows red snackbar "Incorrect code. Please try again."

### 4. Info Box (Demo Mode)
- Light blue background
- Blue border
- Info icon
- Shows expected code: `Enter code: 1234`
- **NOTE**: Remove this in production!

### 5. Navigation
- **Back Button** (←): Returns to Step 2 (Phone Input)
- **Continue Button**: Validates and proceeds if code is correct

## User Flow

1. User arrives at Step 4 after Step 3 (Authenticating)
2. Sees title "Confirm Your Login Code"
3. Sees instruction to check flash message
4. Sees 4 empty OTP input boxes
5. Sees info box with expected code (demo only)
6. User taps first box and enters digit
7. Focus automatically moves to second box
8. User continues entering remaining 3 digits
9. **Option A**: System auto-validates when 4th digit is entered
10. **Option B**: User presses Continue button to submit
11. If correct: Proceeds to Step 5
12. If incorrect: Error message shown, user can try again

## Code Structure

### State Management
```dart
class _Step4FlashMessageState extends State<Step4FlashMessage> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  
  // Auto-focus next field
  void _onOtpChanged(int index, String value) { ... }
  
  // Handle backspace
  void _onOtpBackspace(int index, String value) { ... }
}
```

### Input Validation
```dart
// Check if all fields are filled
if (_controllers.every((controller) => controller.text.isNotEmpty)) {
  final enteredOtp = _controllers.map((c) => c.text).join();
  if (enteredOtp == widget.challengeCode) {
    widget.onYes(); // Success - proceed to Step 5
  }
}
```

## Colors

- **Primary Blue**: `#1E40AF` (button, focused border)
- **Dark Blue**: `#1E3A8A` (title, OTP digits)
- **Gray Border**: `#E5E7EB` (inactive input)
- **Gray Background**: `#F9FAFB` (input fill)
- **Info Blue Background**: `#EFF6FF`
- **Info Blue Border**: `#BFDBFE`
- **Info Blue Text**: `#1E3A8A`

## Accessibility

- Large touch targets (64x64px for inputs)
- Clear visual feedback (border color change on focus)
- Numeric keyboard automatically shown
- Error messages clearly displayed
- Back button for easy navigation

## Production Notes

⚠️ **Remove the info box in production!**

The blue info box showing "Enter code: 1234" is for demo/testing purposes only. In production:

1. Remove the info box container
2. User should receive OTP via SMS/Flash message
3. Consider adding:
   - Resend OTP button
   - Timer countdown (e.g., "Resend in 59s")
   - Help text or FAQ link

## Responsive Design

- OTP boxes are centered horizontally
- Spacing adjusts for different screen sizes
- Input width: 64px (fixed for consistency)
- Margin between boxes: 8px (fixed for consistency)

## Future Enhancements

- [ ] Add timer for OTP expiration
- [ ] Add "Resend OTP" button
- [ ] Add haptic feedback on input
- [ ] Add animation when transitioning to Step 5
- [ ] Add loading state while validating
- [ ] Add accessibility labels
- [ ] Support for paste functionality (paste 4-digit code)

