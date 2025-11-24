# Demo Monitoring Dashboard Guide

This guide explains how to use the real-time demo monitoring system to showcase the XSIM authentication flow.

## Overview

The demo monitoring system consists of:
- **Next.js Dashboard** - Web interface showing real-time events
- **Flutter Mobile App** - Sends events as users interact with it
- **SSE Backend** - Server-Sent Events for live updates

## Architecture

```
┌─────────────────┐         HTTP POST          ┌──────────────────┐
│  Flutter App    │  ─────────────────────────> │  Next.js API     │
│  (Mobile)       │      (Send Events)          │  /api/events     │
└─────────────────┘                             └──────────────────┘
                                                         │
                                                         │ SSE Stream
                                                         ▼
                                                ┌──────────────────┐
                                                │  Dashboard UI    │
                                                │  /demo-monitor   │
                                                └──────────────────┘
```

## Setup Instructions

### 1. Start the Next.js Development Server

```bash
cd wap
pnpm install  # If not already installed
pnpm dev
```

The server will start on `http://localhost:3000`

### 2. Open the Monitoring Dashboard

Open your browser and navigate to:
```
http://localhost:3000/demo-monitor
```

Keep this page open during your demo. You should see:
- A "Connected" status badge (green)
- Instructions on the right side
- Empty timeline waiting for events

### 3. Configure the Flutter App

#### For Android Emulator:
The default configuration (`10.0.2.2:3000`) should work out of the box.

#### For iOS Simulator:
Update the endpoint in `app/lib/services/event_service.dart`:
```dart
String _apiEndpoint = 'http://localhost:3000/api/events';
```

#### For Physical Device:
1. Find your computer's IP address:
   - Mac: System Settings → Network → Wi-Fi → Details → IP Address
   - Windows: `ipconfig` in Command Prompt, look for IPv4 Address
   - Linux: `ip addr show`

2. Update the endpoint in `app/lib/services/event_service.dart`:
```dart
String _apiEndpoint = 'http://YOUR_IP_ADDRESS:3000/api/events';
```
Replace `YOUR_IP_ADDRESS` with your actual IP (e.g., `192.168.1.100`)

3. Ensure your phone and computer are on the same Wi-Fi network

### 4. Run the Flutter App

```bash
cd app
flutter pub get
flutter run
```

Or build and install the APK:
```bash
flutter build apk --release
# Install the APK: app/build/app/outputs/flutter-apk/app-release.apk
```

## Demo Flow

Once everything is running, the demo flow will be:

### Step 1: Login Screen
- **Event Sent**: "Mobile app opened"
- User sees the Cambodia Government Portal welcome screen
- User clicks "Login"
- **Event Sent**: "User clicked Login button"

### Step 2: Phone Number Entry
- User enters their phone number (e.g., 0124876230)
- User clicks "Continue"
- **Event Sent**: "User entered phone number" (with MSISDN)

### Step 3: Authenticating
- **Event Sent**: "Requesting OTP from backend"
- After 1 second: **Event Sent**: "Backend received OTP request" (simulated)
- After 2 seconds: **Event Sent**: "Flash SMS sent to device" (simulated)
- App automatically advances to next screen

### Step 4: SMS Verification
- **Event Sent**: "User received flash SMS"
- User enters the 4-digit code shown on screen
- **Event Sent**: "User entered verification code" (with code)

### Step 5: Verifying
- **Event Sent**: "Verifying user credentials"
- App shows verification progress
- Automatically advances after 3 seconds

### Step 6: Success
- **Event Sent**: "Authentication successful! 🎉"
- User sees success screen

## Event Types

The system tracks these event types with color coding:

| Event Type | Color | Description |
|------------|-------|-------------|
| `app_opened` | Blue | App launched |
| `login_clicked` | Blue | Login button pressed |
| `phone_entered` | Blue | Phone number submitted |
| `otp_requested` | Purple | OTP request sent to backend |
| `backend_received` | Purple | Backend acknowledged request |
| `sms_sent` | Purple | SMS dispatched |
| `sms_received` | Green | User received SMS |
| `code_entered` | Blue | Verification code submitted |
| `verifying` | Purple | Credentials being verified |
| `success` | Emerald | Authentication complete |

## Resetting for New Demo

To clear the event timeline and start fresh:
1. Click the "Clear Events" button in the top-right of the dashboard
2. The timeline will reset
3. You can now go through the flow again

## Troubleshooting

### Dashboard shows "Disconnected"
- Ensure Next.js dev server is running
- Refresh the browser page
- Check browser console for errors

### No events appearing on dashboard
1. **Check network connectivity**:
   - Physical device: Ensure phone and computer are on same Wi-Fi
   - Verify firewall isn't blocking port 3000

2. **Check Flutter app console**:
   - Look for "Event sent:" messages
   - Look for connection errors

3. **Verify endpoint configuration**:
   - Check `app/lib/services/event_service.dart`
   - Ensure endpoint matches your setup (localhost, 10.0.2.2, or IP address)

4. **Test the API manually**:
   ```bash
   curl -X POST http://localhost:3000/api/events \
     -H "Content-Type: application/json" \
     -d '{"type":"test","description":"Test event"}'
   ```
   This should appear on the dashboard immediately.

### Events arrive with delay
- This is normal for Server-Sent Events
- Typical delay is < 100ms
- Check network latency if delays are significant

### Flutter app can't connect
- **Android emulator**: Use `10.0.2.2` instead of `localhost`
- **iOS simulator**: Use `localhost`
- **Physical device**: Use computer's actual IP address
- Ensure Next.js server allows connections from your network

## Production Deployment

For production demos with deployed apps:

1. Deploy Next.js app to Vercel/similar:
   ```bash
   cd wap
   vercel deploy
   ```

2. Update Flutter app endpoint to production URL:
   ```dart
   String _apiEndpoint = 'https://your-app.vercel.app/api/events';
   ```

3. Rebuild and distribute the app:
   ```bash
   flutter build apk --release
   ```

## Customization

### Adding New Events

1. Add a method to `app/lib/services/event_service.dart`:
   ```dart
   Future<void> customEvent(String data) => sendEvent(
     'custom_event',
     'Custom event description',
     data: {'custom_field': data},
   );
   ```

2. Call it from your Flutter code:
   ```dart
   EventService().customEvent('my data');
   ```

3. Update dashboard colors in `wap/app/demo-monitor/page.tsx` if needed:
   ```typescript
   if (['custom_event'].includes(type)) {
     return 'bg-orange-500/10 text-orange-700 border-orange-200';
   }
   ```

### Changing Event Storage

Currently events are stored in memory. For persistent storage:
- Replace in-memory array with Redis/database
- Update `wap/app/api/events/route.ts`

## Tips for Great Demos

1. **Rehearse First**: Run through the flow once to ensure everything works
2. **Full Screen**: Put dashboard in full screen mode for better visibility
3. **Clear Between Runs**: Use "Clear Events" between demo runs
4. **Explain Events**: As each event appears, explain what's happening in the backend
5. **Use Large Screen**: Project the dashboard on a large screen for audience viewing
6. **Backup Plan**: Have screenshots ready in case of connectivity issues

## Support

For issues or questions:
- Check the troubleshooting section above
- Review the plan document: `real-time-demo.plan.md`
- Inspect browser console and Flutter logs for detailed error messages

