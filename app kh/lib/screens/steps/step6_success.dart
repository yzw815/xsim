import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step6Success extends StatefulWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final Color successGreen;
  final VoidCallback onBackToHome;
  final VoidCallback onBack;

  const Step6Success({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.successGreen,
    required this.onBackToHome,
    required this.onBack,
  });

  @override
  State<Step6Success> createState() => _Step6SuccessState();
}

class _Step6SuccessState extends State<Step6Success> {
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventService.authSuccess();
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
        // Back button
        Positioned(
          top: 16,
          left: 16,
          child: GestureDetector(
            onTap: widget.onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF33568F),
                size: 24,
              ),
            ),
          ),
        ),
        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title at top 155px in Figma (~111px after safe area)
              const SizedBox(height: 111),
              // Title (Figma: Arial Rounded MT Bold, 30px, #33568F)
              const Text(
                'Access Granted',
                style: TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33568F),
                ),
              ),
              // Gap to icon (Figma: 243 - 155 - 48 = 40px)
              const SizedBox(height: 40),
              // Success icon (Figma: 180x180 at top 243px)
              Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F8E8), // Light green
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/approval_icon.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.verified,
                        size: 80,
                        color: Color(0xFF00AD51),
                      );
                    },
                  ),
                ),
              ),
              // Gap to text (Figma: 448 - 423 = 25px)
              const SizedBox(height: 25),
              // Authentication successful text (Figma: top 448px)
              const Text(
                'Authentication successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33568F),
                ),
              ),
              // Gap to description (Figma: 486 - 478 = 8px)
              const SizedBox(height: 8),
              // Description text (Figma: top 486px, width 274px)
              const SizedBox(
                width: 274,
                child: Text(
                  'Your identity has been verified using SIM-based cryptographic signing',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF33568F),
                    height: 1.5,
                  ),
                ),
              ),
              // Gap to auth token badge (Figma: 594 - 570 = 24px approx)
              const SizedBox(height: 24),
              // Auth Token Received badge (Figma: top 594px, 240x50)
              Container(
                width: 240,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F8E8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/password_icon.png',
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.lock,
                          size: 24,
                          color: Color(0xFF00AD51),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Auth Token Received',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00AD51),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Back to Home button (primary action now)
              Center(
                child: SizedBox(
                  width: 320,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: widget.onBackToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF33568F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Back To Home',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom padding
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
