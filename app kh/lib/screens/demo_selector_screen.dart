import 'package:flutter/material.dart';

/// First screen: user chooses between App Demo or Web Portal Demo
class DemoSelectorScreen extends StatelessWidget {
  final VoidCallback onAppDemo;
  final VoidCallback onWebPortalDemo;

  const DemoSelectorScreen({
    super.key,
    required this.onAppDemo,
    required this.onWebPortalDemo,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg-image.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFFDBDBDB));
            },
          ),
        ),
        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Logo
                Image.asset(
                  'assets/images/cambodia_coat_of_arms.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.account_balance, size: 50, color: Colors.grey[700]),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'XSIM',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCE2E30),
                    letterSpacing: -1,
                  ),
                ),
                const Text(
                  'Authentication',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F4181),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'CAMBODIA 🇰🇭',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 48),
                // Demo selection card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Select Demo Mode',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F4181),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose how you want to experience XSIM authentication',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                      ),
                      const SizedBox(height: 28),
                      // App Demo button
                      _DemoButton(
                        icon: Icons.phone_android,
                        emoji: '📱',
                        title: 'App Demo',
                        subtitle: 'SIM-based OTP authentication\nfull on-device experience',
                        color: const Color(0xFF33568F),
                        onTap: onAppDemo,
                      ),
                      const SizedBox(height: 16),
                      // Web Portal Demo button
                      _DemoButton(
                        icon: Icons.language,
                        emoji: '🌐',
                        title: 'Web Portal Demo',
                        subtitle: 'Login via web portal with\npush notification OTP',
                        color: const Color(0xFF0D7C5F),
                        onTap: onWebPortalDemo,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Text(
                  'Powered by ZeptoMobile',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Styled demo selection button
class _DemoButton extends StatelessWidget {
  final IconData icon;
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DemoButton({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.2), width: 2),
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.04),
                color.withOpacity(0.08),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
