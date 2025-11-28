import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'log_service.dart';

/// OTP Mode configuration
enum OtpMode {
  /// Real mode - calls the actual SODA Campaign API to send SMS
  realApi,
  
  /// Dummy mode - generates OTP locally and shows a simulated flash SMS popup
  dummy,
}

class EventService {
  // Singleton pattern
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();
  
  // Log service instance
  final LogService _log = LogService();

  // API endpoint - change this to your deployed URL for production demos
  // For local development with emulator:
  // - Android emulator: use 10.0.2.2
  // - iOS simulator: use localhost
  // For physical device: use your computer's IP address
  String _apiEndpoint = 'https://xsim.getmore2u.com/api/events';
  
  // SODA Campaign API endpoint for sending OTP
  String _sodaApiEndpoint = 'http://155.12.30.102/send/campaign/msisdn';
  
  // Store the sent OTP for verification
  String? _sentOtp;
  
  // ============================================
  // OTP MODE CONFIGURATION
  // ============================================
  // Change this to switch between real API and dummy mode
  // OtpMode.realApi - calls the actual SODA Campaign API
  // OtpMode.dummy - generates OTP locally, shows simulated flash SMS
  OtpMode _otpMode = OtpMode.realApi;  // Default to dummy for demo
  
  /// Get current OTP mode
  OtpMode get otpMode => _otpMode;
  
  /// Set OTP mode
  void setOtpMode(OtpMode mode) {
    _otpMode = mode;
    _log.info('CONFIG', 'OTP mode set to: ${mode.name}');
  }
  
  /// Check if using dummy mode
  bool get isDummyMode => _otpMode == OtpMode.dummy;

  // Allow setting custom endpoint
  void setEndpoint(String endpoint) {
    _apiEndpoint = endpoint;
  }
  
  // Allow setting custom SODA endpoint
  void setSodaEndpoint(String endpoint) {
    _sodaApiEndpoint = endpoint;
  }

  String get endpoint => _apiEndpoint;
  String get sodaEndpoint => _sodaApiEndpoint;

  /// Send an event to the monitoring backend
  /// This is fire-and-forget with error handling
  Future<void> sendEvent(
    String type,
    String description, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_apiEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'type': type,
              'description': description,
              'data': data ?? {},
            }),
          )
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              // Don't throw error, just log and continue
              print('Event send timeout for: $type');
              return http.Response('Timeout', 408);
            },
          );

      if (response.statusCode == 200) {
        print('Event sent: $type - $description');
      } else {
        print('Event send failed: ${response.statusCode}');
      }
    } catch (e) {
      // Silently fail - don't disrupt the app flow
      print('Error sending event: $e');
    }
  }

  // Convenience methods for common events
  Future<void> appOpened() => sendEvent(
        'app_opened',
        'Mobile app opened',
      );

  Future<void> loginClicked() => sendEvent(
        'login_clicked',
        'User clicked Login button',
      );

  Future<void> phoneEntered(String phone) => sendEvent(
        'phone_entered',
        'User entered phone number',
        data: {'phone': phone},
      );

  Future<void> otpRequested(String phone) => sendEvent(
        'otp_requested',
        'Requesting OTP from backend',
        data: {'phone': phone},
      );

  Future<void> backendReceived() => sendEvent(
        'backend_received',
        'Backend received OTP request',
      );

  Future<void> smsSent() => sendEvent(
        'sms_sent',
        'Flash SMS sent to device',
      );

  Future<void> smsReceived() => sendEvent(
        'sms_received',
        'User received flash SMS',
      );

  Future<void> codeEntered(String code) => sendEvent(
        'code_entered',
        'User entered verification code',
        data: {'code': code},
      );

  Future<void> verifying() => sendEvent(
        'verifying',
        'Verifying user credentials',
      );

  Future<void> authSuccess() => sendEvent(
        'success',
        'Authentication successful! 🎉',
      );

  /// Send OTP - either via real API or dummy mode based on configuration
  /// Returns the generated OTP code if successful, null if failed
  Future<String?> sendOtp(String msisdn) async {
    // Generate a 4-digit OTP
    final otp = (1000 + Random().nextInt(9000)).toString();
    _sentOtp = otp;
    
    // Prepare the message
    final message = 'Your verification code is: $otp';
    
    // Log: Starting OTP send
    _log.otpSending(msisdn, otp);
    
    // ============================================
    // DUMMY MODE - No API call, just generate OTP
    // ============================================
    if (_otpMode == OtpMode.dummy) {
      _log.info('OTP', 'OTP generated D', data: {'msisdn': msisdn, 'otp': otp});
      _log.otpSent(msisdn, otp, 'OTP generated D');
      
      await sendEvent(
        'otp_sent',
        'OTP generated D',
        data: {'msisdn': msisdn, 'otp': otp, 'mode': 'D'},
      );
      
      return otp;
    }
    
    // ============================================
    // REAL API MODE - Call SODA Campaign API
    // ============================================
    try {
      // Log API request
      final requestBody = {'msisdn': msisdn, 'message': message};
      _log.apiRequest(_sodaApiEndpoint, 'POST', requestBody);
      
      // Send OTP via SODA Campaign API
      final response = await http
          .post(
            Uri.parse(_sodaApiEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              _log.error('API', 'Request timeout after 10 seconds', data: {'endpoint': _sodaApiEndpoint});
              return http.Response('Timeout', 408);
            },
          );

      // Log API response
      _log.apiResponse(_sodaApiEndpoint, response.statusCode, response.body);

      // Check if request was successful
      if (response.statusCode == 200) {
        // Parse the response body
        try {
          final responseData = jsonDecode(response.body);
          
          // Check for success response: {"status":true,"code":200,"message":"campaign sent"}
          if (responseData['status'] == true && responseData['code'] == 200) {
            _log.otpSent(msisdn, otp, 'OTP generated R');
            // Log event to monitoring backend with API response
            await sendEvent(
              'otp_sent',
              'OTP generated R',
              data: {
                'msisdn': msisdn,
                'otp': otp,
                'mode': 'R',
                'apiResponse': response.body,
              },
            );
            return otp;
          } else {
            // API returned error in body
            final errorMsg = responseData['message'] ?? responseData['error']?['message'] ?? 'Unknown error';
            _log.otpSendFailed(msisdn, errorMsg, statusCode: responseData['code']);
            await sendEvent(
              'otp_send_failed',
              'SODA API returned error',
              data: {
                'msisdn': msisdn,
                'error': errorMsg,
                'apiResponse': response.body,
              },
            );
            return null;
          }
        } catch (e) {
          _log.error('OTP', 'Failed to parse API response', data: {
            'msisdn': msisdn,
            'error': e.toString(),
            'responseBody': response.body,
          });
          await sendEvent(
            'otp_send_failed',
            'Failed to parse SODA API response',
            data: {'msisdn': msisdn, 'error': e.toString()},
          );
          return null;
        }
      } else {
        _log.otpSendFailed(msisdn, response.body, statusCode: response.statusCode);
        await sendEvent(
          'otp_send_failed',
          'Failed to send OTP via SODA Campaign API',
          data: {'msisdn': msisdn, 'status': response.statusCode, 'body': response.body},
        );
        return null;
      }
    } catch (e) {
      _log.error('OTP', 'Exception while sending OTP', data: {
        'msisdn': msisdn,
        'exception': e.toString(),
      });
      await sendEvent(
        'otp_send_error',
        'Error sending OTP via SODA Campaign API',
        data: {'msisdn': msisdn, 'error': e.toString()},
      );
      return null;
    }
  }

  /// Verify the entered OTP against the sent OTP
  /// Returns true if the OTP matches, false otherwise
  bool verifyOtp(String enteredOtp) {
    _log.otpVerifying(enteredOtp);
    
    if (_sentOtp == null) {
      _log.error('OTP', 'No OTP was sent - cannot verify', data: {'enteredOtp': enteredOtp});
      return false;
    }
    
    final isValid = _sentOtp == enteredOtp;
    
    if (isValid) {
      _log.otpVerified(enteredOtp);
    } else {
      _log.otpVerificationFailed(enteredOtp, _sentOtp!);
    }
    
    // Log event to monitoring backend
    sendEvent(
      isValid ? 'otp_verified' : 'otp_verification_failed',
      isValid ? 'OTP verified successfully' : 'OTP verification failed',
      data: {'expected': _sentOtp, 'entered': enteredOtp},
    );
    
    return isValid;
  }
  
  /// Clear the stored OTP
  void clearOtp() {
    _sentOtp = null;
  }
  
  /// Get the sent OTP (for testing/demo purposes only)
  String? get sentOtp => _sentOtp;
}

