import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step1Login extends StatefulWidget {
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
  State<Step1Login> createState() => _Step1LoginState();
}

class _Step1LoginState extends State<Step1Login> {
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    // Send app opened event
    _eventService.appOpened();
  }

  void _handleLogin() {
    _eventService.loginClicked();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Cambodian Royal Arms Logo
        Image.asset(
          'assets/images/gov_logo.png',
          height: 120,
          width: 120,
          errorBuilder: (context, error, stackTrace) {
            // Fallback icon if image fails to load
            return Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.account_balance,
                size: 60,
                color: Colors.grey[800],
              ),
            );
          },
        ),
        const Spacer(),
        Text(
          '${widget.t('title1')}\n${widget.t('title2')}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: widget.darkBlue,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            children: [
              TextSpan(text: '${widget.t('secureLogin')}\n'),
              TextSpan(
                text: widget.t('xsimAuth'),
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
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.t('loginBtn'),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: widget.onToggleLanguage,
          child: Text(
            '${widget.t('language')}, ${widget.language == 'km' ? widget.t('khmer') : widget.t('english')} | ${widget.language == 'km' ? widget.t('english') : widget.t('khmer')}',
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

