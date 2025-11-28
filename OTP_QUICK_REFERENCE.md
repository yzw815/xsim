# OTP Integration - Quick Reference

## API Endpoint

```
POST http://155.12.30.102/send/campaign/msisdn
Content-Type: application/json

Request:
{
  "msisdn": "+855123456789",
  "message": "Your verification code is: 1234"
}

Success Response (200):
{
  "status": true,
  "code": 200,
  "message": "campaign sent"
}

Error Response:
{
  "error": {
    "status": false,
    "code": 404,
    "message": "Error description"
  }
}
```

## Usage Flow

### 1. Send OTP

```dart
// In your authentication flow
final otp = await EventService().sendOtp('+855123456789');

if (otp != null) {
  print('OTP sent: $otp');
  // Proceed to OTP entry screen
} else {
  print('Failed to send OTP');
  // Show error message
}
```

### 2. Verify OTP

```dart
// When user enters OTP
final enteredOtp = '1234';
final isValid = EventService().verifyOtp(enteredOtp);

if (isValid) {
  print('OTP verified successfully');
  // Proceed to next step
} else {
  print('Invalid OTP');
  // Show error message
}
```

### 3. Clear OTP (Optional)

```dart
// Clear stored OTP when done
EventService().clearOtp();
```

## Integration Points

### In Step 2 (Phone Entry)
- User enters phone number
- On "Continue" button click, go to Step 3

### In Step 3 (Authenticating)
- Call `sendOtp()` with full phone number (+855 prefix)
- Wait for API response
- If successful, go to Step 4
- If failed, show error and return to Step 2

### In Step 4 (OTP Entry)
- User enters 4-digit OTP code
- Call `verifyOtp()` with entered code
- If valid, proceed to Step 5
- If invalid, show error and clear fields

## Testing

### Console Logs
Watch console for these messages:
```
Sending OTP to +855123456789: 1234
OTP sent successfully to +855123456789
OTP verification: SUCCESS
```

### Check API Response
```bash
curl -X POST http://155.12.30.102/send/campaign/msisdn \
  -H "Content-Type: application/json" \
  -d '{"msisdn":"+855123456789","message":"Your verification code is: 1234"}'
```

## Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "Failed to send OTP" | API unreachable or returned error | Check API endpoint and network |
| "Incorrect code" | User entered wrong OTP | User should re-enter correct code |
| "Timeout" | API took too long to respond | Check network speed, increase timeout |

## Configuration

Change API endpoint:
```dart
EventService().setSodaEndpoint('http://your-api:port/path');
```

## Key Files Modified

1. `lib/services/event_service.dart` - OTP sending and verification logic
2. `lib/screens/auth_screen.dart` - Integration in auth flow
3. `lib/screens/steps/step4_flash_message.dart` - OTP input and verification UI
4. `lib/translations.dart` - Error messages

## Demo vs Production

**Demo Mode (Current):**
- Shows OTP code on screen for easy testing
- Console logs enabled

**Production Mode:**
- Remove OTP hint from UI (line 167-186 in step4_flash_message.dart)
- Reduce console logging
- Use HTTPS endpoint
- Add rate limiting
- Add OTP expiration

## Quick Checklist

- [x] SODA API endpoint configured
- [x] OTP generation (4-digit random)
- [x] OTP sending via API
- [x] OTP storage in memory
- [x] OTP verification logic
- [x] Error handling
- [x] User feedback (success/error messages)
- [x] Auto-advance on correct OTP
- [x] Field clearing on error
- [ ] OTP expiration (future enhancement)
- [ ] Resend OTP button (future enhancement)
- [ ] Rate limiting (future enhancement)

