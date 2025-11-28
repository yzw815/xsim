import 'package:flutter/material.dart';

class Step3Authenticating extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: onBack,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Image.asset(
            'assets/images/gov_logo.png',
            height: 80,
            width: 80,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance, size: 40),
              );
            },
          ),
        ),
        const Spacer(),
        const Text(
          'Authentication XSIM User',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 60),
        Stack(
          alignment: Alignment.center,
          children: [
            // Flash Message Icon
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset(
                'assets/images/flash_message.png',
                fit: BoxFit.contain,
              ),
            ),
            // Loading indicator around the icon
            SizedBox(
              width: 160,
              height: 160,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: primaryBlue,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          '${t('checkFlash1')}\n${t('checkFlash2')}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 120,
            height: 48,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 128,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

