import 'package:flutter/material.dart';
import 'dart:math' as math;

class Step3Authenticating extends StatefulWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const Step3Authenticating({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<Step3Authenticating> createState() => _Step3AuthenticatingState();
}

class _Step3AuthenticatingState extends State<Step3Authenticating>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
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
    return Column(
      children: [
        // Blue header section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
          decoration: const BoxDecoration(
            color: Color(0xFF275695), // Blue header bg
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: widget.onBack,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.chevron_left,
                      color: Color(0xFFF7B119), // Yellow
                      size: 28,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFFF7B119), // Yellow
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Center(
                child: Text(
                  'Authentication XSIM User',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        // White card section
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 0),
            transform: Matrix4.translationValues(0, -20, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Step 1',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0x80000000), // 50% black
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        'Step 2',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        'Step 3',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0x80000000), // 50% black
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Flash message text
                  const Text(
                    'Please check the flash message on your phone.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Flash message icon with animation
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Envelope icon
                          Image.asset(
                            'assets/images/flash_envelope.png',
                            width: 100,
                            height: 111,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallbackIcon();
                            },
                          ),
                          // Lightning icon on top of envelope
                          Positioned(
                            top: 10,
                            child: Image.asset(
                              'assets/images/flash_lightning.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                            ),
                          ),
                          // Animated arc
                          Positioned(
                            top: 0,
                            right: 10,
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _controller.value * 2 * math.pi,
                                  child: CustomPaint(
                                    size: const Size(70, 70),
                                    painter: ArcPainter(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Continue button
                  SizedBox(
                    width: double.infinity,
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
                      child: Text(
                        widget.t('continue'),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.mail_outline,
        size: 60,
        color: Color(0xFFCE2E30),
      ),
    );
  }
}

// Custom painter for the arc animation
class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF275695)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 0.7, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
