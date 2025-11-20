# XSIM Cambodia - Project Structure

This project contains both **Web** and **Mobile** versions of the Cambodia Government Portal XSIM Authentication system.

## 📂 Directory Structure

```
/Users/yang/zeptosourcecode/xsim cambodia/
│
├── app/                                    # 📱 FLUTTER MOBILE APP
│   ├── lib/
│   │   ├── main.dart                      # App entry point
│   │   ├── translations.dart              # English & Khmer
│   │   ├── screens/
│   │   │   ├── auth_screen.dart          # State management
│   │   │   └── steps/                    # 6 authentication steps
│   │   │       ├── step1_login.dart
│   │   │       ├── step2_phone.dart
│   │   │       ├── step3_authenticating.dart
│   │   │       ├── step4_flash_message.dart
│   │   │       ├── step5_verifying.dart
│   │   │       └── step6_success.dart
│   │   └── widgets/
│   │       └── status_bar.dart
│   ├── pubspec.yaml                       # Flutter dependencies
│   ├── analysis_options.yaml              # Linting rules
│   ├── README.md                          # Mobile app documentation
│   └── SETUP.md                           # Flutter setup guide
│
└── wap/                                    # 🌐 NEXT.JS WEB APP
    ├── app/
    │   ├── page.tsx                       # Main authentication page
    │   ├── layout.tsx                     # App layout
    │   └── globals.css                    # Global styles
    ├── components/                        # React components
    │   ├── ui/                           # shadcn/ui components
    │   └── theme-provider.tsx
    ├── lib/                              # Utilities
    ├── public/                           # Static assets
    ├── package.json                      # Node dependencies
    ├── next.config.mjs                   # Next.js config
    └── tsconfig.json                     # TypeScript config
```

## 🚀 Quick Start

### Mobile App (Flutter)
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter pub get
flutter run -d chrome      # Web
flutter run -d macos       # macOS Desktop
flutter run -d ios         # iOS Simulator
flutter run -d android     # Android Emulator
```

### Web App (Next.js)
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/wap"
pnpm install
pnpm dev
```
Then open: http://localhost:3000

## 📱 Mobile App Features

- **Platform**: Flutter (iOS, Android, Web, Desktop)
- **Language**: Dart
- **UI Framework**: Material Design 3
- **Platforms Supported**:
  - ✅ iOS
  - ✅ Android
  - ✅ Web (Chrome, Safari, Firefox)
  - ✅ macOS Desktop
  - ✅ Windows Desktop
  - ✅ Linux Desktop

### Mobile App Commands
```bash
# Navigate to mobile app
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"

# Install dependencies
flutter pub get

# Run on different platforms
flutter run -d chrome      # Web browser
flutter run -d macos       # macOS app
flutter run -d ios         # iOS simulator
flutter run -d android     # Android emulator

# Build for production
flutter build web          # Web
flutter build ios          # iOS
flutter build apk          # Android APK
flutter build appbundle    # Android App Bundle
flutter build macos        # macOS app
```

## 🌐 Web App Features

- **Platform**: Next.js + React
- **Language**: TypeScript
- **UI Framework**: Tailwind CSS + shadcn/ui
- **Platforms Supported**:
  - ✅ Modern browsers (Chrome, Safari, Firefox, Edge)
  - ✅ Mobile browsers (iOS Safari, Chrome Mobile)
  - ✅ Responsive design

### Web App Commands
```bash
# Navigate to web app
cd "/Users/yang/zeptosourcecode/xsim cambodia/wap"

# Install dependencies
pnpm install

# Development server
pnpm dev

# Build for production
pnpm build

# Start production server
pnpm start
```

## 🔐 Authentication Flow (Both Versions)

1. **Step 1 - Login Screen**
   - Welcome message
   - Language toggle (English/Khmer)
   - Login button

2. **Step 2 - Phone Number Input**
   - +855 prefix (Cambodia)
   - Phone number validation
   - SIM registration confirmation

3. **Step 3 - Authenticating**
   - Loading animation
   - "Check Flash Message" instruction
   - Auto-advances after 3 seconds

4. **Step 4 - SIM Flash Message**
   - Phone mockup display
   - Challenge code (4 digits)
   - YES/NO buttons

5. **Step 5 - Server Verification**
   - Verification checklist:
     - ✓ Signature matches SIM public key
     - ✓ Challenge code is correct
     - ✓ SIM matches National ID
     - ✓ Request is still valid
   - Auto-advances after 3 seconds

6. **Step 6 - Success**
   - Success message
   - Auth token received
   - Proceed to dashboard button

## 🎨 Customization

### Colors
Both versions use the same color scheme:
- **Primary Blue**: `#1E40AF`
- **Dark Blue**: `#1E3A8A`
- **Success Green**: `#16A34A`

### Translations
- **Mobile**: Edit `app/lib/translations.dart`
- **Web**: Edit `wap/app/page.tsx` (lines 8-81)

### Logo
- **Mobile**: Update image URLs in step files
- **Web**: Update image URL in `page.tsx`

## 📊 Comparison

| Feature | Mobile (Flutter) | Web (Next.js) |
|---------|-----------------|---------------|
| **Platforms** | iOS, Android, Web, Desktop | Web browsers |
| **Performance** | Native performance | Browser-dependent |
| **Offline** | Possible with local storage | Limited |
| **Distribution** | App stores + Web | Web hosting |
| **Updates** | App store approval | Instant |
| **Development** | Single codebase | Single codebase |
| **Hot Reload** | ✅ Yes | ✅ Yes |

## 🛠️ Development Tools

### Mobile (Flutter)
- **IDE**: VS Code, Android Studio, IntelliJ IDEA
- **Debugging**: Flutter DevTools
- **Testing**: `flutter test`
- **Linting**: `flutter analyze`

### Web (Next.js)
- **IDE**: VS Code, WebStorm
- **Debugging**: Browser DevTools
- **Testing**: Jest, React Testing Library
- **Linting**: ESLint

## 📦 Dependencies

### Mobile (Flutter)
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

### Web (Next.js)
```json
{
  "dependencies": {
    "next": "latest",
    "react": "latest",
    "tailwindcss": "latest",
    "lucide-react": "latest"
  }
}
```

## 🚢 Deployment

### Mobile App
- **iOS**: App Store (requires Apple Developer account)
- **Android**: Google Play Store (requires Google Play Console)
- **Web**: Deploy to Vercel, Netlify, Firebase Hosting, etc.

### Web App
- **Recommended**: Vercel (optimized for Next.js)
- **Alternatives**: Netlify, AWS Amplify, Firebase Hosting

## 📖 Documentation

- [Mobile App README](./app/README.md)
- [Mobile App Setup Guide](./app/SETUP.md)
- [Flutter Documentation](https://docs.flutter.dev)
- [Next.js Documentation](https://nextjs.org/docs)

## 🆘 Support

### Mobile App Issues
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/app"
flutter doctor -v
```

### Web App Issues
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/wap"
pnpm install
pnpm dev
```

## 🎯 Recommended Usage

- **Mobile App**: For native iOS/Android apps with better performance and offline capabilities
- **Web App**: For quick browser access without installation

Both versions provide the same authentication flow and user experience!

---

**Last Updated**: November 19, 2024
**Flutter Version**: 3.38.2
**Next.js Version**: Latest

