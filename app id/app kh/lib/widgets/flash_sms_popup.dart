import 'package:flutter/material.dart';

/// A realistic Flash SMS popup that mimics a real mobile flash SMS notification
class FlashSmsPopup extends StatefulWidget {
  final String otp;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const FlashSmsPopup({
    super.key,
    required this.otp,
    required this.onYes,
    required this.onNo,
  });

  /// Show the flash SMS popup as a dialog overlay
  static Future<bool?> show(
    BuildContext context, {
    required String otp,
    required VoidCallback onOk,
    VoidCallback? onDismiss,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xCC303132), // rgba(48,49,50,0.8)
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FlashSmsPopup(
          otp: otp,
          onYes: () {
            Navigator.of(context).pop(true);
            onOk();
          },
          onNo: () {
            Navigator.of(context).pop(false);
            if (onDismiss != null) {
              onDismiss();
            }
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<FlashSmsPopup> createState() => _FlashSmsPopupState();
}

class _FlashSmsPopupState extends State<FlashSmsPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Format OTP with spaces between characters
  String _formatOtp(String otp) {
    return otp.split('').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Flash Message Title
                      const Text(
                        'Flash Message',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // SIM Card Image
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/images/sim_card_icon.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E7),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE5A800),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.sim_card,
                                size: 60,
                                color: Color(0xFFE5A800),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // OTP Code with spaced characters
                      Text(
                        _formatOtp(widget.otp),
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 10,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Flash Message by XSIM
                      const Text(
                        'Flash Message by XSIM',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Click Yes instruction
                      const Text(
                        'Click Yes to continue login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // YES and NO Buttons
                      Row(
                        children: [
                          // YES Button - Filled
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                onPressed: widget.onYes,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF33568F),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // NO Button - Outlined
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: OutlinedButton(
                                onPressed: widget.onNo,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF33568F),
                                    width: 3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF33568F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
