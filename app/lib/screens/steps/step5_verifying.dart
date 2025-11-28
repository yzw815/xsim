import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step5Verifying extends StatefulWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final VoidCallback onNext;

  const Step5Verifying({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.onNext,
  });

  @override
  State<Step5Verifying> createState() => _Step5VerifyingState();
}

class _Step5VerifyingState extends State<Step5Verifying> {
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventService.verifying();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.t('verifying'),
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
                color: widget.primaryBlue,
              ),
            ),
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: widget.primaryBlue,
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
                widget.t('verifyInfo1'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(widget.t('verifyInfo2'), style: const TextStyle(fontSize: 15, height: 1.6)),
              Text(widget.t('verifyInfo3'), style: const TextStyle(fontSize: 15, height: 1.6)),
              Text(widget.t('verifyInfo4'), style: const TextStyle(fontSize: 15, height: 1.6)),
              Text(widget.t('verifyInfo5'), style: const TextStyle(fontSize: 15, height: 1.6)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 120,
              height: 48,
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryBlue,
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
        ),
      ],
    );
  }
}

