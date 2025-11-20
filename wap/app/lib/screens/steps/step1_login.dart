import 'package:flutter/material.dart';

class Step1Login extends StatelessWidget {
  final String Function(String) t;
  final String language;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onNext;
  final VoidCallback onToggleLanguage;

  const Step1Login({
    super.key,
    required this.t,
    required this.language,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onNext,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Logo
        Image.network(
          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-AeK1dqTdzm7bSzDCKuwc9d6MNRfFVv.png',
          height: 80,
          width: 80,
          errorBuilder: (c, e, s) => Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.account_balance, size: 40),
          ),
        ),
        const Spacer(),
        Text(
          '${t('title1')}\n${t('title2')}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: darkBlue,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            children: [
              TextSpan(text: '${t('secureLogin')}\n'),
              TextSpan(
                text: t('xsimAuth'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              t('loginBtn'),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onToggleLanguage,
          child: Text(
            '${t('language')}, ${language == 'km' ? t('khmer') : t('english')} | ${language == 'km' ? t('english') : t('khmer')}',
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 128,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

