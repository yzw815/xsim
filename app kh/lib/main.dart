import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/auth_screen.dart';
import 'services/notification_service.dart';

/// Handle background messages (required by Firebase Messaging)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.data}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permission & get FCM token (may fail on simulator)
  try {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      NotificationService().fcmToken = fcmToken;
      print('📱 FCM Token: $fcmToken');
    }
  } catch (e) {
    print('⚠️ FCM setup failed (expected on simulator): $e');
  }

  runApp(const XSimAuthApp());
}

class XSimAuthApp extends StatelessWidget {
  const XSimAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xsim kh',
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
