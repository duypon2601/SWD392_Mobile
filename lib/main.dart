import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mobile_app/firebase_options.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/total_revenue_screen.dart';
import 'package:mobile_app/screens/welcome_screen.dart';
import 'package:mobile_app/services/firebase_messaging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo FCM
  await FirebaseMessagingService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Branch Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
