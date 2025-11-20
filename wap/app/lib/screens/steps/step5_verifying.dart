import 'package:flutter/material.dart';

class Step5Verifying extends StatelessWidget {
  final String Function(String) t;
  final Color primaryBlue;

  const Step5Verifying({
    super.key,
    required this.t,
    required this.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t('verifying'),
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 60),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline,
                size: 80,
                color: primaryBlue,
              ),
            ),
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('verifyInfo1'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(t('verifyInfo2'), style: const TextStyle(fontSize: 15, height: 1.6)),
              Text(t('verifyInfo3'), style: const TextStyle(fontSize: 15, height: 1.6)),
              Text(t('verifyInfo4'), style: const TextStyle(fontSize: 15, height: 1.6)),
              Text(t('verifyInfo5'), style: const TextStyle(fontSize: 15, height: 1.6)),
            ],
          ),
        ),
      ],
    );
  }
}

