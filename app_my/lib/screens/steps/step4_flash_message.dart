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
  final TextEditingController _otpController = TextEditingController();
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final _eventService = EventService();

  @override
  void initState() {
    super.initState();
    // User has reached SMS screen, so they received the SMS
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
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Check if all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final enteredOtp = _controllers.map((c) => c.text).join();
      _verifyOtp(enteredOtp);
    }
  }
  
  void _verifyOtp(String enteredOtp) {
    bool isValid;
    
    // Use custom verification function if provided, otherwise compare with challengeCode
    if (widget.onVerifyOtp != null) {
      isValid = widget.onVerifyOtp!(enteredOtp);
    } else {
      isValid = enteredOtp == widget.challengeCode;
    }
    
    if (isValid) {
      _eventService.codeEntered(enteredOtp);
      widget.onYes();
    } else {
      // Show error for incorrect code
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect code. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      // Clear the fields
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  void _onOtpBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 32),
          onPressed: widget.onNo,
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),
        const SizedBox(height: 20),
        Center(
          child: Image.asset(
            'assets/images/gov_logo.png',
            height: 80,
            width: 80,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance, size: 40),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        Text(
          widget.t('confirmLogin'),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: widget.darkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.t('checkFlash1'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const Spacer(),
        // OTP Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              width: 64,
              height: 64,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: widget.darkBlue,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  enabledBorder: OutlineBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineBorder(
                    borderSide: BorderSide(color: widget.primaryBlue, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) => _onOtpChanged(index, value),
                onTap: () {
                  _controllers[index].selection = TextSelection.fromPosition(
                    TextPosition(offset: _controllers[index].text.length),
                  );
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        // Display expected code hint (for demo purposes - remove in production)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Enter code: ${widget.challengeCode}',
                  style: TextStyle(fontSize: 14, color: Colors.blue[900]),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              final enteredOtp = _controllers.map((c) => c.text).join();
              if (enteredOtp.length == 4) {
                _verifyOtp(enteredOtp);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              widget.t('continue'),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 128,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom OutlineBorder that accepts borderRadius
class OutlineBorder extends OutlineInputBorder {
  OutlineBorder({
    required BorderSide borderSide,
    required BorderRadius borderRadius,
  }) : super(
          borderSide: borderSide,
          borderRadius: borderRadius,
        );
}

