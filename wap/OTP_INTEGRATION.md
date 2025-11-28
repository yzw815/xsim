# WAP OTP Integration

This document explains the OTP (One-Time Password) integration for the WAP (Web Application).

## Overview

The WAP now includes full OTP functionality with the SODA Campaign API integration, similar to the mobile app.

## API Endpoints

### 1. Send OTP

**Endpoint:** `POST /api/otp/send`

**Request:**
```json
{
  "msisdn": "+855123456789"
}
```

**Success Response:**
```json
{
  "success": true,
  "message": "OTP sent successfully",
  "otp": "1234",
  "apiResponse": "campaign sent"
}
```

**Error Response:**
```json
{
  "success": false,
  "error": "Error message"
}
```

### 2. Verify OTP

**Endpoint:** `POST /api/otp/verify`

**Request:**
```json
{
  "msisdn": "+855123456789",
  "otp": "1234"
}
```

**Success Response:**
```json
{
  "success": true,
  "valid": true,
  "message": "OTP verified successfully"
}
```

**Error Response:**
```json
{
  "success": false,
  "valid": false,
  "error": "Invalid OTP"
}
```

### 3. Get Logs

**Endpoint:** `GET /api/logs`

**Query Parameters:**
- `category` (optional): Filter by category (OTP, API, AUTH, SYSTEM)
- `level` (optional): Filter by level (INFO, SUCCESS, WARNING, ERROR)
- `limit` (optional): Number of logs to return (default: 100)

**Response:**
```json
{
  "success": true,
  "count": 10,
  "logs": [
    {
      "id": "1234567890-abc123",
      "timestamp": 1700000000000,
      "level": "SUCCESS",
      "category": "OTP",
      "message": "OTP sent successfully",
      "data": {
        "msisdn": "+855123456789",
        "otp": "1234"
      }
    }
  ]
}
```

### 4. Clear Logs

**Endpoint:** `DELETE /api/logs`

**Response:**
```json
{
  "success": true,
  "message": "Logs cleared"
}
```

## Files Created/Modified

### New Files

1. **`/wap/lib/otp-store.ts`** - Shared OTP storage module
   - Stores OTPs in memory (use Redis/DB in production)
   - Auto-expires after 5 minutes
   - Provides verify() method

2. **`/wap/lib/log-store.ts`** - Logging module
   - In-memory log storage
   - Multiple log levels and categories
   - Convenience methods for OTP/API logging

3. **`/wap/app/api/otp/send/route.ts`** - Send OTP endpoint
   - Generates 4-digit OTP
   - Calls SODA Campaign API
   - Falls back to local storage if API unavailable

4. **`/wap/app/api/otp/verify/route.ts`** - Verify OTP endpoint
   - Verifies OTP against stored value
   - Handles expiry and cleanup

5. **`/wap/app/api/logs/route.ts`** - Logs API
   - GET to retrieve logs
   - DELETE to clear logs

### Modified Files

1. **`/wap/app/page.tsx`** - Main auth flow
   - Integrated OTP sending on step 3
   - Added verifyOtp function
   - Added log viewer UI

## Log Viewer

A built-in log viewer is available in the web app:

1. **Access**: Click the document icon (📄) in the top-right corner
2. **Features**:
   - View all logs in real-time (auto-refresh every 2 seconds)
   - Color-coded by log level
   - Expandable entries to see detailed data
   - Clear logs button
   - Refresh button

## Authentication Flow

1. **Step 1**: User clicks "Login"
2. **Step 2**: User enters phone number
3. **Step 3**: Authenticating
   - App calls `/api/otp/send` with the phone number
   - API generates 4-digit OTP
   - API calls SODA Campaign API to send SMS
   - OTP is stored for verification
   - Advances to Step 4 after 2 seconds
4. **Step 4**: OTP Entry
   - User enters the 4-digit code
   - App verifies against stored OTP (or via API)
   - If correct, advances to Step 5
   - If incorrect, shows error and clears fields
5. **Step 5**: Verifying
6. **Step 6**: Success

## Configuration

### SODA API Endpoint

The SODA API endpoint is configured in `/wap/app/api/otp/send/route.ts`:

```typescript
const SODA_API_ENDPOINT = 'http://155.12.30.102/send/campaign/msisdn';
```

### OTP Expiry

Default OTP expiry is 5 minutes, configured in `/wap/lib/otp-store.ts`:

```typescript
export const OTP_EXPIRY_MS = 5 * 60 * 1000;
```

## Testing

### Test OTP Send

```bash
curl -X POST http://localhost:3000/api/otp/send \
  -H "Content-Type: application/json" \
  -d '{"msisdn":"+855123456789"}'
```

### Test OTP Verify

```bash
curl -X POST http://localhost:3000/api/otp/verify \
  -H "Content-Type: application/json" \
  -d '{"msisdn":"+855123456789","otp":"1234"}'
```

### View Logs

```bash
curl http://localhost:3000/api/logs
```

### Clear Logs

```bash
curl -X DELETE http://localhost:3000/api/logs
```

## Demo Mode

For demo purposes:
- The sent OTP is displayed in a blue info box on the OTP entry screen
- OTP is returned in the API response (remove in production)
- If SODA API is unavailable, OTP is still generated and stored locally

## Production Considerations

1. **Remove OTP from responses** - Don't return OTP in API responses
2. **Use Redis/Database** - Replace in-memory storage with persistent storage
3. **Rate limiting** - Add rate limiting to prevent abuse
4. **HTTPS** - Use HTTPS for all API calls
5. **Remove demo hints** - Remove the OTP hint display
6. **Add authentication** - Protect API endpoints with authentication

## Error Handling

The system handles various error scenarios:
- Missing parameters (400 error)
- SODA API unavailable (falls back to local storage)
- OTP expired (asks user to request new OTP)
- Invalid OTP (shows error, clears fields)
- Network errors (shows error message)

## Logging

All operations are logged with:
- Timestamp
- Log level (INFO, SUCCESS, WARNING, ERROR)
- Category (OTP, API, AUTH, SYSTEM)
- Message
- Additional data (MSISDN, OTP, API responses, etc.)

Logs can be viewed in the built-in log viewer or retrieved via the `/api/logs` endpoint.

