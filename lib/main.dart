import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/total_revenue_screen.dart';
import 'package:mobile_app/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
