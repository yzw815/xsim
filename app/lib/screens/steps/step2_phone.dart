import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step2Phone extends StatelessWidget {
  final String Function(String) t;
  final String phoneNumber;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final Function(String) onPhoneChanged;

  const Step2Phone({
    super.key,
    required this.t,
    required this.phoneNumber,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onBack,
    required this.onNext,
    required this.onPhoneChanged,
  });

  void _handleContinue() {
    final fullPhone = '+855 $phoneNumber';
    EventService().phoneEntered(fullPhone);
    onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: onBack,
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
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
        const SizedBox(height: 40),
        Text(
          t('verifyTitle'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text(
                '+855 ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.phone,
                  onChanged: onPhoneChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: t('phonePlaceholder'),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          '${t('simRegistered1')}\n${t('simRegistered2')}\n${t('simRegistered3')}',
          textAlign: TextAlign.center,
          style: const TextStyle(height: 1.6, fontSize: 16),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _handleContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              t('continue'),
              style: const TextStyle(fontSize: 18, color: Colors.white),
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

