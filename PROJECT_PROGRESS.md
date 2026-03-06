# XSIM Cambodia Project Status

This document tracks the milestones, completed progress, and pending steps for the XSIM Cambodia application components.

**Last Updated:** March 2026

## 1. Summary of Completed Infrastructure
- Dual-demo capability added to the main mobile application. User can toggle between the standalone App Demo and the integrated Web Portal Demo.
- Phone Registration functionality inside the Mobile App implemented (`register_screen.dart`).
- FCM Cloud Messaging enabled for securely receiving OTPs both on iOS and Android.
- A fully functional Web Portal demo created and deployed via static site generation. Wait states and mock dashboards styled appropriately for a government entity aesthetic.
- The Node.js Express Backend was entirely ported to **Hono + Cloudflare Workers** to ensure 100% serverless, edge-deployed routing and database management without relying on internal IPs (`10.0.2.2`). KV namespace successfully bridges app registration to portal verification.

## 2. Platforms Status

### 📱 Android Application (Play Store)
- **Status**: ✅ **Live / Under Review**
- **Bundle ID**: `com.zeptomobile.xsim.kh`
- **Current Version**: `1.1.0+7` (Build 7)
- **Firebase Status**: Working (FCM tokens generated properly).
- **Milestones**: Signed App Bundle built successfully. Alpha and Release tracks configured.

### 🍎 iOS Application (App Store)
- **Status**: ⏳ **Under Apple App Review**
- **Bundle ID**: `com.zeptomobile.xsim-cambodia`
- **Current Version**: `1.1.0+7` (Build 7)
- **Firebase Status**: Working (`GoogleService-Info.plist` correctly mapped to Xcode project).
- **Resolutions Made**: 
  - `hasAlpha` bug on iOS App Icons solved. Icons flattened correctly.
  - App Store Connect configuration finished (Support URLs, Age Ratings, Privacy Forms, Export compliance checks).
  - Xcode simulators configured correctly; try-catch injected to prevent Firebase initializations from stalling simulator startups.

### 🌐 Web Portal (Cloudflare Pages)
- **Status**: ✅ **Live**
- **Live URL**: `https://xsim-portal.pages.dev`
- **Capabilities**: Cross-device OTP login simulation. Proper CSS `z-index` and pointer styling implemented to prevent unclickable layout boxes. Privacy Policy created for App Store Verification.

### ⚡ Cloudflare API Server (Cloudflare Workers)
- **Status**: ✅ **Live**
- **Live URL**: `https://xsim-otp-server.yangzw.workers.dev`
- **Capabilities**: Registers user data safely using Cloudflare KV. Generates Google Access Tokens securely out of `.json` service accounts directly to bridge Web-to-App OTP commands for FCM v1.

## 3. Pending/Next Steps
- **Wait on Apple Review Process**: It could take anywhere from 12-48 hours. If rejected for metadata (e.g. testing credentials missing), respond and adjust within App Store Connect.
- **TestFlight Distribution**: Use TestFlight (already prepared) to add internal testers while App Review processes.
- **Production Key Rotations**: Optionally, rotate FCM service account tokens or implement stricter validation logic before mass production.
