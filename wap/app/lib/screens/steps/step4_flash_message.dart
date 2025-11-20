import 'package:flutter/material.dart';

class Step4FlashMessage extends StatelessWidget {
  final String Function(String) t;
  final String challengeCode;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onNo;
  final VoidCallback onYes;

  const Step4FlashMessage({
    super.key,
    required this.t,
    required this.challengeCode,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onNo,
    required this.onYes,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            )
          ],
          border: Border.all(color: Colors.black, width: 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notch simulation
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 120,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            // Status bar simulation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('9:41', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Row(
                    children: const [
                      Icon(Icons.signal_cellular_alt, size: 14),
                      SizedBox(width: 3),
                      Icon(Icons.wifi, size: 14),
                      SizedBox(width: 3),
                      Icon(Icons.battery_full, size: 14),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Header
            Text(
              t('simPopupTitle'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD4AF37), width: 4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.sim_card,
                      size: 56,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t('confirmLogin'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t('approveLogin'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$challengeCode?',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onNo,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            t('noBtn'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onYes,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            t('yesBtn'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Bottom indicator
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

