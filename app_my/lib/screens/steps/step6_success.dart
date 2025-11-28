import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step6Success extends StatefulWidget {
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
  State<Step6Success> createState() => _Step6SuccessState();
}

class _Step6SuccessState extends State<Step6Success> {
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventService.authSuccess();
  }

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
            color: widget.successGreen,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          widget.t('successTitle'),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: widget.successGreen,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                widget.t('successMessage1'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.t('successMessage2')}\n${widget.t('successMessage3')}',
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
            '🔐 ${widget.t('tokenReceived')}',
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
              onPressed: widget.onProceed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.t('proceedToDashboard'),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

