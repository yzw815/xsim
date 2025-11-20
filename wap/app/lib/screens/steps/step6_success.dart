import 'package:flutter/material.dart';

class Step6Success extends StatelessWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final Color successGreen;
  final VoidCallback onProceed;

  const Step6Success({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.successGreen,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 100,
            color: successGreen,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          t('successTitle'),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: successGreen,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                t('successMessage1'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${t('successMessage2')}\n${t('successMessage3')}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            border: Border.all(color: Colors.green[200]!, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '🔐 ${t('tokenReceived')}',
            style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                t('proceedToDashboard'),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

