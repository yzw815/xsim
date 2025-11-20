# Cambodia Government Portal - XSIM Authentication

This directory contains both **Next.js Web** and **Flutter Mobile** versions of the XSIM authentication flow.

## 📁 Structure

```
app/
├── lib/                    # Flutter mobile app
│   ├── main.dart
│   ├── translations.dart
│   ├── screens/
│   └── widgets/
├── pubspec.yaml           # Flutter dependencies
├── page.tsx               # Next.js web page
├── layout.tsx             # Next.js layout
└── globals.css           # Next.js styles
```

## 🌐 Web Version (Next.js)

The web version is built with Next.js and React.

### Run Web Version:
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/wap"
pnpm install
pnpm dev
```

Then open: http://localhost:3000

## 📱 Mobile Version (Flutter)

The mobile version is built with Flutter and can run on iOS, Android, Web, and Desktop.

### Run Mobile Version:
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/wap/app"
flutter pub get
flutter run -d chrome      # Web
flutter run -d macos       # macOS Desktop
flutter run -d ios         # iOS Simulator
flutter run -d android     # Android Emulator
```

See [SETUP.md](./SETUP.md) for detailed Flutter setup instructions.

## ✨ Features

Both versions include:

- 🇰🇭 **Bilingual Support**: English & Khmer
- 🔐 **6-Step Authentication Flow**:
  1. Initial login screen
  2. Phone number input
  3. Authenticating (loading)
  4. SIM flash message popup
  5. Server verification
  6. Success screen
- 📱 **Responsive Design**: Works on all screen sizes
- 💫 **Smooth Animations**: Auto-transitions and loading states
- 🎨 **Modern UI**: Clean, professional design

## 🎯 Use Cases

- **Web Version**: For browser-based access on desktop/mobile
- **Mobile Version**: For native iOS/Android apps with better performance

## 🚀 Quick Start

### For Web Development:
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/wap"
pnpm dev
```

### For Mobile Development:
```bash
cd "/Users/yang/zeptosourcecode/xsim cambodia/wap/app"
flutter run -d chrome
```

## 📖 Documentation

- [Flutter Setup Guide](./SETUP.md) - Detailed Flutter installation and usage
- [Next.js Documentation](https://nextjs.org/docs)
- [Flutter Documentation](https://docs.flutter.dev)

## 🔧 Development

### Edit Translations
- **Web**: Edit `page.tsx` (lines 8-81)
- **Mobile**: Edit `lib/translations.dart`

### Edit Colors
- **Web**: Edit `page.tsx` inline styles
- **Mobile**: Edit `lib/screens/auth_screen.dart`

### Edit Flow Steps
- **Web**: Edit `page.tsx` step components
- **Mobile**: Edit files in `lib/screens/steps/`

## 📦 Dependencies

### Web (Next.js):
- React
- Next.js
- Tailwind CSS
- Lucide Icons
- shadcn/ui components

### Mobile (Flutter):
- Flutter SDK 3.0+
- Dart 3.0+
- Material Design widgets

## 🌟 Next Steps

1. Choose your platform (Web or Mobile)
2. Follow the setup instructions above
3. Customize colors, text, and flow as needed
4. Add API integration for real authentication
5. Deploy to production

Happy coding! 🎉

