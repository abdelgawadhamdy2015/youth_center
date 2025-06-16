import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationDetails androidNotififcationDetail;
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    // onDidReceiveLocalNotification:
    //     (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  notificationDetails(String? imageUrl) async {
    if (imageUrl != null) {
      final http.Response image = await http.get(Uri.parse(imageUrl));
      BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(image.bodyBytes),
            ),
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(image.bodyBytes),
            ),
          );
      androidNotififcationDetail = AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        styleInformation: bigPictureStyleInformation,
      );
    } else {
      androidNotififcationDetail = const AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
      );
    }
    return NotificationDetails(
      android: androidNotififcationDetail,
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future showNotification(RemoteMessage message) async {
    return notificationsPlugin.show(
      0,
      message.notification!.title!,
      message.notification!.body,
      await notificationDetails(message.notification?.android?.imageUrl),
    );
  }
}
