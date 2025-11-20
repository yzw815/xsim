# XSIM Cambodia - Web Application Portal (WAP)

A modern, responsive web authentication portal for the XSIM Cambodia Government Portal system.

## 🌟 Features

- **6-Step Authentication Flow**
  - Step 1: Initial Login Screen
  - Step 2: Mobile Number Entry
  - Step 3: Authenticating (Loading)
  - Step 4: OTP Input (4-digit code)
  - Step 5: Server Verification
  - Step 6: Success Screen

- **Bilingual Support**: English and Khmer (ភាសាខ្មែរ)
- **Responsive Design**: Optimized for mobile and desktop
- **Modern UI**: Built with Next.js 16 and Tailwind CSS
- **Type-Safe**: Full TypeScript support
- **Auto-Focus**: OTP inputs with automatic focus management
- **Auto-Validation**: Real-time OTP validation

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ 
- pnpm (recommended) or npm

### Installation

```bash
# Install dependencies
pnpm install

# Run development server
pnpm dev

# Build for production
pnpm build

# Start production server
pnpm start
```

Open [http://localhost:3000](http://localhost:3000) to view the application.

## 🛠️ Tech Stack

- **Framework**: Next.js 16.0.3
- **React**: 19.2.0
- **Styling**: Tailwind CSS 4.1.9
- **UI Components**: Radix UI
- **Icons**: Lucide React
- **Language**: TypeScript 5
- **Package Manager**: pnpm

## 📁 Project Structure

```
wap/
├── app/
│   ├── page.tsx          # Main authentication flow
│   ├── layout.tsx        # Root layout with metadata
│   └── globals.css       # Global styles
├── components/
│   └── ui/               # Reusable UI components
├── lib/
│   └── utils.ts          # Utility functions
├── public/               # Static assets
└── styles/               # Additional styles
```

## 🎨 Design Features

- **Centered Layout**: Content is vertically and horizontally centered
- **Consistent Branding**: Standardized logo sizes (64x64px)
- **Clean UI**: No status bar, minimal distractions
- **Smooth Transitions**: Animated step transitions
- **Error Handling**: User-friendly error messages

## 🔧 Configuration

### Environment Variables

Create a `.env.local` file for environment-specific configuration:

```env
NEXT_PUBLIC_APP_NAME=XSIM Cambodia
```

### Customization

- **Colors**: Edit Tailwind config or CSS variables
- **Translations**: Modify the `translations` object in `app/page.tsx`
- **Logo**: Replace the image URL in each step component

## 📱 Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## 🤝 Contributing

This is a government portal project. For contributions or issues, please contact the development team.

## 📄 License

© 2024 XSIM Cambodia. All rights reserved.

## 🔗 Related Projects

- **Flutter Mobile App**: See `/app` directory for the cross-platform mobile application
- **Documentation**: See project root for comprehensive documentation

## 📞 Support

For technical support or questions, please refer to the main project documentation.

