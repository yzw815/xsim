import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step1Login extends StatefulWidget {
  final String Function(String) t;
  final String language;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onNext;
  final VoidCallback onToggleLanguage;

  const Step1Login({
    super.key,
    required this.t,
    required this.language,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onNext,
    required this.onToggleLanguage,
  });

  @override
  State<Step1Login> createState() => _Step1LoginState();
}

class _Step1LoginState extends State<Step1Login> {
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventService.appOpened();
  }

  void _handleLogin() {
    _eventService.loginClicked();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg-image.png',
            fit: BoxFit.cover,
          ),
        ),
        // Main content
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo at top 142px in Figma (~98px after safe area)
            const SizedBox(height: 98),
            // Cambodia Coat of Arms Logo (150x150)
            Image.asset(
              'assets/images/cambodia_coat_of_arms.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    size: 80,
                    color: Colors.grey[700],
                  ),
                );
              },
            ),
            // Gap to title (Figma: 312 - 262 = 20px for larger logo)
            const SizedBox(height: 20),
            // Title: "Cambodia" in red (Figma: Arial Rounded MT Bold, 40px, #CE2E30)
            Text(
              widget.t('title1'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFFCE2E30), // Cambodia red
                height: 1.2,
                letterSpacing: -1.2,
              ),
            ),
            // Title: "Government" in dark blue (Figma: Arial Rounded MT Bold, 40px, #1F4181)
            Text(
              widget.t('title2'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4181), // Dark blue
                height: 1.2,
                letterSpacing: -1.2,
              ),
            ),
            // Title: "Portal" in dark blue (Figma: Arial Rounded MT Bold, 40px, #1F4181)
            Text(
              widget.t('title3'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4181), // Dark blue
                height: 1.2,
                letterSpacing: -1.2,
              ),
            ),
            const Spacer(),
            // Subtitle text (Figma: top 496px)
            Column(
              children: [
                Text(
                  widget.t('secureLogin'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.t('xsimAuth'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Gap to button (Figma: 612 - 556 = 56px approx)
            const SizedBox(height: 56),
            // Login Button (Figma: top 612px, 320x60)
            Center(
              child: SizedBox(
                width: 320,
                height: 60,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF33568F), // Button blue
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.t('loginBtn'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Bottom padding (Figma: 852 - 672 = 180px, but accounting for home indicator ~34px)
            const SizedBox(height: 140),
          ],
        ),
      ],
    );
  }
}
