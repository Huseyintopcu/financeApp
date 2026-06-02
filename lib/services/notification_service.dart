import 'package:finance_app/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService
{
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async
  {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    String? token = await _fcm.getToken();
    print("📱 Cihazın FCM Token Adresi: $token");

    if (token != null)
    {
      String? userEmail = await const FlutterSecureStorage().read(key: "email");

      if (userEmail != null)
      {
        await AuthService().updateFcmToken(userEmail, token);
      }
    }

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      RemoteNotification? notification = message.notification;
      if (notification != null)
      {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails('f_channel', 'Fatura Kanalı',importance: Importance.max, priority: Priority.high)
          ),
        );
      }
    });
  }
}