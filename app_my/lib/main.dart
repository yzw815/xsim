import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const XSimAuthApp());
}

class XSimAuthApp extends StatelessWidget {
  const XSimAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambodia Government Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

