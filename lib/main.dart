import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mobile_app/firebase_options.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/total_revenue_screen.dart';
import 'package:mobile_app/screens/welcome_screen.dart';
import 'package:mobile_app/services/firebase_messaging_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Navigator key for FCM navigation
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  // Initialize Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // Set navigator key for FCM service
    FirebaseMessagingService.navigatorKey = _navigatorKey;

    // Initialize FCM
    await FirebaseMessagingService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Branch Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Add this to make SnackBar notifications look better
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          elevation: 6.0,
        ),
      ),
      navigatorKey: _navigatorKey, // Set navigator key for FCM navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
      // Handle dynamic route generation for notification deep links
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/branch_details') {
          // Handle branch details navigation from notification
          final args = settings.arguments as Map<String, dynamic>?;
          final branchId = args?['branch_id'];
          // You would navigate to the branch details page with the right ID
          // For now, just return to dashboard
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          );
        } else if (settings.name == '/employee_details') {
          // Handle employee details navigation from notification
          final args = settings.arguments as Map<String, dynamic>?;
          final employeeId = args?['employee_id'];
          // You would navigate to the employee details page with the right ID
          // For now, just return to dashboard
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          );
        }
        // Default case
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      },
    );
  }
}
