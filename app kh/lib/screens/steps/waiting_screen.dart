import 'package:flutter/material.dart';

/// Screen 2: Waiting for OTP push notification from web portal
class WaitingScreen extends StatefulWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final String phoneNumber;
  final VoidCallback onBack;
  final Function(String otp) onOtpReceived;
  final VoidCallback? onChangeNumber;

  const WaitingScreen({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.phoneNumber,
    required this.onBack,
    required this.onOtpReceived,
    this.onChangeNumber,
  });

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
          decoration: const BoxDecoration(
            color: Color(0xFF275695),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: widget.onBack,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chevron_left, color: Color(0xFFF7B119), size: 28),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(color: Color(0xFFF7B119), fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'XSIM Ready',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content card
        Expanded(
          child: Container(
            width: double.infinity,
            transform: Matrix4.translationValues(0, -20, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(28),
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
                children: [
                  const SizedBox(height: 16),
                  // Success checkmark
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 48,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Registered Successfully',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F4181),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+855 ${widget.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF33568F),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Waiting animation
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF33568F).withOpacity(0.15),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.notifications_active,
                            size: 40,
                            color: Color(0xFF33568F),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Waiting for login request...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F4181),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'When someone enters your phone number on the web portal, an OTP will appear here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Simulate OTP button (for demo/testing)
                  const Text(
                    'For demo: OTP will appear automatically\nwhen push notification arrives',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Manual test button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Simulate receiving an OTP for testing
                        final otp = (1000 + DateTime.now().millisecond % 9000).toString();
                        widget.onOtpReceived(otp);
                      },
                      icon: const Icon(Icons.bug_report, size: 20),
                      label: const Text(
                        'Simulate OTP (Test)',
                        style: TextStyle(fontSize: 15),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF33568F),
                        side: const BorderSide(color: Color(0xFF33568F), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Change number button
                  if (widget.onChangeNumber != null)
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: TextButton.icon(
                        onPressed: widget.onChangeNumber,
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: const Text(
                          'Change Number',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black45,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
