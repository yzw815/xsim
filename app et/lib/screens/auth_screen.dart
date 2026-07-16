import 'package:flutter/material.dart';
import '../translations.dart';
import '../services/event_service.dart';
import '../services/log_service.dart';
import '../widgets/flash_sms_popup.dart';
import 'log_viewer_screen.dart';
import 'steps/step1_login.dart';
import 'steps/step2_phone.dart';
import 'steps/step3_authenticating.dart';
import 'steps/step4_flash_message.dart';
import 'steps/step5_verifying.dart';
import 'steps/step6_success.dart';
import 'steps/step7_dashboard.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _step = 1;
  String _language = 'en';
  String _phoneNumber = '745721380'; // Default test number
  String _countryCode = '+255'; // Default Tanzania test prefix; editable by user
  String? _sentOtp;

  // Theme Colors - Updated for Ethiopia design
  final Color primaryBlue = const Color(0xFF33568F); // Button blue
  final Color darkBlue = const Color(0xFF1F4181); // Title blue
  final Color ethiopiaGreen = const Color(0xFF078930); // Ethiopia green
  final Color step1Background = const Color(0xFFDBDBDB); // Gray background for step 1
  final Color step2Background = const Color(0xFFF3F6FA); // Light blue-gray for step 2+
  final Color successGreen = const Color(0xFF16A34A);
  
  final EventService _eventService = EventService();
  final LogService _logService = LogService();

  @override
  void initState() {
    super.initState();
  }

  void setStep(int step) {
    setState(() {
      _step = step;
    });
  }
  
  bool _otpSending = false;

  /// Send OTP to the entered phone number
  Future<void> _sendOtpToPhone() async {
    if (_otpSending) return; // Guard against duplicate concurrent sends
    _otpSending = true;

    final fullPhone = '$_countryCode $_phoneNumber'; // User-entered country code + number
    
    // Log OTP request event
    await _eventService.otpRequested(fullPhone);
    
    // Send OTP (generates OTP, calls API if in real mode)
    final otp = await _eventService.sendOtp(fullPhone);
    
    if (otp != null) {
      setState(() {
        _sentOtp = otp;
      });
      
      // Check if we're in dummy mode - show flash SMS popup
      if (_eventService.isDummyMode) {
        // Wait a moment to simulate "sending"
        await Future.delayed(const Duration(milliseconds: 800));
        
        if (mounted) {
          // Show the flash SMS popup with YES/NO buttons
          await FlashSmsPopup.show(
            context,
            otp: otp,
            onOk: () {
              // After user taps YES, go to step 4 (OTP entry)
              if (mounted) setStep(4);
            },
            onDismiss: () {
              // After user taps NO, go back to step 2
              if (mounted) setStep(2);
            },
          );
        }
      } else {
        // Real API mode - wait for SMS then advance to step 4
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) setStep(4);
      }
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
    _otpSending = false;
  }

  void toggleLanguage() {
    setState(() {
      _language = _language == 'en' ? 'am' : 'en';
    });
  }

  void setPhoneNumber(String phone) {
    setState(() {
      _phoneNumber = phone;
    });
  }

  void setCountryCode(String code) {
    setState(() {
      _countryCode = code;
    });
  }
  
  /// Verify the OTP entered by user
  bool verifyEnteredOtp(String enteredOtp) {
    return _eventService.verifyOtp(enteredOtp);
  }

  String t(String key) => Translations.get(_language, key);

  // Get background color based on current step
  // Steps 1, 5, 6 use gray background (#DBDBDB)
  // Steps 2, 3, 4, 7 use light blue-gray background (#F3F6FA)
  Color _getBackgroundColor() {
    if (_step == 1 || _step == 5 || _step == 6) {
      return step1Background;
    }
    return step2Background;
  }

  @override
  Widget build(BuildContext context) {
    // Steps 1, 5, 6 use gray background with full-page layout (no blue header)
    final bool isGrayBgStep = _step == 1 || _step == 5 || _step == 6;
    
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      // Debug: tap to open the in-app log viewer (API requests/responses, OTP events)
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.black.withOpacity(0.5),
        foregroundColor: Colors.white,
        tooltip: 'View logs',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LogViewerScreen()),
          );
        },
        child: const Icon(Icons.bug_report),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        // Remove safe area padding for steps that handle their own layout (steps 2, 3, 4)
        top: isGrayBgStep,
        // Only step 1 needs external padding (steps 5, 6 have internal padding with Stack)
        child: _step == 1
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildCurrentStep(),
              )
            : _buildCurrentStep(),
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
          onNext: () {
            // Go straight to authenticating screen and fire OTP immediately
            setStep(3);
            _sendOtpToPhone();
          },
          onToggleLanguage: toggleLanguage,
        );
      case 2:
        return Step2Phone(
          t: t,
          phoneNumber: _phoneNumber,
          countryCode: _countryCode,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onBack: () => setStep(1),
          onNext: () {
            // User edited number and pressed Continue — re-send OTP
            setStep(3);
            _sendOtpToPhone();
          },
          onPhoneChanged: setPhoneNumber,
          onCountryCodeChanged: setCountryCode,
        );
      case 3:
        return Step3Authenticating(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onBack: () => setStep(2),
          // OTP already sent when entering this screen. Continue only skips
          // ahead manually if the code is already out; it never re-sends.
          onNext: () {
            if (_sentOtp != null) setStep(4);
          },
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
          onNext: () => setStep(6),
        );
      case 6:
        return Step6Success(
          t: t,
          primaryBlue: primaryBlue,
          successGreen: successGreen,
          onProceed: () {
            // Navigate to dashboard (step 7)
            setStep(7);
          },
          onBackToHome: () {
            // Reset state and go back to step 1
            setState(() {
              _phoneNumber = '';
              _sentOtp = null;
            });
            _eventService.clearOtp();
            _logService.clearLogs(); // Clear all logs for fresh start
            setStep(1);
          },
        );
      case 7:
        return Step7Dashboard(
          t: t,
          onBackToHome: () {
            // Reset state and go back to step 1
            setState(() {
              _phoneNumber = '';
              _sentOtp = null;
            });
            _eventService.clearOtp();
            _logService.clearLogs();
            setStep(1);
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
