# OTP Integration with SODA Campaign API

This document explains how the OTP (One-Time Password) functionality is integrated into the XSIM authentication flow using the SODA Campaign API.

## Overview

The authentication flow now includes real OTP sending via the SODA Campaign API and verification against the sent OTP code.

## API Integration

### SODA Campaign API Endpoint

**Endpoint:** `http://155.12.30.102/send/campaign/msisdn`  
**Method:** POST  
**Content-Type:** application/json

### Request Format

```json
{
  "msisdn": "+855123456789",
  "message": "Your verification code is: 1234"
}
```

### Parameters

- **msisdn**: The phone number to send the OTP to (including country code, e.g., +855)
- **message**: The message containing the OTP code

### Response Format

**Success Response (HTTP 200):**
```json
{
  "status": true,
  "code": 200,
  "message": "campaign sent"
}
```

**Error Response:**
```json
{
  "error": {
    "status": false,
    "code": 404,
    "message": "Error description"
  }
}
```

## Implementation Details

### 1. EventService Updates

The `EventService` class has been enhanced with OTP functionality:

#### New Methods

- **`sendOtp(String msisdn)`**: Sends OTP to the specified phone number
  - Generates a random 4-digit OTP code
  - Calls the SODA Campaign API
  - Stores the sent OTP for later verification
  - Returns the OTP code if successful, null if failed

- **`verifyOtp(String enteredOtp)`**: Verifies the entered OTP
  - Compares the entered OTP with the stored OTP
  - Returns true if valid, false otherwise
  - Logs verification events

- **`clearOtp()`**: Clears the stored OTP

- **`get sentOtp`**: Returns the sent OTP (for testing/demo purposes)

#### Configuration

You can customize the SODA API endpoint:

```dart
EventService().setSodaEndpoint('http://your-api-endpoint:port/path');
```

### 2. Authentication Flow

The authentication flow has been updated as follows:

#### Step 1: User Login
User clicks the "Login" button to start the authentication process.

#### Step 2: Phone Number Entry
User enters their phone number (without country code, just the local number).

#### Step 3: Authenticating & Sending OTP
- The app prepends the country code (+855) to the phone number
- Calls `EventService().sendOtp(fullPhone)` to send OTP via SODA API
- The API generates a 4-digit OTP and sends it via SMS
- The OTP is stored in the EventService for verification
- If successful, advances to Step 4
- If failed, shows an error message and returns to Step 2

#### Step 4: OTP Entry & Verification
- User enters the 4-digit OTP code received via SMS
- Each digit is entered in a separate input field
- The app calls `EventService().verifyOtp(enteredOtp)` to verify
- If valid, advances to Step 5 (Verifying)
- If invalid, shows error message and clears the input fields

#### Step 5: Final Verification
Shows a verification animation.

#### Step 6: Success
Authentication successful, user can proceed to the dashboard.

### 3. Code Structure

#### EventService (`lib/services/event_service.dart`)
```dart
// Send OTP
final otp = await EventService().sendOtp('+855123456789');

// Verify OTP
final isValid = EventService().verifyOtp('1234');
```

#### AuthScreen (`lib/screens/auth_screen.dart`)
- Manages the overall authentication flow
- Calls `_sendOtpToPhone()` when advancing to Step 3
- Provides `verifyEnteredOtp()` method to Step 4

#### Step4FlashMessage (`lib/screens/steps/step4_flash_message.dart`)
- Displays OTP input fields
- Calls the verification function when OTP is entered
- Shows error messages for invalid OTP
- Auto-clears fields on error

## Error Handling

### OTP Send Failures
- Timeout after 10 seconds
- Shows error message to user
- Returns to phone entry screen
- Logs error events for monitoring

### OTP Verification Failures
- Shows "Incorrect code" message
- Clears input fields
- Allows user to re-enter
- Logs verification failure events

## Testing

### Manual Testing

1. **Test OTP Sending:**
   - Enter a valid phone number
   - Check if OTP is sent successfully
   - Verify the OTP code in console logs

2. **Test OTP Verification:**
   - Enter the correct OTP code
   - Verify successful authentication
   - Enter an incorrect OTP code
   - Verify error message is shown

3. **Test Error Scenarios:**
   - Test with invalid phone number
   - Test when API is unreachable
   - Test timeout scenarios

### Demo Mode

For demo purposes, the sent OTP code is displayed in the UI with an info box:

```
ℹ️ Enter code: 1234
```

**Note:** Remove this in production for security.

## Security Considerations

1. **OTP Storage**: The OTP is stored in memory only and cleared after verification
2. **Timeout**: Consider implementing OTP expiration (e.g., 5 minutes)
3. **Rate Limiting**: Implement rate limiting to prevent OTP spam
4. **HTTPS**: Use HTTPS for the SODA API endpoint in production
5. **Demo Info Box**: Remove the OTP hint display in production builds

## Configuration

### Development vs Production

**Development:**
```dart
EventService().setSodaEndpoint('http://155.12.30.102/send/campaign/msisdn');
```

**Production:**
```dart
EventService().setSodaEndpoint('https://your-production-api.com/send/campaign/msisdn');
```

## Monitoring & Logging

### In-App Log Viewer

A built-in log viewer is available in the app:

1. **Access**: Tap the small log icon (📄) in the top-right corner of the auth screen
2. **Features**:
   - View all OTP and API logs
   - Filter by category (OTP, API, AUTH, SYSTEM)
   - Filter by level (INFO, SUCCESS, WARNING, ERROR)
   - Copy all logs to clipboard
   - Clear logs
   - View detailed data for each log entry

### Log Categories

- **OTP**: OTP generation, sending, and verification events
- **API**: API request and response details
- **AUTH**: Authentication flow events
- **SYSTEM**: System-level events

### Log Levels

- **INFO** (Blue): General information
- **SUCCESS** (Green): Successful operations
- **WARNING** (Orange): Warning conditions
- **ERROR** (Red): Error conditions

### Remote Monitoring

All OTP-related events are also sent to the monitoring backend:

- `otp_sent`: OTP sent successfully
- `otp_send_failed`: Failed to send OTP
- `otp_send_error`: Error sending OTP
- `otp_verified`: OTP verified successfully
- `otp_verification_failed`: OTP verification failed

These events can be monitored via the demo monitor dashboard at `/demo-monitor`.

### Programmatic Access

```dart
import 'package:xsim_auth/services/log_service.dart';

// Get all logs
final logs = LogService().logs;

// Get OTP logs only
final otpLogs = LogService().getLogsByCategory('OTP');

// Get errors only
final errors = LogService().getLogsByLevel('ERROR');

// Export logs as text
final logText = LogService().exportLogs();

// Export logs as JSON
final logJson = LogService().exportLogsAsJson();
```

## Troubleshooting

### OTP Not Received
1. Check if the SODA API is reachable
2. Verify the phone number format (+855...)
3. Check API logs for errors
4. Verify network connectivity

### OTP Verification Fails
1. Check if OTP was sent successfully
2. Verify the user entered the correct code
3. Check console logs for debugging info
4. Ensure OTP hasn't been cleared

### API Timeout
1. Increase timeout duration if needed
2. Check network speed
3. Verify API server is running
4. Check firewall settings

## Future Enhancements

1. **OTP Expiration**: Add time-based OTP expiration
2. **Resend OTP**: Add "Resend OTP" button with rate limiting
3. **SMS Gateway Integration**: Support multiple SMS gateways
4. **Two-Factor Authentication**: Extend for 2FA scenarios
5. **Biometric Fallback**: Add biometric verification as alternative

## References

- SODA Campaign API Documentation: See the attached image/document
- EventService Implementation: `lib/services/event_service.dart`
- Auth Screen: `lib/screens/auth_screen.dart`
- OTP Input Screen: `lib/screens/steps/step4_flash_message.dart`

