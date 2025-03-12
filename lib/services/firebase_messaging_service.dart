import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Handle background messages when app is terminated or in background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to initialize Firebase before handling background messages
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print("Background message data: ${message.data}");
  print("Background message notification: ${message.notification?.title}");
}

class FirebaseMessagingService {
  // Singleton pattern
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  // FCM instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Local notifications plugin for foreground notifications on Android
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Navigation key to navigate from outside of the context
  static GlobalKey<NavigatorState>? navigatorKey;
  
  // Channel IDs for Android notifications
  static const String _notificationChannelId = 'high_importance_channel';
  static const String _notificationChannelName = 'Important Notifications';
  static const String _notificationChannelDesc = 'This channel is used for important notifications';
  
  // Initialize the service
  Future<void> initialize() async {
    // Set background message handler for when app is terminated or in background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Request permission to show notifications
    await _requestPermissions();
    
    // Initialize local notifications for foreground notifications
    await _initializeLocalNotifications();
    
    // Set up message handlers for different app states
    _setupForegroundMessageHandler();
    _setupMessageOpenedAppHandler();
    _checkInitialMessage();
    
    // Print the FCM token for testing
    await _printFCMToken();
  }
  
  // Request permissions to show notifications
  Future<void> _requestPermissions() async {
    // For iOS, request permission
    if (Platform.isIOS) {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      
      print('User granted iOS notification permission: ${settings.authorizationStatus}');
      
      // Configure foreground notification presentation options for iOS
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      // For Android, permissions are handled in the AndroidManifest.xml
      // but we still request them to be sure
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      print('User granted Android notification permission: ${settings.authorizationStatus}');
    }
  }
  
  // Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    // Android initialization settings
    const AndroidInitializationSettings androidInitSettings = 
        AndroidInitializationSettings('ic_launcher');
    
    // iOS initialization settings
    final DarwinInitializationSettings iosInitSettings = 
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    
    // Initialize the plugin
    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create the Android notification channel
    await _createNotificationChannel();
  }
  
  // Create Android notification channel
  Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _notificationChannelId,
        _notificationChannelName,
        description: _notificationChannelDesc,
        importance: Importance.high,
      );
      
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }
  
  // Print FCM token for testing
  Future<void> _printFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }
  
  // Set up handler for foreground messages 
  void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      
      if (message.notification != null) {
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');
        
        // Show a local notification when a foreground message arrives
        _showForegroundNotification(message);
      }
    });
  }
  
  // Show a local notification for foreground messages
  Future<void> _showForegroundNotification(RemoteMessage message) async {
    // If we're in foreground, we have two options:
    // 1. Show a system notification using flutter_local_notifications
    // 2. Show an in-app notification (SnackBar, Dialog, etc.)
    
    // Option 1: System notification
    await _showSystemNotification(message);
    
    // Option 2: In-app notification (if we have a valid context)
    if (navigatorKey?.currentContext != null) {
      _showInAppNotification(navigatorKey!.currentContext!, message);
    }
  }
  
  // Show a system notification 
  Future<void> _showSystemNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    final iOS = message.notification?.apple;
    
    if (notification != null) {
      // For Android
      AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
        _notificationChannelId,
        _notificationChannelName,
        channelDescription: _notificationChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );
      
      // For iOS
      DarwinNotificationDetails iOSDetails = const DarwinNotificationDetails();
      
      NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );
      
      // Create a unique notification ID based on timestamp
      int notificationId = DateTime.now().millisecond;
      
      // Show the notification
      await _notificationsPlugin.show(
        notificationId,
        notification.title,
        notification.body,
        details,
        payload: json.encode(message.data),
      );
    }
  }
  
  // Show an in-app notification using SnackBar
  void _showInAppNotification(BuildContext context, RemoteMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.notification?.title ?? 'New Notification',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (message.notification?.body != null)
              Text(message.notification!.body!),
          ],
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Handle tap on the in-app notification
            _navigateBasedOnMessage(message);
          },
        ),
      ),
    );
  }
  
  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = json.decode(response.payload!);
        _navigateBasedOnData(data);
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }
  
  // Set up handler for when the app is opened by tapping on a notification
  void _setupMessageOpenedAppHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened by tapping on notification: ${message.data}');
      _navigateBasedOnMessage(message);
    });
  }
  
  // Check if the app was opened by tapping on a notification when terminated
  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App was terminated and opened by tapping on notification: ${initialMessage.data}');
      _navigateBasedOnMessage(initialMessage);
    }
  }
  
  // Navigate based on the message content
  void _navigateBasedOnMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      _navigateBasedOnData(message.data);
    }
  }
  
  // Navigate based on data from the notification
  void _navigateBasedOnData(Map<String, dynamic> data) {
    if (navigatorKey?.currentState == null) {
      print('Navigator key is null, cannot navigate');
      return;
    }
    
    // Example navigation based on screen parameter
    if (data.containsKey('screen')) {
      String screen = data['screen'];
      
      switch (screen) {
        case 'dashboard':
          navigatorKey!.currentState!.pushNamed('/dashboard');
          break;
        case 'branch_details':
          if (data.containsKey('branch_id')) {
            navigatorKey!.currentState!.pushNamed(
              '/branch_details', 
              arguments: {'branch_id': data['branch_id']}
            );
          }
          break;
        case 'employee_details':
          if (data.containsKey('employee_id')) {
            navigatorKey!.currentState!.pushNamed(
              '/employee_details',
              arguments: {'employee_id': data['employee_id']}
            );
          }
          break;
        case 'login':
          navigatorKey!.currentState!.pushNamed('/login');
          break;
        default:
          navigatorKey!.currentState!.pushNamed('/dashboard');
      }
    } else {
      // Default navigation
      navigatorKey!.currentState!.pushNamed('/dashboard');
    }
  }
  
  // Subscribe to a topic for targeted notifications
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }
  
  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
  
  // Get the current FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
  
  // Delete the current FCM token
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    
  }
}
