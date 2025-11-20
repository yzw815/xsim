import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../translations.dart';
import '../widgets/status_bar.dart';
import 'steps/step1_login.dart';
import 'steps/step2_phone.dart';
import 'steps/step3_authenticating.dart';
import 'steps/step4_flash_message.dart';
import 'steps/step5_verifying.dart';
import 'steps/step6_success.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _step = 1;
  String _language = 'en';
  String _phoneNumber = '';
  late String _challengeCode;

  // Theme Colors
  final Color primaryBlue = const Color(0xFF1E40AF);
  final Color darkBlue = const Color(0xFF1E3A8A);
  final Color successGreen = const Color(0xFF16A34A);

  @override
  void initState() {
    super.initState();
    _challengeCode = (1000 + Random().nextInt(9000)).toString();
  }

  void setStep(int step) {
    setState(() {
      _step = step;
    });

    // Auto-advance logic for specific steps
    if (step == 3) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) setStep(4);
      });
    }
    if (step == 5) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) setStep(6);
      });
    }
  }

  void toggleLanguage() {
    setState(() {
      _language = _language == 'en' ? 'km' : 'en';
    });
  }

  void setPhoneNumber(String phone) {
    setState(() {
      _phoneNumber = phone;
    });
  }

  String t(String key) => Translations.get(_language, key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const StatusBarWidget(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 1:
        return Step1Login(
          t: t,
          language: _language,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onNext: () => setStep(2),
          onToggleLanguage: toggleLanguage,
        );
      case 2:
        return Step2Phone(
          t: t,
          phoneNumber: _phoneNumber,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onBack: () => setStep(1),
          onNext: () => setStep(3),
          onPhoneChanged: setPhoneNumber,
        );
      case 3:
        return Step3Authenticating(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onBack: () => setStep(2),
        );
      case 4:
        return Step4FlashMessage(
          t: t,
          challengeCode: _challengeCode,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onNo: () => setStep(2),
          onYes: () => setStep(5),
        );
      case 5:
        return Step5Verifying(
          t: t,
          primaryBlue: primaryBlue,
        );
      case 6:
        return Step6Success(
          t: t,
          primaryBlue: primaryBlue,
          successGreen: successGreen,
          onProceed: () {
            // Navigate to dashboard
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Redirecting to dashboard...')),
            );
          },
        );
      default:
        return Step1Login(
          t: t,
          language: _language,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onNext: () => setStep(2),
          onToggleLanguage: toggleLanguage,
        );
    }
  }
}

