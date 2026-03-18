import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebasemessagingBackgroundhandler(RemoteMessage message) async {
  // يجب عمل initialize قبل استخدام أي خدمة من Firebase في الخلفية
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'chat_messages_channel',
    'Chat messages',
    description: "this channel used for message notification",
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize() async {
    // تصحيح الخطأ المطبعي من @ipmap إلى @mipmap
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSetting = InitializationSettings(android: androidSetting);

    // ربط الضغطة على الإشعار بالدالة المسؤولة عن الـ Navigation
    await _localNotification.initialize(
      settings: initSetting,
      onDidReceiveNotificationResponse: _handleNotificationTapped,
    );

    // إنشاء القناة في نظام أندرويد
    await _localNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // التعامل مع الحالات المختلفة للإشعارات
    FirebaseMessaging.onBackgroundMessage(_firebasemessagingBackgroundhandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // عند الضغط على الإشعار والتطبيق في الخلفية (Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message.data['chatroomId']);
    });

    // عند فتح التطبيق من إشعار وهو مغلق تماماً (Terminated)
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data['chatroomId']);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      // تصحيح: يجب وضع NotificationDetails داخل دالة الـ show
      await _localNotification.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher', // تأكد أن الأيقونة موجودة بهذا الاسم
          ),
        ),
        payload: message.data['chatroomId'],
      );
    }
  }

  // دالة التعامل مع الضغط على الإشعار المحلي
  void _handleNotificationTapped(NotificationResponse response) {
    _handleNavigation(response.payload);
  }

  // دالة موحدة للتعامل مع الانتقال لصفحة الشات
  void _handleNavigation(String? chatroomId) {
    if (chatroomId != null) {
      debugPrint('Navigate to Chat Room: $chatroomId');
      // هنا تضع كود الـ Navigator الخاص بك
    }
  }

  Future<String?> getAndroidToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      debugPrint("Error getting token: $e");
      return null;
    }
  }

  // دالة تحديث التوكن (تم تصحيح getAPNSToken إلى getToken لأنك تريد أندرويد)
  Future<void> updateTokenInFirestore(String userId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token == null) return;
      await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(userId)
          .update({
            'token': token,
            'lastseen': FieldValue.serverTimestamp(),
            'isonline': true,
          });
    } catch (e) {
      debugPrint('Error updating user token: $e');
    }
  }

  Future<void> requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
