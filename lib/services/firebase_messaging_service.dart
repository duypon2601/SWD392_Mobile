import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Xử lý thông báo khi ứng dụng bị đóng hoàn toàn
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class FirebaseMessagingService {
  // Singleton pattern
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // ID của notification channel
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription = 'This channel is used for important notifications.';
  
  // Khởi tạo dịch vụ FCM
  Future<void> initialize() async {
    // Đăng ký handler cho background message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Yêu cầu quyền gửi thông báo
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('User granted permission: ${settings.authorizationStatus}');
    
    // Cấu hình notification channel cho Android
    if (Platform.isAndroid) {
      await _setupAndroidNotificationChannel();
    }
    
    // Khởi tạo local notifications
    await _initializeLocalNotifications();
    
    // Lấy FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    
    // Xử lý thông báo khi app đang chạy foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Xử lý khi người dùng nhấn vào thông báo (app đang chạy background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Kiểm tra xem app có được mở từ thông báo khi ở trạng thái terminated không
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }
  
  // Thiết lập notification channel cho Android
  Future<void> _setupAndroidNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
      showBadge: true,
    );
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  
  // Khởi tạo local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }
  
  // Xử lý khi người dùng tương tác với thông báo
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = json.decode(response.payload!);
        print('Notification tapped with data: $data');
        // Xử lý điều hướng dựa trên payload
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }
  
  // Xử lý thông báo khi app đang chạy foreground
  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      
      _showLocalNotification(
        title: message.notification!.title ?? 'New Notification',
        body: message.notification!.body ?? '',
        payload: json.encode(message.data),
      );
    }
  }
  
  // Xử lý khi app được mở từ thông báo trong trạng thái background
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.data}');
    // Xử lý điều hướng dựa trên dữ liệu thông báo
  }
  
  // Xử lý khi app được mở từ thông báo trong trạng thái terminated
  void _handleInitialMessage(RemoteMessage message) {
    print('App opened from terminated state by notification: ${message.data}');
    // Xử lý điều hướng dựa trên dữ liệu thông báo
  }
  
  // Hiển thị thông báo local
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Chi tiết thông báo Android
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      enableLights: true,
      color: Color(0xFF4CAF50), // Màu LED thông báo
      ledColor: Color(0xFF4CAF50), // Màu LED
      ledOnMs: 1000,
      ledOffMs: 500,
    );
    
    // Chi tiết thông báo iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    // Chi tiết thông báo chung
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Hiển thị thông báo
    await _flutterLocalNotificationsPlugin.show(
      0, // notification id
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
  
  // Phương thức public để hiển thị thông báo
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      payload: data != null ? json.encode(data) : null,
    );
  }
  
  // Đăng ký nhận thông báo theo topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }
  
  // Hủy đăng ký nhận thông báo từ topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
  
  // Lấy FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
  
  // Xóa FCM token
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    print('FCM token deleted');
  }
}
