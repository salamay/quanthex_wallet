import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quanthex/data/services/notification/notification_service.dart';
import 'package:quanthex/data/utils/logger.dart';

class FcmService {
  FcmService._internal();
  static FcmService? _instance;
  static String request_quanthex_groupKey = "Quanthex_KEYyy_request";
  static String request_quanthex_summaryId = "82829192";



  static FcmService getInstance() {
    if (_instance == null) {
      logger("Creating new instance of FcmService", "FcmService");
    }
    _instance ??= FcmService._internal();
    return _instance!;
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();
    logger("Handling a background message", 'FcmService');
       var data = jsonDecode(message.data['notification']);
    String description = data['body'];
    String title = data['title'];
    showNotification(title: title, body: description);
  }

  static Future<void> firebaseMessagingOnForegroundMessageHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();
    logger('A new onMessage event on foreground!', 'FcmService');
    logger('Message: ${message.data}', 'FcmService');
    print('Message: ${message.data['notification']}');
    var data = jsonDecode(message.data['notification']);
    String description = data['body'];
    String title = data['title'];
    showNotification(title: title, body: description);

  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingOnMessageOpenedApHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();
    logger('A new onMessageOpenedApp event!', 'FcmService');
    // LocalDatabase.getDatabase();
    // NotificationService.showNotification(title: "Test", body: "Background", imageUrl: "", groupKey: "12", summaryId: 12);
  }

    static onTokenRefresh() async { 
    //on token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      logger('New FCM Token: $newToken', 'FcmService');
      // Send the new token to your server
      try {
        
        
      } catch (e) {
        logger("Error while refreshing token: $e", 'FcmService');
      }
    });
  }

  static void showNotification({required String title, required String body}) async {
    String groupKey = "";
    String summaryId = "0";
    summaryId = request_quanthex_summaryId;
    groupKey = request_quanthex_groupKey;
    NotificationService.getInstance().showNotification(title: title, body: body, imageUrl: "", groupKey: groupKey, summaryId: summaryId);
  }
}
