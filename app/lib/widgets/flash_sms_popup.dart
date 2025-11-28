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
      barrierColor: Colors.black87,
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Flash Message Header Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EED9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Flash Message',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 28),
                    
                    // SIM Card Image
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        'assets/images/sim_card.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // OTP Code
                    Text(
                      widget.otp,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 8,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Flash Message by XSIM
                    const Text(
                      'Flash Message by XSIM',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Click Yes instruction
                    const Text(
                      'Click Yes to continue Login',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black45,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // YES and NO Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Row(
                        children: [
                          // YES Button
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton(
                                onPressed: widget.onYes,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.black, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'YES',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // NO Button
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton(
                                onPressed: widget.onNo,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.black, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'NO',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
