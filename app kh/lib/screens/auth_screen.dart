import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../translations.dart';
import '../services/event_service.dart';
import '../services/notification_service.dart';
import 'demo_selector_screen.dart';
import 'steps/register_screen.dart';
import 'steps/waiting_screen.dart';
import 'steps/otp_display_screen.dart';
import 'steps/step1_login.dart';
import 'steps/step2_phone.dart';
import 'steps/step3_authenticating.dart';
import 'steps/step4_flash_message.dart';
import 'steps/step6_success.dart';

/// Main screen that manages all demo flows:
/// - Demo Selector (first screen)
/// - App Demo (original 5-step flow)
/// - Web Portal Demo (register → waiting → OTP display)
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Current mode: 'selector', 'app_demo', 'web_demo'
  String _mode = 'selector';

  // Web Portal Demo state
  String _webScreen = 'register'; // 'register', 'waiting', 'otp_display'
  String _phoneNumber = '';
  String? _currentOtp;

  // App Demo state (original flow)
  int _appStep = 1;
  String _language = 'en';

  // Theme Colors
  final Color primaryBlue = const Color(0xFF33568F);
  final Color darkBlue = const Color(0xFF1F4181);

  final NotificationService _notificationService = NotificationService();
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _setupFCMListener();
  }

  /// Listen for incoming FCM push messages
  void _setupFCMListener() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 FCM message received: ${message.data}');
      final otp = message.data['otp'];
      if (otp != null) {
        _showOtp(otp);
      }
    });

    // App opened from notification (background → foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📨 FCM message opened: ${message.data}');
      final otp = message.data['otp'];
      if (otp != null) {
        _showOtp(otp);
      }
    });
  }

  /// Show OTP - works from any screen
  void _showOtp(String otp) {
    setState(() {
      _currentOtp = otp;
      _mode = 'web_demo';
      _webScreen = 'otp_display';
    });
  }

  // ---- Navigation ----

  void toggleLanguage() {
    setState(() {
      _language = _language == 'en' ? 'kh' : 'en';
    });
  }

  String t(String key) => Translations.get(_language, key);

  // ---- Demo Selector ----

  void _selectAppDemo() {
    setState(() {
      _mode = 'app_demo';
      _appStep = 1;
    });
  }

  void _selectWebPortalDemo() async {
    // Check if phone already registered
    final hasPhone = await _notificationService.loadSavedPhone();
    setState(() {
      _mode = 'web_demo';
      if (hasPhone) {
        _phoneNumber = _notificationService.displayPhone;
        _webScreen = 'waiting';
        // Re-register to update FCM token
        _notificationService.reRegisterIfNeeded();
      } else {
        _webScreen = 'register';
      }
    });
  }

  void _backToSelector() {
    setState(() {
      _mode = 'selector';
      _appStep = 1;
      _webScreen = 'register';
      _currentOtp = null;
    });
  }

  // ---- Web Portal Demo callbacks ----

  void _onRegistered(String phone) {
    setState(() {
      _phoneNumber = phone;
      _webScreen = 'waiting';
    });
  }

  void _onOtpReceived(String otp) {
    setState(() {
      _currentOtp = otp;
      _webScreen = 'otp_display';
    });
  }

  void _onOtpDone() {
    setState(() {
      _currentOtp = null;
      _webScreen = 'waiting';
    });
  }

  void _onChangeNumber() async {
    await _notificationService.clearRegistration();
    setState(() {
      _phoneNumber = '';
      _webScreen = 'register';
    });
  }

  // ---- App Demo callbacks ----

  void _appGoToStep(int step) {
    setState(() {
      _appStep = step;
    });
  }

  // ---- Background color ----

  Color _getBackgroundColor() {
    if (_mode == 'selector' || (_mode == 'web_demo' && _webScreen == 'register')) {
      return const Color(0xFFDBDBDB);
    }
    return const Color(0xFFF3F6FA);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: SafeArea(
        top: _mode == 'selector' || (_mode == 'web_demo' && _webScreen == 'register'),
        child: _buildScreen(),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_mode) {
      case 'selector':
        return DemoSelectorScreen(
          onAppDemo: _selectAppDemo,
          onWebPortalDemo: _selectWebPortalDemo,
        );

      case 'app_demo':
        return _buildAppDemoScreen();

      case 'web_demo':
        return _buildWebDemoScreen();

      default:
        return DemoSelectorScreen(
          onAppDemo: _selectAppDemo,
          onWebPortalDemo: _selectWebPortalDemo,
        );
    }
  }

  // ---- App Demo (Original 5-step flow) ----

  Widget _buildAppDemoScreen() {
    switch (_appStep) {
      case 1:
        return Step1Login(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onNext: () => _appGoToStep(2),
          onToggleLanguage: toggleLanguage,
          language: _language,
          onBack: _backToSelector,
        );
      case 2:
        return Step2Phone(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          phoneNumber: '',
          onNext: () {
            _appGoToStep(3);
          },
          onBack: () => _appGoToStep(1),
          onPhoneChanged: (phone) {},
        );
      case 3:
        return Step3Authenticating(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onNext: () => _appGoToStep(4),
          onBack: () => _appGoToStep(2),
        );
      case 4:
        return Step4FlashMessage(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          challengeCode: '1234',
          onYes: () => _appGoToStep(5),
          onNo: () => _appGoToStep(2),
        );
      case 5:
        return Step6Success(
          t: t,
          primaryBlue: primaryBlue,
          successGreen: const Color(0xFF4CAF50),
          onBackToHome: _backToSelector,
          onBack: _backToSelector,
        );
      default:
        return Step1Login(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onNext: () => _appGoToStep(2),
          onToggleLanguage: toggleLanguage,
          language: _language,
          onBack: _backToSelector,
        );
    }
  }

  // ---- Web Portal Demo ----

  Widget _buildWebDemoScreen() {
    switch (_webScreen) {
      case 'register':
        return RegisterScreen(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onRegistered: _onRegistered,
          onToggleLanguage: toggleLanguage,
          language: _language,
          onBack: _backToSelector,
        );
      case 'waiting':
        return WaitingScreen(
          t: t,
          primaryBlue: primaryBlue,
          phoneNumber: _phoneNumber,
          onBack: _backToSelector,
          onOtpReceived: _onOtpReceived,
          onChangeNumber: _onChangeNumber,
        );
      case 'otp_display':
        return OtpDisplayScreen(
          t: t,
          primaryBlue: primaryBlue,
          otp: _currentOtp ?? '0000',
          phoneNumber: _phoneNumber,
          onDone: _onOtpDone,
          onBack: () {
            setState(() {
              _webScreen = 'waiting';
            });
          },
        );
      default:
        return RegisterScreen(
          t: t,
          primaryBlue: primaryBlue,
          darkBlue: darkBlue,
          onRegistered: _onRegistered,
          onToggleLanguage: toggleLanguage,
          language: _language,
          onBack: _backToSelector,
        );
    }
  }
}
