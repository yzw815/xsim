import 'dart:async';
import 'package:flutter/material.dart';
import '../translations.dart';
import '../services/event_service.dart';
import 'log_viewer_screen.dart';
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
  String? _sentOtp;
  bool _isLoading = false;

  // Theme Colors
  final Color primaryBlue = const Color(0xFF1E40AF);
  final Color darkBlue = const Color(0xFF1E3A8A);
  final Color successGreen = const Color(0xFF16A34A);
  
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
  }

  void setStep(int step) {
    setState(() {
      _step = step;
    });

    // Auto-advance logic for specific steps
    if (step == 3) {
      // Step 3: Authenticating - send OTP here
      _sendOtpToPhone();
    }
    if (step == 5) {
      Timer(const Duration(seconds: 3), () {
        if (mounted) setStep(6);
      });
    }
  }
  
  /// Send OTP to the entered phone number
  Future<void> _sendOtpToPhone() async {
    final fullPhone = '+855$_phoneNumber';
    
    // Log OTP request event
    await _eventService.otpRequested(fullPhone);
    
    // Send OTP via SODA Campaign API
    final otp = await _eventService.sendOtp(fullPhone);
    
    if (otp != null) {
      setState(() {
        _sentOtp = otp;
      });
      
      // Wait for 2 seconds then advance to step 4
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setStep(4);
    } else {
      // Failed to send OTP - show error and go back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('otpSendFailed')),
            backgroundColor: Colors.red,
          ),
        );
        setStep(2); // Go back to phone entry
      }
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
  
  /// Verify the OTP entered by user
  bool verifyEnteredOtp(String enteredOtp) {
    return _eventService.verifyOtp(enteredOtp);
  }

  String t(String key) => Translations.get(_language, key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildCurrentStep(),
        ),
      ),
      // Floating button to view logs (for debugging)
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.grey[700],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LogViewerScreen()),
          );
        },
        tooltip: 'View Logs',
        child: const Icon(Icons.article_outlined, color: Colors.white, size: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
          challengeCode: _sentOtp ?? '0000',
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onNo: () => setStep(2),
          onYes: () => setStep(5),
          onVerifyOtp: verifyEnteredOtp,
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

