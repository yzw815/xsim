import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../services/event_service.dart';

class Step5Verifying extends StatefulWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final VoidCallback onNext;

  const Step5Verifying({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.onNext,
  });

  @override
  State<Step5Verifying> createState() => _Step5VerifyingState();
}

class _Step5VerifyingState extends State<Step5Verifying>
    with SingleTickerProviderStateMixin {
  final _eventService = EventService();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _eventService.verifying();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title at top 155px in Figma (~111px after safe area)
              const SizedBox(height: 111),
              // Title (Figma: Arial Rounded MT Bold, 30px, #33568F)
              const Text(
                'Verifying Authenticity',
                style: TextStyle(
                  fontFamily: 'Arial Rounded MT Bold',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33568F),
                ),
              ),
              // Gap to icon (Figma: 243 - 155 - 48 = 40px approx)
              const SizedBox(height: 44),
              // Icon with animated arc (Figma: 180x180 at top 243px)
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle with info icon
                    Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF8E7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Info icon
                    Image.asset(
                      'assets/images/info_icon.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.info_outline,
                          size: 80,
                          color: Color(0xFFE5A800),
                        );
                      },
                    ),
                    // Animated arc
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * math.pi,
                          child: CustomPaint(
                            size: const Size(180, 180),
                            painter: VerifyArcPainter(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Gap to text (Figma: 471 - 423 = 48px)
              const SizedBox(height: 48),
              // XSIM Server is verifying text (Figma: top 471px)
              const Text(
                'XSIM Server is verifying:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF33568F),
                ),
              ),
              // Gap to bullet list (Figma: 517 - 501 = 16px)
              const SizedBox(height: 16),
              // Bullet list (Figma: top 517px)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  BulletItem(text: 'Signature matches SIM public key'),
                  SizedBox(height: 8),
                  BulletItem(text: 'Challenge code is correct'),
                  SizedBox(height: 8),
                  BulletItem(text: 'SIM matches National ID'),
                  SizedBox(height: 8),
                  BulletItem(text: 'Request is still valid'),
                ],
              ),
              const Spacer(),
              // Next button (Figma: top 669px, 320x60)
              Center(
                child: SizedBox(
                  width: 320,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF33568F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom padding (Figma: 852 - 729 = 123px, accounting for home indicator)
              const SizedBox(height: 90),
            ],
          ),
        ),
      ],
    );
  }
}

// Bullet item widget
class BulletItem extends StatelessWidget {
  final String text;

  const BulletItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•  ',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF33568F),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF33568F),
              height: 1.75,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for the verification arc
class VerifyArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5A800)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 0.6, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
