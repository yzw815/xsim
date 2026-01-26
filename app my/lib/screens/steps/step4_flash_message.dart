import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/event_service.dart';

class Step4FlashMessage extends StatefulWidget {
  final String Function(String) t;
  final String challengeCode;
  final Color primaryBlue;
  final Color darkBlue;
  final VoidCallback onNo;
  final VoidCallback onYes;
  final bool Function(String)? onVerifyOtp;

  const Step4FlashMessage({
    super.key,
    required this.t,
    required this.challengeCode,
    required this.primaryBlue,
    required this.darkBlue,
    required this.onNo,
    required this.onYes,
    this.onVerifyOtp,
  });

  @override
  State<Step4FlashMessage> createState() => _Step4FlashMessageState();
}

class _Step4FlashMessageState extends State<Step4FlashMessage> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventService.smsReceived();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final enteredOtp = _controllers.map((c) => c.text).join();
      _verifyOtp(enteredOtp);
    }
  }
  
  void _verifyOtp(String enteredOtp) {
    bool isValid;
    
    if (widget.onVerifyOtp != null) {
      isValid = widget.onVerifyOtp!(enteredOtp);
    } else {
      isValid = enteredOtp == widget.challengeCode;
    }
    
    if (isValid) {
      _eventService.codeEntered(enteredOtp);
      widget.onYes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect code. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  void _onKeyPressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent && 
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty && 
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
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
                onTap: widget.onNo,
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
              const SizedBox(height: 40),
              // Title
              const Center(
                child: Text(
                  'Confirm Your Login Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
                          color: Color(0x80000000), // 50% black
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
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Flash message text
                  const Text(
                    'Please check the flash',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // OTP Input Fields - 4 boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 60,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black.withOpacity(0.9),
                            width: 0.5,
                          ),
                        ),
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (event) => _onKeyPressed(index, event),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onOtpChanged(index, value),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Alert with code hint
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/box_important.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF7B119),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.priority_high,
                              size: 16,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Enter code: ${widget.challengeCode}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        final enteredOtp = _controllers.map((c) => c.text).join();
                        if (enteredOtp.length == 4) {
                          _verifyOtp(enteredOtp);
                        }
                      },
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
