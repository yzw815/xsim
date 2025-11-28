import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step3Authenticating extends StatefulWidget {
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
  State<Step3Authenticating> createState() => _Step3AuthenticatingState();
}

class _Step3AuthenticatingState extends State<Step3Authenticating> {
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _simulateBackendEvents();
  }

  void _simulateBackendEvents() async {
    // Immediate: OTP request sent
    await _eventService.otpRequested('+855 0124876230');
    
    // After 1 second: Backend received the request
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) await _eventService.backendReceived();
    
    // After another 1 second: SMS sent
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) await _eventService.smsSent();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: widget.onBack,
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
        Text(
          widget.t('authenticating'),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: widget.darkBlue,
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
                color: widget.primaryBlue,
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
                        color: widget.primaryBlue,
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
                color: widget.primaryBlue,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          '${widget.t('checkFlash1')}\n${widget.t('checkFlash2')}',
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
              backgroundColor: widget.primaryBlue.withOpacity(0.5),
              disabledBackgroundColor: widget.primaryBlue.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.t('continue'),
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

