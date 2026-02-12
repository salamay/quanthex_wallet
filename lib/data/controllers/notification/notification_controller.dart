import 'package:flutter/foundation.dart';
import 'package:quanthex/data/Models/notifications/notification_dto.dart';
import 'package:quanthex/data/services/notification/notification_service.dart';
import 'package:quanthex/data/utils/logger.dart';

class NotificationController extends ChangeNotifier {
  NotificationService notificationService = NotificationService.getInstance();
  List<NotificationDto> notifications = [];
  int unreadCount = 0;

  Future<List<NotificationDto>> fetchNotifications({int offset = 0, int limit = 25}) async {
    List<NotificationDto> results = await notificationService.getNotifications(offset: offset, limit: limit);
    logger("Notifications: ${results.length}", "NotificationController");
    List<NotificationDto> existing = notifications;
    existing.addAll(results);
    notifications = existing;
    notifyListeners();
    return results;
  }

  Future<void> markAsRead(String notificationId) async {
    await notificationService.markAsRead(notificationId);
    int index = notifications.indexWhere((element) => element.notiId == notificationId);
    if (index != -1) {
      notifications[index].notiSeen = true;
      if (unreadCount > 0) {
        unreadCount--;
      }
    }
    notifyListeners();
  }
  Future<void> getUnreadCount() async {
    unreadCount = await notificationService.getUnreadCount();
    notifyListeners();
  }
  void clear(){
    notifications=[];
    unreadCount=0;
  }
}
