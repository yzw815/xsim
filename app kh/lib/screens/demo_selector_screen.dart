import 'package:flutter/material.dart';

/// First screen: user chooses between Mobile App or Web Portal Authentication
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
        // Content — ListView avoids overflow on any screen size
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              const SizedBox(height: 52),
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/cambodia_coat_of_arms.png',
                  height: 90,
                  width: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.account_balance,
                          size: 48, color: Colors.grey[700]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'XSIM',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCE2E30),
                    letterSpacing: -1,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Authentication',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F4181),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'CAMBODIA',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              // Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                      'Select Authentication Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F4181),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Mobile App button
                    _DemoButton(
                      icon: Icons.phone_android,
                      title: 'Mobile App',
                      subtitle: 'SIM-based OTP on your device',
                      color: const Color(0xFF33568F),
                      onTap: onAppDemo,
                    ),
                    const SizedBox(height: 12),
                    // Web Portal button
                    _DemoButton(
                      icon: Icons.language,
                      title: 'Web Portal',
                      subtitle: 'Login via web with push OTP',
                      color: const Color(0xFF0D7C5F),
                      onTap: onWebPortalDemo,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Powered by ZeptoMobile',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

/// Styled demo selection button
class _DemoButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DemoButton({
    required this.icon,
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
          padding: const EdgeInsets.all(18),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(icon, size: 26, color: color),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}
