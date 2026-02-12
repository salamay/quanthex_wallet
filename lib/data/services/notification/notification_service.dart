import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quanthex/core/network/Api_url.dart';
import 'package:quanthex/core/network/my_api.dart';
import 'package:quanthex/data/Models/notifications/notification_dto.dart';
import 'package:quanthex/data/services/auth/auth_service.dart';
import 'package:quanthex/data/utils/logger.dart';


class NotificationService {
  NotificationService._internal();
  static NotificationService? _instance;
  final my_api = MyApi();
  static NotificationService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of NotificationService", "NotificationService");
    }
    _instance ??= NotificationService._internal();
    return _instance!;
  }
     String channelId = "com.quanthex.mining.notification";
   String channelName = "Quanthex Wallet Notification";
   String channelDescription = "Quanthex Wallet Notification to show user messages and other important information";
   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
   AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
   final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: false, requestSoundPermission: true);
   final WindowsInitializationSettings initializationSettingsWindows = WindowsInitializationSettings(
    appName: 'Quanthex',
    appUserModelId: 'com.quanthex.mining',
    // Search online for GUID generators to make your own
    guid: 'E46CEC34-0D3D-425E-AE66-3069F3948CC9',
  );
   late AndroidNotificationDetails androidNotificationDetails;

   Future<void> initNotification() async {
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin, macOS: initializationSettingsDarwin, windows: initializationSettingsWindows);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

     Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    } else if (Platform.isAndroid) {
      final bool? result = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      return result ?? false;
    } else if (Platform.isMacOS) {
      final bool? result = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    } else {
      return false;
    }
  }

     Future<void> showNotification({required String title, required String body, required String imageUrl, required String groupKey, required String summaryId}) async {
    try {
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.max,
        ticker: 'ticker',
        groupKey: groupKey,
        styleInformation: MessagingStyleInformation(
          Person(name: title),
          messages: [Message(body, DateTime.now(), Person(name: title))],
          groupConversation: true,
        ),
      );
      DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: false, presentSound: true, categoryIdentifier: groupKey);

      final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iOSDetails, macOS: iOSDetails);
      int id = generateRandomSixDigitNumber();
      flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics, payload: 'item x');
      logger("Notification shown successfully", 'NotificationService');
      if (Platform.isAndroid) {
        // showSummaryNotification(summaryId: summaryId, title: title, body: body, imageUrl: imageUrl, groupKey: groupKey, file: file);
      }
    } catch (e) {
      print(e);
    }
  }
    static int generateRandomSixDigitNumber() {
    math.Random random = math.Random();
    return 100000 + random.nextInt(900000);
  }

  Future<List<NotificationDto>> getNotifications({int offset = 0, int limit = 25}) async {
    logger("Getting notifications", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      response = await my_api.get("${ApiUrls.notifications}?offset=$offset&limit=$limit", {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger("Getting notifications: Response code ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return List.from(data).map((e) => NotificationDto.fromJson(e)).toList();
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }
  Future<NotificationDto> markAsRead(String notificationId) async {
    logger("Marking notification as read", runtimeType.toString());
    Response? response;
    var body = {};
    try {
      String accessToken = AuthService.getInstance().authToken;
      response = await my_api.post(jsonEncode(body), "${ApiUrls.markAsRead}/$notificationId", {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
    if (response != null) {
      logger("Marking notification as read: Response code ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return NotificationDto.fromJson(data);
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }


  Future<int> getUnreadCount() async {
    logger("Getting unread count", runtimeType.toString());
    Response? response;
    try {
      String accessToken = AuthService.getInstance().authToken;
      response = await my_api.get(ApiUrls.unreadCount, {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"});
    } catch (e) {
      logger(e.toString(), runtimeType.toString());
      throw Exception("Unable to establish connection");
    }
       if (response != null) {
      logger("Getting unread count: Response code ${response.statusCode}", runtimeType.toString());
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data["data"];
        return data["count"];
      } else {
        var data = response.data;
        throw Exception(data["message"]);
      }
    } else {
      throw Exception("Unable to establish connection");
    }
  }
}