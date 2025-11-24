# Demo Monitor - Quick Start

Get the real-time demo monitoring system running in 3 steps.

## 🚀 Quick Start

### Step 1: Start the Dashboard (Terminal 1)
```bash
cd wap
pnpm dev
```

Then open in browser: **http://localhost:3000/demo-monitor**

### Step 2: Configure Flutter App

**Choose based on your setup:**

- ✅ **Android Emulator**: No changes needed (uses `10.0.2.2`)
- 📱 **iOS Simulator**: Change endpoint to `localhost`
- 📲 **Physical Device**: Change endpoint to your computer's IP

To change endpoint, edit `app/lib/services/event_service.dart` line 13:
```dart
String _apiEndpoint = 'http://YOUR_IP:3000/api/events';
```

### Step 3: Run the App (Terminal 2)
```bash
cd app
flutter run
```

## 🎯 Demo Flow

1. Dashboard shows "Connected" ✅
2. Open mobile app → See "Mobile app opened" event
3. Click Login → See "User clicked Login" event  
4. Enter phone → See "User entered phone number" event
5. Watch simulated backend events appear automatically
6. Enter verification code → See remaining events
7. Success! 🎉

## 🔄 Reset Between Demos

Click **"Clear Events"** button on dashboard

## ⚠️ Troubleshooting

**No events appearing?**
```bash
# Test the API manually:
curl -X POST http://localhost:3000/api/events \
  -H "Content-Type: application/json" \
  -d '{"type":"test","description":"Test event"}'
```

If test event appears but app events don't:
- Check Flutter console for errors
- Verify endpoint configuration
- Ensure same Wi-Fi network (physical device)

**Dashboard shows "Disconnected"?**
- Refresh the page
- Check if Next.js server is running
- Look for errors in browser console

## 📖 Full Documentation

See `DEMO_MONITOR_GUIDE.md` for detailed information.

## 🎬 Production Demo

For deployed apps, update the endpoint to your production URL:
```dart
String _apiEndpoint = 'https://your-app.vercel.app/api/events';
```

Then rebuild:
```bash
flutter build apk --release
```

---

**That's it! You're ready to demo!** 🎉

