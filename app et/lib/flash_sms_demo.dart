import 'package:flutter/material.dart';

void main() {
  runApp(const FlashSmsDemoApp());
}

class FlashSmsDemoApp extends StatelessWidget {
  const FlashSmsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash SMS Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const FlashSmsHomePage(),
    );
  }
}

class FlashSmsHomePage extends StatefulWidget {
  const FlashSmsHomePage({super.key});

  @override
  State<FlashSmsHomePage> createState() => _FlashSmsHomePageState();
}

class _FlashSmsHomePageState extends State<FlashSmsHomePage> {
  @override
  void initState() {
    super.initState();

    // Show the "flash SMS" popup as soon as the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFlashSmsBottomSheet(
        context,
        sender: "XSIM",
        message: "Your verification code is: 9301\n\nClick OK to confirm login.",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Background simulates home screen
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flash SMS Demo',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showFlashSmsBottomSheet(
                  context,
                  sender: "XSIM",
                  message: "Your verification code is: 9301\n\nClick OK to confirm login.",
                );
              },
              child: const Text('Show Flash SMS'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a Flash SMS popup that slides up from the bottom (like real Android Flash SMS)
void _showFlashSmsBottomSheet(
  BuildContext context, {
  required String sender,
  required String message,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      return FlashSmsBottomPopup(
        sender: sender,
        message: message,
        onCancel: () {
          Navigator.of(ctx).pop();
        },
        onOk: () {
          Navigator.of(ctx).pop();
          // Handle OK action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flash SMS confirmed!')),
          );
        },
      );
    },
  );
}

/// The Flash SMS popup widget styled like Android's native Flash SMS
class FlashSmsBottomPopup extends StatelessWidget {
  final String sender;
  final String message;
  final VoidCallback onCancel;
  final VoidCallback onOk;

  const FlashSmsBottomPopup({
    super.key,
    required this.sender,
    required this.message,
    required this.onCancel,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width - left to right
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D), // Dark gray background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with sender name
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Text(
              sender,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Message body
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
          // Action buttons row with short vertical divider
          Row(
            children: [
              // Cancel button
              Expanded(
                child: InkWell(
                  onTap: onCancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4DA6FF), // Blue color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Short vertical divider
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[600],
              ),
              // OK button
              Expanded(
                child: InkWell(
                  onTap: onOk,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: const Center(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4DA6FF), // Blue color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Bottom safe area padding
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
