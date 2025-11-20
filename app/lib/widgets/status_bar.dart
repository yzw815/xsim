import 'package:flutter/material.dart';

class StatusBarWidget extends StatelessWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "9:41",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Row(
            children: const [
              Icon(Icons.signal_cellular_alt, size: 16),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 16),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 16),
            ],
          )
        ],
      ),
    );
  }
}

