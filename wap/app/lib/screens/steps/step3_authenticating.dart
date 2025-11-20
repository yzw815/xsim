import 'package:flutter/material.dart';

class Step3Authenticating extends StatelessWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onBack;

  const Step3Authenticating({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onBack,
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
          child: Image.network(
            'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-AeK1dqTdzm7bSzDCKuwc9d6MNRfFVv.png',
            height: 64,
            width: 64,
            errorBuilder: (c, e, s) => Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.account_balance, size: 32),
            ),
          ),
        ),
        const Spacer(),
        Text(
          t('authenticating'),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 60),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.smartphone, color: Colors.white, size: 64),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.lock, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 148,
              height: 148,
              child: CircularProgressIndicator(
                strokeWidth: 4,
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
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue.withOpacity(0.5),
              disabledBackgroundColor: primaryBlue.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              t('continue'),
              style: const TextStyle(fontSize: 18, color: Colors.white70),
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

