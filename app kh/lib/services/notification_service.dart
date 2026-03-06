import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle device registration and push notification setup
/// Registers the phone number + FCM token with the XSIM server
class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _phoneKey = 'registered_phone';
  static const String _serverUrlKey = 'server_url';

  // Server URL - deployed on Cloudflare Workers
  String _serverUrl = 'https://xsim-otp-server.yangzw.workers.dev';

  String? _fcmToken;
  String? _registeredPhone;

  /// Set the server URL
  void setServerUrl(String url) {
    _serverUrl = url;
    _saveServerUrl(url);
  }

  String get serverUrl => _serverUrl;

  /// Get or set the FCM token
  String? get fcmToken => _fcmToken;
  set fcmToken(String? token) {
    _fcmToken = token;
  }

  /// Get the registered phone
  String? get registeredPhone => _registeredPhone;

  /// Check if phone is already registered (from local storage)
  Future<bool> loadSavedPhone() async {
    final prefs = await SharedPreferences.getInstance();
    _registeredPhone = prefs.getString(_phoneKey);
    final savedUrl = prefs.getString(_serverUrlKey);
    if (savedUrl != null) _serverUrl = savedUrl;
    return _registeredPhone != null;
  }

  /// Save server URL locally
  Future<void> _saveServerUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverUrlKey, url);
  }

  /// Register phone number + FCM token with the server
  /// Returns true if registration was successful
  Future<bool> registerWithServer(String phone) async {
    // Normalize phone number
    final normalizedPhone = phone.replaceAll(RegExp(r'[\s\-\+]'), '');
    
    // Use real FCM token or placeholder
    final token = _fcmToken ?? 'placeholder_token_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final response = await http
          .post(
            Uri.parse('$_serverUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'phone': normalizedPhone,
              'fcmToken': token,
            }),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              return http.Response('Timeout', 408);
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['ok'] == true) {
          _registeredPhone = normalizedPhone;
          // Save to local storage
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_phoneKey, normalizedPhone);
          print('✅ Registered with server: $normalizedPhone');
          return true;
        }
      }

      print('❌ Registration failed: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('❌ Registration error: $e');
      return false;
    }
  }

  /// Re-register existing phone (e.g. after app restart, to update FCM token)
  Future<bool> reRegisterIfNeeded() async {
    if (_registeredPhone == null) return false;
    return registerWithServer(_registeredPhone!);
  }

  /// Check if a phone is registered
  bool get isRegistered => _registeredPhone != null;

  /// Get the phone number without country code prefix for display
  String get displayPhone {
    if (_registeredPhone == null) return '';
    // Remove 855 prefix if present
    if (_registeredPhone!.startsWith('855')) {
      return _registeredPhone!.substring(3);
    }
    return _registeredPhone!;
  }

  /// Clear registration
  Future<void> clearRegistration() async {
    _registeredPhone = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_phoneKey);
  }
}
