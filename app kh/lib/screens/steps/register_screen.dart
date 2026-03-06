import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

/// Screen 1: User enters phone number to register with XSIM server
class RegisterScreen extends StatefulWidget {
  final String Function(String) t;
  final Color primaryBlue;
  final Color darkBlue;
  final Function(String phone) onRegistered;
  final VoidCallback onToggleLanguage;
  final String language;
  final VoidCallback? onBack;

  const RegisterScreen({
    super.key,
    required this.t,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onRegistered,
    required this.onToggleLanguage,
    required this.language,
    this.onBack,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _serverController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final NotificationService _notificationService = NotificationService();
  bool _isRegistering = false;
  String? _errorMessage;
  bool _showServerConfig = false;

  @override
  void initState() {
    super.initState();
    _serverController.text = _notificationService.serverUrl;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _serverController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 6) {
      setState(() {
        _errorMessage = 'Please enter a valid phone number';
      });
      return;
    }

    setState(() {
      _isRegistering = true;
      _errorMessage = null;
    });

    // Update server URL if changed
    final serverUrl = _serverController.text.trim();
    if (serverUrl.isNotEmpty) {
      _notificationService.setServerUrl(serverUrl);
    }

    final fullPhone = '855$phone';
    final success = await _notificationService.registerWithServer(fullPhone);

    if (!mounted) return;

    if (success) {
      widget.onRegistered(phone);
    } else {
      setState(() {
        _isRegistering = false;
        _errorMessage = 'Cannot connect to server. Check server URL and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg-image.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: const Color(0xFFDBDBDB));
            },
          ),
        ),
        // Main content
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                // Logo
                Image.asset(
                  'assets/images/cambodia_coat_of_arms.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.account_balance, size: 60, color: Colors.grey[700]),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  'XSIM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCE2E30),
                    letterSpacing: -1,
                  ),
                ),
                const Text(
                  'Authentication',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F4181),
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 32),
                // Registration card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Register Your Phone',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F4181),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your phone number to receive OTP notifications from the web portal',
                        style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      // Phone Number label
                      const Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      // Phone input
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(color: Colors.black12)),
                              ),
                              child: const Row(
                                children: [
                                  Text('🇰🇭', style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 6),
                                  Text('+855', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                focusNode: _focusNode,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 18, letterSpacing: 2),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                                  hintText: '12 345 6789',
                                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.3), letterSpacing: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Server config toggle
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showServerConfig = !_showServerConfig;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              _showServerConfig ? Icons.expand_less : Icons.expand_more,
                              size: 20,
                              color: Colors.black38,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Server Settings',
                              style: TextStyle(fontSize: 13, color: Colors.black38),
                            ),
                          ],
                        ),
                      ),
                      if (_showServerConfig) ...[
                        const SizedBox(height: 8),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _serverController,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                              hintText: 'http://192.168.1.100:3000',
                              hintStyle: TextStyle(fontSize: 13, color: Colors.black26),
                            ),
                          ),
                        ),
                      ],
                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(fontSize: 13, color: Colors.red),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Register button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isRegistering ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF33568F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: _isRegistering
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        // Back button (on top of everything so it's tappable)
        if (widget.onBack != null)
          Positioned(
            top: 44,
            left: 12,
            child: GestureDetector(
              onTap: widget.onBack,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text('Back', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
