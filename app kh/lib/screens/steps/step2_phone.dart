import 'package:flutter/material.dart';
import '../../services/event_service.dart';

class Step2Phone extends StatefulWidget {
  final String Function(String) t;
  final String phoneNumber;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final Function(String) onPhoneChanged;

  const Step2Phone({
    super.key,
    required this.t,
    required this.phoneNumber,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onBack,
    required this.onNext,
    required this.onPhoneChanged,
  });

  @override
  State<Step2Phone> createState() => _Step2PhoneState();
}

class _Step2PhoneState extends State<Step2Phone> {
  late TextEditingController _phoneController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.phoneNumber);
    _focusNode = FocusNode();
    // Request focus after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final fullPhone = '+855 ${_phoneController.text}';
    EventService().phoneEntered(fullPhone);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue header section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
          decoration: const BoxDecoration(
            color: Color(0xFF275695), // Blue header bg
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: widget.onBack,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.chevron_left,
                      color: Color(0xFFF7B119), // Yellow
                      size: 28,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFFF7B119), // Yellow
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Title
              const Text(
                'Verify Your Mobile Number',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              // Description
              const Text(
                'Please proceed to secure login. By input your mobile number, a flash message will be send to you to confirm',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        // White card section
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 0),
            transform: Matrix4.translationValues(0, -20, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Step 1',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        'Step 2',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0x80000000), // 50% black
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        'Step 3',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0x80000000), // 50% black
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Phone Number label
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // SIM registration info
                  const Text(
                    'Your SIM is registered with Ministry of Interior',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Phone input field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.9),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            '+855',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            focusNode: _focusNode,
                            keyboardType: TextInputType.phone,
                            autofocus: true,
                            onChanged: (value) {
                              widget.onPhoneChanged(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '12 345 6789',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 15,
                                letterSpacing: 2,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF33568F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.t('continue'),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
