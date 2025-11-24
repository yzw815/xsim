import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  // Singleton pattern
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  // API endpoint - change this to your deployed URL for production demos
  // For local development with emulator:
  // - Android emulator: use 10.0.2.2
  // - iOS simulator: use localhost
  // For physical device: use your computer's IP address
  String _apiEndpoint = 'https://xsim.getmore2u.com/api/events';

  // Allow setting custom endpoint
  void setEndpoint(String endpoint) {
    _apiEndpoint = endpoint;
  }

  String get endpoint => _apiEndpoint;

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
}

