import 'package:flutter/material.dart';

/// Screen 3: Displays the OTP code that user reads and enters on web portal
class OtpDisplayScreen extends StatefulWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final String otp;
  final String phoneNumber;
  final VoidCallback onDone;
  final VoidCallback onBack;

  const OtpDisplayScreen({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.otp,
    required this.phoneNumber,
    required this.onDone,
    required this.onBack,
  });

  @override
  State<OtpDisplayScreen> createState() => _OtpDisplayScreenState();
}

class _OtpDisplayScreenState extends State<OtpDisplayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatOtp(String otp) {
    return otp.split('').join('  ');
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
                  'Verification Code',
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
                  const SizedBox(height: 12),
                  // SIM card icon
                  Image.asset(
                    'assets/images/sim_card_icon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5A800), width: 2),
                        ),
                        child: const Icon(Icons.sim_card, size: 48, color: Color(0xFFE5A800)),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Flash Message by XSIM',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For phone: +855 ${widget.phoneNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // OTP Display
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFF0F4FF), Color(0xFFE8EEFF)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF33568F).withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your Verification Code',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF33568F),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _formatOtp(widget.otp),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F4181),
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Enter this code on the web portal',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Done button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: widget.onDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF33568F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
